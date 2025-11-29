-- extends add_regular_tokens() to add new lines to all generated creatures
old_add_regular_tokens=add_regular_tokens
function add_regular_tokens(lines,options)
    old_add_regular_tokens(lines,options)
    lines[#lines+1]="[GENERAL_MATERIAL_FORCE_MULTIPLIER:1:2]"--                 0.5x  damage taken from all materials
    lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:STEEL:1:1]"--         1.0x  damage taken from steel
	lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:BRONZE:4:5]"--        0.75x damage taken from bronze
	lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:ELF_STEEL:1:1]"--     1.0x  damage taken from elf steel
	lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:ENCHANTED_WOOD:1:1]"--1.0x  damage taken from elf wood
    lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:MITHRIL:5:4]"--       1.25x damage taken from mithril
    lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:DWARFSTEEL:5:4]"--    1.25x damage taken from dwarfsteel
    lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:TITANSTEEL:3:2]"--    1.5x  damage taken from titansteel
    lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:ORICHALCUM:3:2]"--    1.5x  damage taken from orichalcum
    lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:VOLCANIC:3:2]"--      1.5x  damage taken from volcanite
    lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:ADAMANTINE:3:2]"--    1.5x  damage taken from adamantine
	lines[#lines+1]="[STANCE_CLIMBER]"-- so rcp creatures can climb
	lines[#lines+1]="[NATURAL_SKILL:CLIMBING:1]"-- nat climbing skill
end