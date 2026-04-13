--[[
    APOCALIPSE [BR] - Radio Apocalipse Transmissions
    Channel: radio_apocalipse (104.2 MHz)

    Survivor community broadcasts: horde warnings, supply updates, words of
    hope, and distress calls from Knox County's last free voices.
]]


ABRRadio.registerTransmission("radio_apocalipse", {
    id = "apo_01",
    lines = {
        { EN = "This is Radio Apocalipse, broadcasting from an undisclosed location.",
          PTBR = "Aqui e a Radio Apocalipse, transmitindo de um local nao revelado." },
        { EN = "To all survivors in the Knox County region: you are not alone.",
          PTBR = "Para todos os sobreviventes na regiao do Condado de Knox: voces nao estao sozinhos." },
        { EN = "We broadcast daily with survival tips, safe zone updates, and community news.",
          PTBR = "Transmitimos diariamente com dicas de sobrevivencia, atualizacoes de zonas seguras e noticias." },
        { EN = "Stay strong. Stay human. Stay alive.",
          PTBR = "Sejam fortes. Sejam humanos. Sobrevivam." },
    },
    weight = 20,
    minDay = 0,
})

ABRRadio.registerTransmission("radio_apocalipse", {
    id = "apo_02",
    lines = {
        { EN = "Attention survivors: significant horde activity spotted near the warehouse district.",
          PTBR = "Atencao sobreviventes: atividade significativa de hordas detectada perto do distrito de armazens." },
        { EN = "Avoid West Point downtown area for the next 48 hours.",
          PTBR = "Evitem o centro de West Point pelas proximas 48 horas." },
        { EN = "Supply runs should be redirected to rural areas east of Muldraugh.",
          PTBR = "Expedicoes de suprimentos devem ser redirecionadas para areas rurais a leste de Muldraugh." },
        "<bzzt>",
    },
    color = { r = 1.0, g = 0.6, b = 0.0 },
    weight = 12,
    minDay = 3,
    command = "HordeWarning",
    commandArgs = { intensity = "medium", area = "west_point" },
})

ABRRadio.registerTransmission("radio_apocalipse", {
    id = "apo_03",
    lines = {
        { EN = "Good news from the northern settlements.",
          PTBR = "Boas noticias dos assentamentos ao norte." },
        { EN = "A group of survivors has established a fortified position near the lake.",
          PTBR = "Um grupo de sobreviventes estabeleceu uma posicao fortificada perto do lago." },
        { EN = "They are accepting new members. Look for the green signal fires at night.",
          PTBR = "Eles estao aceitando novos membros. Procurem as fogueiras verdes de sinalizacao a noite." },
    },
    weight = 10,
    minDay = 7,
})

ABRRadio.registerTransmission("radio_apocalipse", {
    id = "apo_04",
    lines = {
        { EN = "WARNING: Armed groups have been spotted moving along the main highway.",
          PTBR = "AVISO: Grupos armados foram avistados se movendo pela rodovia principal." },
        { EN = "They are hostile. Repeat: engage only if necessary.",
          PTBR = "Eles sao hostis. Repito: engajem apenas se necessario." },
        { EN = "Travel in groups and avoid main roads after dark.",
          PTBR = "Viajem em grupos e evitem estradas principais apos o anoitecer." },
        "<fzzt>",
    },
    color = { r = 1.0, g = 0.3, b = 0.0 },
    weight = 10,
    minDay = 10,
})

ABRRadio.registerTransmission("radio_apocalipse", {
    id = "apo_05",
    lines = {
        { EN = "To everyone listening tonight...",
          PTBR = "Para todos que estao ouvindo esta noite..." },
        { EN = "I know it's hard. I know you've lost people. We all have.",
          PTBR = "Eu sei que e dificil. Eu sei que voces perderam pessoas. Todos nos perdemos." },
        { EN = "But every day you wake up is a victory against this nightmare.",
          PTBR = "Mas cada dia que voces acordam e uma vitoria contra este pesadelo." },
        { EN = "This is Radio Apocalipse, reminding you: we survive together, or not at all.",
          PTBR = "Aqui e a Radio Apocalipse, lembrando voces: sobrevivemos juntos, ou nao sobrevivemos." },
    },
    weight = 15,
    minDay = 0,
})

ABRRadio.registerTransmission("radio_apocalipse", {
    id = "apo_06",
    lines = {
        "<fzzt>",
        { EN = "Mayday, mayday! This is a distress call from a group of four survivors.",
          PTBR = "Mayday, mayday! Este e um pedido de socorro de um grupo de quatro sobreviventes." },
        { EN = "We are trapped on the second floor of the Crossroads Mall.",
          PTBR = "Estamos presos no segundo andar do Shopping Crossroads." },
        { EN = "We have wounded and are running low on supplies.",
          PTBR = "Temos feridos e estamos ficando sem suprimentos." },
        { EN = "If anyone can hear this, please... we need help.",
          PTBR = "Se alguem pode ouvir isto, por favor... precisamos de ajuda." },
        "<bzzt>",
    },
    color = { r = 1.0, g = 0.0, b = 0.0 },
    weight = 8,
    minDay = 5,
})
