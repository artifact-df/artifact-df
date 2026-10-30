-- Sets the fortress and specific seed caps 
-- author Droseran

--@module = true

local sensible_caps = {
	specific = 50,
	fortress = 30000,
}

-- Get the current seed cap values
-- No longer used, here in case I need it in the future
--function get_seed_caps()
--	local seed_caps = {}
--	seed_caps.specific = df.global.d_init.dwarf.specific_seed_cap
--	seed_caps.fortress = df.global.d_init.dwarf.fortress_seed_cap
--	return seed_caps
--end

-- Set the seed caps to recommended values
local function set_seed_caps(caps_table)
	df.global.d_init.dwarf.specific_seed_cap = caps_table.specific
	df.global.d_init.dwarf.fortress_seed_cap = caps_table.fortress
end

-- Using a global settings file to record the original seed caps permanently
function do_enable()
	set_seed_caps(sensible_caps)
	print("Changed seed caps to recommended values.")
end

function do_unload()
	-- Does nothing, prevents needing special handling for this module
	return
end

function print_help()
	print("Sensible Seed Caps:\n\nThis module changes the specific and fortress seed caps to more sane values of 50 and 30000, respectively. This allows obtaining seeds for every crop and receiving new seeds from reactions when merchants arrive with many seeds. Yes, merchant seeds count against your fortress caps even without buying them.\n\n"
		.. "Note that the issue the seed caps were implemented to fix was resolved years ago. Even 200,000 seeds in a fortress would not significantly affect FPS in modern Dwarf Fortress versions.\n\n"
		.. "The default fortress seed cap is 3000. Once this limit is reached, seeds begin being DELETED from stockpiles, oldest first, maintaining equal amounts of each species. This only allows 19 seeds of each species if you manage to collect them all.\n\n"
		.. "The math:\n"
		.. "    Default Total cap: 3000.\n"
		.. "    Default Specific cap: 200.\n"
		.. "    Vanilla seeds = 157 x 200 = 31,400.\n"
		.. "        3000 / 157 = 19 per species.\n"
		.. "    AA seeds = 112 x 200 = 22,400.\n"
		.. "        3000 / 112 = 26 per species.\n\n"
		.. "    Sensible Total cap: 30000 (maximum).\n"
		.. "    Sensible Specific cap: 50.\n"
		.. "    Sensible caps = 112 x 50 = 5,600.\n"
		.. "        Max species below Total = 600.\n\n"
		.. "Even if you only farm subterranean crops 50 of each species is still more than enough for secure food production, while allowing up to 600 species of crops without worrying about the Total cap causing depletion."
	)
end