--[[
    APOCALIPSE [BR] - Numbers Station Transmissions
    Channel: numbers_station (47.8 MHz)

    Enigmatic automated broadcasts: number sequences, NATO phonetic codes,
    binary strings, and coordinates. Its purpose is unknown. Its origin, untraceable.
]]


ABRRadio.registerTransmission("numbers_station", {
    id = "num_01",
    lines = {
        "<wzzt>",
        "... 4... 8... 15... 16... 23... 42...",
        "<fzzt>",
        "... 4... 8... 15... 16... 23... 42...",
        "<szzt>",
    },
    weight = 15,
    minDay = 0,
})

ABRRadio.registerTransmission("numbers_station", {
    id = "num_02",
    lines = {
        { EN = "Alpha... Tango... Echo... November... Delta...",
          PTBR = "Alfa... Tango... Eco... Novembro... Delta..." },
        { EN = "Sierra... India... X-ray...",
          PTBR = "Serra... India... Xadrez..." },
        "<wzzt>",
        { EN = "Repeat cycle. Alpha... Tango... Echo...",
          PTBR = "Repetir ciclo. Alfa... Tango... Eco..." },
        "<bzzt>",
    },
    weight = 10,
    minDay = 0,
})

ABRRadio.registerTransmission("numbers_station", {
    id = "num_03",
    lines = {
        "<fzzt>",
        { EN = "North 36 point 14... West 86 point 79...",
          PTBR = "Norte 36 ponto 14... Oeste 86 ponto 79..." },
        "<wzzt>",
        { EN = "North 36 point 14... West 86 point 79...",
          PTBR = "Norte 36 ponto 14... Oeste 86 ponto 79..." },
        { EN = "You know where to go.",
          PTBR = "Voce sabe para onde ir." },
        "<szzt>",
    },
    weight = 12,
    minDay = 7,
})

ABRRadio.registerTransmission("numbers_station", {
    id = "num_04",
    lines = {
        "01001000 01000101 01001100 01010000",
        "<fzzt>",
        "01001000 01000101 01001100 01010000",
        "<wzzt>",
        { EN = "... message repeats...",
          PTBR = "... mensagem repete..." },
        "<szzt>",
    },
    weight = 8,
    minDay = 14,
})

ABRRadio.registerTransmission("numbers_station", {
    id = "num_05",
    lines = {
        "<wzzt>",
        "... ... ...",
        { EN = "... end of cycle. Begin retransmission...",
          PTBR = "... fim do ciclo. Iniciar retransmissao..." },
        "... ... ...",
        "<szzt>",
    },
    weight = 10,
    minDay = 0,
})
