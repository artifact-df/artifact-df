-- convenient way to ban cooking categories of food
-- based on ban-cooking.rb by Putnam: https://github.com/DFHack/scripts/pull/427/files
-- Putnams work completed by TBSTeun
-- Updated by myk002 to maintain compatibility with current DFHack
-- This version altered by Droseran to work with new product varieties and plant items in Advanced Agriculture

local help = [====[

AA-ban-cooking
=================
Tags: fort | productivity | items | plants

Command: AA-ban-cooking

	Protect useful items from being cooked.

Some cookable ingredients have other important uses. For example, seed giving plants and growths can be cooked, but if you cook them all, then your farmers will have no seeds to plant in the fields. Similarly, thread producing items can be cooked, but if you do that, then your weavers will have nothing to weave into cloth and your doctors will have nothing to use for stitching up injured dwarves.

If you open the Kitchen screen, you can select individual item types and choose to ban them from cooking. To prevent all your booze from being cooked, for example, you’d select the Booze tab and then click each of the visible types of booze to prevent them from being cooked. Only types that you have in stock are shown, so if you acquire a different type of booze in the future, you have to come back to this screen and ban the new types.

Instead of doing all that clicking, ban-cooking can ban entire classes of items (e.g. all types of booze) in one go. It can even ban types that you don’t have in stock yet, so when you do get some in stock, they will already be banned. It will never ban items that are only good for eating or cooking, like meat or non-plantable nuts. It is usually a good idea to run ban-cooking all as one of your first actions in a new fort.

If you want to re-enable cooking for a banned item type, you can go to the Kitchen screen and un-ban whatever you like by clicking on the “cook” icon. You can also un-ban an entire class of items with the ban-cooking --unban option.
Usage

ban-cooking <type|all> [<type> ...] [<options>]

Valid types are:
	all (everything below)
	booze (drinks)
	brew (brewable plants and growths)
	honey
	mill (millable plants and growths)
	milk
	oil
	plant_milk (only plant milks that can be processed into tofu)
	roast (growths that have processing chains, such as coffee cherries)
	syrup
	seed_items (plants and growths which produce seeds)
	seeds
	tallow
	thread (plants and growths which can be spun into thread)

It is possible to include multiple types or all types in a single ban-cooking command: ban-cooking oil tallow will ban both oil and tallow from cooking. ban-cooking all will ban all of the above types.


]====]

local argparse = require('argparse')

local kitchen = df.global.plotinfo.kitchen

local options = {}
local banned = {}
local count = 0

local function make_key(mat_type, mat_index, type, subtype)
	return ('%s:%s:%s:%s'):format(mat_type, mat_index, type, subtype)
end

local function ban_cooking(print_name, mat_type, mat_index, type, subtype)
	local key = make_key(mat_type, mat_index, type, subtype)
	-- Skip adding a new entry further below if there's nothing to do
	if (banned[key] and not options.unban) or (not banned[key] and options.unban) then
		return
	end
	-- The item hasn't already been (un)banned, so we do that here by appending/removing
	-- its values to/from the various arrays
	count = count + 1
	if options.verbose then
		print(print_name .. ' has been ' .. (options.unban and 'un' or '') .. 'banned!')
	end

	if options.unban then
		dfhack.kitchen.removeExclusion({Cook=true}, type, subtype, mat_type, mat_index)
		banned[key] = nil
	else
		dfhack.kitchen.addExclusion({Cook=true}, type, subtype, mat_type, mat_index)
		banned[key] = {
			mat_type=mat_type,
			mat_index=mat_index,
			type=type,
			subtype=subtype,
		}
	end
end

local function init_banned()
	-- Iterate over the elements of the kitchen.item_types list
	for i in ipairs(kitchen.item_types) do
		if kitchen.exc_types[i].Cook then
			local key = make_key(kitchen.mat_types[i], kitchen.mat_indices[i], kitchen.item_types[i], kitchen.item_subtypes[i])
			if not banned[key] then
				banned[key] = {
					mat_type=kitchen.mat_types[i],
					mat_index=kitchen.mat_indices[i],
					type=kitchen.item_types[i],
					subtype=kitchen.item_subtypes[i],
				}
			end
		end
	end
end

local funcs = {}

funcs.booze = function()
	for _, p in ipairs(df.global.world.raws.plants.all) do
		for _, m in ipairs(p.material) do
			if m.flags.ALCOHOL and m.flags.EDIBLE_COOKED then
				local matinfo = dfhack.matinfo.find(p.id, m.id)
				ban_cooking(p.name .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.DRINK, -1)
			end
		end
	end
	for _, c in ipairs(df.global.world.raws.creatures.all) do
		for _, m in ipairs(c.material) do
			if m.flags.ALCOHOL and m.flags.EDIBLE_COOKED then
				local matinfo = dfhack.matinfo.find(c.creature_id, m.id)
				ban_cooking(c.name[2] .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.DRINK, -1)
			end
		end
	end
end

funcs.brew = function()
	for _, p in ipairs(df.global.world.raws.plants.all) do
		if p.material_defs.type.drink == -1 or p.material_defs.idx.drink == -1 then goto continue end
		for _, m in ipairs(p.material) do
			if m.id == "STRUCTURAL" then
				if m.flags.EDIBLE_COOKED then
					for _, s in ipairs(m.reaction_product.id) do
						if s.value == "DRINK_MAT" then
							local matinfo = dfhack.matinfo.find(p.id, m.id)
							ban_cooking(p.name .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.PLANT, -1)
							-- Stop iterating through reaction products for this material
							break
						end
					end
				end
				-- Stop iterating through materials since there can only be one STRUCTURAL
				break
			end
		end
		for k, g in ipairs(p.growths) do
			local matinfo = dfhack.matinfo.decode(g)
			local m = matinfo.material
			if m.flags.EDIBLE_COOKED then
				for _, s in ipairs(m.reaction_product.id) do
					if s.value == "DRINK_MAT" then
						ban_cooking(p.name .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.PLANT_GROWTH, k)
						break
					end
				end
			end
		end

		::continue::
	end
end

funcs.honey = function()
	for _, c in ipairs(df.global.world.raws.creatures.all) do
		for _, m in ipairs(c.material) do
			if m.flags.EDIBLE_COOKED then
				for _, s in ipairs(m.reaction_product.id) do
					if s.value == "DRINK_MAT" then
						local matinfo = dfhack.matinfo.find(c.creature_id, m.id)
						ban_cooking(c.name[2] .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.LIQUID_MISC, -1)
						break
					end
				end
			end
		end
	end
end

funcs.milk = function()
	for _, c in ipairs(df.global.world.raws.creatures.all) do
		for _, m in ipairs(c.material) do
			if m.flags.EDIBLE_COOKED then
				for _, s in ipairs(m.reaction_product.id) do
					if s.value == "CHEESE_MAT" then
						local matinfo = dfhack.matinfo.find(c.creature_id, m.id)
						ban_cooking(c.name[2] .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.LIQUID_MISC, -1)
						break
					end
				end
			end
		end
	end
end

funcs.mill = function()
	for _, p in ipairs(df.global.world.raws.plants.all) do
		for _, m in ipairs(p.material) do
			if m.id == "STRUCTURAL" then
				if m.flags.EDIBLE_COOKED then
					if p.material_defs.idx.mill ~= -1 then
						local matinfo = dfhack.matinfo.find(p.id, m.id)
						ban_cooking(p.name .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.PLANT, -1)
					else
						for _, s in ipairs(m.reaction_product.id) do
							if s.value == "DYE_MAT" or s.value == "FLOUR_MAT" or s.value == "MILL_MAT" or s.value == "POWDER_MAT" or s.value == "STARCH_MAT" or s.value == "PRESS_LIQUID_MAT" then
								local matinfo = dfhack.matinfo.find(p.id, m.id)
								ban_cooking(p.name .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.PLANT, -1)
								break
							end
						end
					end
				end
				break
			end
		end
		for k, g in ipairs(p.growths) do
			local matinfo = dfhack.matinfo.decode(g)
			local m = matinfo.material
			if m.flags.EDIBLE_COOKED then
				for _, s in ipairs(m.reaction_product.id) do
					if s.value == "DYE_MAT" or s.value == "FLOUR_MAT" or s.value == "MILL_MAT" or s.value == "POWDER_MAT" or s.value == "STARCH_MAT" or s.value == "PRESS_LIQUID_MAT" then
						ban_cooking(p.name .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.PLANT_GROWTH, k)
						break
					end
				end
			end
		end
	end
end

funcs.oil = function()
	for _, p in ipairs(df.global.world.raws.plants.all) do
		for _, m in ipairs(p.material) do
			if m.flags.EDIBLE_COOKED then
				for _, s in ipairs(m.reaction_product.id) do
					if s.value == "SOAP_MAT" then
						local matinfo = dfhack.matinfo.find(p.id, m.id)
						ban_cooking(p.name .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.LIQUID_MISC, -1)
						break
					end
				end
			end
		end
	end
end

funcs.plant_milk = function()
	for _, p in ipairs(df.global.world.raws.plants.all) do
		for _, m in ipairs(p.material) do
			if m.flags.EDIBLE_COOKED then
				for _, s in ipairs(m.reaction_product.id) do
					if s.value == "TOFU_MAT" then
						local matinfo = dfhack.matinfo.find(p.id, m.id)
						ban_cooking(p.name .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.LIQUID_MISC, -1)
						break
					end
				end
			end
		end
	end
end

funcs.roast = function()
	for _, p in ipairs(df.global.world.raws.plants.all) do
		for k, g in ipairs(p.growths) do
			local matinfo = dfhack.matinfo.decode(g)
			local m = matinfo.material
			if m.flags.EDIBLE_COOKED then
				for _, s in ipairs(m.reaction_product.id) do
					if s.value == "PROCESS_MAT" then
						ban_cooking(p.name .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.PLANT_GROWTH, k)
						break
					end
				end
			end
		end
	end
end

funcs.seed_items = function()
	for _, p in ipairs(df.global.world.raws.plants.all) do
		for _, m in ipairs(p.material) do
			if m.id == "STRUCTURAL" then
				if m.flags.EDIBLE_COOKED then
					for _, s in ipairs(m.reaction_product.id) do
						if s.value == "SEED_MAT" then
							local matinfo = dfhack.matinfo.find(p.id, m.id)
							ban_cooking(p.name .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.PLANT, -1)
							break
						end
					end
				end
				break
			end
		end
		for k, g in ipairs(p.growths) do
			local matinfo = dfhack.matinfo.decode(g)
			local m = matinfo.material
			if m.flags.EDIBLE_COOKED then
				for _, s in ipairs(m.reaction_product.id) do
					if s.value == "SEED_MAT" then
						ban_cooking(p.name .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.PLANT_GROWTH, k)
						break
					end
				end
			end
		end
	end
end

funcs.seeds = function()
	for _, p in ipairs(df.global.world.raws.plants.all) do
		if p.material_defs.type.seed == -1 or p.material_defs.idx.seed == -1 or p.flags.TREE then goto continue end
		ban_cooking(p.name .. ' seeds', p.material_defs.type.seed, p.material_defs.idx.seed, df.item_type.SEEDS, -1)
		::continue::
	end
end

funcs.syrup = function()
	for _, p in ipairs(df.global.world.raws.plants.all) do
		for _, m in ipairs(p.material) do
			if m.flags.EDIBLE_COOKED then
				for _, s in ipairs(m.reaction_product.id) do
					if s.value == "SUGAR_MAT" then
						local matinfo = dfhack.matinfo.find(p.id, m.id)
						ban_cooking(p.name .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.LIQUID_MISC, -1)
						break
					end
				end
			end
		end
	end
end

funcs.tallow = function()
	for _, c in ipairs(df.global.world.raws.creatures.all) do
		for _, m in ipairs(c.material) do
			if m.flags.EDIBLE_COOKED then
				for _, s in ipairs(m.reaction_product.id) do
					if s.value == "SOAP_MAT" then
						local matinfo = dfhack.matinfo.find(c.creature_id, m.id)
						ban_cooking(c.name[2] .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.GLOB, -1)
						break
					end
				end
			end
		end
	end
end

funcs.thread = function()
	for _, p in ipairs(df.global.world.raws.plants.all) do
		if p.material_defs.idx.thread == -1 then goto continue end
		for _, m in ipairs(p.material) do
			if m.id == "STRUCTURAL" then
				if m.flags.EDIBLE_COOKED then
					for _, s in ipairs(m.reaction_product.id) do
						if s.value == "THREAD" then
							local matinfo = dfhack.matinfo.find(p.id, m.id)
							ban_cooking(p.name .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.PLANT, -1)
							break
						end
					end
				end
				break
			end
		end
		for k, g in ipairs(p.growths) do
			local matinfo = dfhack.matinfo.decode(g)
			local m = matinfo.material
			if m.flags.EDIBLE_COOKED then
				for _, s in ipairs(m.reaction_product.id) do
					if s.value == "THREAD" then
						ban_cooking(p.name .. ' ' .. m.id, matinfo.type, matinfo.index, df.item_type.PLANT_GROWTH, k)
						break
					end
				end
			end
		end

		::continue::
	end
end

local classes = argparse.processArgsGetopt({...}, {
	{'h', 'help', handler=function() options.help = true end},
	{'u', 'unban', handler=function() options.unban = true end},
	{'v', 'verbose', handler=function() options.verbose = true end},
})

if options.help == true then
	print(dfhack.script_help())
	return
end

init_banned()

if classes[1] == 'all' then
	for _, func in pairs(funcs) do
		func()
	end
else
	for _, v in ipairs(classes) do
		if funcs[v] then
			funcs[v]()
		end
	end
end

print((options.unban and 'un' or '') .. 'banned ' .. count .. ' types.')
