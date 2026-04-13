--[[
    APOCALIPSE [BR] - Radio Transmissions
    Channel definitions and transmission content registration.

    This file defines five custom radio channels and their transmission pools.
    All transmission text uses translation keys (UI_ABR_*) resolved at broadcast
    time via the game's translation system (EN + PTBR supported).

    TO ADD NEW TRANSMISSIONS:
        Simply call ABRRadio.registerTransmission() with your channel ID and content.
        New files can be created in this same directory following the same pattern.

    TO ADD NEW CHANNELS:
        Call ABRRadio.registerChannel() with your channel config, then register
        transmissions for it. Remember to add a sandbox option if you want
        server admins to be able to toggle it.

    STATIC SOUNDS:
        The game recognizes these special strings as radio static:
        "<bzzt>", "<fzzt>", "<wzzt>", "<szzt>"
        Use them as literal lines (not translation keys) for atmosphere.
]]

require "ApocalipseBRRadio/ABRRadioFramework"


-- ============================================================================
-- CHANNEL DEFINITIONS
-- ============================================================================

-- Emergency Broadcast System - 91.6 MHz
-- Government warnings, evacuation notices, automated emergency loops
ABRRadio.registerChannel({
    id              = "emergency_broadcast",
    name            = getText("UI_ABR_CH_EmergencyBroadcast"),
    frequency       = 91600,
    category        = "Emergency",
    color           = { r = 1.0, g = 0.2, b = 0.2 },
    intervalMin     = 8,
    intervalMax     = 20,
    signalStrength  = -1,
    sandboxOption   = "EnableEmergencyBroadcast",
})

-- Ghost Radio - 66.6 MHz
-- Creepypasta, eerie whispers, numbers, unexplained transmissions
ABRRadio.registerChannel({
    id              = "ghost_radio",
    name            = getText("UI_ABR_CH_GhostRadio"),
    frequency       = 66600,
    category        = "Other",
    color           = { r = 0.6, g = 0.0, b = 0.6 },
    intervalMin     = 12,
    intervalMax     = 30,
    signalStrength  = -1,
    sandboxOption   = "EnableCreepyTransmissions",
})

-- Radio Apocalipse - 104.2 MHz
-- Survivor broadcasts, community news, morale, distress calls
ABRRadio.registerChannel({
    id              = "radio_apocalipse",
    name            = getText("UI_ABR_CH_RadioApocalipse"),
    frequency       = 104200,
    category        = "Radio",
    color           = { r = 0.2, g = 0.8, b = 0.2 },
    intervalMin     = 5,
    intervalMax     = 15,
    signalStrength  = -1,
    sandboxOption   = "EnableRadioApocalipse",
})

-- Military Communications - 310 kHz
-- Tactical comms, classified operations, coded messages
ABRRadio.registerChannel({
    id              = "military_comms",
    name            = getText("UI_ABR_CH_MilitaryComms"),
    frequency       = 310,
    category        = "Military",
    color           = { r = 0.4, g = 0.6, b = 0.2 },
    intervalMin     = 15,
    intervalMax     = 35,
    signalStrength  = -1,
    sandboxOption   = "EnableMilitaryComms",
})

-- Numbers Station - 47.8 MHz
-- Cryptic number sequences, encoded messages, eerie automation
ABRRadio.registerChannel({
    id              = "numbers_station",
    name            = getText("UI_ABR_CH_NumbersStation"),
    frequency       = 47800,
    category        = "Other",
    color           = { r = 0.5, g = 0.5, b = 0.5 },
    intervalMin     = 10,
    intervalMax     = 25,
    signalStrength  = -1,
    sandboxOption   = "EnableNumbersStation",
})


-- ============================================================================
-- EMERGENCY BROADCAST SYSTEM TRANSMISSIONS
-- ============================================================================

-- EBS_01: Standard evacuation warning
ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_01",
    lines = {
        "UI_ABR_EBS_01_L01",
        "UI_ABR_EBS_01_L02",
        "UI_ABR_EBS_01_L03",
        "UI_ABR_EBS_01_L04",
        "<bzzt>",
    },
    weight = 15,
    minDay = 0,
})

-- EBS_02: Quarantine zone expansion
ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_02",
    lines = {
        "UI_ABR_EBS_02_L01",
        "UI_ABR_EBS_02_L02",
        "<fzzt>",
        "UI_ABR_EBS_02_L03",
        "<bzzt>",
    },
    weight = 12,
    minDay = 0,
})

-- EBS_03: Supply drop notice
ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_03",
    lines = {
        "UI_ABR_EBS_03_L01",
        "UI_ABR_EBS_03_L02",
        "UI_ABR_EBS_03_L03",
        "<bzzt>",
    },
    weight = 10,
    minDay = 0,
    maxDay = 30,
})

-- EBS_04: Automated loop (station abandoned)
ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_04",
    lines = {
        "<wzzt>",
        "UI_ABR_EBS_04_L01",
        "UI_ABR_EBS_04_L02",
        "UI_ABR_EBS_04_L03",
        "UI_ABR_EBS_04_L04",
        "<bzzt>",
    },
    weight = 20,
    minDay = 14,
})

-- EBS_05: Desperate final message
ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_05",
    lines = {
        "<szzt>",
        "UI_ABR_EBS_05_L01",
        "UI_ABR_EBS_05_L02",
        "UI_ABR_EBS_05_L03",
        "UI_ABR_EBS_05_L04",
        "UI_ABR_EBS_05_L05",
        "<bzzt>",
    },
    weight = 15,
    minDay = 21,
})

-- EBS_06: Containment failure alert (triggers alarm event for listeners)
ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_06",
    lines = {
        "UI_ABR_EBS_06_L01",
        "UI_ABR_EBS_06_L02",
        "UI_ABR_EBS_06_L03",
        "<fzzt>",
        "UI_ABR_EBS_06_L04",
        "<bzzt>",
    },
    weight = 10,
    minDay = 7,
    command = "ContainmentBreach",
    commandArgs = { sector = "south" },
})


-- ============================================================================
-- GHOST RADIO TRANSMISSIONS (CREEPYPASTA)
-- ============================================================================

-- GHO_01: Numbers whisper
ABRRadio.registerTransmission("ghost_radio", {
    id = "gho_01",
    lines = {
        "<wzzt>",
        "UI_ABR_GHO_01_L01",
        "<szzt>",
        "UI_ABR_GHO_01_L02",
        "UI_ABR_GHO_01_L03",
        "<bzzt>",
    },
    weight = 10,
    minDay = 0,
})

-- GHO_02: Child's voice
ABRRadio.registerTransmission("ghost_radio", {
    id = "gho_02",
    lines = {
        "<fzzt>",
        "UI_ABR_GHO_02_L01",
        "UI_ABR_GHO_02_L02",
        "UI_ABR_GHO_02_L03",
        "<wzzt>",
        "UI_ABR_GHO_02_L04",
        "<szzt>",
    },
    weight = 12,
    minDay = 3,
})

-- GHO_03: Warning message
ABRRadio.registerTransmission("ghost_radio", {
    id = "gho_03",
    lines = {
        "<fzzt>",
        "<wzzt>",
        "UI_ABR_GHO_03_L01",
        "UI_ABR_GHO_03_L02",
        "UI_ABR_GHO_03_L03",
        "<szzt>",
        "UI_ABR_GHO_03_L04",
        "<bzzt>",
    },
    weight = 8,
    minDay = 7,
})

-- GHO_04: The Watcher
ABRRadio.registerTransmission("ghost_radio", {
    id = "gho_04",
    lines = {
        "UI_ABR_GHO_04_L01",
        "UI_ABR_GHO_04_L02",
        "UI_ABR_GHO_04_L03",
        "<szzt>",
    },
    color = { r = 0.8, g = 0.0, b = 0.0 },
    weight = 15,
    minDay = 10,
})

-- GHO_05: Time loop
ABRRadio.registerTransmission("ghost_radio", {
    id = "gho_05",
    lines = {
        "UI_ABR_GHO_05_L01",
        "UI_ABR_GHO_05_L02",
        "UI_ABR_GHO_05_L03",
        "<fzzt>",
        "UI_ABR_GHO_05_L04",
        "<bzzt>",
    },
    weight = 10,
    minDay = 5,
})

-- GHO_06: The Countdown
ABRRadio.registerTransmission("ghost_radio", {
    id = "gho_06",
    lines = {
        "UI_ABR_GHO_06_L01",
        "<wzzt>",
        "UI_ABR_GHO_06_L02",
        "UI_ABR_GHO_06_L03",
        "UI_ABR_GHO_06_L04",
        "<szzt>",
    },
    weight = 10,
    minDay = 14,
})

-- GHO_07: The Invitation (triggers paranormal event for listeners)
ABRRadio.registerTransmission("ghost_radio", {
    id = "gho_07",
    lines = {
        "<wzzt>",
        "UI_ABR_GHO_07_L01",
        "UI_ABR_GHO_07_L02",
        "UI_ABR_GHO_07_L03",
        "UI_ABR_GHO_07_L04",
        "<bzzt>",
    },
    color = { r = 0.7, g = 0.0, b = 0.3 },
    weight = 12,
    minDay = 21,
    command = "ParanormalEvent",
    commandArgs = { type = "invasion" },
})


-- ============================================================================
-- RADIO APOCALIPSE TRANSMISSIONS (SURVIVOR BROADCASTS)
-- ============================================================================

-- APO_01: Station introduction
ABRRadio.registerTransmission("radio_apocalipse", {
    id = "apo_01",
    lines = {
        "UI_ABR_APO_01_L01",
        "UI_ABR_APO_01_L02",
        "UI_ABR_APO_01_L03",
        "UI_ABR_APO_01_L04",
    },
    weight = 20,
    minDay = 0,
})

-- APO_02: Horde warning (triggers horde activity event for listeners)
ABRRadio.registerTransmission("radio_apocalipse", {
    id = "apo_02",
    lines = {
        "UI_ABR_APO_02_L01",
        "UI_ABR_APO_02_L02",
        "UI_ABR_APO_02_L03",
        "<bzzt>",
    },
    color = { r = 1.0, g = 0.6, b = 0.0 },
    weight = 12,
    minDay = 3,
    command = "HordeWarning",
    commandArgs = { intensity = "medium", area = "west_point" },
})

-- APO_03: Settlement update
ABRRadio.registerTransmission("radio_apocalipse", {
    id = "apo_03",
    lines = {
        "UI_ABR_APO_03_L01",
        "UI_ABR_APO_03_L02",
        "UI_ABR_APO_03_L03",
    },
    weight = 10,
    minDay = 7,
})

-- APO_04: Raider warning
ABRRadio.registerTransmission("radio_apocalipse", {
    id = "apo_04",
    lines = {
        "UI_ABR_APO_04_L01",
        "UI_ABR_APO_04_L02",
        "UI_ABR_APO_04_L03",
        "<fzzt>",
    },
    color = { r = 1.0, g = 0.3, b = 0.0 },
    weight = 10,
    minDay = 10,
})

-- APO_05: Morale message (night broadcast)
ABRRadio.registerTransmission("radio_apocalipse", {
    id = "apo_05",
    lines = {
        "UI_ABR_APO_05_L01",
        "UI_ABR_APO_05_L02",
        "UI_ABR_APO_05_L03",
        "UI_ABR_APO_05_L04",
    },
    weight = 15,
    minDay = 0,
})

-- APO_06: Distress call
ABRRadio.registerTransmission("radio_apocalipse", {
    id = "apo_06",
    lines = {
        "<fzzt>",
        "UI_ABR_APO_06_L01",
        "UI_ABR_APO_06_L02",
        "UI_ABR_APO_06_L03",
        "UI_ABR_APO_06_L04",
        "<bzzt>",
    },
    color = { r = 1.0, g = 0.0, b = 0.0 },
    weight = 8,
    minDay = 5,
})


-- ============================================================================
-- MILITARY COMMUNICATIONS TRANSMISSIONS
-- ============================================================================

-- MIL_01: Failed extraction request
ABRRadio.registerTransmission("military_comms", {
    id = "mil_01",
    lines = {
        "UI_ABR_MIL_01_L01",
        "UI_ABR_MIL_01_L02",
        "UI_ABR_MIL_01_L03",
        "<bzzt>",
        "UI_ABR_MIL_01_L04",
        "<szzt>",
    },
    weight = 12,
    minDay = 0,
})

-- MIL_02: Containment breach (triggers military response event)
ABRRadio.registerTransmission("military_comms", {
    id = "mil_02",
    lines = {
        "UI_ABR_MIL_02_L01",
        "UI_ABR_MIL_02_L02",
        "UI_ABR_MIL_02_L03",
        "UI_ABR_MIL_02_L04",
        "<bzzt>",
    },
    weight = 10,
    minDay = 3,
    command = "MilitaryResponse",
    commandArgs = { action = "fallback", sector = 9 },
})

-- MIL_03: Classified operation
ABRRadio.registerTransmission("military_comms", {
    id = "mil_03",
    lines = {
        "<fzzt>",
        "UI_ABR_MIL_03_L01",
        "UI_ABR_MIL_03_L02",
        "UI_ABR_MIL_03_L03",
        "UI_ABR_MIL_03_L04",
        "<szzt>",
    },
    color = { r = 0.5, g = 0.5, b = 0.5 },
    weight = 8,
    minDay = 14,
})

-- MIL_04: Lost patrol distress
ABRRadio.registerTransmission("military_comms", {
    id = "mil_04",
    lines = {
        "<wzzt>",
        "UI_ABR_MIL_04_L01",
        "UI_ABR_MIL_04_L02",
        "UI_ABR_MIL_04_L03",
        "UI_ABR_MIL_04_L04",
        "<bzzt>",
    },
    weight = 12,
    minDay = 7,
})

-- MIL_05: Final military broadcast
ABRRadio.registerTransmission("military_comms", {
    id = "mil_05",
    lines = {
        "UI_ABR_MIL_05_L01",
        "UI_ABR_MIL_05_L02",
        "UI_ABR_MIL_05_L03",
        "UI_ABR_MIL_05_L04",
        "UI_ABR_MIL_05_L05",
        "<bzzt>",
    },
    weight = 15,
    minDay = 21,
})


-- ============================================================================
-- NUMBERS STATION TRANSMISSIONS
-- ============================================================================

-- NUM_01: The Sequence (LOST reference)
ABRRadio.registerTransmission("numbers_station", {
    id = "num_01",
    lines = {
        "<wzzt>",
        "UI_ABR_NUM_01_L01",
        "<fzzt>",
        "UI_ABR_NUM_01_L02",
        "<szzt>",
    },
    weight = 15,
    minDay = 0,
})

-- NUM_02: NATO phonetic alphabet
ABRRadio.registerTransmission("numbers_station", {
    id = "num_02",
    lines = {
        "UI_ABR_NUM_02_L01",
        "UI_ABR_NUM_02_L02",
        "<wzzt>",
        "UI_ABR_NUM_02_L03",
        "<bzzt>",
    },
    weight = 10,
    minDay = 0,
})

-- NUM_03: Coordinates
ABRRadio.registerTransmission("numbers_station", {
    id = "num_03",
    lines = {
        "<fzzt>",
        "UI_ABR_NUM_03_L01",
        "<wzzt>",
        "UI_ABR_NUM_03_L02",
        "UI_ABR_NUM_03_L03",
        "<szzt>",
    },
    weight = 12,
    minDay = 7,
})

-- NUM_04: Binary (spells "HELP" in ASCII)
ABRRadio.registerTransmission("numbers_station", {
    id = "num_04",
    lines = {
        "UI_ABR_NUM_04_L01",
        "<fzzt>",
        "UI_ABR_NUM_04_L02",
        "<wzzt>",
        "UI_ABR_NUM_04_L03",
        "<szzt>",
    },
    weight = 8,
    minDay = 14,
})

-- NUM_05: Signal pattern
ABRRadio.registerTransmission("numbers_station", {
    id = "num_05",
    lines = {
        "<wzzt>",
        "UI_ABR_NUM_05_L01",
        "UI_ABR_NUM_05_L02",
        "UI_ABR_NUM_05_L03",
        "<szzt>",
    },
    weight = 10,
    minDay = 0,
})


-- ============================================================================
print("[ABRRadio] Registered " .. ABRRadio.getTransmissionCount("emergency_broadcast") .. " emergency transmissions.")
print("[ABRRadio] Registered " .. ABRRadio.getTransmissionCount("ghost_radio") .. " ghost radio transmissions.")
print("[ABRRadio] Registered " .. ABRRadio.getTransmissionCount("radio_apocalipse") .. " survivor transmissions.")
print("[ABRRadio] Registered " .. ABRRadio.getTransmissionCount("military_comms") .. " military transmissions.")
print("[ABRRadio] Registered " .. ABRRadio.getTransmissionCount("numbers_station") .. " numbers station transmissions.")
print("[ABRRadio] All transmissions loaded.")
