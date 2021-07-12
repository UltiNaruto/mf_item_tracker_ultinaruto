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
else
	Tracker:AddLayouts("layouts/standard/tracker.json")
end

Tracker:AddLayouts("layouts/broadcast.json")