--[[
    APOCALIPSE [BR] - Military Communications Transmissions
    Channel: military_comms (310 kHz)

    Intercepted military transmissions: tactical operations, extraction requests,
    and classified communications from soldiers fighting a war they've already lost.
]]


ABRRadio.registerTransmission("military_comms", {
    id = "mil_01",
    lines = {
        { EN = "Alpha-Seven to Command. Requesting extraction at grid reference Delta-Four-Niner.",
          PTBR = "Alpha-Sete para Comando. Solicitando extracao na referencia de grade Delta-Quatro-Niner." },
        { EN = "Negative, Alpha-Seven. All extraction assets have been reassigned to Louisville.",
          PTBR = "Negativo, Alpha-Sete. Todos os recursos de extracao foram realocados para Louisville." },
        { EN = "Command, we have civilian survivors. Requesting immediate support—",
          PTBR = "Comando, temos civis sobreviventes. Solicitando suporte imediato—" },
        "<bzzt>",
        { EN = "... Alpha-Seven, do you copy? ... Alpha-Seven? ...",
          PTBR = "... Alpha-Sete, responda... Alpha-Sete? ..." },
        "<szzt>",
    },
    weight = 12,
    minDay = 0,
})

ABRRadio.registerTransmission("military_comms", {
    id = "mil_02",
    lines = {
        { EN = "Foxtrot-Actual to all units. Containment breach at Sector Nine.",
          PTBR = "Foxtrot-Atual para todas as unidades. Quebra de contencao no Setor Nove." },
        { EN = "Recommend immediate fallback to secondary perimeter.",
          PTBR = "Recomendo recuo imediato para o perimetro secundario." },
        { EN = "Authorization code: BROKEN ARROW. Repeat: BROKEN ARROW.",
          PTBR = "Codigo de autorizacao: BROKEN ARROW. Repito: BROKEN ARROW." },
        { EN = "All personnel withdraw immediately. This is not a drill.",
          PTBR = "Todo o pessoal deve se retirar imediatamente. Isto nao e um exercicio." },
        "<bzzt>",
    },
    weight = 10,
    minDay = 3,
    command = "MilitaryResponse",
    commandArgs = { action = "fallback", sector = 9 },
})

ABRRadio.registerTransmission("military_comms", {
    id = "mil_03",
    lines = {
        "<fzzt>",
        { EN = "Whiskey-Tango. Payload delivered at designated coordinates.",
          PTBR = "Whiskey-Tango. Carga entregue nas coordenadas designadas." },
        { EN = "Collateral damage assessment: total.",
          PTBR = "Avaliacao de danos colaterais: total." },
        { EN = "This channel will go silent in T-minus three minutes.",
          PTBR = "Este canal entrara em silencio em T-menos tres minutos." },
        { EN = "God forgive us for what we've done.",
          PTBR = "Deus nos perdoe pelo que fizemos." },
        "<szzt>",
    },
    color = { r = 0.5, g = 0.5, b = 0.5 },
    weight = 8,
    minDay = 14,
})

ABRRadio.registerTransmission("military_comms", {
    id = "mil_04",
    lines = {
        "<wzzt>",
        { EN = "This is Sergeant Morrison, 3rd Battalion, 24th Infantry.",
          PTBR = "Aqui e o Sargento Morrison, 3º Batalhao, 24ª Infantaria." },
        { EN = "We are cut off from the main force. Down to four personnel.",
          PTBR = "Estamos isolados da forca principal. Restam quatro operadores." },
        { EN = "If anyone receives this... we are holding position at the school on Oak Street.",
          PTBR = "Se alguem receber isto... estamos na escola da Rua Oak." },
        { EN = "Ammunition is critical. We will not last another night.",
          PTBR = "Municao em estado critico. Nao sobreviveremos outra noite." },
        "<bzzt>",
    },
    weight = 12,
    minDay = 7,
})

ABRRadio.registerTransmission("military_comms", {
    id = "mil_05",
    lines = {
        { EN = "To any military personnel still monitoring this frequency:",
          PTBR = "Para qualquer militar ainda monitorando esta frequencia:" },
        { EN = "Operation DEADLIGHT has been declared a total failure.",
          PTBR = "A Operacao DEADLIGHT foi declarada uma falha total." },
        { EN = "The chain of command has been dissolved. You are hereby released from duty.",
          PTBR = "A cadeia de comando foi dissolvida. Voces estao dispensados do servico." },
        { EN = "Go home, soldier. Find your family, if you still can.",
          PTBR = "Va para casa, soldado. Encontre sua familia, se ainda puder." },
        { EN = "This is the last official military broadcast. Central Command, signing off.",
          PTBR = "Esta e a ultima transmissao militar oficial. Comando Central, cambio final." },
        "<bzzt>",
    },
    weight = 15,
    minDay = 21,
})
