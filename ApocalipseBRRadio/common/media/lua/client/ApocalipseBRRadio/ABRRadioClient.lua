--[[
    APOCALIPSE [BR] - Radio Client Handler
    Client-side transmission detection, listener reporting, and command dispatch.

    FLOW:
        1. OnDeviceText fires when the local player's radio receives text
        2. We match the text against known ABR transmission lines (via frequency lookup)
        3. If matched, we send a ListenerReport to the server
        4. When the server dispatches an EventCommand back, we route it to the
           registered command handler (ABRRadio.registerCommandHandler)

    SINGLE-PLAYER:
        In single-player mode, the server controller and client handler both run
        in the same Lua VM. Listener tracking still works — the local player is
        registered as a listener. Command dispatch uses direct function calls
        instead of network commands.
]]

require "ApocalipseBRRadio/ABRRadioFramework"

ABRRadioClient = ABRRadioClient or {}

-- Cache of resolved transmission texts per frequency for fast matching.
-- frequency -> { resolvedText -> channelId }
ABRRadioClient.textLookup = {}

-- Whether the text lookup cache has been built
ABRRadioClient.lookupReady = false


--- Build the text lookup cache from all registered transmissions.
--- Maps each resolved line text to its channel ID, keyed by frequency.
--- Must be called after all transmissions are registered and translations loaded.
local function buildTextLookup()
    ABRRadioClient.textLookup = {}

    for channelId, channel in pairs(ABRRadio.channels) do
        local freq = channel.frequency
        if not ABRRadioClient.textLookup[freq] then
            ABRRadioClient.textLookup[freq] = {}
        end

        local transmissions = ABRRadio.transmissions[channelId]
        if transmissions then
            for _, tx in ipairs(transmissions) do
                local textSet = ABRRadio.buildTransmissionTextSet(tx)
                for text, _ in pairs(textSet) do
                    ABRRadioClient.textLookup[freq][text] = channelId
                end
            end
        end
    end

    ABRRadioClient.lookupReady = true
    print("[ABRRadio Client] Text lookup cache built.")
end


--- Report to the server that the local player heard a transmission line.
--- @param channelId string The ABR channel the text was received on
local function reportListenerToServer(channelId)
    local player = getPlayer()
    if not player then return end

    -- In single-player, directly update the server state
    if not isClient() then
        if ABRRadioServer and ABRRadioServer.listeners and ABRRadioServer.listeners[channelId] then
            local pid = "0"
            if not ABRRadioServer.listeners[channelId][pid] then
                ABRRadioServer.listeners[channelId][pid] = {
                    username = player:getUsername() or "Player",
                    linesHeard = 0,
                }
            end
            ABRRadioServer.listeners[channelId][pid].linesHeard =
                ABRRadioServer.listeners[channelId][pid].linesHeard + 1
        end
        return
    end

    -- Multiplayer: send via network
    local args = { channelId = channelId }
    sendClientCommand(player, ABRRadio.NET_MODULE, "ListenerReport", args)
end


--- OnDeviceText hook — fires when the local player's radio device receives text.
--- Parameters from Java: guid, codes, x, y, z, text, device
--- For portable (inventory) radios: x, y, z = -1, -1, -1
local function onDeviceText(guid, codes, x, y, z, text, device)
    if not ABRRadioClient.lookupReady then return end
    if not text or text == "" then return end
    if not device then return end

    -- Get the device's current frequency to narrow the lookup
    local deviceData = nil
    if device.getDeviceData then
        deviceData = device:getDeviceData()
    elseif device.getChannel then
        -- device might be a DeviceData directly
        deviceData = device
    end

    if not deviceData then return end

    local freq = nil
    if deviceData.getChannel then
        freq = deviceData:getChannel()
    end

    if not freq then return end

    -- Check if this text matches any ABR transmission on this frequency
    local freqLookup = ABRRadioClient.textLookup[freq]
    if not freqLookup then return end

    local channelId = freqLookup[text]
    if not channelId then return end

    -- This player heard an ABR transmission line — report to server
    reportListenerToServer(channelId)
end


--- OnServerCommand hook — receives event commands dispatched by the server
--- after a transmission ends and listeners are confirmed.
--- @param module string Module name
--- @param command string Command name
--- @param args table Command arguments
local function onServerCommand(module, command, args)
    if module ~= ABRRadio.NET_MODULE then return end

    if command == "EventCommand" then
        local cmdName = args and args["command"]
        if not cmdName then
            print("[ABRRadio Client] Received EventCommand with no command name.")
            return
        end

        local handler = ABRRadio.commandHandlers[cmdName]
        if handler then
            local player = getPlayer()
            print("[ABRRadio Client] Executing command: " .. cmdName)
            handler(player, args)
        else
            print("[ABRRadio Client] No handler for command: " .. cmdName)
        end
    end
end


--- Game start initialization.
local function onGameStart()
    -- Build lookup cache once translations and transmissions are loaded
    buildTextLookup()

    print("[ABRRadio Client] Client initialized. Framework v" .. ABRRadio.VERSION)
    print("[ABRRadio Client] " .. #ABRRadio.getChannelIds() .. " channels registered.")
    print("[ABRRadio Client] " .. (ABRRadioClient.lookupReady and "Text lookup ready." or "Text lookup FAILED."))
end


-- Register event hooks
Events.OnGameStart.Add(onGameStart)
Events.OnDeviceText.Add(onDeviceText)
Events.OnServerCommand.Add(onServerCommand)

print("[ABRRadio Client] Client handler loaded.")
