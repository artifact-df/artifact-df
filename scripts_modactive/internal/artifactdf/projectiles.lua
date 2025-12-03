--@ module = true
--
-- This script uses the DFHack lua API, and was written for the Artifact DF mod.
-- Unless this script is present, the bullet cartridges included in Artifact DF
-- will launch out of the gun instead of turning into bullets.

local events = require("plugins.eventful")
local utils = require("utils")
local tokens = require("custom-raw-tokens")

local artifact = reqscript("internal/artifactdf/core")
artifact.print("Loading projectile behavior script...")

-- Arbitrarily picked one of the unlabeled flags
local IGNORE_BITFLAG = 30

local makeCopyProjectile = function(ammo_subtype_string, original_proj)
	local firer = original_proj.firer
	local mat_type = original_proj.item.mat_type
	local mat_idx = original_proj.item.mat_index
	local item_vec = dfhack.items.createItem(
		firer,
		df.item_type.AMMO,
		dfhack.items.findSubtype("AMMO:" .. ammo_subtype_string),
		mat_type,
		mat_idx,
		false
	)
	assert(#item_vec == 1, "Failed to create projectile")
	local new_proj_item = item_vec[1]

	local new_proj = dfhack.items.makeProjectile(new_proj_item)

	new_proj.firer = firer
	new_proj.origin_pos = utils.clone(original_proj.origin_pos)
	new_proj.target_pos = utils.clone(original_proj.target_pos)
	new_proj.cur_pos = utils.clone(original_proj.cur_pos)
	new_proj.prev_pos = utils.clone(original_proj.prev_pos)
	new_proj.fall_threshold = original_proj.fall_threshold
	new_proj.fall_counter = original_proj.fall_counter
	new_proj.fall_delay = original_proj.fall_delay
	new_proj.min_hit_distance = original_proj.min_hit_distance
	new_proj.min_ground_distance = original_proj.min_ground_distance
	new_proj.bow_id = original_proj.bow_id
	new_proj.total_z_dist = original_proj.total_z_dist
	new_proj.velocity = original_proj.velocity
	new_proj.hit_rating = original_proj.hit_rating
	new_proj.flags.no_impact_destroy = true
	-- NOTE: this causes our event logic to ignore this projectile
	new_proj.flags[IGNORE_BITFLAG] = true
end

events.onProjItemCheckMovement.one = function(fired_proj)
	-- Skip this projectile if it's been marked as ignored
	if fired_proj.flags[IGNORE_BITFLAG] then
		return
	end

	-- Logic for cartridge-type ammo
	local cart_data = { tokens.getToken(fired_proj.item, "ARTIFACTDF_CARTRIDGE_SHOTS") }
	if cart_data[1] ~= false then -- cart_data[1] will be false if ARTIFACTDF_CARTRIDGE_SHOTS is not present
		artifact.printDebug("Fired projectile " .. fired_proj.item.id .. " is a cartridge")
		-- Create smoke if needed
		if not artifact.settings.DISABLE_GUN_SMOKE then
			local smoke_data = { tokens.getToken(fired_proj.item, "ARTIFACTDF_CARTRIDGE_SMOKE") }
			if smoke_data[1] ~= false then
				local smoke_count

				if artifact.settings.REDUCE_GUN_SMOKE then
					smoke_count = tonumber(smoke_data[1]) * 0.5
				else
					smoke_count = tonumber(smoke_data[1])
				end

				assert(
					type(smoke_count) == "number",
					"Expected ARTIFACTDF_CARTRIDGE_SMOKE:x to provide an integer for x"
				)

				dfhack.maps.spawnFlow(fired_proj.cur_pos, df.flow_type.Smoke, 0, 0, smoke_count)
			end
		end

		-- Fire the bullets
		for i = 1, #cart_data, 2 do
			local shot_subtype_string = cart_data[i]
			local shot_count = tonumber(cart_data[i + 1])
			assert(
				type(shot_subtype_string) == "string" and type(shot_count) == "number",
				"Expected ARTIFACTDF_CARTRIDGE_SHOTS:x:y to provide an ITEM_AMMO subtype for x and a quantity for y"
			)
			for _ = 1, shot_count do
				makeCopyProjectile(shot_subtype_string, fired_proj)
			end
		end
		-- Remove the cartridge
		dfhack.items.remove(fired_proj.item)

		-- Don't continue this function, fired_proj is gone
		return
	end

	-- If no relevant tokens were found, mark the projectile as ignored
	artifact.printDebug("Fired projectile " .. fired_proj.item.id .. " has no special behavior")
	fired_proj.flags[IGNORE_BITFLAG] = true
end
