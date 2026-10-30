-- Make cooking return seeds when cooking PLANT or PLANT_GROWTH items with SEED_MAT MRP
-- author Droseran

--@module = true

local eventful = require 'plugins.eventful'

local GLOBAL_KEY = 'cooking_gives_seeds'

-- Create the byproduct in the workshop if the job should have one
local function create_seeds(job)
	-- Check if this is a job type that should create a byproduct
	if not job.job_type == df.job_type.PrepareMeal then
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
	
	-- Check that there are items for the job
	if #job.items < 1 then
		return
	end
	
	-- Check if any ingredients have a SEED_MAT MRP
	for i, ingredient in ipairs(job.items) do
		local ingred_mat = dfhack.matinfo.decode(
			ingredient.item.mat_type,
			ingredient.item.mat_index
		)
		ingred_mat = ingred_mat.material
		
		for j, mrp in ipairs(ingred_mat.reaction_product.id) do
			if mrp.value == 'SEED_MAT' then
				local seed_type = ingred_mat.reaction_product.material.mat_type[j]
				local seed_index = ingred_mat.reaction_product.material.mat_index[j]
				local seed_number = ingredient.item.stack_size
				
				-- Create the seeds
				local new_items = dfhack.items.createItem(
					worker, df.item_type.SEEDS, -1,
					seed_type, seed_index, false, seed_number
				)
				
				-- Place the seeds inside the workshop
				for j, item in ipairs(new_items) do
					dfhack.items.moveToBuilding(item, workshop, df.building_item_role_type.TEMP)
				end
				
				-- Stop checking MRPs for this ingredient
				break
			end
		end
	end
end

function do_enable()
	eventful.enableEvent(eventful.eventType.JOB_COMPLETED, 0)
	eventful.onJobCompleted[GLOBAL_KEY] = create_seeds
	print("Enabled Cooking Gives Seeds.")
end

function do_unload()
	eventful.onJobCompleted[GLOBAL_KEY] = nil
	print("Disabled Cooking Gives Seeds.")
end

function print_help()
	print("Cooking Gives Seeds:\n\nThis module makes cooking produce seeds from plants and plant growths which should produce seeds. It can be disabled. Seeds produced will never exceed seed caps.")
end