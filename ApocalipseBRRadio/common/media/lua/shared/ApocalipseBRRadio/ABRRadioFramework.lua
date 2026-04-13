--[[
    APOCALIPSE [BR] - Radio Framework v1.0.0
    Core API for custom radio channel and transmission management.

    This framework provides a simple, data-driven API to register custom radio
    channels and transmissions. The server controller (ABRRadioServer) handles
    scheduling, broadcasting, and radio keep-alive.

    USAGE:
        -- Register a channel
        ABRRadio.registerChannel({
            id = "my_channel",
            name = "My Channel Name",
            frequency = 95000,
            category = "Radio",
            color = { r = 0.0, g = 0.8, b = 0.0 },
            intervalMin = 3,
            intervalMax = 10,
        })

        -- Register transmissions for that channel
        ABRRadio.registerTransmission("my_channel", {
            id = "tx_greeting",
            lines = { "UI_MY_LINE_01", "UI_MY_LINE_02", "<bzzt>" },
            weight = 10,
        })

        -- Trigger an immediate one-shot transmission (for events)
        ABRRadio.triggerImmediate("my_channel", {
            "UI_MY_EVENT_LINE_01",
            "UI_MY_EVENT_LINE_02",
        })

    NOTES:
        - Lines starting with "UI_" or "IGUI_" are resolved via getText() (translation system)
        - Static sounds (<bzzt>, <fzzt>, <wzzt>, <szzt>) pass through as-is
        - Lines can be strings or tables: { text = "...", color = {r,g,b}, codes = "..." }
        - Signal strength -1 means infinite range (reaches all players)
        - Channels can be tied to sandbox options for easy toggling
]]

ABRRadio = ABRRadio or {}

ABRRadio.VERSION = "1.1.0"

-- Module name for sendServerCommand / sendClientCommand networking
ABRRadio.NET_MODULE = "ABRRadio"

-- Channel registry: channelId -> channel config
ABRRadio.channels = {}

-- Reverse lookup: frequency (number) -> channelId (string)
ABRRadio.frequencyToChannel = {}

-- Transmission registry: channelId -> list of transmissions
ABRRadio.transmissions = {}

-- Immediate broadcast queue (processed by server controller)
ABRRadio.immediateQueue = {}

-- Client-side command handlers: commandName -> handler function(player, args)
ABRRadio.commandHandlers = {}


--- Get the ZomboidRadio singleton instance.
--- @return userdata|nil ZomboidRadio instance
function ABRRadio.getRadio()
    if getZomboidRadio then
        return getZomboidRadio()
    end
    if ZomboidRadio and ZomboidRadio.getInstance then
        return ZomboidRadio.getInstance()
    end
    return nil
end


--- Register a custom radio channel.
--- @param config table Channel configuration:
---   id             (string)  [REQUIRED] Unique channel identifier
---   name           (string)  Display name shown in radio UI
---   frequency      (number)  Broadcast frequency (e.g. 91600 = 91.6 MHz)
---   category       (string)  "Radio"|"Emergency"|"Military"|"Amateur"|"Other"|"Television"|"Bandit"
---   color          (table)   Default line color { r, g, b } in 0.0-1.0 range
---   intervalMin    (number)  Min game minutes between transmissions (default: 3)
---   intervalMax    (number)  Max game minutes between transmissions (default: 12)
---   signalStrength (number)  Signal range in tiles; -1 = infinite (default: -1)
---   isTV           (boolean) Is this a television channel? (default: false)
---   enabled        (boolean) Is channel enabled by default? (default: true)
---   sandboxOption  (string)  SandboxVars.ApocalipseBRRadio.<key> that controls this channel
--- @return boolean Success
function ABRRadio.registerChannel(config)
    if not config or not config.id then
        print("[ABRRadio] ERROR: Channel config must have an 'id' field.")
        return false
    end

    if ABRRadio.channels[config.id] then
        print("[ABRRadio] WARNING: Overwriting channel '" .. config.id .. "'")
    end

    ABRRadio.channels[config.id] = {
        id              = config.id,
        name            = config.name or "Unknown Channel",
        frequency       = config.frequency or 91400,
        category        = config.category or "Radio",
        color           = config.color or { r = 0.0, g = 0.8, b = 0.0 },
        intervalMin     = config.intervalMin or 3,
        intervalMax     = config.intervalMax or 12,
        signalStrength  = config.signalStrength or -1,
        isTV            = config.isTV == true,
        enabled         = config.enabled ~= false,
        sandboxOption   = config.sandboxOption or nil,
    }

    if not ABRRadio.transmissions[config.id] then
        ABRRadio.transmissions[config.id] = {}
    end

    -- Register reverse frequency lookup
    ABRRadio.frequencyToChannel[ABRRadio.channels[config.id].frequency] = config.id

    print("[ABRRadio] Registered channel: " .. (config.name or config.id) .. " @ " .. (config.frequency or "?"))
    return true
end


--- Register a transmission for a channel.
--- @param channelId string The channel to add the transmission to
--- @param tx table Transmission definition:
---   id      (string)  Unique transmission ID (auto-generated if nil)
---   lines   (table)   Array of lines (strings or tables with text/color/codes)
---   color   (table)   Optional color override { r, g, b } for all lines in this transmission
---   codes   (string)  Optional effect codes string (default: "")
---   weight  (number)  Random selection weight; higher = more likely (default: 10)
---   minDay  (number)  Earliest game day this transmission can play (default: 0)
---   maxDay  (number)  Latest game day; -1 = no limit (default: -1)
---   command (string)  Optional event command sent to listeners after the last line
---   commandArgs (table) Optional key-value args passed alongside the command
--- @return boolean Success
function ABRRadio.registerTransmission(channelId, tx)
    if not tx then
        print("[ABRRadio] ERROR: Transmission cannot be nil.")
        return false
    end

    if not ABRRadio.transmissions[channelId] then
        ABRRadio.transmissions[channelId] = {}
    end

    local transmission = {
        id          = tx.id or (channelId .. "_tx_" .. (#ABRRadio.transmissions[channelId] + 1)),
        lines       = tx.lines or {},
        color       = tx.color or nil,
        codes       = tx.codes or "",
        weight      = tx.weight or 10,
        minDay      = tx.minDay or 0,
        maxDay      = tx.maxDay or -1,
        command     = tx.command or nil,
        commandArgs = tx.commandArgs or nil,
    }

    table.insert(ABRRadio.transmissions[channelId], transmission)
    return true
end


--- Queue an immediate one-shot transmission on a channel.
--- This interrupts any current transmission and broadcasts immediately.
--- Useful for event-triggered broadcasts.
--- @param channelId string Channel to broadcast on
--- @param lines table Array of line strings/tables
--- @param color table Optional color override { r, g, b }
--- @param command string Optional event command dispatched to listeners after last line
--- @param commandArgs table Optional key-value args passed alongside the command
function ABRRadio.triggerImmediate(channelId, lines, color, command, commandArgs)
    if not channelId or not lines or #lines == 0 then
        print("[ABRRadio] ERROR: triggerImmediate requires channelId and non-empty lines.")
        return
    end
    table.insert(ABRRadio.immediateQueue, {
        channelId = channelId,
        lines = lines,
        color = color,
        command = command,
        commandArgs = commandArgs,
    })
end


--- Get a weighted random transmission for a channel, filtered by current game day.
--- @param channelId string Channel identifier
--- @param currentDay number Current game day (days since apocalypse start)
--- @return table|nil The selected transmission, or nil if none eligible
function ABRRadio.getRandomTransmission(channelId, currentDay)
    local pool = ABRRadio.transmissions[channelId]
    if not pool or #pool == 0 then return nil end

    local eligible = {}
    local totalWeight = 0

    for _, tx in ipairs(pool) do
        local dayOk = currentDay >= tx.minDay and (tx.maxDay == -1 or currentDay <= tx.maxDay)
        if dayOk then
            table.insert(eligible, tx)
            totalWeight = totalWeight + tx.weight
        end
    end

    if #eligible == 0 or totalWeight <= 0 then return nil end

    local roll = ZombRand(totalWeight)
    local cumulative = 0
    for _, tx in ipairs(eligible) do
        cumulative = cumulative + tx.weight
        if roll < cumulative then
            return tx
        end
    end

    return eligible[#eligible]
end


--- Resolve a line to its display text.
--- Handles: plain strings, translation keys (UI_/IGUI_ prefix), and table entries.
--- Static sounds (<bzzt>, <fzzt>, <wzzt>, <szzt>) pass through unchanged.
--- @param line string|table The line to resolve
--- @return string The resolved display text
function ABRRadio.resolveLineText(line)
    local text
    if type(line) == "table" then
        text = line.text or ""
    elseif type(line) == "string" then
        text = line
    else
        return ""
    end

    -- Resolve translation keys
    if getText and (string.find(text, "^UI_") or string.find(text, "^IGUI_")) then
        local translated = getText(text)
        if translated and translated ~= text then
            return translated
        end
    end

    return text
end


--- Resolve the color for a specific line.
--- Priority: per-line color > transmission color > channel color > default green.
--- @param line string|table The line definition
--- @param txColor table|nil Transmission-level color override
--- @param channelColor table Channel's default color
--- @return table { r, g, b }
function ABRRadio.resolveLineColor(line, txColor, channelColor)
    if type(line) == "table" and line.color then
        return line.color
    end
    return txColor or channelColor or { r = 0.0, g = 0.8, b = 0.0 }
end


--- Resolve effect codes for a line.
--- @param line string|table The line definition
--- @param txCodes string Default codes from the transmission
--- @return string Effect codes string
function ABRRadio.resolveLineCodes(line, txCodes)
    if type(line) == "table" and line.codes then
        return line.codes
    end
    return txCodes or ""
end


--- Check if a channel is enabled, considering sandbox options.
--- @param channelId string Channel identifier
--- @return boolean
function ABRRadio.isChannelEnabled(channelId)
    local channel = ABRRadio.channels[channelId]
    if not channel then return false end
    if not channel.enabled then return false end

    -- Check linked sandbox option
    if channel.sandboxOption and SandboxVars and SandboxVars.ApocalipseBRRadio then
        local optionValue = SandboxVars.ApocalipseBRRadio[channel.sandboxOption]
        if optionValue ~= nil then
            return optionValue
        end
    end

    return true
end


--- Get all registered channel IDs.
--- @return table Array of channel ID strings
function ABRRadio.getChannelIds()
    local ids = {}
    for id, _ in pairs(ABRRadio.channels) do
        table.insert(ids, id)
    end
    return ids
end


--- Get channel configuration by ID.
--- @param channelId string
--- @return table|nil Channel config table
function ABRRadio.getChannel(channelId)
    return ABRRadio.channels[channelId]
end


--- Get the number of registered transmissions for a channel.
--- @param channelId string
--- @return number
function ABRRadio.getTransmissionCount(channelId)
    local pool = ABRRadio.transmissions[channelId]
    return pool and #pool or 0
end


--- Look up the channelId for a given frequency.
--- @param frequency number
--- @return string|nil channelId
function ABRRadio.getChannelIdByFrequency(frequency)
    return ABRRadio.frequencyToChannel[frequency]
end


--- Register a client-side command handler.
--- When the server dispatches a command (after a transmission ends and listeners
--- are confirmed), the client executes the matching handler.
--- @param commandName string The command identifier (must match transmission.command)
--- @param handler function(player, args) Called with the local player and command args
function ABRRadio.registerCommandHandler(commandName, handler)
    if not commandName or not handler then
        print("[ABRRadio] ERROR: registerCommandHandler requires commandName and handler.")
        return
    end
    ABRRadio.commandHandlers[commandName] = handler
    print("[ABRRadio] Registered command handler: " .. commandName)
end


--- Build a resolved text lookup table for a transmission's lines.
--- Used by the client to match incoming OnDeviceText lines to known transmissions.
--- @param tx table Transmission definition
--- @return table Set of resolved text strings (text -> true)
function ABRRadio.buildTransmissionTextSet(tx)
    local textSet = {}
    if tx and tx.lines then
        for _, line in ipairs(tx.lines) do
            local text = ABRRadio.resolveLineText(line)
            if text and text ~= "" then
                textSet[text] = true
            end
        end
    end
    return textSet
end


print("[ABRRadio] Radio Framework v" .. ABRRadio.VERSION .. " loaded.")
