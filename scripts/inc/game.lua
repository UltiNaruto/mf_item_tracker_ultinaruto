ScriptHost:LoadScript("scripts/inc/constants.lua")
ScriptHost:LoadScript("scripts/inc/memory.lua")

IS_SPLIT_LOCK_LEVELS = string.find(Tracker.ActiveVariantUID, "split_lock_levels") ~= nil

missile_bomb_status = nil
max_missiles = nil
max_powerbombs = nil
beams_status = nil
suit_status = nil
max_etanks = nil
bosses_status = nil
lock_level = nil

-- Get the game identifier (aka the first 3 letters)
function getGameIdentifier()
	return read_string("ROM", OFF_ROM_GAMEIDENTIFIER, 3)
end

-- Get the game region (aka the fourth letter)
function getGameRegion()
	return read_char("ROM", OFF_ROM_GAMEIDENTIFIER + 3)
end

-- Get In Game Time as int32
function getIGT()
	return read_u8(OFF_IRAM_PLAYTIME_H) * H + read_u8(OFF_IRAM_PLAYTIME_M) * M + read_u8(OFF_IRAM_PLAYTIME_S) * S + (read_u8(OFF_IRAM_PLAYTIME_CS) * S) / 63
end

-- Is ingame
function isInGame()
	if getGameIdentifier() ~= "AMT" then
		return false
	end
	if getIGT() <= 16 then
		return false
	end
	GameMode = read_u16("IRAM", OFF_IRAM_GAME_MODE)
	return GameMode == 1 or GameMode == 3 or GameMode == 4 or GameMode == 5
end

function updateMissileBallStatus()
	local missileBallStatus = read_u8("IRAM", OFF_IRAM_MISSILES_BALL_STATUS)
	if isInGame() then
		-- Missile Launcher
		Tracker:FindObjectForCode("datam").Active = missileBallStatus & 1 == 1
		Tracker:FindObjectForCode("missile_icon").Active = missileBallStatus & 1 == 1
		Tracker:FindObjectForCode("missile").AcquiredCount = read_u16("IRAM", OFF_IRAM_MAX_MISSILES)
		-- Super Missile
		Tracker:FindObjectForCode("super_missile").Active = missileBallStatus & 2 == 2
		-- Ice Missile
		Tracker:FindObjectForCode("ice_missile").Active = missileBallStatus & 4 == 4
		-- Diffusion Missile
		Tracker:FindObjectForCode("diffusion_missile").Active = missileBallStatus & 8 == 8
		-- Morph Ball Bombs
		Tracker:FindObjectForCode("morph_ball_bombs").Active = missileBallStatus & 16 == 16
		-- Power Bombs
		Tracker:FindObjectForCode("datapb").Active = missileBallStatus & 32 == 32
		Tracker:FindObjectForCode("pb_icon").Active = missileBallStatus & 32 == 32
		Tracker:FindObjectForCode("powerbomb").AcquiredCount = read_u8("IRAM", OFF_IRAM_MAX_POWERBOMBS)
	else
		-- Missile Launcher
		Tracker:FindObjectForCode("datam").Active = false
		Tracker:FindObjectForCode("missile_icon").Active = false
		Tracker:FindObjectForCode("missile").AcquiredCount = 0
		-- Super Missile
		Tracker:FindObjectForCode("super_missile").Active = false
		-- Ice Missile
		Tracker:FindObjectForCode("ice_missile").Active = false
		-- Diffusion Missile
		Tracker:FindObjectForCode("diffusion_missile").Active = false
		-- Morph Ball Bombs
		Tracker:FindObjectForCode("morph_ball_bombs").Active = false
		-- Power Bombs
		Tracker:FindObjectForCode("datapb").Active = false
		Tracker:FindObjectForCode("pb_icon").Active = false
		Tracker:FindObjectForCode("powerbomb").AcquiredCount = 0
	end
end

-- Get amount of energy tanks
function updateEtanks()
	local maxEtanks = (read_u16("IRAM", OFF_IRAM_MAX_HEALTH) - 99) / 100
	if isInGame() then
		Tracker:FindObjectForCode("etank").AcquiredCount = maxEtanks
		Tracker:FindObjectForCode("etank_icon").Active = maxEtanks > 0
	else
		Tracker:FindObjectForCode("etank").AcquiredCount = 0
		Tracker:FindObjectForCode("etank_icon").Active = false
	end
end

-- Get beam status
function updateBeamStatus()
	local beamStatus = read_u8("IRAM", OFF_IRAM_BEAMS_STATUS)
	if isInGame() then
		Tracker:FindObjectForCode("charge_beam").Active = beamStatus & 1 == 1
		Tracker:FindObjectForCode("wide_beam").Active = beamStatus & 2 == 2
		Tracker:FindObjectForCode("plasma_beam").Active = beamStatus & 4 == 4
		Tracker:FindObjectForCode("wave_beam").Active = beamStatus & 8 == 8
		Tracker:FindObjectForCode("ice_beam").Active = beamStatus & 16 == 16
	else
		Tracker:FindObjectForCode("charge_beam").Active = false
		Tracker:FindObjectForCode("wide_beam").Active = false
		Tracker:FindObjectForCode("plasma_beam").Active = false
		Tracker:FindObjectForCode("wave_beam").Active = false
		Tracker:FindObjectForCode("ice_beam").Active = false
	end
end

-- Get suit status
function updateSuitStatus()
	local suitStatus = read_u8("IRAM", OFF_IRAM_SUIT_STATUS)
	if isInGame() then
		Tracker:FindObjectForCode("hijump_boots").Active = suitStatus & 1 == 1
		Tracker:FindObjectForCode("speed_booster").Active = suitStatus & 2 == 2
		Tracker:FindObjectForCode("space_jump").Active = suitStatus & 4 == 4
		Tracker:FindObjectForCode("screw_attack").Active = suitStatus & 8 == 8
		Tracker:FindObjectForCode("varia_suit").Active = suitStatus & 16 == 16
		Tracker:FindObjectForCode("gravity_suit").Active = suitStatus & 32 == 32
		Tracker:FindObjectForCode("morph_ball").Active = suitStatus & 64 == 64
	else
		Tracker:FindObjectForCode("hijump_boots").Active = false
		Tracker:FindObjectForCode("speed_booster").Active = false
		Tracker:FindObjectForCode("space_jump").Active = false
		Tracker:FindObjectForCode("screw_attack").Active = false
		Tracker:FindObjectForCode("varia_suit").Active = false
		Tracker:FindObjectForCode("gravity_suit").Active = false
		Tracker:FindObjectForCode("morph_ball").Active = false
	end
end

-- Get boss status
function updateBossStatus()
	local bossStatus = read_u16("IRAM", OFF_IRAM_BOSS_STATUS)
	if isInGame() then
		Tracker:FindObjectForCode("arachnus").Active = bossStatus & 1 == 1
		Tracker:FindObjectForCode("torizo").Active = bossStatus & 2 == 2
		Tracker:FindObjectForCode("science").Active = bossStatus & 4 == 4
		Tracker:FindObjectForCode("nettori").Active = bossStatus & 8 == 8
		Tracker:FindObjectForCode("box2").Active = bossStatus & 16 == 16
		Tracker:FindObjectForCode("zazabi").Active = bossStatus & 32 == 32
		Tracker:FindObjectForCode("serris").Active = bossStatus & 64 == 64
		Tracker:FindObjectForCode("chungus").Active = bossStatus & 128 == 128
		Tracker:FindObjectForCode("yakuza").Active = bossStatus & 256 == 256
		Tracker:FindObjectForCode("nightmare").Active = bossStatus & 512 == 512
		Tracker:FindObjectForCode("ridley").Active = bossStatus & 1024 == 1024
		--Tracker:FindObjectForCode("box1").Active = bossStatus & 2048 == 2048
	else
		Tracker:FindObjectForCode("arachnus").Active = false
		Tracker:FindObjectForCode("torizo").Active = false
		Tracker:FindObjectForCode("science").Active = false
		Tracker:FindObjectForCode("nettori").Active = false
		Tracker:FindObjectForCode("box2").Active = false
		Tracker:FindObjectForCode("zazabi").Active = false
		Tracker:FindObjectForCode("serris").Active = false
		Tracker:FindObjectForCode("chungus").Active = false
		Tracker:FindObjectForCode("yakuza").Active = false
		Tracker:FindObjectForCode("nightmare").Active = false
		Tracker:FindObjectForCode("ridley").Active = false
		--Tracker:FindObjectForCode("box1").Active = false
	end
end

-- Get lock level
function updateLockLevel()
	local lockLevel = read_u8("IRAM", OFF_IRAM_LOCK_LEVEL)
	if IS_SPLIT_LOCK_LEVELS then
		if isInGame() then
			Tracker:FindObjectForCode("l1").Active = lockLevel & 2 == 2
			Tracker:FindObjectForCode("l2").Active = lockLevel & 4 == 4
			Tracker:FindObjectForCode("l3").Active = lockLevel & 8 == 8
			Tracker:FindObjectForCode("l4").Active = lockLevel & 16 == 16
		else
			Tracker:FindObjectForCode("l1").Active = false
			Tracker:FindObjectForCode("l2").Active = false
			Tracker:FindObjectForCode("l3").Active = false
			Tracker:FindObjectForCode("l4").Active = false
		end
	else
		-- To prevent lock level to be -1
		if lockLevel < 0 then
			lockLevel = 0
		end
		if isInGame() then
			Tracker:FindObjectForCode("lock_level").CurrentStage = lockLevel
		else
			Tracker:FindObjectForCode("lock_level").CurrentStage = 0
		end
	end
end

-- Initialize memory watches
function initMemoryWatches()
	missile_bomb_status = ScriptHost:AddMemoryWatch("Missile/Bomb status", get_address("IRAM", OFF_IRAM_MISSILES_BALL_STATUS), 1, updateMissileBallStatus, 60)
	max_missiles = ScriptHost:AddMemoryWatch("Max Missiles", get_address("IRAM", OFF_IRAM_MAX_MISSILES), 2, updateMissileBallStatus, 60)
	max_powerbombs = ScriptHost:AddMemoryWatch("Max Power Bombs", get_address("IRAM", OFF_IRAM_MAX_POWERBOMBS), 1, updateMissileBallStatus, 60)
	max_etanks = ScriptHost:AddMemoryWatch("Max Etanks", get_address("IRAM", OFF_IRAM_MAX_HEALTH), 2, updateEtanks, 60)
	beam_status = ScriptHost:AddMemoryWatch("Beam status", get_address("IRAM", OFF_IRAM_BEAMS_STATUS), 1, updateBeamStatus, 60)
	suit_status = ScriptHost:AddMemoryWatch("Suit status", get_address("IRAM", OFF_IRAM_SUIT_STATUS), 1, updateSuitStatus, 60)
	bosses_status = ScriptHost:AddMemoryWatch("Boss status", get_address("IRAM", OFF_IRAM_BOSS_STATUS), 2, updateBossStatus, 60)
	lock_level = ScriptHost:AddMemoryWatch("Lock level", get_address("IRAM", OFF_IRAM_LOCK_LEVEL), 1, updateLockLevel, 60)
end

-- Clear memory watches
function clearMemoryWatches()
	ScriptHost:RemoveMemoryWatch(lock_level)
	ScriptHost:RemoveMemoryWatch(bosses_status)
	ScriptHost:RemoveMemoryWatch(suit_status)
	ScriptHost:RemoveMemoryWatch(beam_status)
	ScriptHost:RemoveMemoryWatch(max_etanks)
	ScriptHost:RemoveMemoryWatch(max_powerbombs)
	ScriptHost:RemoveMemoryWatch(max_missiles)
	ScriptHost:RemoveMemoryWatch(missile_bomb_status)
end