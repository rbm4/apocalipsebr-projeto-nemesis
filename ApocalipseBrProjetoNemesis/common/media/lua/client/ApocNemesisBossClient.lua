--[[
	ApocNemesisBossClient.lua
	Client-side Nemesis boss sound and behavior system.
	Detects Nemesis/MrX outfit zombies and plays contextual audio:
	  - STARS.ogg announcement on first detection
	  - theme.ogg looping 3D music on the zombie (natural distance fade)
	  - Periodic roars (roaring.ogg, roaring-2.ogg, RWOAR.ogg)
	  - Grunts on weapon hit (50% chance: grunting.ogg, grunting-2.ogg)
	Follows the same sound patterns used by SIMBA_TheySEEyou.
]]

if isServer() then
	return
end

-- Sound names (must match ApocNemesisSounds.txt definitions)
local SOUND_THEME = "ApocNemesis_Theme"
local SOUND_STARS = "ApocNemesis_STARS"
local SOUND_GRUNT = { "ApocNemesis_Grunt1", "ApocNemesis_Grunt2" }
local SOUND_ROAR  = { "ApocNemesis_Roar1", "ApocNemesis_Roar2", "ApocNemesis_RWOAR" }

-- Timing (in client ticks, ~60 ticks per second)
local ROAR_COOLDOWN_TICKS = 480      -- default ~8 seconds, overridden by sandbox
local ROAR_CHANCE          = 40      -- overridden by sandbox
local GRUNT_CHANCE         = 50      -- overridden by sandbox
local REDIRECT_COOLDOWN    = 300     -- default ~5 seconds, overridden by sandbox

-- Distance thresholds (in tiles)
local DETECTION_RANGE = 80  -- overridden by sandbox
local THEME_RANGE     = 60  -- overridden by sandbox
local STARS_RANGE     = 40  -- overridden by sandbox

local configLoaded = false

local function loadClientConfig()
	if configLoaded then
		return
	end
	local sv = SandboxVars.ApocalipseBrProjetoNemesis
	if not sv then
		return
	end
	DETECTION_RANGE      = sv.DetectionRange or 80
	THEME_RANGE          = sv.ThemeRange or 60
	STARS_RANGE          = sv.StarsRange or 40
	ROAR_COOLDOWN_TICKS  = (sv.RoarCooldownSeconds or 8) * 60
	ROAR_CHANCE          = sv.RoarChance or 40
	GRUNT_CHANCE         = sv.GruntChance or 50
	REDIRECT_COOLDOWN    = (sv.RedirectSeconds or 5) * 60
	configLoaded = true
end

-- State
local trackedNemesis = {}  -- [onlineID] = { themePlaying, themeInstance, lastRoarTick, starsPlayed, lastRedirectTick }
local tickCounter    = 0

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------

local function isNemesisBoss(zombie)
	if not zombie then
		return false
	end
	return zombie:getModData().ApocNemesisBoss == true
end

local function getDistSq(a, b)
	local dx = a:getX() - b:getX()
	local dy = a:getY() - b:getY()
	return dx * dx + dy * dy
end

---------------------------------------------------------------------------
-- Sound Playback
---------------------------------------------------------------------------

local function playSTARS(zombie)
	local sq = zombie and zombie:getSquare()
	if sq then
		getSoundManager():PlayWorldSound(SOUND_STARS, sq, 0, 1.0, 1.0, false)
	end
end

local function startTheme(zombie, data)
	if data.themePlaying then
		return
	end
	local emitter = zombie:getEmitter()
	if emitter then
		data.themeInstance = emitter:playSound(SOUND_THEME)
		data.themePlaying = true
	end
end

local function stopTheme(zombie, data)
	if not data.themePlaying then
		return
	end
	local emitter = zombie:getEmitter()
	if emitter and data.themeInstance then
		emitter:stopSound(data.themeInstance)
	end
	data.themePlaying = false
	data.themeInstance = nil
end

local function playRoar(zombie)
	local sq = zombie:getSquare()
	if sq then
		local sound = SOUND_ROAR[ZombRand(#SOUND_ROAR) + 1]
		getSoundManager():PlayWorldSound(sound, sq, 0, 0.7, 1.0, false)
	end
end

local function playGrunt(zombie)
	local sq = zombie:getSquare()
	if sq then
		local sound = SOUND_GRUNT[ZombRand(#SOUND_GRUNT) + 1]
		getSoundManager():PlayWorldSound(sound, sq, 0, 0.6, 1.0, false)
	end
end

---------------------------------------------------------------------------
-- OnZombieUpdate — detects Nemesis zombies each tick
-- Same hook pattern as SIMBA_TSY_Main.lua's SIMBA_TSY_OnZombieUpdate
---------------------------------------------------------------------------

local function onZombieUpdate(zombie)
	if not zombie then
		return
	end

	loadClientConfig()

	local id = zombie:getOnlineID()

	-- Dead zombie: stop theme and clean up tracking
	if zombie:isDead() then
		if trackedNemesis[id] then
			stopTheme(zombie, trackedNemesis[id])
			trackedNemesis[id] = nil
		end
		return
	end

	-- Only process actual boss zombies (server sets ApocNemesisBoss modData)
	if not isNemesisBoss(zombie) then
		return
	end

	local player = getPlayer()
	if not player or player:isDead() then
		return
	end

	local distSq = getDistSq(zombie, player)
	local detectionSq = DETECTION_RANGE * DETECTION_RANGE
	local themeSq = THEME_RANGE * THEME_RANGE

	-- Out of detection range: stop theme, drop tracking
	if distSq > detectionSq then
		if trackedNemesis[id] then
			stopTheme(zombie, trackedNemesis[id])
			trackedNemesis[id] = nil
		end
		return
	end

	-- First detection: initialize state
	if not trackedNemesis[id] then
		trackedNemesis[id] = {
			themePlaying    = false,
			themeInstance   = nil,
			lastRoarTick    = tickCounter,
			starsPlayed     = false,
			lastRedirectTick = 0,
		}
	end

	local data = trackedNemesis[id]

	-- STARS announcement: once per Nemesis encounter, when close enough
	local starsSq = STARS_RANGE * STARS_RANGE
	if not data.starsPlayed and distSq <= starsSq then
		playSTARS(zombie)
		data.starsPlayed = true
	end

	-- Theme music: looping 3D on the zombie's emitter.
	-- Because is3D=true with distanceMax=120, the theme is faint when far
	-- and crescendos as the Nemesis approaches — natural slow transition.
	if distSq <= themeSq then
		startTheme(zombie, data)
	else
		stopTheme(zombie, data)
	end

	-- Periodic roaring
	if tickCounter - data.lastRoarTick >= ROAR_COOLDOWN_TICKS then
		if ZombRand(100) < ROAR_CHANCE then
			playRoar(zombie)
		end
		data.lastRoarTick = tickCounter
	end

	-- Redirect the zombie toward the player (only the owning client can command AI)
	if zombie:isLocal() and tickCounter - data.lastRedirectTick >= REDIRECT_COOLDOWN then
		zombie:pathToLocationF(player:getX(), player:getY(), player:getZ())
		data.lastRedirectTick = tickCounter
	end
end

---------------------------------------------------------------------------
-- OnWeaponHitCharacter — grunt sounds when hitting a Nemesis
-- Same hook pattern as SIMBA_TSY's RegionManager_ZombieShared.lua
---------------------------------------------------------------------------

local function onWeaponHitCharacter(attacker, target, weapon, damage)
	local player = getPlayer()
	if not player or attacker ~= player then
		return
	end
	if not instanceof(target, "IsoZombie") or not target:isAlive() then
		return
	end
	if not isNemesisBoss(target) then
		return
	end

	if ZombRand(100) < GRUNT_CHANCE then
		playGrunt(target)
	end
end

---------------------------------------------------------------------------
-- Tick counter for cooldown tracking
---------------------------------------------------------------------------

local function onTick()
	tickCounter = tickCounter + 1
end

---------------------------------------------------------------------------
-- Register event hooks
---------------------------------------------------------------------------

Events.OnZombieUpdate.Add(onZombieUpdate)
Events.OnWeaponHitCharacter.Add(onWeaponHitCharacter)
Events.OnTick.Add(onTick)
