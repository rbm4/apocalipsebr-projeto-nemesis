--[[
    APOCALIPSE [BR] - Emergency Broadcast System Transmissions
    Channel: emergency_broadcast (91.6 MHz)

    Government emergency broadcasts: evacuation orders, containment updates,
    and automated warnings from what remains of Central Command.
]]


ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_01",
    lines = {
        { EN = "This is an automated Emergency Broadcast System transmission. This is not a test.",
          PTBR = "Esta e uma transmissao automatizada do Sistema de Alerta de Emergencia. Isto nao e um teste." },
        { EN = "All citizens in Knox County are ordered to evacuate immediately.",
          PTBR = "Todos os cidadaos do Condado de Knox devem evacuar imediatamente." },
        { EN = "Proceed to the nearest military checkpoint for processing and evacuation.",
          PTBR = "Dirijam-se ao posto de controle militar mais proximo para processamento e evacuacao." },
        { EN = "Do not attempt to aid infected individuals. Repeat: do not approach the infected.",
          PTBR = "Nao tente ajudar individuos infectados. Repito: nao se aproxime dos infectados." },
        "<bzzt>",
    },
    weight = 15,
    minDay = 0,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_02",
    lines = {
        { EN = "Attention: the exclusion zone has been expanded to cover all of Knox County.",
          PTBR = "Atencao: a zona de exclusao foi expandida para todo o Condado de Knox." },
        { EN = "Military forces have established a perimeter. Unauthorized exit will be met with lethal force.",
          PTBR = "Forcas militares estabeleceram um perimetro. Saida nao autorizada sera respondida com forca letal." },
        "<fzzt>",
        { EN = "This message will repeat.",
          PTBR = "Esta mensagem sera repetida." },
        "<bzzt>",
    },
    weight = 12,
    minDay = 0,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_03",
    lines = {
        { EN = "Emergency supply drops have been scheduled for designated areas.",
          PTBR = "Lancamentos de suprimentos de emergencia foram programados para as areas designadas." },
        { EN = "Citizens are advised to approach supply zones only during daylight hours.",
          PTBR = "Cidadaos devem se aproximar das zonas de suprimento apenas durante o dia." },
        { EN = "Supplies are limited. Priority will be given to families with children and the elderly.",
          PTBR = "Suprimentos sao limitados. Prioridade para familias com criancas e idosos." },
        "<bzzt>",
    },
    weight = 10,
    minDay = 0,
    maxDay = 30,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_04",
    lines = {
        "<wzzt>",
        "...",
        { EN = "This station is no longer broadcasting live content.",
          PTBR = "Esta estacao nao esta mais transmitindo conteudo ao vivo." },
        { EN = "If you are hearing this, this is an automated emergency message.",
          PTBR = "Se voce esta ouvindo isto, esta e uma mensagem de emergencia automatizada." },
        { EN = "Stay indoors. Barricade all entry points. Do not open the door for anyone.",
          PTBR = "Permaneca em sua residencia. Barricade todas as entradas. Nao abra a porta para ninguem." },
        "<bzzt>",
    },
    weight = 20,
    minDay = 14,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_05",
    lines = {
        "<szzt>",
        { EN = "To anyone still listening out there...",
          PTBR = "Para qualquer pessoa que ainda esteja ouvindo..." },
        { EN = "The evacuation centers have been overrun. Louisville has... Louisville is gone.",
          PTBR = "Os centros de evacuacao foram invadidos. Louisville... Louisville nao existe mais." },
        { EN = "We are the last broadcast tower still operational in the region.",
          PTBR = "Somos a ultima torre de transmissao ainda operacional na regiao." },
        { EN = "If you can hear this, head north. There may still be survivors near the lake.",
          PTBR = "Se voce pode ouvir isto, siga para o norte. Pode haver sobreviventes perto do lago." },
        { EN = "May God have mercy on us all.",
          PTBR = "Que Deus tenha misericordia de todos nos." },
        "<bzzt>",
    },
    weight = 15,
    minDay = 21,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_06",
    lines = {
        { EN = "ALERT: Containment has failed at multiple checkpoints along the southern perimeter.",
          PTBR = "ALERTA: Contencao falhou em multiplos postos de controle ao longo do perimetro sul." },
        { EN = "All personnel are to fall back to Rally Point Echo.",
          PTBR = "Todo o pessoal deve recuar para o Ponto de Encontro Echo." },
        { EN = "Civilian evacuation is no longer possible. Shelter in place immediately.",
          PTBR = "Evacuacao civil nao e mais possivel. Abriguem-se no local imediatamente." },
        "<fzzt>",
        { EN = "This is the last update from Central Command.",
          PTBR = "Esta e a ultima atualizacao do Comando Central." },
        "<bzzt>",
    },
    weight = 10,
    minDay = 7,
    command = "ContainmentBreach",
    commandArgs = { sector = "south" },
})
