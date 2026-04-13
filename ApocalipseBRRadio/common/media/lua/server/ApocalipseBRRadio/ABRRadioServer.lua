--[[
    APOCALIPSE [BR] - Radio Server Controller
    Manages broadcast scheduling, channel registration with the game engine,
    radio keep-alive, listener tracking, and event command dispatch.

    This runs ONLY on the server (or in single-player).
    It hooks into EveryOneMinute to pace transmissions at one line per game minute.

    EVENT COMMAND FLOW:
        1. Server broadcasts a transmission (line by line via SendTransmission)
        2. Clients detect received lines via OnDeviceText and report back
        3. Server tracks which players heard each active transmission
        4. When the last line is sent, server dispatches the transmission's
           command to all confirmed listeners via sendServerCommand
]]

if not isServer() and not isClient() then
    -- Single player: allow loading
elseif not isServer() then
    return
end

require "ApocalipseBRRadio/ABRRadioFramework"

ABRRadioServer = ABRRadioServer or {}

-- Active broadcast state per channel:
-- channelId -> { transmission, currentLineIndex }
ABRRadioServer.activeTransmissions = {}

-- Listener tracking per channel:
-- channelId -> { playerOnlineId -> { username, linesHeard } }
ABRRadioServer.listeners = {}

-- Server-side command hooks: commandName -> handler function(playerIds, args)
-- These are called ON THE SERVER after dispatching the command to clients.
-- Useful for server-authoritative logic (logging, global state changes).
ABRRadioServer.serverCommandHooks = {}

-- Cooldown per channel: channelId -> game minutes until next broadcast
ABRRadioServer.cooldowns = {}

-- Reference to the script manager (set during OnLoadRadioScripts)
ABRRadioServer.scriptManager = nil

-- Whether this is a new game
ABRRadioServer.isNewGame = false

-- Whether channels have been registered with the game engine
ABRRadioServer.channelsRegistered = false

-- Minute counter for diagnostics
ABRRadioServer.minuteCounter = 0


--- Get the sandbox transmission interval multiplier.
--- Default sandbox value is 5 minutes. Returns a multiplier relative to that.
local function getIntervalMultiplier()
    if SandboxVars and SandboxVars.ApocalipseBRRadio
        and SandboxVars.ApocalipseBRRadio.TransmissionInterval then
        return SandboxVars.ApocalipseBRRadio.TransmissionInterval / 5.0
    end
    return 1.0
end


--- Calculate a random interval for a channel, adjusted by sandbox settings.
--- @param channel table Channel config
--- @return number Game minutes until next transmission
local function getChannelInterval(channel)
    local multiplier = getIntervalMultiplier()
    local min = math.max(1, math.floor(channel.intervalMin * multiplier))
    local max = math.max(min, math.floor(channel.intervalMax * multiplier))
    return ZombRand(min, max + 1)
end


--- Get the current in-game day count.
--- @return number Days since apocalypse start
local function getCurrentDay()
    local radio = ABRRadio.getRadio()
    if radio then
        local ok, day = pcall(function() return radio:getDaysSinceStart() end)
        if ok and day then return day end
    end
    if GameTime and GameTime.getInstance then
        local gt = GameTime.getInstance()
        if gt then
            local ok, day = pcall(function() return gt:getNightsSurvived() end)
            if ok and day then return day end
        end
    end
    return 0
end


--- Register all enabled channels with the game's radio channel list.
--- This makes channels discoverable in the in-game radio UI.
local function registerChannelsWithGame()
    local radio = ABRRadio.getRadio()
    if not radio then
        print("[ABRRadio Server] WARNING: ZomboidRadio instance not available yet.")
        return false
    end

    local count = 0
    for id, channel in pairs(ABRRadio.channels) do
        if ABRRadio.isChannelEnabled(id) then
            local displayName = ABRRadio.resolveChannelName(channel)
            radio:addChannelName(displayName, channel.frequency, channel.category)
            ABRRadioServer.cooldowns[id] = ZombRand(1, 4)
            count = count + 1
        end
    end

    ABRRadioServer.channelsRegistered = true
    print("[ABRRadio Server] Registered " .. count .. " channels with the game engine.")
    return true
end


--- Send a single line on a channel's frequency via ZomboidRadio.SendTransmission.
--- Also stamps the active transmission with the resolved text for listener matching.
--- @param channel table Channel config
--- @param line string|table The line to send
--- @param txColor table|nil Transmission-level color override
--- @param channelId string The channel identifier
local function sendLine(channel, line, txColor, channelId)
    local radio = ABRRadio.getRadio()
    if not radio then return end

    local text = ABRRadio.resolveLineText(line)
    if not text or text == "" then return end

    local color = ABRRadio.resolveLineColor(line, txColor, channel.color)
    local codes = ABRRadio.resolveLineCodes(line, "")

    -- Track the last sent text so clients can reference it in reports
    local active = ABRRadioServer.activeTransmissions[channelId]
    if active then
        active.lastSentText = text
    end

    radio:SendTransmission(
        0, 0,                           -- sourceX, sourceY (0,0 = no specific location)
        channel.frequency,              -- channel frequency
        text,                           -- message text
        "",                             -- guid
        codes,                          -- effect codes
        color.r, color.g, color.b,      -- RGB color (0.0-1.0)
        channel.signalStrength,         -- signal strength (-1 = infinite range)
        channel.isTV                    -- isTV flag
    )
end


--- Process the immediate broadcast queue.
--- Immediate transmissions interrupt any current transmission on the channel.
local function processImmediateQueue()
    while #ABRRadio.immediateQueue > 0 do
        local item = table.remove(ABRRadio.immediateQueue, 1)
        local channel = ABRRadio.channels[item.channelId]
        if channel and ABRRadio.isChannelEnabled(item.channelId) then
            ABRRadioServer.activeTransmissions[item.channelId] = {
                transmission = {
                    lines = item.lines,
                    color = item.color,
                    codes = "",
                    command = item.command or nil,
                    commandArgs = item.commandArgs or nil,
                },
                currentLineIndex = 0,
                lastSentText = nil,
            }
            ABRRadioServer.listeners[item.channelId] = {}
            print("[ABRRadio Server] Immediate transmission queued on: " .. channel.name)
        end
    end
end


--- Dispatch the transmission's command to all confirmed listeners.
--- Called when an active transmission ends and has a command defined.
--- @param channelId string The channel whose transmission just ended
--- @param transmission table The transmission definition
local function dispatchCommand(channelId, transmission)
    if not transmission.command then return end

    local listenerSet = ABRRadioServer.listeners[channelId]
    if not listenerSet then return end

    -- Collect listener player IDs
    local listenerIds = {}
    for onlineId, info in pairs(listenerSet) do
        table.insert(listenerIds, { onlineId = onlineId, username = info.username, linesHeard = info.linesHeard })
    end

    if #listenerIds == 0 then
        print("[ABRRadio Server] Command '" .. transmission.command .. "' has no listeners, skipping dispatch.")
        return
    end

    print("[ABRRadio Server] Dispatching command '" .. transmission.command .. "' to " .. #listenerIds .. " listeners.")

    -- Build args table to send to each client
    local cmdArgs = {
        command     = transmission.command,
        channelId   = channelId,
        txId        = transmission.id,
    }

    -- Merge custom commandArgs if defined
    if transmission.commandArgs then
        for k, v in pairs(transmission.commandArgs) do
            cmdArgs[k] = v
        end
    end

    -- Send to each confirmed listener
    local players = getOnlinePlayers()
    if players then
        for i = 0, players:size() - 1 do
            local player = players:get(i)
            if player then
                local pid = tostring(player:getOnlineID())
                if listenerSet[pid] then
                    sendServerCommand(player, ABRRadio.NET_MODULE, "EventCommand", cmdArgs)
                end
            end
        end
    end

    -- Fire server-side hook if registered
    local hook = ABRRadioServer.serverCommandHooks[transmission.command]
    if hook then
        hook(listenerIds, transmission.commandArgs or {})
    end
end


--- Process broadcasts for all channels.
--- Called every game minute. Sends one line per minute for active transmissions.
local function processBroadcasts()
    local currentDay = getCurrentDay()

    for channelId, channel in pairs(ABRRadio.channels) do
        if ABRRadio.isChannelEnabled(channelId) then
            local active = ABRRadioServer.activeTransmissions[channelId]

            if active then
                -- Active transmission: advance to next line
                active.currentLineIndex = active.currentLineIndex + 1
                local line = active.transmission.lines[active.currentLineIndex]

                if line then
                    sendLine(channel, line, active.transmission.color, channelId)
                else
                    -- Transmission complete: dispatch command to listeners, then clear
                    dispatchCommand(channelId, active.transmission)
                    ABRRadioServer.activeTransmissions[channelId] = nil
                    ABRRadioServer.listeners[channelId] = nil
                    ABRRadioServer.cooldowns[channelId] = getChannelInterval(channel)
                end
            else
                -- No active transmission: decrement cooldown
                local cd = ABRRadioServer.cooldowns[channelId] or 0
                if cd <= 0 then
                    -- Time to broadcast: pick a random transmission
                    local tx = ABRRadio.getRandomTransmission(channelId, currentDay)
                    if tx and #tx.lines > 0 then
                        -- Start new transmission: send first line immediately
                        ABRRadioServer.activeTransmissions[channelId] = {
                            transmission = tx,
                            currentLineIndex = 1,
                            lastSentText = nil,
                        }
                        ABRRadioServer.listeners[channelId] = {}
                        sendLine(channel, tx.lines[1], tx.color, channelId)
                    else
                        -- No eligible transmissions: retry later
                        ABRRadioServer.cooldowns[channelId] = ZombRand(5, 15)
                    end
                else
                    ABRRadioServer.cooldowns[channelId] = cd - 1
                end
            end
        end
    end
end


--- Keep radios discoverable on the channel list past day 14.
--- NOTE: The vanilla ZomboidRadio.update() sets the static boolean
--- `postRadioSilence = true` after daysSinceStart > 14, which tells clients
--- the radio is "silent". There is no setter method exposed for this field
--- (unlike disableBroadcasting which has setDisableBroadcasting), and Kahlua
--- does not support writing to Java static fields directly from Lua.
--- Additionally, update() re-sets it to true every tick, so even a successful
--- write would be immediately reverted.
---
--- Our custom transmissions work regardless of postRadioSilence because
--- SendTransmission bypasses the silence flag. The only effect is cosmetic:
--- clients may see a "no signal" indicator in the radio UI, but broadcasts
--- still arrive. We keep this function as a no-op placeholder in case a
--- future PZ build exposes a setter or Lua-writable field.
local function keepRadioAlive()
    -- No-op: postRadioSilence is not writable from Lua (no setter in ZomboidRadio).
end


--- Main update hook: fires every game minute.
local function onEveryOneMinute()
    -- Ensure channels are registered
    if not ABRRadioServer.channelsRegistered then
        registerChannelsWithGame()
    end

    if not ABRRadioServer.channelsRegistered then return end

    -- Keep radio alive
    keepRadioAlive()

    -- Process immediate queue first (interrupts current transmissions)
    processImmediateQueue()

    -- Process regular scheduled broadcasts
    processBroadcasts()

    ABRRadioServer.minuteCounter = ABRRadioServer.minuteCounter + 1
end


--- Hook into OnLoadRadioScripts for early channel registration.
--- This fires during ZomboidRadio.Init() with access to the script manager.
local function onLoadRadioScripts(scriptManager, isNewGame)
    print("[ABRRadio Server] OnLoadRadioScripts fired. isNewGame = " .. tostring(isNewGame))
    ABRRadioServer.scriptManager = scriptManager
    ABRRadioServer.isNewGame = isNewGame

    -- Register channels with the game engine at this early stage
    registerChannelsWithGame()
end


-- Register event hooks
Events.EveryTenMinutes.Add(onEveryOneMinute)
Events.OnLoadRadioScripts.Add(onLoadRadioScripts)


--- Handle client commands from the ABRRadio module.
--- Clients report which transmissions they heard via "ListenerReport".
--- @param module string The module name (must be ABRRadio.NET_MODULE)
--- @param command string The command name
--- @param player userdata The IsoPlayer who sent the command
--- @param args table The command arguments
local function onClientCommand(module, command, player, args)
    if module ~= ABRRadio.NET_MODULE then return end

    if command == "ListenerReport" then
        -- Client is reporting that they heard a line on a channel
        local channelId = args and args["channelId"]
        local onlineId = tostring(player:getOnlineID())
        local username = player:getUsername() or "unknown"

        if channelId and ABRRadioServer.listeners[channelId] then
            if not ABRRadioServer.listeners[channelId][onlineId] then
                ABRRadioServer.listeners[channelId][onlineId] = {
                    username = username,
                    linesHeard = 0,
                }
            end
            ABRRadioServer.listeners[channelId][onlineId].linesHeard =
                ABRRadioServer.listeners[channelId][onlineId].linesHeard + 1
        end
    end
end

Events.OnClientCommand.Add(onClientCommand)


--- Register a server-side command hook.
--- This handler fires ON THE SERVER after the command has been dispatched to clients.
--- Useful for logging, server-authoritative game state changes, or coordinated events.
--- @param commandName string The command identifier (must match transmission.command)
--- @param handler function(listenerIds, args) Called with listener list and command args
function ABRRadioServer.registerServerHook(commandName, handler)
    if not commandName or not handler then
        print("[ABRRadio Server] ERROR: registerServerHook requires commandName and handler.")
        return
    end
    ABRRadioServer.serverCommandHooks[commandName] = handler
    print("[ABRRadio Server] Registered server hook: " .. commandName)
end


--- Get the current listeners for a channel's active transmission.
--- @param channelId string
--- @return table|nil { onlineId -> { username, linesHeard } }
function ABRRadioServer.getListeners(channelId)
    return ABRRadioServer.listeners[channelId]
end


--- Check if a specific player heard the current transmission on a channel.
--- @param channelId string
--- @param onlineId number|string Player's online ID
--- @return boolean
function ABRRadioServer.playerHeardTransmission(channelId, onlineId)
    local set = ABRRadioServer.listeners[channelId]
    return set ~= nil and set[tostring(onlineId)] ~= nil
end


print("[ABRRadio Server] Server controller loaded.")
