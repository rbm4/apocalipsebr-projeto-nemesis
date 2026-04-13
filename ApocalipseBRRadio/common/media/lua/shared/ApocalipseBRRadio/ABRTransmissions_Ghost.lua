--[[
    APOCALIPSE [BR] - Ghost Radio Transmissions
    Channel: ghost_radio (66.6 MHz)

    Creepypasta-style transmissions: unsettling whispers, cryptic warnings,
    and voices from a frequency no one claims to operate.
]]


ABRRadio.registerTransmission("ghost_radio", {
    id = "gho_01",
    lines = {
        "<wzzt>",
        { EN = "Seven... seven... three... nine... two...",
          PTBR = "Sete... sete... tres... nove... dois..." },
        "<szzt>",
        { EN = "Repeat: seven... seven... three... nine... two...",
          PTBR = "Repita: sete... sete... tres... nove... dois..." },
        { EN = "... the door is open... the door is open...",
          PTBR = "... a porta esta aberta... a porta esta aberta..." },
        "<bzzt>",
    },
    weight = 10,
    minDay = 0,
})

ABRRadio.registerTransmission("ghost_radio", {
    id = "gho_02",
    lines = {
        "<fzzt>",
        { EN = "Can you hear me? ... Is someone there?",
          PTBR = "Alguem pode me ouvir? ... Tem alguem ai?" },
        { EN = "Mommy said not to go outside. But mommy doesn't talk anymore.",
          PTBR = "A mamae disse pra nao sair. Mas a mamae nao fala mais." },
        { EN = "The man at the window... he's still there... he's always there...",
          PTBR = "O homem na janela... ele ainda esta la... ele sempre esta la..." },
        "<wzzt>",
        { EN = "... come play with us...",
          PTBR = "... tenho medo... Estou sozinho..." },
        "<szzt>",
    },
    weight = 12,
    minDay = 3,
})

ABRRadio.registerTransmission("ghost_radio", {
    id = "gho_03",
    lines = {
        "<fzzt>",
        "<wzzt>",
        { EN = "T-H-E-Y ... C-A-N ... H-E-A-R ... Y-O-U",
          PTBR = "E-L-E-S ... P-O-D-E-M ... T-E ... O-U-V-I-R" },
        { EN = "... seventeen days since last contact...",
          PTBR = "... dezessete dias desde o ultimo contato..." },
        { EN = "DO NOT TUNE TO THIS FREQUENCY AGAIN",
          PTBR = "NAO SINTONIZE ESTA FREQUENCIA NOVAMENTE" },
        "<szzt>",
        { EN = "... you were warned...",
          PTBR = "... voce foi avisado..." },
        "<bzzt>",
    },
    weight = 8,
    minDay = 7,
})

ABRRadio.registerTransmission("ghost_radio", {
    id = "gho_04",
    lines = {
        { EN = "I can see you.",
          PTBR = "Eu posso te ver." },
        { EN = "You checked the locks, didn't you? ... Good.",
          PTBR = "Voce verificou as trancas, nao foi? ... Bom." },
        { EN = "But it won't matter. They're already inside.",
          PTBR = "Mas nao vai adiantar. Eles ja estao la dentro." },
        "<szzt>",
    },
    color = { r = 0.8, g = 0.0, b = 0.0 },
    weight = 15,
    minDay = 10,
})

ABRRadio.registerTransmission("ghost_radio", {
    id = "gho_05",
    lines = {
        { EN = "Day 1: Everything is fine.",
          PTBR = "Dia 1: Esta tudo bem." },
        { EN = "Day 1: Everything is fine.",
          PTBR = "Dia 1: Esta tudo bem." },
        { EN = "Day 1: Everything is fine.",
          PTBR = "Dia 1: Esta tudo bem." },
        "<fzzt>",
        { EN = "Day 1: Everything is... not fine.",
          PTBR = "Dia 1: Esta tudo... nao esta bem." },
        "<bzzt>",
    },
    weight = 10,
    minDay = 5,
})

ABRRadio.registerTransmission("ghost_radio", {
    id = "gho_06",
    lines = {
        { EN = "Fourteen... thirteen... twelve...",
          PTBR = "Catorze... treze... doze..." },
        "<wzzt>",
        { EN = "... eight... seven... six...",
          PTBR = "... oito... sete... seis..." },
        { EN = "When the countdown reaches zero...",
          PTBR = "Quando a contagem chegar a zero..." },
        { EN = "... look behind you.",
          PTBR = "... olhe para tras." },
        "<szzt>",
    },
    weight = 10,
    minDay = 14,
})

ABRRadio.registerTransmission("ghost_radio", {
    id = "gho_07",
    lines = {
        "<wzzt>",
        { EN = "We've been watching you for a long time.",
          PTBR = "Estamos observando voce ha muito tempo." },
        { EN = "You're doing so well. So resourceful. So alone.",
          PTBR = "Voce esta indo tao bem. Tao esperto. Tao sozinho." },
        { EN = "Don't worry. You won't be alone for much longer.",
          PTBR = "Nao se preocupe. Voce nao ficara sozinho por muito mais tempo." },
        { EN = "We're coming.",
          PTBR = "Estamos chegando." },
        "<bzzt>",
    },
    color = { r = 0.7, g = 0.0, b = 0.3 },
    weight = 12,
    minDay = 21,
    command = "ParanormalEvent",
    commandArgs = { type = "invasion" },
})
