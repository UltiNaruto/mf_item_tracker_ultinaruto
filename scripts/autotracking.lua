lock_level_icons = {}
default_tracker_height = 0
default_broadcast_tracker_height = 0

-- Invoked when the auto-tracker is activated/connected
function autotracker_started()
	initMemoryWatches()
end

--Invoked when the auto-tracker is stopped.
function autotracker_stopped()
	clearMemoryWatches()
end

function updateLockLevelIcons()
	if next(lock_level_icons) == nil then
		table.insert(lock_level_icons, {
			Tracker:FindObjectForCode("lock_level").Stages[1].Icon,
			Tracker:FindObjectForCode("lock_level").Stages[2].Icon,
			Tracker:FindObjectForCode("lock_level").Stages[3].Icon,
			Tracker:FindObjectForCode("lock_level").Stages[4].Icon
		})
		table.insert(lock_level_icons, {
			Tracker:FindObjectForCode("l1").Icon,
			Tracker:FindObjectForCode("l1").ActiveIcon
		})
		table.insert(lock_level_icons, {
			Tracker:FindObjectForCode("l2").Icon,
			Tracker:FindObjectForCode("l2").ActiveIcon
		})
		table.insert(lock_level_icons, {
			Tracker:FindObjectForCode("l3").Icon,
			Tracker:FindObjectForCode("l3").ActiveIcon
		})
		table.insert(lock_level_icons, {
			Tracker:FindObjectForCode("l4").Icon,
			Tracker:FindObjectForCode("l4").ActiveIcon
		})
		default_tracker_height = Layout:FindLayout("tracker_default").Root.Height
		default_broadcast_tracker_height = Layout:FindLayout("tracker_broadcast").Root.Height
	end
	if Tracker:FindObjectForCode("setting_split_security").CurrentStage == 1 then
		Tracker:FindObjectForCode("lock_level").Icon = nil
		Tracker:FindObjectForCode("lock_level").DisabledImageFilterSpec = nil
		Tracker:FindObjectForCode("lock_level").IgnoreUserInput = true
		Tracker:FindObjectForCode("l1").Icon = lock_level_icons[2][1]
		Tracker:FindObjectForCode("l1").ActiveIcon = lock_level_icons[2][2]
		Tracker:FindObjectForCode("l1").IgnoreUserInput = false
		Tracker:FindObjectForCode("l2").Icon = lock_level_icons[3][1]
		Tracker:FindObjectForCode("l2").ActiveIcon = lock_level_icons[3][2]
		Tracker:FindObjectForCode("l2").IgnoreUserInput = false
		Tracker:FindObjectForCode("l3").Icon = lock_level_icons[4][1]
		Tracker:FindObjectForCode("l3").ActiveIcon = lock_level_icons[4][2]
		Tracker:FindObjectForCode("l3").IgnoreUserInput = false
		Tracker:FindObjectForCode("l4").Icon = lock_level_icons[5][1]
		Tracker:FindObjectForCode("l4").ActiveIcon = lock_level_icons[5][2]
		Tracker:FindObjectForCode("l4").IgnoreUserInput = false
		Layout:FindLayout("tracker_default").Root.Height = default_tracker_height
		Layout:FindLayout("tracker_broadcast").Root.Height = default_broadcast_tracker_height
	else
		if Tracker:FindObjectForCode("lock_level").Icon == nil then
			Tracker:FindObjectForCode("lock_level").CurrentStage = 1
			Tracker:FindObjectForCode("lock_level").CurrentStage = 0
		end
		Tracker:FindObjectForCode("lock_level").IgnoreUserInput = false
		Tracker:FindObjectForCode("l1").Icon = nil
		Tracker:FindObjectForCode("l1").IgnoreUserInput = true
		Tracker:FindObjectForCode("l2").Icon = nil
		Tracker:FindObjectForCode("l2").IgnoreUserInput = true
		Tracker:FindObjectForCode("l3").Icon = nil
		Tracker:FindObjectForCode("l3").IgnoreUserInput = true
		Tracker:FindObjectForCode("l4").Icon = nil
		Tracker:FindObjectForCode("l4").IgnoreUserInput = true
		Layout:FindLayout("tracker_default").Root.Height = default_tracker_height - 50
		Layout:FindLayout("tracker_broadcast").Root.Height = default_broadcast_tracker_height - 65
	end
end

--Invoked when clicking on the settings
function tracker_on_accessibility_updated()
    updateLockLevelIcons()
end

-- This is kind of hacky, but the tracker needs at least one memory watch set up in order to detect that the package
-- uses auto-tracking.  The only one that is active all the time is the "Which Game Is It Anyways" watch, but until we
-- get proper native addressing we can't initialize it until we know what connector is selected.
-- This is a dummy entry that will do nothing, the actual watches will be set when it starts above.
-- Set this watch interval to 60 seconds so it fires infrequently.
function noop()
    return true
end

ScriptHost:AddMemoryWatch("Let EmoTracker know we're here :)", 0x03000000, 0x02, noop, 60 * 1000)