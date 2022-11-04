-- Items

Tracker:AddItems("items/common.json")
Tracker:AddItems("items/options.json")
Tracker:AddItems("items/bosses.json")
Tracker:AddItems("items/lock_levels.json")

-- Layouts

Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")

-- Autotracking if supported
if _VERSION == "Lua 5.3" then
    ScriptHost:LoadScript("scripts/inc/constants.lua")
    ScriptHost:LoadScript("scripts/inc/memory.lua")
	ScriptHost:LoadScript("scripts/inc/game.lua")
    ScriptHost:LoadScript("scripts/autotracking.lua")
	updateLockLevelIcons()
else
    print("Autotracking is unsupported by your EmoTracker version, please update to the latest version!")
end