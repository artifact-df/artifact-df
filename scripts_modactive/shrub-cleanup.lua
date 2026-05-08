-- Cleanup dead shrubs and saplings once a month to simulate rotting
-- author Droseran

--@enable = true
--@module = true

--[====[
Shrub Cleanup
===========

Tags: fort | gameplay | plants

Removes dead shrubs and saplings once a month.

Shrubs and saplings that die due to not growing in certain seasons
(namely winter) never naturally decay and eventually end up covering
the ground. This script removes these dead plants once a month to
simulate them rotting away.

Usage
-----
    enable shrub-cleanup
    disable shrub-cleanup
    
    shrub-cleanup status
]====]

local argparse = require 'argparse'
local repeatUtil = require 'repeat-util'
local utils = require 'utils'

local GLOBAL_KEY = 'shrub_cleanup'

local function remove_shrubs()
	dfhack.run_command('plant remove -spd')
end

local function get_default_state()
	return {
		enabled = true
	}
end

state = state or get_default_state()

function isEnabled()
	return state.enabled
end

local function do_enable()
	state.enabled = true
	dfhack.persistent.saveSiteData(GLOBAL_KEY, state)
	repeatUtil.scheduleEvery(GLOBAL_KEY, 33600, "ticks", remove_shrubs)
	print("Shrub Cleanup: Enabled")
end

-- State is not saved persistently here since this is also called by save unloading
local function do_unload()
	state.enabled = false
	repeatUtil.cancel(GLOBAL_KEY)
	print("Shrub Cleanup: Disabled")
end

local function do_disable()
	do_unload()
	dfhack.persistent.saveSiteData(GLOBAL_KEY, state)
end

dfhack.onStateChange[GLOBAL_KEY] = function(sc)
	if sc == SC_MAP_UNLOADED then
		do_unload()
		return
	end
	
	if sc ~= SC_MAP_LOADED or df.global.gamemode ~= df.game_mode.DWARF then
		return
	end
	
	-- retrieve state saved in game. merge with default state so config
	-- saved from previous versions can pick up newer defaults.
	state = get_default_state()
	utils.assign(state, dfhack.persistent.getSiteData(GLOBAL_KEY, state))
	
	if state.enabled then
		do_enable()
	end
end

local function print_status()
	print(('Shrub Cleanup is %s.'):format(state.enabled and 'enabled' or 'disabled'))
end

local args = {...}
local command = table.remove(args, 1)

if dfhack_flags.enable then
	if dfhack_flags.enable_state then
		do_enable()
	else
		do_disable()
	end
-- In case the player uses enable/disable as arguments instead of calling DFHack's enable/disable <module>
elseif command == 'enable' then
	do_enable()
elseif command == 'disable' then
	do_disable()
elseif not command or command == 'status' then
	print_status()
else
	print(dfhack.script_help())
	return
end