if not isServer() then
	return
end

require "RegionManager_ZombieModules"

ApocNemesisBoss = ApocNemesisBoss or {}

local Config = {
	ModDataKey = "ApocNemesisBossState",
	_loaded = false,
}

local function loadConfig()
	if Config._loaded then
		return
	end
	local sv = SandboxVars.ApocalipseBrProjetoNemesis
	if not sv then
		return
	end
	Config.OutfitName = sv.OutfitName or "Nemesis"
	Config.PressurePerMinute = sv.PressurePerMinute or 3
	Config.PressureThreshold = sv.PressureThreshold or 30
	Config.SpawnRollPercent = sv.SpawnRollPercent or 10
	Config.SpawnMinDistance = sv.SpawnMinDistance or 30
	Config.SpawnMaxDistance = sv.SpawnMaxDistance or 45
	Config.SpawnAttempts = sv.SpawnAttempts or 24
	Config.BossHealth = sv.BossHealth or 4.5
	Config.Debug = sv.Debug or false
	Config._loaded = true
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
		if zombie and not zombie:isDead() and zombie:getOutfitName() == Config.OutfitName then
			local zData = zombie:getModData()
			if zData.ApocNemesisBoss then
				hasNemesis = true
				applyBossTuning(zombie)
			else
				-- Random zombie got the Nemesis outfit: redress it
				zombie:dressInRandomOutfit()
				log("Stripped Nemesis outfit from non-boss zombie")
			end
		end
	end

	return hasNemesis
end

local function isSpawnSquareValid(square, requireOutside)
	if not square then
		return false
	end

	if square:HasStairs() or not square:isFree(false) then
		return false
	end

	if requireOutside and not square:isOutside() then
		return false
	end

	return true
end

local function findSpawnSquare(player, requireOutside)
	local cell = getCell()
	if not cell then
		return nil
	end

	local originX = math.floor(player:getX())
	local originY = math.floor(player:getY())
	local originZ = player:getZ()
	local angleMax = math.pi * 2

	for _ = 1, Config.SpawnAttempts do
		local angle = ZombRand(0, 6284) / 1000
		local distance = ZombRand(Config.SpawnMinDistance, Config.SpawnMaxDistance + 1)
		local x = math.floor(originX + math.cos(angle) * distance)
		local y = math.floor(originY + math.sin(angle) * distance)
		local square = cell:getGridSquare(x, y, originZ)
		if isSpawnSquareValid(square, requireOutside) then
			return square
		end
	end

	log("No valid square found for " .. tostring(player:getUsername()))
	return nil
end

local function spawnNearPlayer(player)
	local state = getState()
	local square = findSpawnSquare(player, true)
	if not square then
		square = findSpawnSquare(player, false)
	end

	if not square then
		return false
	end

	local spawned = addZombiesInOutfit(
		square:getX(),
		square:getY(),
		square:getZ(),
		1,
		Config.OutfitName,
		nil,
		false,
		false,
		false,
		false,
		false,
		false,
		Config.BossHealth
	)

	if not spawned or spawned:size() == 0 then
		log("Spawn call returned no zombies")
		return false
	end

	for index = 0, spawned:size() - 1 do
		local zombie = spawned:get(index)
		applyBossTuning(zombie)
		-- Give network ownership to the targeted player so their client simulates the AI
		zombie:setOwnerPlayer(player)
	end

	state.bossActive = true
	state.pressure = 0
	state.lastTargetUsername = player:getUsername() or "unknown"
	state.lastSpawnX = square:getX()
	state.lastSpawnY = square:getY()
	state.lastSpawnZ = square:getZ()
	log("Spawned Nemesis near " .. state.lastTargetUsername)
	return true
end

local function onEveryOneMinute()
	loadConfig()
	local state = getState()
	state.bossActive = scanLiveNemesis()

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
		return
	end

	local player = players[ZombRand(#players) + 1]
	spawnNearPlayer(player)
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
		id = "nemesis",
		outfitNames = { Config.OutfitName or "Nemesis", "MrX" },
		stats = {
			isSprinter      = true,
			isTough         = true,
			maxHits         = 10,
			bossHealth      = Config.BossHealth or 4.5,
			isSuperhuman    = true,
			hawkVision      = true,
			pinpointHearing = true,
			hasNavigation   = true,
			hasMemoryLong   = true,
			killBonus       = 50,
		},
		sounds = {
			suppressVanilla = true,
			theme    = { name = "ApocNemesis_Theme", range = 60, loop = true },
			onDetect = { name = "ApocNemesis_STARS", range = 40 },
			periodic = {
				{
					names = { "ApocNemesis_Roar1", "ApocNemesis_Roar2", "ApocNemesis_RWOAR" },
					cooldownTicks = 480,
					chance = 40,
				},
			},
			onHit = {
				{
					names = { "ApocNemesis_Grunt1", "ApocNemesis_Grunt2" },
					chance = 50,
				},
			},
		},
		behavior = {
			redirectToPlayer      = true,
			redirectCooldownTicks = 300,
			detectionRange        = 80,
		},
	})
end

Events.OnInitWorld.Add(registerNemesisModule)