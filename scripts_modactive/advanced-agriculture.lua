-- Management system for Advanced Agriculture modules
-- author Droseran

--@module = true

--[====[
Advanced Agriculture
===========

Tags: fort | gameplay | jobs | plants

Controls the Advanced Agriculture modules.

If a module is not specified after status, then the
state of every module will be displayed.

Note that seedcaps is globally enabled or disabled as it
affects game settings. All other modules will have
per-world settings.

Available commands:
    enable <module>
    disable <module>
    help <module (optional)>
    status <module (optional)>

Available modules:
    byproducts: Creates byproducts from jobs
    harvesting: Provides growths on farm plot harvest
    seedcaps: Changes game seed caps to sane values
    seedsfromcooking: Cooking creates seeds
    shrubcleanup: Removes dead shrubs seasonally

Usage
-----
    advanced-agriculture status
    advanced-agriculture enable seedcaps
    advanced-agriculture disable harvesting
]====]

local GLOBAL_KEY = 'advanced_agriculture'

local argparse = require('argparse')
local utils = require 'utils'

-- Table of modules
local modules = {
	['byproducts'] = reqscript('internal/byproduct-system'),
	['harvesting'] = reqscript('internal/advanced-harvesting'),
	['planting'] = reqscript('internal/advanced-planting'),
	['seedcaps'] = reqscript('internal/seed-caps'),
	['seedsfromcooking'] = reqscript('internal/seeds-from-cooking'),
	['shrubcleanup'] = reqscript('internal/shrub-cleanup'),
}

-- Modules with player controlled states
-- Modules without a state are required and will always load
local function get_default_state()
	return {
		['byproducts'] = {
			enabled = true, -- All modules enabled by default
		},
		['harvesting'] = {
			enabled = true,
		},
		['seedcaps'] = {
			enabled = true,
		},
		['seedsfromcooking'] = {
			enabled = true,
		},
		['shrubcleanup'] = {
			enabled = true,
		},
	}
end

state = state or get_default_state()

-- Loads all required modules and all enabled modules on startup
local function load_all()
	for k, v in pairs(modules) do
		if not state[k] then
			v.do_enable()
		elseif state[k].enabled then
			v.do_enable()
		end
	end
end

-- Unload all enabled modules (unloading a world)
local function unload_all()
	for k, v in pairs(modules) do
		if not state[k] then
			v.do_unload()
		elseif state[k].enabled then
			v.do_unload()
		end
	end
end

-- Check that the module called exists and we are in the correct game mode
local function check_module(name)
	-- Don't allow changing the state of the planting module
	-- It is required for the tree planting workshop to function
	if not state[name] then
		print(name .. ' is not a valid module.')
		return false
	elseif state[name].fort_mode and df.global.gamemode ~= df.game_mode.DWARF then
		print(name .. ' can only be used in Fortress Mode.')
		return false
	end
	return true
end

local function change_mod_state(command, module)
	if not check_module(module) then
		return
	end
	
	if command == 'enable' then
		state[module].enabled = true
		state[module].player_set = true
		modules[module].do_enable()
	else
		state[module].enabled = false
		state[module].player_set = true
		modules[module].do_unload()
	end
	
	if state[module].fort_mode then
		dfhack.persistent.saveWorldData(GLOBAL_KEY, state)
	end
end

dfhack.onStateChange[GLOBAL_KEY] = function(sc)
	if sc == SC_MAP_UNLOADED then
		unload_all()
		dfhack.onStateChange[GLOBAL_KEY] = nil
		return
	end
	
	if sc ~= SC_MAP_LOADED or df.global.gamemode ~= df.game_mode.DWARF then
		return
	end
	
	state = get_default_state()
	utils.assign(state, dfhack.persistent.getWorldData(GLOBAL_KEY, state))
	load_all()
end

local function print_status(module)
	if module == 'all' then
		for m, v in pairs(state) do
			if check_module(m) then
				print(('Module ' .. m .. ' is %s.'):format(state[m].enabled and 'enabled' or 'disabled'))
			end
		end
		return
	end
	
	if check_module(module) then
		print(('Module ' .. module .. ' is %s.'):format(state[module].enabled and 'enabled' or 'disabled'))
	end
end

local args = {...}

if args[1] == 'enable' or args[1] == 'disable' then
	if not args[2] then
		print('Enable requires a module to be specified.')
		return
	end
	change_mod_state(args[1], args[2])
elseif args[1] == 'help' then
	if state[args[2]] then
		modules[args[2]].print_help()
	else
		print(dfhack.script_help())
	end
elseif args[1] == 'status' then
	if state[args[2]] then
		print_status(args[2])
	else
		print_status('all')
	end
else
	print(dfhack.script_help())
	return
end