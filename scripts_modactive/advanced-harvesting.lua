-- Add PLANT_GROWTH items to crop plot harvesting output
-- author Droseran

--@enable = true
--@module = true

--[====[
Advanced Harvesting
===========

Tags: fort | gameplay | jobs | plants

Enables harvesting growths from crop plots.

This script returns the farming behavior from before DF 52.03 that when a crop plot is harvested
the plant's growths are obtained along with the plant item.

Usage
-----
    enable advanced-harvesting
    disable advanced-harvesting
    
    advanced-harvesting status
]====]

local argparse = require 'argparse'
local eventful = require 'plugins.eventful'
local utils = require 'utils'

local GLOBAL_KEY = 'advanced_harvesting'
local growths_data = {}

-- On load create a lookup table for plant ID to growths data instead of searching every time
local function cache_growths()
	for i, p in ipairs(df.global.world.raws.plants.all) do
		growths_data[p.id] = {}
		local has_growth = false
		for j, g in ipairs(df.global.world.raws.plants.all[i].growths) do
			local matinfo = dfhack.matinfo.decode(g)
			if matinfo.material.flags.STOCKPILE_PLANT_GROWTH then
				-- Growth index is the item subtype for createitem
				has_growth = true
				growths_data[p.id][j] = {mat_type = matinfo.type, mat_index = matinfo.index}
			end
		end
		
		-- Make it easier to detect plants without useful growths
		if not has_growth then
			growths_data[p.id] = nil
		end
	end
end

-- Search the job's farm plot for the plant's information
local function get_harvested_plant(job)
	-- For some reason job.pos does not return a z value except this way
	local x = job.pos.x
	local y = job.pos.y
	local z = job.pos.z
	
	local farm = dfhack.job.getHolder(job)
	for i, contained in ipairs(farm.contained_items) do
		local item = contained.item
		local t,u,v = dfhack.items.getPosition(item)
		if x == t and y == u and z == v then
			local p_id = string.match(dfhack.matinfo.getToken(item), ":(.+):")
			local number = item:getStackSize()
			return p_id, number
		end
	end
	
	dfhack.printerr('Advanced Harvesting: Plant not found in farm plot for harvesting job.')
	return nil
end

-- Create the growths and move them to the job position when a harvest job is started
-- and has a valid worker
local function create_growths(job)
	if job.job_type ~= df.job_type.HarvestPlants then
		return
	end
	
	local harvester = dfhack.job.getWorker(job)
	
	-- This removes a lot of duplicate jobs for the same plant
	if not harvester then
		return
	end
	
	-- Get the plant's ID and stack size, quit if not found
	local plant_id, amount = get_harvested_plant(job)
	if not plant_id then
		return
	end
	
	-- check if the plant actually has growths to create
	if not growths_data[plant_id] then
		return
	end
	
	-- create all stockpilable growths for this plant
	for k, v in pairs(growths_data[plant_id]) do
		local items = dfhack.items.createItem(harvester, df.item_type.PLANT_GROWTH, k, v.mat_type, v.mat_index, false, amount)
		
		-- Move growth to job position since unit won't be in place at start of job and JOB_COMPLETE doesn't work
		dfhack.items.moveToGround(items[1], job.pos)
	end
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
	cache_growths()
	
	-- Using JOB_STARTED because harvests don't trigger JOB_COMPLETED
	eventful.enableEvent(eventful.eventType.JOB_STARTED, 0)
	eventful.onJobStarted[GLOBAL_KEY] = create_growths
	print("Advanced Harvesting: Enabled")
end

-- State is not saved persistently here since this is also called by save unloading
local function do_unload()
	state.enabled = false
	eventful.onJobStarted[GLOBAL_KEY] = nil
	growths_data = nil
	print("Advanced Harvesting: Disabled")
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
	
	state = get_default_state()
	utils.assign(state, dfhack.persistent.getSiteData(GLOBAL_KEY, state))
	
	if state.enabled then
		do_enable()
	end
end

local function print_status()
	print(('Advanced Harvesting is %s.'):format(state.enabled and 'enabled' or 'disabled'))
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