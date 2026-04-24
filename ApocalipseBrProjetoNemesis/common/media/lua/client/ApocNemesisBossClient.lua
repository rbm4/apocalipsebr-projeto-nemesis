--[[
	ApocNemesisBossClient.lua
	Client-side registration for the Nemesis boss zombie module.

	All sound playback, AI redirect, and vanilla sound suppression are now
	handled by the regioes framework (RegionManager_ZombieModuleClient.lua).
	This file only registers the Nemesis module definition so the framework
	knows how to handle Nemesis-outfit zombies on the client.

	Sound assets (ApocNemesisSounds.txt, .ogg files) still live in this mod.
]]

if isServer() then
	return
end

require "RegionManager_ZombieModules"
require "RegionManager_ZombieShared"
require "RegionManager_ZombieModuleClient"
require "RegionManager_Config"

local sandboxOptions = getSandboxOptions()

local configLoaded = false

--- Split a string by a separator and return a table of trimmed tokens.
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

-- Cached Nemesis/MrX outfit lookup. Populated at module registration and
-- refreshed whenever sandbox options change, so hot paths (per-hit failsafe,
-- clothing updated, etc.) don't re-tokenize the sandbox string each call.
---@type table<string, boolean>
local cachedOutfitSet = {}
local cachedOutfitSetReady = false
local function rebuildOutfitSet()
	local sv = SandboxVars.ApocalipseBrProjetoNemesis
	local names = splitCSV(sv and sv.OutfitName or "Nemesis")
	if #names == 0 then
		names = { "Nemesis" }
	end
	local set = {}
	for _, n in ipairs(names) do
		set[n] = true
	end
	cachedOutfitSet = set
	cachedOutfitSetReady = true
	return names
end
Events.OnGameBoot.Add(rebuildOutfitSet)
-- SandboxOptions can be mutated live by admin tools; keep the cache fresh.
if Events.OnSandboxOptionsChanged then
	Events.OnSandboxOptionsChanged.Add(rebuildOutfitSet)
end

local function registerNemesisClientModule()
	if configLoaded then return end
	configLoaded = true

	-- Read sandbox overrides for tunable values
	local sv = SandboxVars.ApocalipseBrProjetoNemesis
	local detectionRange     = 80
	local themeRange         = 60
	local starsRange         = 40
	local roarCooldownTicks  = 480
	local roarChance         = 40
	local gruntChance        = 50
	local redirectCooldown   = 300

	if sv then
		detectionRange     = sv.DetectionRange or 80
		themeRange         = sv.ThemeRange or 60
		starsRange         = sv.StarsRange or 40
		roarCooldownTicks  = (sv.RoarCooldownSeconds or 8) * 60
		roarChance         = sv.RoarChance or 40
		gruntChance        = sv.GruntChance or 50
		redirectCooldown   = (sv.RedirectSeconds or 5) * 60
	end

	local outfitNames = splitCSV(sv and sv.OutfitName or "Nemesis")
	if #outfitNames == 0 then
		outfitNames = { "Nemesis" }
	end
	-- Keep the shared cached lookup in sync with what the module is using.
	local set = {}
	for _, n in ipairs(outfitNames) do
		set[n] = true
	end
	cachedOutfitSet = set
	cachedOutfitSetReady = true

	RegionManager.ZombieModules.register({
		id = "nemesis",
		outfitNames = outfitNames,
		stats = {}, -- stats are applied server-side; this is for client lookup only
		sounds = {
			suppressVanilla = true,
			theme    = { name = "ApocNemesis_Theme", range = themeRange, loop = true },
			onDetect = { name = "ApocNemesis_STARS", range = starsRange },
			periodic = {
				{
					names = { "ApocNemesis_Roar1", "ApocNemesis_Roar2", "ApocNemesis_RWOAR" },
					cooldownTicks = roarCooldownTicks,
					chance = roarChance,
				},
			},
			onHit = {
				{
					names = { "ApocNemesis_Grunt1", "ApocNemesis_Grunt2" },
					chance = gruntChance,
				},
			},
		},
		behavior = {
			redirectToPlayer      = true,
			redirectCooldownTicks = redirectCooldown,
			detectionRange        = detectionRange,
			smashObstacles        = true,
			smashCooldownTicks    = 60,
			smashDamage           = 40,
		},
	})

	print("[ApocNemesisBoss] Client module registered with regioes framework")
end

Events.OnGameBoot.Add(registerNemesisClientModule)

-- ============================================================================
-- NemesisConvert handler: receives the custom command from the server when a
-- zombie is converted to Nemesis.  Dresses the zombie in the outfit locally
-- (since server-side dressInNamedOutfit doesn't sync to clients), then applies
-- all module properties exactly like the ConfirmZombie pipeline would.
-- ============================================================================

--- Decode the compact bit-encoded payload (same as RegionManager_ZombieClient).
local function decodeConfirmPayload(args)
	local r = args.r
	local bits    = tonumber(string.sub(r, 1, 9))   or 0
	local xSign   = tonumber(string.sub(r, 10, 10)) or 1
	local xAbs    = tonumber(string.sub(r, 11, 15)) or 0
	local ySign   = tonumber(string.sub(r, 16, 16)) or 1
	local yAbs    = tonumber(string.sub(r, 17, 21)) or 0
	local maxHits = tonumber(string.sub(r, 22, 23)) or RegionManager.Shared.DEFAULT_MAX_HITS

	local x = xSign == 1 and xAbs or -xAbs
	local y = ySign == 1 and yAbs or -yAbs

	local function hasBit(pos)
		return math.floor(bits / (2 ^ pos)) % 2 == 1
	end

	return {
		zombieID           = args.z,
		isSprinter         = hasBit(0),
		isShambler         = hasBit(1),
		hawkVision         = hasBit(2),
		badVision          = hasBit(3),
		normalVision       = hasBit(4),
		poorVision         = hasBit(5),
		randomVision       = hasBit(6),
		goodHearing        = hasBit(7),
		badHearing         = hasBit(8),
		pinpointHearing    = hasBit(9),
		normalHearing      = hasBit(10),
		poorHearing        = hasBit(11),
		randomHearing      = hasBit(12),
		isResistant        = hasBit(13),
		isTough            = hasBit(14),
		isNormalToughness  = hasBit(15),
		isFragile          = hasBit(16),
		isRandomToughness  = hasBit(17),
		isSuperhuman       = hasBit(18),
		isNormalToughness2 = hasBit(19),
		isWeak             = hasBit(20),
		isRandomToughness2 = hasBit(21),
		hasNavigation      = hasBit(22),
		hasMemoryLong      = hasBit(23),
		hasMemoryNormal    = hasBit(24),
		hasMemoryShort     = hasBit(25),
		hasMemoryNone      = hasBit(26),
		hasMemoryRandom    = hasBit(27),
		x       = x,
		y       = y,
		maxHits = maxHits,
	}
end

local function onNemesisConvertCommand(module, command, args)
	if module ~= "ApocNemesisBoss" or command ~= "NemesisConvert" then
		return
	end

	local player = getPlayer()
	if not player then return end

	local cell = player:getCell()
	if not cell then return end

	local data = decodeConfirmPayload(args)
	local zombieID = data.zombieID
	local outfitName = args.outfit

	local zombieList = cell:getZombieList()
	if not zombieList then return end

	for i = 0, zombieList:size() - 1 do
		local zombie = zombieList:get(i)
		if zombie and not zombie:isDead() and zombie:getOnlineID() == zombieID then
			-- Pass module ID into data for kill bonus
			data.moduleId = args.m or "nemesis"

			-- Apply all server-determined properties (speed, toughness, vision, etc.)
			-- This MUST run FIRST because makeInactive(true/false) inside it
			-- resets the zombie's outfit and model to random defaults.
			RegionManager.Shared.ServerSideProperties(zombie, data, sandboxOptions)

			-- Re-fetch modData after ServerSideProperties (the makeInactive cycle
			-- inside it invalidates earlier references).
			local modData = zombie:getModData()

			-- Dress the zombie AFTER the makeInactive cycle so the outfit
			-- survives. We use resetModelNextFrame() rather than resetModel()
			-- so the mesh rebuild is deferred off the conversion frame --
			-- makeInactive already forces one rebuild, and stacking a second
			-- synchronous resetModel() here was a measurable stutter source.
			if outfitName then
				zombie:dressInNamedOutfit(outfitName)
				zombie:resetModelNextFrame()
			end

			-- Cache the raw payload for speed revalidation
			modData.Apocalipse_TSY_CachedPayload = args.r
			modData.Apocalipse_TSY_CachedMaxHits = data.maxHits
			modData.Apocalipse_TSY_IsModuleZombie = true
			modData.Apocalipse_TSY_ForceModuleId = "nemesis"

			-- Stamp the server-assigned PID so GetReliablePID returns a stable
			-- value that matches globalData.zombies on the server, regardless
			-- of any getPersistentOutfitID() drift from ZombiePacket sync.
			if args.pid then
				modData.Apocalipse_TSY_AssignedPID = args.pid
			end

			-- Re-apply toughness on the fresh modData reference.
			-- ServerSideProperties wrote these but makeInactive may have
			-- invalidated the modData table it used.
			if data.isTough then
				local maxHits = data.maxHits or RegionManager.Shared.DEFAULT_MAX_HITS
				modData.Apocalipse_TSY_ToughnessType = "tough"
				modData.Apocalipse_TSY_ToughnessHitCounter = 0
				modData.Apocalipse_TSY_ToughnessMaxHits = maxHits
			end

			-- Build convergence opts so the framework self-heals on every tick
			local maxHits = data.maxHits or RegionManager.Shared.DEFAULT_MAX_HITS

			local initOpts = {
				expectedOutfit = outfitName,
				expectedToughness = {
					type    = "tough",
					maxHits = maxHits,
				},
			}

			-- Initialize client-side module tracking (sounds, redirect, convergence)
			RegionManager.ZombieModuleClient.initZombie(zombie, "nemesis", initOpts)

			print("[ApocNemesisBoss] Client: converted zombie " .. tostring(zombieID) ..
				  " to Nemesis (outfit=" .. tostring(outfitName) ..
				  ", getOutfitName=" .. tostring(zombie:getOutfitName()) ..
				  ", tough=" .. tostring(modData.Apocalipse_TSY_ToughnessType) ..
				  ", maxHits=" .. tostring(modData.Apocalipse_TSY_ToughnessMaxHits) .. ")")
			break
		end
	end
end

Events.OnServerCommand.Add(onNemesisConvertCommand)

-- ============================================================================
-- Prevent players from equipping Nemesis / MrX boss suits.
-- The items still drop from zombie corpses and can be looted, but players
-- cannot wear them.  Three interception layers guarantee no bypass path:
--   1. Context-menu: "Wear" option is never shown.
--   2. Timed-action: ISWearClothing:isValid() rejects the item (drag-drop).
--   3. OnClothingUpdated: force-strip if somehow equipped anyway.
-- ============================================================================

local BLOCKED_FULLTYPES = {
	["ApocNemesisBoss.NemesisSuit"] = true,
	["ApocNemesisBoss.MrXSuit"]    = true,
}

local function isBossClothing(item)
	return item and BLOCKED_FULLTYPES[item:getFullType()] == true
end

-- Layer 1: Remove "Wear" option from inventory right-click menu ---------------
require "ISUI/ISInventoryPaneContextMenu"

local _origDoWearClothingMenu = ISInventoryPaneContextMenu.doWearClothingMenu

function ISInventoryPaneContextMenu.doWearClothingMenu(player, clothing, items, context)
	if isBossClothing(clothing) then
		return
	end
	return _origDoWearClothingMenu(player, clothing, items, context)
end

-- Layer 2: Block the timed wear action (catches drag-and-drop) ----------------
require "TimedActions/ISWearClothing"

local _origIsValid = ISWearClothing.isValid

function ISWearClothing:isValid()
	if isBossClothing(self.item) then
		return false
	end
	return _origIsValid(self)
end

-- Layer 3: Safety net – force-strip on clothing update event ------------------
local function onClothingUpdated(character)
	-- if not character or not instanceof(character, "IsoPlayer") then
	-- 	return
	-- end
	-- local wornItems = character:getWornItems()
	-- if not wornItems then return end
	-- for i = wornItems:size() - 1, 0, -1 do
	-- 	local wornItem = wornItems:getItemByIndex(i)
	-- 	if wornItem and isBossClothing(wornItem) then
	-- 		local bodyLocation = wornItems:getItem(i)
	-- 		character:setWornItem(bodyLocation:getLocation(), nil)
	-- 	end
	-- end
end

Events.OnClothingUpdated.Add(onClothingUpdated)
-- ============================================================================
-- Failsafe: scrub leaked Nemesis toughness from non-Nemesis zombies.
--
-- A small number of normal zombies have been reported getting stuck in the
-- toughness damage-immunity state (ToughnessType="tough" + avoidDamage=true)
-- despite not wearing a Nemesis/MrX outfit nor being tagged as the nemesis
-- module.  Suspected leak paths:
--   * onlineID drift / late-join NemesisConvert replay stamping the wrong
--     local zombie with the Nemesis toughness bits.
--   * Per-tick module convergence (RegionManager_ZombieModuleClient) keeping
--     a stale entry keyed by a reused reliable PID and re-applying "tough".
--   * Optimistic client-side setAvoidDamage(true) in the regioes OnHit handler
--     outliving the tough state when the authoritative ApplyToughZombieHit
--     broadcast fails to locate the target (moved out of cell, PID mismatch).
--
-- This guard runs on every player OnWeaponHitCharacter AFTER the regioes
-- toughness handler.  If the target has Nemesis-signature toughness modData
-- (ToughnessType=="tough" AND ToughnessMaxHits == BossMaxHits) but is NOT
-- actually a Nemesis (outfit doesn't match AND ForceModuleId ~= "nemesis"),
-- we scrub the tough flags and release avoidDamage so the hit lands.
--
-- It deliberately does NOT touch toughness whose maxHits differs from the
-- Nemesis BossMaxHits, so generic region-zombie toughness (the regioes
-- extra-hits system) remains untouched.
-- ============================================================================

local function isNemesisOutfit(outfit)
	if not outfit then return false end
	if type(cachedOutfitSet) ~= "table" then
		cachedOutfitSet = {}
		cachedOutfitSetReady = false
	end
	-- Fast path: module-level cache populated at boot and on sandbox change.
	if cachedOutfitSet[outfit] then return true end
	-- Cold path / cache miss: rebuild once then recheck. Handles the edge case
	-- where this helper runs before OnGameBoot fires during very early events.
	if not cachedOutfitSetReady then
		local sv = SandboxVars and SandboxVars.ApocalipseBrProjetoNemesis
		local names = splitCSV(sv and sv.OutfitName or "Nemesis")
		if #names == 0 then
			names = { "Nemesis" }
		end
		local set = {}
		for _, n in ipairs(names) do
			set[n] = true
		end
		cachedOutfitSet = set
		cachedOutfitSetReady = true
		if cachedOutfitSet[outfit] then return true end
	end
	return false
end

local function scrubLeakedNemesisToughness(zombie)
	if not zombie or zombie:isDead() then return false end

	local modData = zombie:getModData()
	if modData.Apocalipse_TSY_ToughnessType ~= "tough" then
		return false
	end

	-- Only act on toughness matching the Nemesis signature (BossMaxHits).
	-- Leave generic region toughness alone.
	local sv = SandboxVars.ApocalipseBrProjetoNemesis
	local bossMaxHits = (sv and sv.BossMaxHits) or 10
	local zMaxHits = tonumber(modData.Apocalipse_TSY_ToughnessMaxHits) or -1
	if zMaxHits ~= bossMaxHits then
		return false
	end

	-- Legit Nemesis: let the regioes toughness + convergence pipeline own it.
	if modData.Apocalipse_TSY_ForceModuleId == "nemesis" then
		return false
	end
	local outfitName = nil
	if zombie.getOutfitName then
		outfitName = zombie:getOutfitName()
	end
	if isNemesisOutfit(outfitName) then
		return false
	end

	-- Leak confirmed: wipe Nemesis toughness state and release damage immunity.
	modData.Apocalipse_TSY_ToughnessType        = nil
	modData.Apocalipse_TSY_ToughnessHitCounter  = nil
	modData.Apocalipse_TSY_ToughnessMaxHits     = nil
	modData.Apocalipse_TSY_IsModuleZombie       = nil
	modData.Apocalipse_TSY_ForceModuleId        = nil
	modData.Apocalipse_TSY_CachedMaxHits        = nil
	zombie:setAvoidDamage(false)

	print("[ApocNemesisBoss] Failsafe: scrubbed leaked Nemesis toughness from " ..
		  "zombie onlineID=" .. tostring(zombie:getOnlineID()) ..
		  " outfit=" .. tostring(outfitName))
	return true
end

local function onHitNemesisToughnessFailsafe(attacker, target, weapon, damage)
	local player = getPlayer()
	if not player or attacker ~= player then return end
	if not instanceof(target, "IsoZombie") then return end
	scrubLeakedNemesisToughness(target)
end

Events.OnWeaponHitCharacter.Add(onHitNemesisToughnessFailsafe)