IS_SPLIT_LOCK_LEVELS = string.find(Tracker.ActiveVariantUID, "split_lock_levels") ~= nil

-- Items

Tracker:AddItems("items/common.json")
Tracker:AddItems("items/bosses.json")
if IS_SPLIT_LOCK_LEVELS then
	Tracker:AddItems("items/lock_levels/split.json")
else
	Tracker:AddItems("items/lock_levels/standard.json")
end

-- Layouts

if IS_SPLIT_LOCK_LEVELS then
	Tracker:AddLayouts("layouts/split_lock_levels/tracker.json")
	Tracker:AddLayouts("layouts/split_lock_levels/broadcast.json")
else
	Tracker:AddLayouts("layouts/standard/tracker.json")
	Tracker:AddLayouts("layouts/standard/broadcast.json")
end

-- Autotracking if supported
if _VERSION == "Lua 5.3" then
    ScriptHost:LoadScript("scripts/autotracking.lua")
else
    print("Autotracking is unsupported by your EmoTracker version, please update to the latest version!")
end