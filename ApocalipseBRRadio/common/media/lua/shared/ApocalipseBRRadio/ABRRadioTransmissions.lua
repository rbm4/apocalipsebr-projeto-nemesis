--[[
    APOCALIPSE [BR] - Radio Transmissions v2.0.0
    Channel definitions and transmission content registration.

    This file registers all custom radio channels and loads their transmission
    pools from individual files. Each channel has its own dedicated file under
    the ApocalipseBRRadio/ directory.

    CHANNEL FILES:
        ABRTransmissions_Emergency.lua   - Emergency Broadcast System (91.6 MHz)
        ABRTransmissions_Ghost.lua       - Ghost Radio (66.6 MHz)
        ABRTransmissions_Apocalipse.lua  - Radio Apocalipse (104.2 MHz)
        ABRTransmissions_Military.lua    - Military Communications (310 kHz)
        ABRTransmissions_Numbers.lua     - Numbers Station (47.8 MHz)
        ABRTransmissions_Alexandria.lua  - The Alexandria Library (108.0 MHz)

    TO ADD A NEW CHANNEL:
        1. Register the channel below with ABRRadio.registerChannel()
        2. Create a new ABRTransmissions_<Name>.lua file with its transmissions
        3. Add a require line at the bottom of this file
        4. Add a sandbox option in sandbox-options.txt and Sandbox.json translations

    STATIC SOUNDS:
        The game recognizes these special strings as radio static:
        "<bzzt>", "<fzzt>", "<wzzt>", "<szzt>"
        Use them as literal strings (not i18n tables) for atmosphere.
]]

require "ApocalipseBRRadio/ABRRadioFramework"


-- ============================================================================
-- CHANNEL DEFINITIONS
-- ============================================================================

-- Emergency Broadcast System - 91.6 MHz
ABRRadio.registerChannel({
    id              = "emergency_broadcast",
    name            = { EN = "Emergency Broadcast System", PTBR = "Sistema de Alerta de Emergencia" },
    description     = {
        EN = "Automated government emergency broadcasts. Evacuation orders, containment updates, and survival directives from what remains of Central Command.",
        PTBR = "Transmissoes automatizadas de emergencia do governo. Ordens de evacuacao, atualizacoes de contencao e diretivas de sobrevivencia do que resta do Comando Central.",
    },
    frequency       = 91600,
    category        = "Emergency",
    color           = { r = 1.0, g = 0.2, b = 0.2 },
    intervalMin     = 8,
    intervalMax     = 20,
    signalStrength  = -1,
    sandboxOption   = "EnableEmergencyBroadcast",
})

-- Ghost Radio - 66.6 MHz
ABRRadio.registerChannel({
    id              = "ghost_radio",
    name            = { EN = "Ghost Radio", PTBR = "Radio Fantasma" },
    description     = {
        EN = "A frequency no one claims to operate. Unsettling whispers, cryptic warnings, and voices that seem to know things they shouldn't. Tune in at your own risk.",
        PTBR = "Uma frequencia que ninguem afirma operar. Sussurros perturbadores, avisos enigmaticos e vozes que parecem saber coisas que nao deveriam. Sintonize por sua conta e risco.",
    },
    frequency       = 66600,
    category        = "Other",
    color           = { r = 0.6, g = 0.0, b = 0.6 },
    intervalMin     = 25,
    intervalMax     = 30,
    signalStrength  = -1,
    sandboxOption   = "EnableCreepyTransmissions",
})

-- Radio Apocalipse - 104.2 MHz
ABRRadio.registerChannel({
    id              = "radio_apocalipse",
    name            = { EN = "Radio Apocalipse", PTBR = "Radio Apocalipse" },
    description     = {
        EN = "The voice of the survivors. Community news, horde warnings, supply drop locations, and words of hope from an undisclosed location somewhere in Knox County.",
        PTBR = "A voz dos sobreviventes. Noticias da comunidade, alertas de hordas, locais de suprimentos e palavras de esperanca de um local secreto em algum lugar do Condado de Knox.",
    },
    frequency       = 104200,
    category        = "Radio",
    color           = { r = 0.2, g = 0.8, b = 0.2 },
    intervalMin     = 25,
    intervalMax     = 35,
    signalStrength  = -1,
    sandboxOption   = "EnableRadioApocalipse",
})

-- Military Communications - 310 kHz
ABRRadio.registerChannel({
    id              = "military_comms",
    name            = { EN = "Military Communications", PTBR = "Comunicacoes Militares" },
    description     = {
        EN = "Intercepted military transmissions. Tactical operations, extraction requests, and classified communications from soldiers fighting a war they've already lost.",
        PTBR = "Transmissoes militares interceptadas. Operacoes taticas, pedidos de extracao e comunicacoes classificadas de soldados lutando uma guerra que ja perderam.",
    },
    frequency       = 310,
    category        = "Military",
    color           = { r = 0.4, g = 0.6, b = 0.2 },
    intervalMin     = 15,
    intervalMax     = 35,
    signalStrength  = -1,
    sandboxOption   = "EnableMilitaryComms",
})

-- Numbers Station - 47.8 MHz
ABRRadio.registerChannel({
    id              = "numbers_station",
    name            = { EN = "Numbers Station", PTBR = "Estacao de Numeros" },
    description     = {
        EN = "An enigmatic automated broadcast of number sequences, NATO phonetic codes, and binary strings. Its purpose is unknown. Its origin is untraceable.",
        PTBR = "Uma transmissao automatizada e enigmatica de sequencias numericas, codigos foneticos NATO e strings binarias. Seu proposito e desconhecido. Sua origem e irrastreavel.",
    },
    frequency       = 47800,
    category        = "Other",
    color           = { r = 0.5, g = 0.5, b = 0.5 },
    intervalMin     = 10,
    intervalMax     = 25,
    signalStrength  = -1,
    sandboxOption   = "EnableNumbersStation",
})

-- The Alexandria Library - 1.0 MHz
ABRRadio.registerChannel({
    id              = "alexandria_library",
    name            = { EN = "The Alexandria Library", PTBR = "A Biblioteca de Alexandria" },
    description     = {
        EN = "A solitary archivist who calls herself 'The Librarian' monitors every frequency and curates the airwaves. She records, catalogs, and re-broadcasts fragments of transmissions, weaving them with her own commentary. No one knows where she transmits from, or how she is still alive.",
        PTBR = "Uma arquivista solitaria que se autodenomina 'A Bibliotecaria' monitora todas as frequencias e curadoria as ondas do radio. Ela grava, cataloga e retransmite fragmentos de transmissoes, entrelacando-os com seus proprios comentarios. Ninguem sabe de onde ela transmite, ou como ainda esta viva.",
    },
    frequency       = 1000,
    category        = "Radio",
    color           = { r = 0.8, g = 0.7, b = 0.3 },
    intervalMin     = 10,
    intervalMax     = 25,
    signalStrength  = -1,
    sandboxOption   = "EnableAlexandriaLibrary",
})

print("[ABRRadio] All channels registered.")


-- ============================================================================
-- LOAD TRANSMISSION FILES
-- ============================================================================

require "ApocalipseBRRadio/ABRTransmissions_Emergency"
require "ApocalipseBRRadio/ABRTransmissions_Ghost"
require "ApocalipseBRRadio/ABRTransmissions_Apocalipse"
require "ApocalipseBRRadio/ABRTransmissions_Military"
require "ApocalipseBRRadio/ABRTransmissions_Numbers"
require "ApocalipseBRRadio/ABRTransmissions_Alexandria"


-- ============================================================================
print("[ABRRadio] Registered " .. ABRRadio.getTransmissionCount("emergency_broadcast") .. " emergency transmissions.")
print("[ABRRadio] Registered " .. ABRRadio.getTransmissionCount("ghost_radio") .. " ghost radio transmissions.")
print("[ABRRadio] Registered " .. ABRRadio.getTransmissionCount("radio_apocalipse") .. " survivor transmissions.")
print("[ABRRadio] Registered " .. ABRRadio.getTransmissionCount("military_comms") .. " military transmissions.")
print("[ABRRadio] Registered " .. ABRRadio.getTransmissionCount("numbers_station") .. " numbers station transmissions.")
print("[ABRRadio] Registered " .. ABRRadio.getTransmissionCount("alexandria_library") .. " Alexandria Library transmissions.")
print("[ABRRadio] All transmissions loaded.")