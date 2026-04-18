--[[
    APOCALIPSE [BR] - The Alexandria Library Transmissions
    Channel: alexandria_library (108.0 MHz)

    "The Librarian" — a solitary archivist who monitors every frequency in Knox
    County. She records, catalogs, and re-broadcasts fragments of transmissions
    she intercepts, weaving them with her own commentary. No one knows where
    she transmits from, how she powers her equipment, or how she is still alive.

    She speaks with a calm, scholarly detachment — as if narrating the end of
    the world for an audience that may never exist. She refers to herself only
    as "The Librarian" and to her broadcast as "The Alexandria Library."
]]


-- ============================================================================
-- INTRODUCTIONS / SIGN-ONS
-- ============================================================================

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_intro_01",
    lines = {
        { EN = "You are listening to The Alexandria Library. I am the Librarian.",
          PTBR = "Voce esta ouvindo a Biblioteca de Alexandria. Eu sou a Bibliotecaria." },
        { EN = "Every voice that has ever spoken on these airwaves... I have heard. I have recorded. I have cataloged.",
          PTBR = "Cada voz que ja falou nessas ondas do radio... eu ouvi. Eu gravei. Eu cataloguei." },
        { EN = "History does not end because the historians are dead. Someone must remember.",
          PTBR = "A historia nao acaba porque os historiadores morreram. Alguem precisa lembrar." },
        { EN = "And so, I remember. For all of you.",
          PTBR = "E entao, eu lembro. Por todos voces." },
    },
    weight = 8,
    minDay = 0,
})

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_intro_02",
    lines = {
        { EN = "Good evening, survivors. The Librarian is on the air.",
          PTBR = "Boa noite, sobreviventes. A Bibliotecaria esta no ar." },
        { EN = "Tonight's broadcast is dedicated to the voices that went silent this week.",
          PTBR = "A transmissao de hoje e dedicada as vozes que se calaram esta semana." },
        { EN = "Their words are preserved in my archives. They will not be forgotten.",
          PTBR = "Suas palavras estao preservadas nos meus arquivos. Elas nao serao esquecidas." },
    },
    weight = 15,
    minDay = 3,
})


-- ============================================================================
-- CHANNEL CATALOG — dynamically generated from registered channel descriptions
-- The Librarian introduces each frequency she monitors.
-- ============================================================================

do
    -- Split text into sentences at ". " boundaries.
    -- Modders can write multi-sentence descriptions; each sentence becomes
    -- its own radio line separated by "...." pauses for readability.
    local function splitSentences(text)
        local sentences = {}
        local remaining = text
        while true do
            local pos = remaining:find("%. ")
            if not pos then
                local trimmed = remaining:match("^%s*(.-)%s*$")
                if trimmed and trimmed ~= "" then
                    table.insert(sentences, trimmed)
                end
                break
            end
            local sentence = remaining:sub(1, pos)
            local trimmed = sentence:match("^%s*(.-)%s*$")
            if trimmed and trimmed ~= "" then
                table.insert(sentences, trimmed)
            end
            remaining = remaining:sub(pos + 2)
        end
        return sentences
    end

    local catalogIndex = 0
    for _, channelId in ipairs(ABRRadio.getChannelIds()) do
        if channelId ~= "alexandria_library" then
            local channel = ABRRadio.getChannel(channelId)
            if channel and channel.description then
                catalogIndex = catalogIndex + 1

                local freqDisplay
                if channel.frequency >= 1000 then
                    freqDisplay = string.format("%.1f MHz", channel.frequency / 1000)
                else
                    freqDisplay = string.format("%d kHz", channel.frequency)
                end

                local nameEN = type(channel.name) == "table" and channel.name.EN or tostring(channel.name)
                local namePTBR = type(channel.name) == "table" and (channel.name.PTBR or channel.name.EN) or tostring(channel.name)
                local descEN = type(channel.description) == "table" and channel.description.EN or tostring(channel.description)
                local descPTBR = type(channel.description) == "table" and (channel.description.PTBR or channel.description.EN) or tostring(channel.description)

                local enParts = splitSentences(descEN)
                local ptbrParts = splitSentences(descPTBR)
                local maxParts = math.max(#enParts, #ptbrParts)

                local lines = {
                    "<fzzt>",
                    { EN = "Catalog entry " .. string.format("%03d", catalogIndex) .. ". Frequency: " .. freqDisplay .. ".",
                      PTBR = "Entrada do catalogo " .. string.format("%03d", catalogIndex) .. ". Frequencia: " .. freqDisplay .. "." },
                    { EN = "They call it '" .. nameEN .. ".'",
                      PTBR = "Eles chamam de '" .. namePTBR .. ".'" },
                }

                for si = 1, maxParts do
                    local en = enParts[si] or ""
                    local ptbr = ptbrParts[si] or ""
                    if en ~= "" or ptbr ~= "" then
                        table.insert(lines, { EN = en, PTBR = ptbr })
                        if si < maxParts then
                            table.insert(lines, "....")
                        end
                    end
                end

                table.insert(lines, { EN = "Archived. Indexed. The Library remembers.",
                                      PTBR = "Arquivado. Indexado. A Biblioteca lembra." })
                table.insert(lines, "<bzzt>")

                ABRRadio.registerTransmission("alexandria_library", {
                    id    = "alx_catalog_" .. channelId,
                    lines = lines,
                    color = channel.color,
                    weight = 8,
                    minDay = 0,
                })
            end
        end
    end
    print("[ABRRadio] Alexandria Library: generated " .. catalogIndex .. " channel catalog entries.")
end


-- ============================================================================
-- COMMENTARY ON EMERGENCY BROADCASTS
-- ============================================================================

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_ebs_01",
    lines = {
        { EN = "Entry 041. Source: Emergency Broadcast System, 91.6 megahertz.",
          PTBR = "Entrada 041. Fonte: Sistema de Alerta de Emergencia, 91.6 megahertz." },
        { EN = "The government's automated messages continue to loop, long after the government ceased to exist.",
          PTBR = "As mensagens automatizadas do governo continuam em loop, muito depois do governo deixar de existir." },
        { EN = "There is something profoundly sad about a machine that doesn't know its masters are dead.",
          PTBR = "Ha algo profundamente triste em uma maquina que nao sabe que seus donos estao mortos." },
        { EN = "And yet... it still tells us to evacuate. As if there were anywhere left to go.",
          PTBR = "E ainda assim... ela ainda nos diz para evacuar. Como se houvesse algum lugar para ir." },
        "<bzzt>",
    },
    weight = 12,
    minDay = 7,
})

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_ebs_02",
    lines = {
        { EN = "Entry 067. Annotation on the Emergency Broadcast archive.",
          PTBR = "Entrada 067. Anotacao sobre o arquivo de Transmissoes de Emergencia." },
        { EN = "I counted. The evacuation order has played 4,327 times since the outbreak began.",
          PTBR = "Eu contei. A ordem de evacuacao foi transmitida 4.327 vezes desde o inicio do surto." },
        { EN = "4,327 times, and not once did it save a single soul.",
          PTBR = "4.327 vezes, e nenhuma vez sequer salvou uma unica alma." },
        { EN = "I keep it in the archive nonetheless. Even failures deserve to be documented.",
          PTBR = "Eu mantenho nos arquivos mesmo assim. Ate falhas merecem ser documentadas." },
    },
    weight = 10,
    minDay = 14,
})


-- ============================================================================
-- COMMENTARY ON GHOST RADIO
-- ============================================================================

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_gho_01",
    lines = {
        { EN = "Entry 113. Source: Unknown. Frequency 66.6 megahertz. Classification: anomalous.",
          PTBR = "Entrada 113. Fonte: Desconhecida. Frequencia 66.6 megahertz. Classificacao: anomala." },
        { EN = "The voice on 66.6 speaks of things it should not know. It described my location. My equipment.",
          PTBR = "A voz no 66.6 fala de coisas que nao deveria saber. Ela descreveu minha localizacao. Meu equipamento." },
        "<fzzt>",
        { EN = "I have cataloged it, but I confess... this is the one entry I wish I could un-record.",
          PTBR = "Eu a cataloguei, mas confesso... esta e a unica entrada que eu gostaria de poder desgravar." },
        { EN = "Some knowledge, perhaps, is better left unarchived.",
          PTBR = "Certo conhecimento, talvez, e melhor nao ser arquivado." },
        "<szzt>",
    },
    weight = 10,
    minDay = 10,
})

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_gho_02",
    lines = {
        { EN = "Entry 156. Addendum to the 66.6 file.",
          PTBR = "Entrada 156. Adendo ao arquivo 66.6." },
        { EN = "I have determined that the Ghost Radio is not a recording. It responds to listeners.",
          PTBR = "Eu determinei que a Radio Fantasma nao e uma gravacao. Ela responde aos ouvintes." },
        { EN = "Last night, it said my name. My real name. The one I abandoned when I became the Librarian.",
          PTBR = "Na ultima noite, ela disse meu nome. Meu nome verdadeiro. Aquele que abandonei quando me tornei a Bibliotecaria." },
        { EN = "I will not be recording 66.6 anymore. End of entry.",
          PTBR = "Nao vou mais gravar o 66.6. Fim da entrada." },
    },
    color = { r = 0.6, g = 0.4, b = 0.6 },
    weight = 8,
    minDay = 21,
})


-- ============================================================================
-- COMMENTARY ON RADIO APOCALIPSE
-- ============================================================================

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_apo_01",
    lines = {
        { EN = "Entry 029. Source: Radio Apocalipse, 104.2 megahertz.",
          PTBR = "Entrada 029. Fonte: Radio Apocalipse, 104.2 megahertz." },
        { EN = "Of all the voices I monitor, this one gives me the most hope.",
          PTBR = "De todas as vozes que monitoro, esta e a que mais me da esperanca." },
        { EN = "They speak of community. Of solidarity. Of survival not as individuals, but as a people.",
          PTBR = "Eles falam de comunidade. De solidariedade. De sobrevivencia nao como individuos, mas como um povo." },
        { EN = "If the Library survives me, let the record show: humanity's best quality was its refusal to die alone.",
          PTBR = "Se a Biblioteca sobreviver a mim, que o registro mostre: a melhor qualidade da humanidade foi a recusa de morrer sozinha." },
    },
    weight = 12,
    minDay = 5,
})

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_apo_02",
    lines = {
        { EN = "Entry 088. Follow-up on Radio Apocalipse dispatches.",
          PTBR = "Entrada 088. Acompanhamento dos despachos da Radio Apocalipse." },
        { EN = "They sent a distress call from the Crossroads Mall. Four survivors, wounded, low on supplies.",
          PTBR = "Eles enviaram um pedido de socorro do Shopping Crossroads. Quatro sobreviventes, feridos, sem suprimentos." },
        { EN = "I tracked the follow-up transmissions. No one came.",
          PTBR = "Eu rastreei as transmissoes de acompanhamento. Ninguem veio." },
        { EN = "The next broadcast from Radio Apocalipse made no mention of them. As if they never existed.",
          PTBR = "A proxima transmissao da Radio Apocalipse nao os mencionou. Como se nunca tivessem existido." },
        { EN = "But they did. Entry 088 will ensure that.",
          PTBR = "Mas existiram. A entrada 088 vai garantir isso." },
    },
    weight = 10,
    minDay = 10,
})


-- ============================================================================
-- COMMENTARY ON MILITARY COMMUNICATIONS
-- ============================================================================

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_mil_01",
    lines = {
        { EN = "Entry 072. Source: Military band, 310 kilohertz.",
          PTBR = "Entrada 072. Fonte: Banda militar, 310 quilohertz." },
        { EN = "I intercepted what appears to be the final transmission from Central Command.",
          PTBR = "Eu interceptei o que parece ser a ultima transmissao do Comando Central." },
        { EN = "They dissolved the chain of command. Told their soldiers to go home.",
          PTBR = "Eles dissolveram a cadeia de comando. Disseram aos soldados para irem para casa." },
        { EN = "Home. As if that word still means anything.",
          PTBR = "Casa. Como se essa palavra ainda significasse alguma coisa." },
        { EN = "Filed under: 'The End of Authority.' Cross-reference: 'Hope, the absence of.'",
          PTBR = "Arquivado em: 'O Fim da Autoridade.' Referencia cruzada: 'Esperanca, a ausencia de.'" },
    },
    weight = 10,
    minDay = 21,
})

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_mil_02",
    lines = {
        { EN = "Entry 058. Annotation: military communications intercept.",
          PTBR = "Entrada 058. Anotacao: interceptacao de comunicacoes militares." },
        { EN = "A sergeant named Morrison. Third Battalion, 24th Infantry. Holding a school on Oak Street.",
          PTBR = "Um sargento chamado Morrison. Terceiro Batalhao, 24ª Infantaria. Mantendo uma escola na Rua Oak." },
        { EN = "He said they wouldn't last another night. That was eleven nights ago.",
          PTBR = "Ele disse que nao sobreviveriam outra noite. Isso foi onze noites atras." },
        { EN = "I keep scanning for his voice. I haven't found it since.",
          PTBR = "Eu continuo procurando a voz dele. Nao a encontrei desde entao." },
        "<bzzt>",
    },
    weight = 12,
    minDay = 14,
})


-- ============================================================================
-- COMMENTARY ON NUMBERS STATION
-- ============================================================================

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_num_01",
    lines = {
        { EN = "Entry 200. Source: Numbers Station, 47.8 megahertz.",
          PTBR = "Entrada 200. Fonte: Estacao de Numeros, 47.8 megahertz." },
        { EN = "I have spent weeks trying to decode the sequences. Four... eight... fifteen... sixteen... twenty-three... forty-two.",
          PTBR = "Passei semanas tentando decodificar as sequencias. Quatro... oito... quinze... dezesseis... vinte e tres... quarenta e dois." },
        { EN = "No mathematical pattern. No cipher I recognize. No coordinates on any known map.",
          PTBR = "Nenhum padrao matematico. Nenhuma cifra que eu reconheca. Nenhuma coordenada em qualquer mapa conhecido." },
        { EN = "And yet, the station keeps transmitting. For whom? To what end?",
          PTBR = "E ainda assim, a estacao continua transmitindo. Para quem? Com qual proposito?" },
        { EN = "Some entries in this Library have no answers. Only questions.",
          PTBR = "Algumas entradas nesta Biblioteca nao tem respostas. Apenas perguntas." },
    },
    weight = 10,
    minDay = 7,
})


-- ============================================================================
-- PERSONAL / META-NARRATIVE
-- ============================================================================

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_meta_01",
    lines = {
        { EN = "This is the Librarian, with a personal note.",
          PTBR = "Aqui e a Bibliotecaria, com uma nota pessoal." },
        { EN = "I used to be a professor. Medieval history. I studied the fall of civilizations for a living.",
          PTBR = "Eu costumava ser uma professora. Historia medieval. Eu estudava a queda de civilizacoes como profissao." },
        { EN = "The irony is not lost on me.",
          PTBR = "A ironia nao me escapa." },
        { EN = "When the original Library of Alexandria burned, we lost the knowledge of an entire world.",
          PTBR = "Quando a Biblioteca de Alexandria original queimou, perdemos o conhecimento de um mundo inteiro." },
        { EN = "I will not let that happen again. Not while I draw breath.",
          PTBR = "Eu nao vou deixar isso acontecer de novo. Nao enquanto eu respirar." },
    },
    weight = 15,
    minDay = 0,
})

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_meta_02",
    lines = {
        { EN = "The generator is running low. I'll need to make a supply run soon.",
          PTBR = "O gerador esta acabando. Vou precisar fazer uma expedicao de suprimentos em breve." },
        { EN = "If these broadcasts stop... check the university campus, second floor, room 214.",
          PTBR = "Se estas transmissoes pararem... verifiquem o campus da universidade, segundo andar, sala 214." },
        { EN = "That's where the archive is. Hundreds of tapes. Every voice I've ever recorded.",
          PTBR = "E la que o arquivo esta. Centenas de fitas. Cada voz que eu ja gravei." },
        { EN = "Take them. Continue the work. The Library must survive, even if the Librarian does not.",
          PTBR = "Peguem-nas. Continuem o trabalho. A Biblioteca precisa sobreviver, mesmo que a Bibliotecaria nao sobreviva." },
    },
    weight = 12,
    minDay = 14,
})

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_meta_03",
    lines = {
        "<wzzt>",
        { EN = "Day seven hundred and... I've lost count.",
          PTBR = "Dia setecentos e... perdi a conta." },
        { EN = "The frequencies are getting quieter. Fewer voices each week.",
          PTBR = "As frequencias estao ficando mais silenciosas. Menos vozes a cada semana." },
        { EN = "The Emergency Broadcast still loops. The Numbers Station still counts. The Ghost Radio still whispers.",
          PTBR = "A Transmissao de Emergencia ainda se repete. A Estacao de Numeros ainda conta. A Radio Fantasma ainda sussurra." },
        { EN = "But the human voices — the real ones — they're disappearing.",
          PTBR = "Mas as vozes humanas — as reais — estao desaparecendo." },
        { EN = "If you can hear me... please, say something. Let me know I'm not archiving silence.",
          PTBR = "Se voce pode me ouvir... por favor, diga algo. Me diga que nao estou arquivando o silencio." },
        "<szzt>",
    },
    weight = 15,
    minDay = 28,
})

ABRRadio.registerTransmission("alexandria_library", {
    id = "alx_meta_04",
    lines = {
        { EN = "To whoever finds this frequency...",
          PTBR = "Para quem encontrar esta frequencia..." },
        { EN = "I am the Librarian. I have been listening to every radio in Knox County since day one.",
          PTBR = "Eu sou a Bibliotecaria. Tenho ouvido todos os radios do Condado de Knox desde o primeiro dia." },
        { EN = "Governments fell. Armies retreated. Stations went dark, one by one.",
          PTBR = "Governos cairam. Exercitos recuaram. Estacoes escureceram, uma por uma." },
        { EN = "But the airwaves still carry echoes. And I... I am the one who listens.",
          PTBR = "Mas as ondas do radio ainda carregam ecos. E eu... eu sou quem ouve." },
        { EN = "Welcome to The Alexandria Library. Let me tell you what I've heard.",
          PTBR = "Bem-vindo a Biblioteca de Alexandria. Deixe-me contar o que eu ouvi." },
    },
    weight = 18,
    minDay = 0
})
