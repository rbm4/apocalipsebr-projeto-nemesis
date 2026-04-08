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

local configLoaded = false

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

	RegionManager.ZombieModules.register({
		id = "nemesis",
		outfitNames = { sv and sv.OutfitName or "Nemesis", "MrX" },
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
		},
	})

	print("[ApocNemesisBoss] Client module registered with regioes framework")
end

Events.OnGameBoot.Add(registerNemesisClientModule)
