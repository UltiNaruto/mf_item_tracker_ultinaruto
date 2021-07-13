ScriptHost:LoadScript("scripts/inc/game.lua")

-- Invoked when the auto-tracker is activated/connected
function autotracker_started()
	initMemoryWatches()
end

--Invoked when the auto-tracker is stopped.
function autotracker_stopped()
	clearMemoryWatches()
end

-- This is kind of hacky, but the tracker needs at least one memory watch set up in order to detect that the package
-- uses auto-tracking.  The only one that is active all the time is the "Which Game Is It Anyways" watch, but until we
-- get proper native addressing we can't initialize it until we know what connector is selected.
-- This is a dummy entry that will do nothing, the actual watches will be set when it starts above.
-- Set this watch interval to 60 seconds so it fires infrequently.
function noop()
    return true
end

ScriptHost:AddMemoryWatch("Let EmoTracker know we're here :)", 0x7e0000, 0x01, noop, 60 * 1000)