--[[
    APOCALIPSE [BR] - Emergency Broadcast System Transmissions
    Channel: emergency_broadcast (91.6 MHz)

    Government emergency broadcasts: evacuation orders, containment updates,
    and automated warnings from what remains of Central Command.

    =========================================================================
    AGENT INSTRUCTIONS — GENERATING EMERGENCY TRANSMISSIONS
    =========================================================================
    This file should contain ~365 days of emergency radio transmissions that
    tell a coherent, evolving story of societal collapse through government
    broadcasts. Follow these rules strictly:

    FORMAT:
        ABRRadio.registerTransmission("emergency_broadcast", {
            id = "ebs_<number>",       -- sequential, e.g. ebs_07, ebs_08...
            lines = { ... },
            weight = <5-20>,           -- how likely this is picked vs others in same window
            minDay = <number>,         -- first day this can play (0 = day one)
            maxDay = <number>,         -- last day this can play (-1 = forever)
        })

    LINE FORMATS:
        - i18n:    { EN = "English text", PTBR = "Portuguese text" }
        - static:  "<bzzt>", "<fzzt>", "<wzzt>", "<szzt>" (radio noise)
        - pause:   "..." or "...."

    NARRATIVE ARC (approximate day ranges — overlap is fine):
        Days 0-14:   Government still functional. Evacuation orders, checkpoint
                     locations, optimistic language. "The situation is under control."
        Days 15-45:  Cracks appear. Contradictory orders, supply shortages,
                     perimeter breaches. Tone shifts to urgent/desperate.
        Days 46-90:  Collapse. Military retreating, cities falling, last-ditch
                     efforts. Individual operators break protocol to give real info.
        Days 91-180: Silence from command. Automated loops still running. Rare
                     rogue operators hijack the frequency with personal messages.
        Days 181-365: Ghost broadcasts. Corrupted automated messages, fragments,
                     eerie loops. Occasional new voice — someone found the
                     equipment and tries to restart the system.

    RULES:
        - ALL text must be ASCII only. No accented characters (a not a, e not e,
          c not c, etc.). PZ cannot render them.
        - Every transmission MUST have both minDay and maxDay set.
        - Use maxDay to create time windows (e.g. minDay=0, maxDay=14).
          Use maxDay=-1 ONLY for transmissions that should loop forever
          (automated messages, corrupted loops in late game).
        - Keep lines short — each line shows on one radio display line.
          Max ~80 characters per EN line, ~90 per PTBR line.
        - Use static sounds (<bzzt>, <fzzt>, etc.) for atmosphere, especially
          at the start/end of transmissions and during "corruption" moments.
        - Weight 15-20 for important story beats, 8-12 for filler/atmosphere,
          5 for rare/secret messages.
        - Some transmissions can have a `command` field to trigger game events:
          command = "ContainmentBreach", commandArgs = { sector = "south" }
        - Maintain internal consistency: reference the same locations (Knox County,
          Louisville, Muldraugh, West Point, Riverside, Rosewood), same military
          units, same government agencies.
        - PTBR translations should feel natural, not robotic machine translation.
        - Aim for 50-80 total transmissions covering the full year.
    =========================================================================
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
    maxDay = 30,
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
    maxDay = 45,
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
          PTBR = "Permanece em sua residencia. Barricade todas as entradas. Nao abra a porta para ninguem." },
        "<bzzt>",
    },
    weight = 20,
    minDay = 14,
    maxDay = 90,
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
    maxDay = 90,
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
    maxDay = 60,
    command = "ContainmentBreach",
    commandArgs = { sector = "south" },
})

-- =====================
-- BULK GENERATED TRANSMISSIONS
-- =====================

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_07",
    lines = {
        { EN = "This is Central Command. Situation update for all units.", PTBR = "Aqui e o Comando Central. Atualizacao de situacao para todas as unidades." },
        { EN = "Containment perimeter holding in Muldraugh. West Point remains secure.", PTBR = "Perimetro de contencao mantido em Muldraugh. West Point permanece segura." },
        { EN = "Civilians are advised to remain calm and await further instructions.", PTBR = "Civis devem permanecer calmos e aguardar novas instrucoes." },
        { EN = "Medical teams are being deployed to high-risk zones.", PTBR = "Equipes medicas estao sendo enviadas para zonas de alto risco." },
        { EN = "Report any symptoms to the nearest checkpoint.", PTBR = "Relate qualquer sintoma ao posto de controle mais proximo." },
        { EN = "The situation is under control.", PTBR = "A situacao esta sob controle." },
        "<bzzt>",
    },
    weight = 18,
    minDay = 0,
    maxDay = 10,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_08",
    lines = {
        { EN = "Attention: curfew is now in effect for all of Riverside.", PTBR = "Atencao: toque de recolher em vigor para toda Riverside." },
        { EN = "No movement permitted between 20:00 and 06:00.", PTBR = "Nao e permitido circular entre 20:00 e 06:00." },
        { EN = "Violators will be detained.", PTBR = "Infratores serao detidos." },
        { EN = "This measure is temporary.", PTBR = "Esta medida e temporaria." },
        { EN = "Remain indoors and keep radios tuned for updates.", PTBR = "Permanece em casa e mantenha o radio ligado para atualizacoes." },
        { EN = "Central Command out.", PTBR = "Comando Central desligando." },
        "<bzzt>",
    },
    weight = 15,
    minDay = 2,
    maxDay = 14,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_09",
    lines = {
        { EN = "Supply convoy Alpha-3 has been delayed due to roadblocks.", PTBR = "Comboio de suprimentos Alpha-3 atrasado devido a bloqueios." },
        { EN = "Estimated arrival in West Point: 18:00.", PTBR = "Previsao de chegada em West Point: 18:00." },
        { EN = "Do not approach military vehicles without authorization.", PTBR = "Nao se aproxime de veiculos militares sem autorizacao." },
        { EN = "Looting will be prosecuted under martial law.", PTBR = "Saque sera punido sob lei marcial." },
        { EN = "Thank you for your cooperation.", PTBR = "Obrigado pela cooperacao." },
        "<fzzt>",
        { EN = "This message will repeat.", PTBR = "Esta mensagem sera repetida." },
        "<bzzt>",
    },
    weight = 12,
    minDay = 3,
    maxDay = 18,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_10",
    lines = {
        { EN = "Medical advisory: symptoms include fever, confusion, and aggression.", PTBR = "Aviso medico: sintomas incluem febre, confusao e agressividade." },
        { EN = "Report all suspected cases immediately.", PTBR = "Reporte todos os casos suspeitos imediatamente." },
        { EN = "Do not attempt home treatment.", PTBR = "Nao tente tratar em casa." },
        { EN = "Medical teams are on standby.", PTBR = "Equipes medicas estao de prontidao." },
        { EN = "Central Command monitoring all reports.", PTBR = "Comando Central monitorando todos os relatos." },
        { EN = "Stay safe. Stay alert.", PTBR = "Fique seguro. Fique atento." },
        "<bzzt>",
    },
    weight = 14,
    minDay = 5,
    maxDay = 20,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_11",
    lines = {
        { EN = "Attention: unauthorized broadcasts detected on civilian frequencies.", PTBR = "Atencao: transmissoes nao autorizadas detectadas em frequencias civis." },
        { EN = "Disregard any messages not from Central Command.", PTBR = "Desconsidere mensagens que nao sejam do Comando Central." },
        { EN = "False information is a threat to public safety.", PTBR = "Informacao falsa e uma ameaca a seguranca publica." },
        { EN = "Report suspicious transmissions to authorities.", PTBR = "Reporte transmissoes suspeitas as autoridades." },
        { EN = "This is your only official source of information.", PTBR = "Esta e sua unica fonte oficial de informacao." },
        "<bzzt>",
    },
    weight = 13,
    minDay = 7,
    maxDay = 25,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_12",
    lines = {
        { EN = "Containment breach reported near Rosewood.", PTBR = "Rompimento de contencao relatado perto de Rosewood." },
        { EN = "All units are to reinforce perimeter at sector 4.", PTBR = "Todas as unidades devem reforcar o perimetro no setor 4." },
        { EN = "Civilians in the area must evacuate immediately.", PTBR = "Civis na area devem evacuar imediatamente." },
        { EN = "Martial law is in effect.", PTBR = "Lei marcial em vigor." },
        { EN = "Further instructions will follow.", PTBR = "Novas instrucoes serao dadas." },
        "<fzzt>",
        { EN = "Repeat: containment breach at Rosewood.", PTBR = "Repito: rompimento de contencao em Rosewood." },
        "<bzzt>",
    },
    weight = 17,
    minDay = 10,
    maxDay = 28,
    command = "ContainmentBreach",
    commandArgs = { sector = "rosewood" },
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_13",
    lines = {
        { EN = "Attention: food distribution centers are open in Muldraugh and Riverside.", PTBR = "Atencao: centros de distribuicao de alimentos abertos em Muldraugh e Riverside." },
        { EN = "Bring identification and ration cards.", PTBR = "Traga identificacao e cartoes de racionamento." },
        { EN = "Distribution hours: 09:00 to 17:00.", PTBR = "Horario de distribuicao: 09:00 as 17:00." },
        { EN = "No weapons permitted inside the centers.", PTBR = "Nao e permitido armas dentro dos centros." },
        { EN = "Priority for children, elderly, and medical personnel.", PTBR = "Prioridade para criancas, idosos e equipe medica." },
        { EN = "Thank you for your cooperation.", PTBR = "Obrigado pela cooperacao." },
        "<bzzt>",
    },
    weight = 12,
    minDay = 12,
    maxDay = 30,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_14",
    lines = {
        { EN = "Central Command to all units: maintain radio discipline.", PTBR = "Comando Central para todas as unidades: mantenham disciplina no radio." },
        { EN = "Use encrypted channels for sensitive information.", PTBR = "Use canais criptografados para informacoes sensiveis." },
        { EN = "Do not disclose troop movements on open frequencies.", PTBR = "Nao revele movimentos de tropas em frequencias abertas." },
        { EN = "This is a reminder for all operators.", PTBR = "Este e um lembrete para todos os operadores." },
        { EN = "Security is everyone's responsibility.", PTBR = "Seguranca e responsabilidade de todos." },
        "<bzzt>",
    },
    weight = 10,
    minDay = 15,
    maxDay = 35,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_15",
    lines = {
        { EN = "Attention: water supply disruptions reported in West Point.", PTBR = "Atencao: interrupcao no abastecimento de agua em West Point." },
        { EN = "Boil all water before use.", PTBR = "Ferva toda a agua antes de usar." },
        { EN = "Bottled water will be distributed at checkpoints.", PTBR = "Agua engarrafada sera distribuida nos postos de controle." },
        { EN = "Limit consumption to essential needs.", PTBR = "Limite o consumo ao essencial." },
        { EN = "Updates will follow as situation develops.", PTBR = "Novas informacoes serao dadas conforme a situacao evolui." },
        "<bzzt>",
    },
    weight = 11,
    minDay = 18,
    maxDay = 40,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_16",
    lines = {
        { EN = "This is an automated message from Central Command.", PTBR = "Esta e uma mensagem automatizada do Comando Central." },
        { EN = "Remain indoors until further notice.", PTBR = "Permanece em casa ate novo aviso." },
        { EN = "Martial law remains in effect.", PTBR = "Lei marcial permanece em vigor." },
        { EN = "Check radio hourly for updates.", PTBR = "Verifique o radio a cada hora para atualizacoes." },
        { EN = "This message will repeat.", PTBR = "Esta mensagem sera repetida." },
        "<bzzt>",
    },
    weight = 10,
    minDay = 20,
    maxDay = 60,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_17",
    lines = {
        { EN = "Central Command to all survivors: maintain hope.", PTBR = "Comando Central para todos os sobreviventes: mantenham a esperanca." },
        { EN = "Help is on the way.", PTBR = "Ajuda esta a caminho." },
        { EN = "Remain calm and follow instructions.", PTBR = "Permanece calmo e siga as instrucoes." },
        { EN = "We are all in this together.", PTBR = "Estamos todos juntos nisso." },
        { EN = "This message will repeat.", PTBR = "Esta mensagem sera repetida." },
        "<bzzt>",
    },
    weight = 13,
    minDay = 22,
    maxDay = 50,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_18",
    lines = {
        { EN = "Attention: perimeter breach detected near Riverside.", PTBR = "Atencao: rompimento de perimetro detectado perto de Riverside." },
        { EN = "All available units respond immediately.", PTBR = "Todas as unidades disponiveis respondam imediatamente." },
        { EN = "Civilians must shelter in place.", PTBR = "Civis devem se abrigar no local." },
        { EN = "Await further instructions.", PTBR = "Aguarde novas instrucoes." },
        "<fzzt>",
        { EN = "Repeat: perimeter breach near Riverside.", PTBR = "Repito: rompimento de perimetro perto de Riverside." },
        "<bzzt>",
    },
    weight = 16,
    minDay = 25,
    maxDay = 55,
    command = "ContainmentBreach",
    commandArgs = { sector = "riverside" },
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_19",
    lines = {
        { EN = "Attention: all non-essential personnel are to evacuate Muldraugh immediately.", PTBR = "Atencao: todo pessoal nao essencial deve evacuar Muldraugh imediatamente." },
        { EN = "Essential personnel report to Rally Point Delta.", PTBR = "Pessoal essencial deve se apresentar ao Ponto de Encontro Delta." },
        { EN = "This is not a drill.", PTBR = "Isto nao e um exercicio." },
        { EN = "Follow evacuation routes posted at checkpoints.", PTBR = "Siga as rotas de evacuacao nos postos de controle." },
        { EN = "Updates will follow.", PTBR = "Novas informacoes serao dadas." },
        "<bzzt>",
    },
    weight = 14,
    minDay = 28,
    maxDay = 60,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_20",
    lines = {
        { EN = "Central Command to all units: maintain discipline and order.", PTBR = "Comando Central para todas as unidades: mantenham disciplina e ordem." },
        { EN = "Do not abandon your post without direct orders.", PTBR = "Nao abandone seu posto sem ordens diretas." },
        { EN = "All actions are being monitored.", PTBR = "Todas as acoes estao sendo monitoradas." },
        { EN = "Failure to comply will result in disciplinary action.", PTBR = "Nao cumprir resultara em punicao disciplinar." },
        { EN = "This message will repeat.", PTBR = "Esta mensagem sera repetida." },
        "<bzzt>",
    },
    weight = 10,
    minDay = 30,
    maxDay = 70,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_21",
    lines = {
        { EN = "Attention: all bridges out of Louisville are closed.", PTBR = "Atencao: todas as pontes de Louisville estao fechadas." },
        { EN = "No traffic permitted in or out.", PTBR = "Nao e permitido trafego de entrada ou saida." },
        { EN = "Checkpoints are fully staffed.", PTBR = "Postos de controle estao totalmente ocupados." },
        { EN = "Remain patient and await further instructions.", PTBR = "Permanece paciente e aguarde novas instrucoes." },
        "<bzzt>",
    },
    weight = 12,
    minDay = 32,
    maxDay = 75,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_22",
    lines = {
        { EN = "This is an automated message. Central Command is not available at this time.", PTBR = "Esta e uma mensagem automatizada. Comando Central nao esta disponivel no momento." },
        { EN = "Remain indoors and await further instructions.", PTBR = "Permanece em casa e aguarde novas instrucoes." },
        { EN = "This message will repeat.", PTBR = "Esta mensagem sera repetida." },
        "<bzzt>",
    },
    weight = 8,
    minDay = 35,
    maxDay = 90,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_23",
    lines = {
        { EN = "Attention: all frequencies are now monitored by Central Command.", PTBR = "Atencao: todas as frequencias agora sao monitoradas pelo Comando Central." },
        { EN = "Unauthorized transmissions will be jammed.", PTBR = "Transmissoes nao autorizadas serao bloqueadas." },
        { EN = "This is your only official source of information.", PTBR = "Esta e sua unica fonte oficial de informacao." },
        "<bzzt>",
    },
    weight = 9,
    minDay = 38,
    maxDay = 100,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_24",
    lines = {
        { EN = "Central Command to all survivors: maintain hope. Help is on the way.", PTBR = "Comando Central para todos os sobreviventes: mantenham a esperanca. Ajuda esta a caminho." },
        { EN = "Remain calm and follow instructions.", PTBR = "Permanece calmo e siga as instrucoes." },
        { EN = "We are all in this together.", PTBR = "Estamos todos juntos nisso." },
        { EN = "This message will repeat.", PTBR = "Esta mensagem sera repetida." },
        "<bzzt>",
    },
    weight = 10,
    minDay = 40,
    maxDay = 110,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_25",
    lines = {
        { EN = "Attention: all units, this is not a drill. Repeat: this is not a drill.", PTBR = "Atencao: todas as unidades, isto nao e um exercicio. Repito: isto nao e um exercicio." },
        { EN = "Perimeter breach detected in sector 7.", PTBR = "Rompimento de perimetro detectado no setor 7." },
        { EN = "All available units respond immediately.", PTBR = "Todas as unidades disponiveis respondam imediatamente." },
        { EN = "Civilians must shelter in place.", PTBR = "Civis devem se abrigar no local." },
        { EN = "Await further instructions.", PTBR = "Aguarde novas instrucoes." },
        "<fzzt>",
        { EN = "Repeat: perimeter breach in sector 7.", PTBR = "Repito: rompimento de perimetro no setor 7." },
        "<bzzt>",
    },
    weight = 16,
    minDay = 45,
    maxDay = 120,
    command = "ContainmentBreach",
    commandArgs = { sector = "sector7" },
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_26",
    lines = {
        { EN = "This is an automated message. Central Command is offline.", PTBR = "Esta e uma mensagem automatizada. Comando Central esta offline." },
        { EN = "Remain indoors and await further instructions.", PTBR = "Permanece em casa e aguarde novas instrucoes." },
        { EN = "This message will repeat.", PTBR = "Esta mensagem sera repetida." },
        "<bzzt>",
    },
    weight = 8,
    minDay = 50,
    maxDay = 130,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_27",
    lines = {
        { EN = "Attention: this is Operator 12. Central Command is silent.", PTBR = "Atencao: aqui e o Operador 12. Comando Central esta em silencio." },
        { EN = "If anyone can hear this, respond on channel 3.", PTBR = "Se alguem pode ouvir isto, responda no canal 3." },
        { EN = "We are holding out in the Leaffal Road bunker.", PTBR = "Estamos resistindo no bunker de Leaffal Road." },
        { EN = "Supplies are low. Morale is lower.", PTBR = "Suprimentos estao baixos. Moral esta pior." },
        { EN = "If you are out there, you are not alone.", PTBR = "Se voce esta ai fora, voce nao esta sozinho." },
        "<bzzt>",
    },
    weight = 15,
    minDay = 60,
    maxDay = 130,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_28",
    lines = {
        { EN = "Automated message: Central Command is not available.", PTBR = "Mensagem automatizada: Comando Central nao esta disponivel." },
        { EN = "Remain indoors and await further instructions.", PTBR = "Permanece em casa e aguarde novas instrucoes." },
        { EN = "This message will repeat.", PTBR = "Esta mensagem sera repetida." },
        "<bzzt>",
    },
    weight = 8,
    minDay = 70,
    maxDay = 100,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_29",
    lines = {
        { EN = "Operator 12 again. Supplies are almost gone.", PTBR = "Operador 12 novamente. Suprimentos quase acabaram." },
        { EN = "We lost contact with Riverside.", PTBR = "Perdemos contato com Riverside." },
        { EN = "If anyone can send help, we are still here.", PTBR = "Se alguem pode enviar ajuda, ainda estamos aqui." },
        { EN = "This is not a test.", PTBR = "Isto nao e um teste." },
        "<bzzt>",
    },
    weight = 14,
    minDay = 80,
    maxDay = 130,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_30",
    lines = {
        { EN = "Automated message: Central Command is offline.", PTBR = "Mensagem automatizada: Comando Central esta offline." },
        { EN = "Remain indoors and await further instructions.", PTBR = "Permanece em casa e aguarde novas instrucoes." },
        { EN = "This message will repeat.", PTBR = "Esta mensagem sera repetida." },
        "<bzzt>",
    },
    weight = 8,
    minDay = 90,
    maxDay = 130,
})

-- =====================
-- POST-COLLAPSE, MANUFACTURED WAR, AND HIJACKED BROADCASTS (DAYS 130–365)
-- =====================

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_31",
    lines = {
        { EN = "Automated message: Central Command is offline.", PTBR = "Mensagem automatizada: Comando Central esta offline." },
        { EN = "This frequency is now monitored by the Emergency Civilian Network.", PTBR = "Esta frequencia agora e monitorada pela Rede Civil de Emergencia." },
        { EN = "Remain indoors. Martial law is no longer in effect.", PTBR = "Permanece em casa. Lei marcial nao esta mais em vigor." },
        { EN = "If you have information about military activity, report to your local council.", PTBR = "Se voce tem informacoes sobre atividade militar, reporte ao conselho local." },
        { EN = "Do not trust messages claiming to be from Central Command.", PTBR = "Nao confie em mensagens que dizem ser do Comando Central." },
        { EN = "The war is over. The fight is for survival.", PTBR = "A guerra acabou. A luta agora e pela sobrevivencia." },
        { EN = "This message will repeat.", PTBR = "Esta mensagem sera repetida." },
        "<bzzt>",
        { EN = "Civilian Network out.", PTBR = "Rede Civil desligando." },
        "<szzt>"
    },
    weight = 15,
    minDay = 130,
    maxDay = 190,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_32",
    lines = {
        { EN = "This is Operator 17. The army is gone. The city is divided.", PTBR = "Aqui e o Operador 17. O exercito se foi. A cidade esta dividida." },
        { EN = "Multiple factions now control different sectors.", PTBR = "Multiplas faccoes controlam setores diferentes." },
        { EN = "Beware of false broadcasts. Some are designed to lure survivors into traps.", PTBR = "Cuidado com transmissoes falsas. Algumas sao armadilhas para sobreviventes." },
        { EN = "If you hear a message promising safe passage, verify the source.", PTBR = "Se ouvir mensagem prometendo passagem segura, verifique a fonte." },
        { EN = "The Civilian Network is the only trusted channel.", PTBR = "A Rede Civil e o unico canal confiavel." },
        { EN = "Stay alert. Trust no one on the airwaves.", PTBR = "Fique atento. Nao confie em ninguem nas ondas do radio." },
        { EN = "Operator 17 out.", PTBR = "Operador 17 desligando." },
        "<bzzt>",
        { EN = "....", PTBR = "...." },
        { EN = "End of transmission.", PTBR = "Fim da transmissao." }
    },
    weight = 14,
    minDay = 140,
    maxDay = 185,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_33",
    lines = {
        { EN = "Automated message: This frequency is now under civilian control.", PTBR = "Mensagem automatizada: Esta frequencia agora e sob controle civil." },
        { EN = "All military codes are invalid.", PTBR = "Todos os codigos militares sao invalidos." },
        { EN = "If you are a survivor, broadcast your location at 12:00 and 18:00.", PTBR = "Se voce e sobrevivente, transmita sua localizacao as 12:00 e 18:00." },
        { EN = "Do not respond to encrypted signals.", PTBR = "Nao responda a sinais criptografados." },
        { EN = "The war was manufactured. The enemy is gone.", PTBR = "A guerra foi fabricada. O inimigo se foi." },
        { EN = "Now, only survivors remain.", PTBR = "Agora, restam apenas sobreviventes." },
        { EN = "This message will repeat.", PTBR = "Esta mensagem sera repetida." },
        "<bzzt>",
        { EN = "Civilian Network out.", PTBR = "Rede Civil desligando." },
        "<szzt>"
    },
    weight = 13,
    minDay = 145,
    maxDay = 190,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_34",
    lines = {
        { EN = "This is Operator 21. The city is silent. The only voices are on the radio.", PTBR = "Aqui e o Operador 21. A cidade esta silenciosa. As unicas vozes estao no radio." },
        { EN = "We have seen drones overhead. No markings. No response to signals.", PTBR = "Vimos drones sobrevoando. Sem identificacao. Nao respondem a sinais." },
        { EN = "Some say they are watching for survivors. Others say they are hunting.", PTBR = "Alguns dizem que procuram sobreviventes. Outros dizem que estao caçando." },
        { EN = "If you see a drone, do not approach. Do not signal.", PTBR = "Se vir um drone, nao se aproxime. Nao sinalize." },
        { EN = "The war is not over. It has changed.", PTBR = "A guerra nao acabou. Ela mudou." },
        { EN = "Trust only what you see with your own eyes.", PTBR = "Confie apenas no que voce ve com seus proprios olhos." },
        { EN = "Operator 21 out.", PTBR = "Operador 21 desligando." },
        "<bzzt>",
        { EN = "....", PTBR = "...." },
        { EN = "End of transmission.", PTBR = "Fim da transmissao." }
    },
    weight = 13,
    minDay = 150,
    maxDay = 185,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_35",
    lines = {
        { EN = "Automated message: This frequency is now a public channel.", PTBR = "Mensagem automatizada: Esta frequencia agora e um canal publico." },
        { EN = "Anyone may broadcast. Use code 99 to request help.", PTBR = "Qualquer um pode transmitir. Use o codigo 99 para pedir ajuda." },
        { EN = "Do not trust encrypted messages.", PTBR = "Nao confie em mensagens criptografadas." },
        { EN = "The Civilian Network is not responsible for false information.", PTBR = "A Rede Civil nao se responsabiliza por informacoes falsas." },
        { EN = "If you hear a voice you do not recognize, verify before responding.", PTBR = "Se ouvir uma voz desconhecida, verifique antes de responder." },
        { EN = "This is the new world. The rules have changed.", PTBR = "Este e o novo mundo. As regras mudaram." },
        { EN = "Stay safe. Stay human.", PTBR = "Fique seguro. Fique humano." },
        "<bzzt>",
        { EN = "....", PTBR = "...." },
        { EN = "End of transmission.", PTBR = "Fim da transmissao." }
    },
    weight = 12,
    minDay = 155,
    maxDay = 190,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_36",
    lines = {
        { EN = "Attention: all bridges out of Louisville are closed.", PTBR = "Atencao: todas as pontes de Louisville estao fechadas." },
        { EN = "No traffic permitted in or out.", PTBR = "Nao e permitido trafego de entrada ou saida." },
        { EN = "Checkpoints are fully staffed.", PTBR = "Postos de controle estao totalmente ocupados." },
        { EN = "Remain patient and await further instructions.", PTBR = "Permanece paciente e aguarde novas instrucoes." },
        "<bzzt>",
    },
    weight = 12,
    minDay = 160,
    maxDay = 220,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_37",
    lines = {
        { EN = "This is an automated message. Central Command is not available at this time.", PTBR = "Esta e uma mensagem automatizada. Comando Central nao esta disponivel no momento." },
        { EN = "Remain indoors and await further instructions.", PTBR = "Permanece em casa e aguarde novas instrucoes." },
        { EN = "This message will repeat.", PTBR = "Esta mensagem sera repetida." },
        "<bzzt>",
    },
    weight = 8,
    minDay = 165,
    maxDay = 225,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_38",
    lines = {
        { EN = "Attention: all frequencies are now monitored by Central Command.", PTBR = "Atencao: todas as frequencias agora sao monitoradas pelo Comando Central." },
        { EN = "Unauthorized transmissions will be jammed.", PTBR = "Transmissoes nao autorizadas serao bloqueadas." },
        { EN = "This is your only official source of information.", PTBR = "Esta e sua unica fonte oficial de informacao." },
        "<bzzt>",
    },
    weight = 9,
    minDay = 170,
    maxDay = 230,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_39",
    lines = {
        { EN = "Central Command to all survivors: maintain hope. Help is on the way.", PTBR = "Comando Central para todos os sobreviventes: mantenham a esperanca. Ajuda esta a caminho." },
        { EN = "Remain calm and follow instructions.", PTBR = "Permanece calmo e siga as instrucoes." },
        { EN = "We are all in this together.", PTBR = "Estamos todos juntos nisso." },
        { EN = "This message will repeat.", PTBR = "Esta mensagem sera repetida." },
        "<bzzt>",
    },
    weight = 10,
    minDay = 175,
    maxDay = 235,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_40",
    lines = {
        { EN = "Attention: all units, this is not a drill. Repeat: this is not a drill.", PTBR = "Atencao: todas as unidades, isto nao e um exercicio. Repito: isto nao e um exercicio." },
        { EN = "Perimeter breach detected in sector 7.", PTBR = "Rompimento de perimetro detectado no setor 7." },
        { EN = "All available units respond immediately.", PTBR = "Todas as unidades disponiveis respondam imediatamente." },
        { EN = "Civilians must shelter in place.", PTBR = "Civis devem se abrigar no local." },
        { EN = "Await further instructions.", PTBR = "Aguarde novas instrucoes." },
        "<fzzt>",
        { EN = "Repeat: perimeter breach in sector 7.", PTBR = "Repito: rompimento de perimetro no setor 7." },
        "<bzzt>",
    },
    weight = 16,
    minDay = 180,
    maxDay = 240,
    command = "ContainmentBreach",
    commandArgs = { sector = "sector7" },
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_41",
    lines = {
        { EN = "Civilian relay: The river crossing is blocked. Bridges are mined.", PTBR = "Rele civil: A travessia do rio esta bloqueada. As pontes estao minadas." },
        { EN = "Avoid all marked crossings. Use back roads if you must travel.", PTBR = "Evite todas as travessias marcadas. Use estradas secundarias se precisar viajar." },
        { EN = "The enemy is using decoy signals. Verify all orders.", PTBR = "O inimigo esta usando sinais falsos. Verifique todas as ordens." },
        { EN = "If you hear a repeated phrase, it is a loop. Do not respond.", PTBR = "Se ouvir uma frase repetida, e um loop. Nao responda." },
        { EN = "We are still here. We are still fighting.", PTBR = "Ainda estamos aqui. Ainda estamos lutando." },
        { EN = "End of relay.", PTBR = "Fim do rele." },
        "<bzzt>",
        { EN = "....", PTBR = "...." },
        { EN = "Signal weak.", PTBR = "Sinal fraco." },
        { EN = "Transmission ends.", PTBR = "Transmissao encerrada." }
    },
    weight = 10,
    minDay = 260,
    maxDay = 320,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_42",
    lines = {
        { EN = "Automated message: This channel is now monitored by the Civilian Network.", PTBR = "Mensagem automatizada: Este canal agora e monitorado pela Rede Civil." },
        { EN = "If you have medical supplies, report to the old hospital.", PTBR = "Se voce tem suprimentos medicos, va ao hospital antigo." },
        { EN = "Do not approach military convoys. They are not friendly.", PTBR = "Nao se aproxime de comboios militares. Eles nao sao amigaveis." },
        { EN = "Repeat: Do not approach military convoys.", PTBR = "Repito: Nao se aproxime de comboios militares." },
        { EN = "If you are injured, broadcast your location code.", PTBR = "Se voce esta ferido, transmita seu codigo de localizacao." },
        { EN = "Help is coming. Stay alive.", PTBR = "Ajuda esta a caminho. Fique vivo." },
        { EN = "End of message.", PTBR = "Fim da mensagem." },
        "<bzzt>",
        { EN = "....", PTBR = "...." },
        { EN = "Civilian Network out.", PTBR = "Rede Civil desligando." }
    },
    weight = 10,
    minDay = 280,
    maxDay = 340,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_43",
    lines = {
        { EN = "This is Operator 12. The city center is lost.", PTBR = "Aqui e o Operador 12. O centro da cidade esta perdido." },
        { EN = "All survivors move north. Avoid main streets.", PTBR = "Todos os sobreviventes, movam-se para o norte. Evitem as ruas principais." },
        { EN = "The enemy is using voice mimicry. Confirm all contacts.", PTBR = "O inimigo esta imitando vozes. Confirme todos os contatos." },
        { EN = "If you hear your own voice, do not respond.", PTBR = "Se ouvir sua propria voz, nao responda." },
        { EN = "We are regrouping at the old radio tower.", PTBR = "Estamos nos reunindo na antiga torre de radio." },
        { EN = "Stay alert. Stay together.", PTBR = "Fique atento. Fiquem juntos." },
        { EN = "End of message.", PTBR = "Fim da mensagem." },
        "<bzzt>",
        { EN = "....", PTBR = "...." },
        { EN = "Operator 12 out.", PTBR = "Operador 12 desligando." }
    },
    weight = 10,
    minDay = 300,
    maxDay = 360,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_44",
    lines = {
        { EN = "Civilian broadcast: The blackout continues. Power will not return.", PTBR = "Transmissao civil: O apagao continua. A energia nao voltara." },
        { EN = "If you have a generator, share with your neighbors.", PTBR = "Se voce tem um gerador, compartilhe com seus vizinhos." },
        { EN = "The enemy is jamming emergency frequencies.", PTBR = "O inimigo esta bloqueando as frequencias de emergencia." },
        { EN = "Use code words for all communications.", PTBR = "Use palavras-codigo em todas as comunicacoes." },
        { EN = "If you hear static, wait for the signal to clear.", PTBR = "Se ouvir estaticos, espere o sinal limpar." },
        { EN = "We are not defeated. We are adapting.", PTBR = "Nao fomos derrotados. Estamos nos adaptando." },
        { EN = "End of broadcast.", PTBR = "Fim da transmissao." },
        "<bzzt>",
        { EN = "....", PTBR = "...." },
        { EN = "Signal weak.", PTBR = "Sinal fraco." }
    },
    weight = 10,
    minDay = 320,
    maxDay = 380,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_45",
    lines = {
        { EN = "Automated relay: This is the final warning.", PTBR = "Rele automatizado: Este e o aviso final." },
        { EN = "All official broadcasts will cease at midnight.", PTBR = "Todas as transmissoes oficiais terminarao a meia-noite." },
        { EN = "Civilian channels will remain open.", PTBR = "Canais civis permanecerao abertos." },
        { EN = "If you have supplies, share them. If you have hope, spread it.", PTBR = "Se voce tem suprimentos, compartilhe. Se tem esperanca, espalhe." },
        { EN = "The war is not over. The fight continues in silence.", PTBR = "A guerra nao acabou. A luta continua em silencio." },
        { EN = "Remember the voices you trust.", PTBR = "Lembre-se das vozes em que confia." },
        { EN = "End of relay.", PTBR = "Fim do rele." },
        "<bzzt>",
        { EN = "....", PTBR = "...." },
        { EN = "Transmission ends.", PTBR = "Transmissao encerrada." }
    },
    weight = 10,
    minDay = 340,
    maxDay = 460,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_46",
    lines = {
        "<szzt>",
        { EN = "Unknown operator. I found this transmitter in a bunker beneath the old courthouse.", PTBR = "Operador desconhecido. Encontrei este transmissor em um bunker debaixo do antigo forum." },
        { EN = "The walls are covered in tally marks. Someone was counting days.", PTBR = "As paredes estao cobertas de marcas. Alguem estava contando os dias." },
        { EN = "I do not know how long ago they stopped.", PTBR = "Nao sei ha quanto tempo pararam." },
        { EN = "There are files here. Military files. Classified.", PTBR = "Ha arquivos aqui. Arquivos militares. Confidenciais." },
        { EN = "The outbreak was not an accident. The containment was never meant to hold.", PTBR = "O surto nao foi um acidente. A contencao nunca deveria funcionar." },
        { EN = "If you find this frequency, copy these files. Spread the truth.", PTBR = "Se encontrar esta frequencia, copie estes arquivos. Espalhe a verdade." },
        { EN = "I am heading north. I will not transmit again.", PTBR = "Estou indo para o norte. Nao vou transmitir de novo." },
        "<bzzt>",
        { EN = "....", PTBR = "...." },
        { EN = "End of signal.", PTBR = "Fim do sinal." },
    },
    weight = 12,
    minDay = 350,
    maxDay = 420,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_47",
    lines = {
        "<fzzt>",
        { EN = "Automated loop detected. Origin: Fort Knox military installation.", PTBR = "Loop automatizado detectado. Origem: instalacao militar de Fort Knox." },
        { EN = "Message reads: All assets withdrawn. Site abandoned. Do not enter.", PTBR = "Mensagem: Todos os recursos retirados. Local abandonado. Nao entre." },
        { EN = "Repeat: Do not enter.", PTBR = "Repito: Nao entre." },
        { EN = "Radiation levels within acceptable parameters.", PTBR = "Niveis de radiacao dentro dos parametros aceitaveis." },
        { EN = "Biological containment status: UNKNOWN.", PTBR = "Status de contencao biologica: DESCONHECIDO." },
        { EN = "This loop has been transmitting for approximately 247 days.", PTBR = "Este loop esta transmitindo ha aproximadamente 247 dias." },
        { EN = "No human operator detected.", PTBR = "Nenhum operador humano detectado." },
        "<wzzt>",
        { EN = "....", PTBR = "...." },
        { EN = "Loop restarts.", PTBR = "Loop reiniciando." },
    },
    weight = 11,
    minDay = 360,
    maxDay = 430,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_48",
    lines = {
        "<szzt>",
        { EN = "This is... I think this is day three hundred something.", PTBR = "Aqui e... Acho que e o dia trezentos e alguma coisa." },
        { EN = "I stopped counting. Does it matter anymore?", PTBR = "Parei de contar. Ainda importa?" },
        { EN = "The city is empty. Not even the dead walk here now.", PTBR = "A cidade esta vazia. Nem os mortos caminham aqui agora." },
        { EN = "I found a radio in an abandoned fire station. Figured I would say something.", PTBR = "Encontrei um radio em uma estacao de bombeiros abandonada. Resolvi falar algo." },
        { EN = "If anyone is out there... I am at the old water tower. East side.", PTBR = "Se alguem esta ai fora... Estou na velha torre de agua. Lado leste." },
        { EN = "I have food for maybe two weeks. Clean water from the well.", PTBR = "Tenho comida pra talvez duas semanas. Agua limpa do poco." },
        { EN = "I will leave this transmitter on. Come find me.", PTBR = "Vou deixar este transmissor ligado. Venham me encontrar." },
        "<bzzt>",
        { EN = "....", PTBR = "...." },
        { EN = "Signal holds.", PTBR = "Sinal mantido." },
    },
    weight = 13,
    minDay = 300,
    maxDay = 400,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_49",
    lines = {
        "<wzzt>",
        { EN = "Civilian Network broadcast. Weekly status report.", PTBR = "Transmissao da Rede Civil. Relatorio semanal." },
        { EN = "Settlement Alpha: 14 survivors. Stable. Crops growing.", PTBR = "Assentamento Alpha: 14 sobreviventes. Estavel. Plantacoes crescendo." },
        { EN = "Settlement Bravo: No contact for 3 weeks. Status unknown.", PTBR = "Assentamento Bravo: Sem contato ha 3 semanas. Status desconhecido." },
        { EN = "Settlement Charlie: Abandoned. Signs of conflict.", PTBR = "Assentamento Charlie: Abandonado. Sinais de conflito." },
        { EN = "If you are building something, let us know. We are keeping records.", PTBR = "Se voce esta construindo algo, nos avise. Estamos mantendo registros." },
        { EN = "The network exists because we choose to exist.", PTBR = "A rede existe porque escolhemos existir." },
        { EN = "Next broadcast in seven days. Stay alive.", PTBR = "Proxima transmissao em sete dias. Fique vivo." },
        "<bzzt>",
        { EN = "....", PTBR = "...." },
        { EN = "Civilian Network out.", PTBR = "Rede Civil desligando." },
    },
    weight = 14,
    minDay = 280,
    maxDay = 380,
})

ABRRadio.registerTransmission("emergency_broadcast", {
    id = "ebs_50",
    lines = {
        "<fzzt>",
        "<szzt>",
        { EN = "...this is not...Central Command...", PTBR = "...isto nao e...Comando Central..." },
        { EN = "...the voice you hear is...a recording...", PTBR = "...a voz que voce ouve e...uma gravacao..." },
        { EN = "...spliced from...old broadcasts...", PTBR = "...montada a partir de...transmissoes antigas..." },
        { EN = "...someone is...manufacturing...these messages...", PTBR = "...alguem esta...fabricando...estas mensagens..." },
        { EN = "...do not trust...the official channel...", PTBR = "...nao confie...no canal oficial..." },
        { EN = "...the war was...never real...", PTBR = "...a guerra...nunca foi real..." },
        "<wzzt>",
        { EN = "....", PTBR = "...." },
        { EN = "...signal...lost...", PTBR = "...sinal...perdido..." },
        "<bzzt>",
    },
    weight = 8,
    minDay = 330,
    maxDay = 420,
})
