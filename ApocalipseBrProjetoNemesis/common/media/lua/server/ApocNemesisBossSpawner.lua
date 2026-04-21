if not isServer() then
	return
end

require "RegionManager_ZombieModules"
local ZombieHelper = require "RegionManager_ZombieServerHelper"
local moduleID = "nemesis"

ApocNemesisBoss = ApocNemesisBoss or {}

local Config = {
	ModDataKey = "ApocNemesisBossState",
	_loaded = false,
}

--- Split a CSV string into a table of trimmed tokens.
local function splitCSV(str, sep)
	local result = {}
	if not str or str == "" then return result end
	sep = sep or ","
	for token in string.gmatch(str, "([^" .. sep .. "]+)") do
		local trimmed = token:match("^%s*(.-)%s*$")
		if trimmed and trimmed ~= "" then
			result[#result + 1] = trimmed
		end
	end
	return result
end

local function loadConfig()
	if Config._loaded then
		return
	end
	local sv = SandboxVars.ApocalipseBrProjetoNemesis
	if not sv then
		return
	end

	-- Parse outfit names and weights as parallel CSV lists
	Config.OutfitNames = splitCSV(sv.OutfitName or "Nemesis")
	if #Config.OutfitNames == 0 then
		Config.OutfitNames = { "Nemesis" }
	end

	local rawWeights = splitCSV(sv.OutfitWeights or "100")
	Config.OutfitWeights = {}
	Config.OutfitWeightTotal = 0
	for i, name in ipairs(Config.OutfitNames) do
		local w = tonumber(rawWeights[i]) or 100
		Config.OutfitWeights[i] = w
		Config.OutfitWeightTotal = Config.OutfitWeightTotal + w
	end

	-- Build a fast lookup set for outfit names
	Config.OutfitNameSet = {}
	for _, name in ipairs(Config.OutfitNames) do
		Config.OutfitNameSet[name] = true
	end

	Config.PressurePerMinute = sv.PressurePerMinute or 3
	Config.PressureThreshold = sv.PressureThreshold or 30
	Config.SpawnRollPercent = sv.SpawnRollPercent or 10
	Config.SpawnMinDistance = sv.SpawnMinDistance or 30
	Config.SpawnMaxDistance = sv.SpawnMaxDistance or 45
	Config.BossHealth = sv.BossHealth or 4.5
	Config.BossMaxHits = sv.BossMaxHits or 10
	Config.Debug = sv.Debug or false
	Config._loaded = true
end

--- Pick a random outfit name using the weighted probabilities.
---@return string
local function pickRandomOutfit()
	if #Config.OutfitNames == 1 then
		return Config.OutfitNames[1]
	end
	local roll = ZombRand(Config.OutfitWeightTotal)
	local cumulative = 0
	for i, w in ipairs(Config.OutfitWeights) do
		cumulative = cumulative + w
		if roll < cumulative then
			return Config.OutfitNames[i]
		end
	end
	return Config.OutfitNames[1]
end

local function log(message)
	if Config.Debug then
		print("[ApocNemesisBoss] " .. tostring(message))
	end
end

local function getState()
	local state = ModData.getOrCreate(Config.ModDataKey)
	if type(state.pressure) ~= "number" then
		state.pressure = 0
	end
	if state.bossActive == nil then
		state.bossActive = false
	end
	if type(state.lastTargetUsername) ~= "string" then
		state.lastTargetUsername = ""
	end
	return state
end

local function isEligiblePlayer(player)
	return player
		and player:isAlive()
		and not player:isDead()
		and not player:isAsleep()
		and player:getCurrentSquare() ~= nil
end

local function collectEligiblePlayers()
	local players = {}
	local onlinePlayers = getOnlinePlayers()
	if onlinePlayers then
		for index = 0, onlinePlayers:size() - 1 do
			local player = onlinePlayers:get(index)
			if isEligiblePlayer(player) then
				players[#players + 1] = player
			end
		end
	end
	return players
end

local function applyBossTuning(zombie)
	if not zombie then
		return
	end

	local zombieData = zombie:getModData()
	if zombieData.ApocNemesisBossApplied then
		return
	end

	zombieData.ApocNemesisBossApplied = true
	zombieData.ApocNemesisBoss = true
	-- Health is now handled by the regioes module stats (isTough + maxHits)
	-- and bossHealth override in the module registration.
	log("Applied boss tuning to Nemesis zombie")
end

local function scanLiveNemesis()
	local cell = getCell()
	if not cell then
		return false
	end

	local zombies = cell:getZombieList()
	if not zombies then
		return false
	end

	local hasNemesis = false
	for index = 0, zombies:size() - 1 do
		local zombie = zombies:get(index)
		local outfitName = zombie and not zombie:isDead() and zombie:getOutfitName()
		if outfitName and Config.OutfitNameSet[outfitName] then
			local zData = zombie:getModData()
			if zData.ApocNemesisBoss then
				hasNemesis = true
				applyBossTuning(zombie)
			else
				-- Random zombie got a boss outfit: redress it
				zombie:dressInRandomOutfit()
				log("Stripped boss outfit from non-boss zombie")
			end
		end
	end

	return hasNemesis
end

local function isConversionCandidate(zombie, playerX, playerY, minDistSq, maxDistSq)
	if not zombie or zombie:isDead() then return false end

	-- Skip crawlers, sitting/fake-dead zombies, and knocked-down zombies
	if zombie:isCrawling() or zombie:isFakeDead() or zombie:isKnockedDown() then
		return false
	end

	-- Skip zombies currently engaged with a target (e.g. attacking a door)
	if zombie:getTarget() then return false end

	local zData = zombie:getModData()
	if zData.ApocNemesisBoss then return false end

	-- Skip zombies already belonging to a registered module
	local outfitName = zombie:getOutfitName()
	if outfitName and RegionManager.ZombieModules.getByOutfit(outfitName) then
		return false
	end

	local dx = zombie:getX() - playerX
	local dy = zombie:getY() - playerY
	local distSq = dx * dx + dy * dy
	return distSq >= minDistSq and distSq <= maxDistSq
end

local function findCandidateZombie(player)
	local cell = getCell()
	if not cell then return nil end

	local zombies = cell:getZombieList()
	if not zombies or zombies:size() == 0 then return nil end

	local playerX = player:getX()
	local playerY = player:getY()
	local minDistSq = Config.SpawnMinDistance * Config.SpawnMinDistance
	local maxDistSq = Config.SpawnMaxDistance * Config.SpawnMaxDistance

	local candidates = {}
	for i = 0, zombies:size() - 1 do
		local zombie = zombies:get(i)
		if isConversionCandidate(zombie, playerX, playerY, minDistSq, maxDistSq) then
			candidates[#candidates + 1] = zombie
		end
	end

	if #candidates == 0 then
		log("No candidate zombies within range of " .. tostring(player:getUsername()))
		return nil
	end
	return candidates[ZombRand(#candidates) + 1]
end

-- ============================================================================
-- Delayed NemesisConvert: after converting a zombie, broadcast a custom
-- command to all clients so they can dress the zombie locally and apply
-- module properties.  The generic ConfirmZombie pipeline cannot be used
-- because dressInNamedOutfit on the server does not sync the outfit to
-- clients, causing the outfit validation check to fail.
-- ============================================================================
local DelayedConverts = {
	queue = {},   -- { [i] = { framesLeft=number, zombieRef=IsoZombie, decisions=table } }
	count = 0,
}

local function processDelayedConverts()
	if DelayedConverts.count == 0 then return end
	for i = DelayedConverts.count, 1, -1 do
		local entry = DelayedConverts.queue[i]
		entry.framesLeft = entry.framesLeft - 1
		if entry.framesLeft <= 0 then
			local zombie = entry.zombieRef
			if zombie and not zombie:isDead() then
				local onlineID = zombie:getOnlineID()
				if onlineID >= 0 then
					local payload = ZombieHelper.BuildConfirmPayload(onlineID, entry.decisions)
					-- Add the chosen outfit and assigned PID so the client can dress
					-- the zombie locally and stamp the stable PID in modData.
					payload.outfit = entry.outfitName
					payload.pid = entry.assignedPID
					sendServerCommand("ApocNemesisBoss", "NemesisConvert", payload)
					log("Sent NemesisConvert for onlineID=" .. tostring(onlineID) .. " outfit=" .. tostring(entry.outfitName))
				end
			end
			-- Remove (swap with last)
			DelayedConverts.queue[i] = DelayedConverts.queue[DelayedConverts.count]
			DelayedConverts.queue[DelayedConverts.count] = nil
			DelayedConverts.count = DelayedConverts.count - 1
		end
	end
end

Events.OnTick.Add(processDelayedConverts)

local function convertToNemesis(zombie, player)
	-- Pick a weighted random outfit from the configured list
	local chosenOutfit = pickRandomOutfit()

	-- Capture the OLD persistentID before re-dressing. dressInPersistentOutfit
	-- assigns a new persistentOutfitID, so the old entry becomes orphaned.
	local oldPid = ZombieHelper.GetPersistentID(zombie)

	-- Dress the zombie in the chosen outfit using dressInPersistentOutfit
	-- (not dressInNamedOutfit) so that persistentOutfitId is set on the server.
	-- ZombiePacket carries this ID every sync tick, meaning late-joining clients
	-- or clients that chunk-reload will create the zombie with the correct outfit
	-- natively through the engine's createRealZombieAlways pipeline.
	zombie:dressInNamedOutfit(chosenOutfit)
	zombie:dressInPersistentOutfit(chosenOutfit)

	-- Apply boss modData flags
	applyBossTuning(zombie)

	-- Pre-cache module decisions so the regioes framework confirms correctly.
	-- When any client sends RequestZombieInfo the cache already contains the
	-- correct module entry (_moduleId set, maxHits, etc.).
	local x, y = math.floor(zombie:getX()), math.floor(zombie:getY())
	local pid = ZombieHelper.GetPersistentID(zombie)
	if pid then
		local decisions = ZombieHelper.ResolveModuleOverrides(moduleID, x, y)
		if decisions then
			local globalData = ModData.getOrCreate("Apocalipse_TSY_ZombieStates")
			if not globalData.zombies then globalData.zombies = {} end

			-- Remove the OLD pid entry left over from the pre-conversion outfit.
			-- Without this, the cleanup loop would never match the old PID to any
			-- live zombie (since its PID changed), leaving a ghost entry forever.
			if oldPid and oldPid ~= pid then
				globalData.zombies[oldPid] = nil
				log("Removed stale pre-conversion pid=" .. oldPid)
			end

			globalData.zombies[pid] = decisions
			log("Pre-cached module decisions for converted Nemesis pid=" .. pid)

			-- Stamp the assigned PID into zombie modData so it survives outfit
			-- changes. Clients will read this instead of computing from
			-- getPersistentOutfitID() (which changes after dressInPersistentOutfit).
			zombie:getModData().Apocalipse_TSY_AssignedPID = pid

			-- Schedule a delayed NemesisConvert broadcast so that clients
			-- dress the zombie locally and apply the full module properties.
			DelayedConverts.count = DelayedConverts.count + 1
			DelayedConverts.queue[DelayedConverts.count] = {
				framesLeft = 180,  -- ~3 seconds: give clients time to fully initialize the zombie
				zombieRef  = zombie,
				decisions  = decisions,
				outfitName = chosenOutfit,
				assignedPID = pid,
			}
		end
	end

	-- Give network ownership to the targeted player so their client simulates the AI
	zombie:setOwnerPlayer(player)

	log("Converted zombie to " .. chosenOutfit .. " at (" .. x .. ", " .. y .. ")")
	return true
end

local function convertNearPlayer(player)
	local state = getState()

	local zombie = findCandidateZombie(player)
	if not zombie then
		return false
	end

	if not convertToNemesis(zombie, player) then
		return false
	end

	state.bossActive = true
	state.pressure = 0
	state.lastTargetUsername = player:getUsername() or "unknown"
	state.lastSpawnX = math.floor(zombie:getX())
	state.lastSpawnY = math.floor(zombie:getY())
	state.lastSpawnZ = math.floor(zombie:getZ())
	log("Nemesis active near " .. state.lastTargetUsername)
	return true
end

local function onEveryOneMinute()
	loadConfig()
	local state = getState()
	-- state.bossActive = scanLiveNemesis()

	local players = collectEligiblePlayers()
	if #players == 0 then
		return
	end

	state.pressure = math.min(state.pressure + Config.PressurePerMinute, Config.PressureThreshold)
	if state.pressure < Config.PressureThreshold then
		log("Pressure " .. tostring(state.pressure) .. "/" .. tostring(Config.PressureThreshold))
		return
	end

	if ZombRand(100) >= Config.SpawnRollPercent then
		log("Threshold reached but roll failed")
		state.pressure = 0
		return
	end

	local player = players[ZombRand(#players) + 1]
	convertNearPlayer(player)
end

Events.EveryOneMinute.Add(onEveryOneMinute)

-- ============================================================================
-- Register Nemesis as a zombie module with the regioes framework.
-- Stats, sounds, and behavior are declared here; execution is handled by the
-- framework's confirmZombie pipeline and ZombieModuleClient engine.
-- ============================================================================

local function registerNemesisModule()
	loadConfig()

	RegionManager.ZombieModules.register({
		id = moduleID,
		outfitNames = Config.OutfitNames,
		stats = {
			isSprinter      = true,
			isTough         = true,
			maxHits         = Config.BossMaxHits or 10,
			bossHealth      = Config.BossHealth or 4.1,
			isSuperhuman    = true,
			hawkVision      = true,
			pinpointHearing = true,
			hasNavigation   = true,
			hasMemoryLong   = true,
			isResistant		= true,
			killBonus       = 50,
		},
		sounds = {
			suppressVanilla = true,
			theme    = { name = "ApocNemesis_Theme", range = 40, loop = true },
			onDetect = { name = "ApocNemesis_STARS", range = 60 },
			periodic = {
				{
					names = { "ApocNemesis_Roar1", "ApocNemesis_Roar2", "ApocNemesis_RWOAR" },
					cooldownTicks = 480,
					chance = 40,
				},
			},
			onHit = {
				{
					names = { "ApocNemesis_Grunt1", "ApocNemesis_Grunt2", "ApocNemesis_STARS" },
					chance = 30,
				},
			},
		},
		behavior = {
			redirectToPlayer      = true,
			redirectCooldownTicks = 300,
			detectionRange        = 80,
			smashObstacles        = true,
			smashCooldownTicks    = 60,
			smashDamage           = 400,
		},
	})
end

Events.OnInitWorld.Add(registerNemesisModule)