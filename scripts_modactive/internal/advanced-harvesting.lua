-- Add PLANT_GROWTH items to crop plot harvesting output
-- author Droseran

--@module = true

local eventful = require 'plugins.eventful'

local GLOBAL_KEY = 'advanced_harvesting'

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
			return item.mat_index, item:getStackSize()
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
	local plant_index, amount = get_harvested_plant(job)
	if not plant_index then
		return
	end
	
	local plant = df.global.world.raws.plants.all[plant_index]
	local growths = plant.growths
	
	-- check if the plant actually has growths to create
	if #growths < 1 then
		return
	end
	
	-- create all stockpileable growths for this plant
	for i, growth in ipairs(growths) do
		matinfo = dfhack.matinfo.decode(growth.mat_type, growth.mat_index)
		if matinfo.material.flags.STOCKPILE_PLANT_GROWTH then
			local items = dfhack.items.createItem(
				harvester, df.item_type.PLANT_GROWTH, i,
				growth.mat_type, growth.mat_index, false, amount
			)
			
			-- Move growth to job position since unit won't be in place at start of job and JOB_COMPLETE doesn't work
			dfhack.items.moveToGround(items[1], job.pos)
		end
	end
end

function do_enable()
	-- Using JOB_STARTED because harvests don't trigger JOB_COMPLETED
	eventful.enableEvent(eventful.eventType.JOB_STARTED, 0)
	eventful.onJobStarted[GLOBAL_KEY] = create_growths
	print("Enabled Advanced Harvesting.")
end

function do_unload()
	eventful.onJobStarted[GLOBAL_KEY] = nil
	print("Disabled Advanced Harvesting.")
end

function print_help()
	print("Advanced Harvesting:\n\nThis module returns the farming behavior from before DF 52.03:\nWhen a farm plot is harvested the plant's growths are obtained along with the plant item. Unlike the original behavior, farmers will only pick stockpileable growths in order to avoid clutter.")
end