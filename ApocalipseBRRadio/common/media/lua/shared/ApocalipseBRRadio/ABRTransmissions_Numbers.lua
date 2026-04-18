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

-- 100+ new transmissions below, following the established style
local cryptic_transmissions = {
  {
    lines = {"<wzzt>", "... 3... 1... 4... 1... 5... 9...", "<fzzt>", "... 2... 6... 5... 3... 5... 8...", "<szzt>"},
    weight = 8, minDay = 0
  },
  {
    lines = {"01000001 01000010 01010010", "<wzzt>", "01001110 01010101 01001101 01000010 01000101 01010010 01010011", "<szzt>"},
    weight = 7, minDay = 2
  },
  {
    lines = {{EN="Juliet... Oscar... Victor... India... Alpha...", PTBR="Julieta... Oscar... Victor... India... Alfa..."}, "<bzzt>", {EN="Repeat. Juliet... Oscar... Victor...", PTBR="Repetir. Julieta... Oscar... Victor..."}, "<szzt>"},
    weight = 7, minDay = 1
  },
  {
    lines = {"<fzzt>", {EN="North 51 point 50... West 0 point 12...", PTBR="Norte 51 ponto 50... Oeste 0 ponto 12..."}, "<wzzt>", {EN="London coordinates confirmed.", PTBR="Coordenadas de Londres confirmadas."}, "<szzt>"},
    weight = 6, minDay = 3
  },
  {
    lines = {"01101101 01100101 01110011 01110011 01100001 01100111 01100101", "<wzzt>", {EN="... message repeats...", PTBR="... mensagem repete..."}, "<szzt>"},
    weight = 6, minDay = 4
  },
  {
    lines = {"... 7... 13... 21... 34... 55... 89...", "<fzzt>", "... 144... 233... 377...", "<szzt>"},
    weight = 8, minDay = 0
  },
  {
    lines = {"<wzzt>", {EN="Echo... Lima... Echo... Victor... Echo... November...", PTBR="Eco... Lima... Eco... Victor... Eco... Novembro..."}, "<bzzt>", {EN="End transmission.", PTBR="Fim da transmissao."}, "<szzt>"},
    weight = 7, minDay = 2
  },
  {
    lines = {"<fzzt>", "... 19... 20... 21... 22... 23... 24...", "<wzzt>", "... 25... 26... 27...", "<szzt>"},
    weight = 7, minDay = 0
  },
  {
    lines = {"01010011 01001001 01001100 01000101 01001110 01000011 01000101", "<wzzt>", {EN="... silence ...", PTBR="... silencio ..."}, "<szzt>"},
    weight = 6, minDay = 5
  },
  {
    lines = {"<wzzt>", {EN="Romeo... Alpha... Delta... India... Oscar...", PTBR="Romeu... Alfa... Delta... India... Oscar..."}, "<bzzt>", {EN="Repeat. Romeo... Alpha...", PTBR="Repetir. Romeu... Alfa..."}, "<szzt>"},
    weight = 7, minDay = 1
  },
}

-- Generate 90 more transmissions with varied cryptic content
for i = 1, 90 do
  local n = i + 5
  local t = {}
  if i % 5 == 1 then
    t.lines = {"<wzzt>", string.format("... %d... %d... %d... %d... %d... %d...", n, n+1, n+2, n+3, n+4, n+5), "<fzzt>", string.format("... %d... %d... %d...", n+6, n+7, n+8), "<szzt>"}
    t.weight = 7 + (i % 4)
    t.minDay = i % 15
  elseif i % 5 == 2 then
    t.lines = {string.format("%08d %08d %08d", n*11, n*13, n*17), "<wzzt>", string.format("%08d %08d", n*19, n*23), "<szzt>"}
    t.weight = 6 + (i % 3)
    t.minDay = i % 20
  elseif i % 5 == 3 then
    t.lines = {{EN=string.format("%s... %s... %s...", "Alpha", "Bravo", "Charlie"), PTBR=string.format("%s... %s... %s...", "Alfa", "Bravo", "Charlie")}, "<bzzt>", {EN="Repeat. Alpha... Bravo...", PTBR="Repetir. Alfa... Bravo..."}, "<szzt>"}
    t.weight = 7
    t.minDay = i % 10
  elseif i % 5 == 4 then
    t.lines = {"<fzzt>", {EN=string.format("North %d point %02d... West %d point %02d...", 10+i, i, 20+i, i), PTBR=string.format("Norte %d ponto %02d... Oeste %d ponto %02d...", 10+i, i, 20+i, i)}, "<wzzt>", {EN="Coordinates received.", PTBR="Coordenadas recebidas."}, "<szzt>"}
    t.weight = 6
    t.minDay = i % 12
  else
    t.lines = {string.format("%08d %08d %08d", n*7, (n+1)*7, (n+2)*7), "<wzzt>", {EN="... message repeats...", PTBR="... mensagem repete..."}, "<szzt>"}
    t.weight = 5 + (i % 4)
    t.minDay = i % 18
  end
  table.insert(cryptic_transmissions, t)
end

for idx, t in ipairs(cryptic_transmissions) do
  ABRRadio.registerTransmission("numbers_station", {
    id = string.format("num_%02d", idx+5),
    lines = t.lines,
    weight = t.weight,
    minDay = t.minDay,
  })
end
