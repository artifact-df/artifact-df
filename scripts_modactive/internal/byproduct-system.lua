-- Add plant byproducts to the output of specific jobs
-- Such as tree bark from making blocks and furniture from logs
-- author Droseran

--@module = true

--[====[
Byproduct System
===========

Tags: fort | gameplay | jobs | plants

Adds byproducts to certain jobs in Fortress Mode

Currently produces bark from making blocks and furniture from logs.
Can be disabled if you do not want to deal with byproducts from 
vanilla jobs.

Usage
-----
    enable byproduct-system
    disable byproduct-system
    
    byproduct-system status
]====]

local eventful = require 'plugins.eventful'

local GLOBAL_KEY = 'byproduct_system'
local carpentry_jobs = {
	[df.job_type.ConstructBed] = true,
	[df.job_type.MakeTrapComponent] = true,
	[df.job_type.ConstructBlocks] = true,
	[df.job_type.MakeTool] = true,
	[df.job_type.MakeAnimalTrap] = true,
	[df.job_type.ConstructArmorStand] = true,
	[df.job_type.MakeBarrel] = true,
	[df.job_type.ConstructBin] = true,
	[df.job_type.MakeBucket] = true,
	[df.job_type.ConstructCabinet] = true,
	[df.job_type.MakeCage] = true,
	[df.job_type.ConstructCoffin] = true,
	[df.job_type.ConstructThrone] = true,
	[df.job_type.ConstructChest] = true,
	[df.job_type.ConstructCrutch] = true,
	[df.job_type.ConstructDoor] = true,
	[df.job_type.ConstructFloodgate] = true,
	[df.job_type.ConstructGrate] = true,
	[df.job_type.ConstructHatchCover] = true,
	[df.job_type.MakePipeSection] = true,
	[df.job_type.ConstructSplint] = true,
	[df.job_type.ConstructTable] = true,
	[df.job_type.ConstructWeaponRack] = true,
}

-- Create the byproduct in the workshop if the job should have one
local function create_byproducts(job)
	-- Check if this is a job type that should create a byproduct
	if not carpentry_jobs[job.job_type] then
		return
	end
	
	-- Ensure there is a valid worker for createItem
	local worker = dfhack.job.getWorker(job)
	if not worker then
		return
	end
	
	-- Get the workshop the job is in
	workshop = dfhack.job.getHolder(job)
	if not workshop then
		return
	end
	
	-- Get the item being used in the job and ensure it exists
	if #job.items < 1 then
		return
	end
	
	local item = job.items[0].item
	if not item then
		return
	end
	
	-- Find the BYPRODUCT_MAT of the item and record its material
	local item_mat = dfhack.matinfo.decode(job.mat_type, job.mat_index).material
	local bypmat = {}
	for i, mrp in ipairs(item_mat.reaction_product.id) do
		if mrp.value == 'BYPRODUCT_MAT' then
			bypmat.type = item_mat.reaction_product.material.mat_type[i]
			bypmat.index = item_mat.reaction_product.material.mat_index[i]
		end
		break
	end
	
	-- Return if the material does not have a byproduct
	if not bypmat.type or not bypmat.index then
		return
	end
	
	-- Create the byproduct item
	local new_items = dfhack.items.createItem(
		worker, df.item_type.GLOB, -1, 
		bypmat.type, bypmat.index, false, 5
	)
	
	-- Place byproduct inside workshop
	dfhack.items.moveToBuilding(new_items[1], workshop, df.building_item_role_type.TEMP)
end

function do_enable()
	eventful.enableEvent(eventful.eventType.JOB_COMPLETED, 0)
	eventful.onJobCompleted[GLOBAL_KEY] = create_byproducts
	print("Enabled Byproduct System.")
end

function do_unload()
	eventful.onJobCompleted[GLOBAL_KEY] = nil
	print("Disabled Byproduct System.")
end

function print_help()
	print("Byproduct System:\n\nThis module adds byproducts to certain vanilla jobs in Fortress Mode.\nIt currently only produces bark when making wooden blocks and furniture. It can be disabled if you do not want to deal with byproducts from vanilla jobs.")
end