-- Cleanup dead shrubs and saplings once a month to simulate rotting
-- author Droseran

--@module = true

local repeatUtil = require 'repeat-util'

local GLOBAL_KEY = 'shrub_cleanup'

local function remove_shrubs()
	dfhack.run_command('plant remove -spd')
end

function do_enable()
	repeatUtil.scheduleEvery(GLOBAL_KEY, 33600, "ticks", remove_shrubs)
	print("Enabled Shrub Cleanup.")
end

function do_unload()
	repeatUtil.cancel(GLOBAL_KEY)
	print("Disabled Shrub Cleanup.")
end

function print_help()
	print("Shrub Cleanup:\n\nThis module removes dead plants once a month to simulate them rotting away. Otherwise, shrubs and saplings that die due to not growing in certain seasons (namely winter) never naturally decay and eventually end up covering the ground.")
end