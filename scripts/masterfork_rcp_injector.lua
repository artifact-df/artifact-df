old_add_regular_tokens=add_regular_tokens-- injects new lines into the rcp generator
function add_regular_tokens(lines,options)
    old_add_regular_tokens(lines,options)
    lines[#lines+1]="[GENERAL_MATERIAL_FORCE_MULTIPLIER:1:2]"-- 0.5x damage taken from all materials
    lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:STEEL:1:4]"-- 0.25x damage taken from steel
    lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:MITHRIL:3:2]"-- 1.5x damage taken from mithril
    lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:DWARFSTEEL:3:2]"-- 1.5x damage taken from dwarfsteel
    lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:TITANSTEEL:3:2]"-- 1.5x damage taken from titansteel
    lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:ORICHALCUM:3:2]"-- 1.5x damage taken from orichalcum
    lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:VOLCANIC:3:2]"--   1.5x damage taken from volcanite
    lines[#lines+1]="[MATERIAL_FORCE_MULTIPLIER:INORGANIC:ADAMANTINE:3:2]"-- 1.5x damage taken from adamantine
	lines[#lines+1]="[APPLY_CREATURE_VARIATION:EMOTION_AURA_TERROR]"-- terror aura
--rcp_emotion_aura={
--if creatures.fb=true then
--lines[#lines+1]="[APPLY_CREATURE_VARIATION:EMOTION_AURA_TERROR]"-- forgotten beasts
--elseif creatures.night_creature=true then
--lines[#lines+1]="[APPLY_CREATURE_VARIATION:EMOTION_AURA_TERROR]"-- night creatures
--elseif creatures.angel=true then
--lines[#lines+1]="[APPLY_CREATURE_VARIATION:EMOTION_AURA_HORROR]"-- angels
--elseif creatures.demon=true then
--lines[#lines+1]="[APPLY_CREATURE_VARIATION:EMOTION_AURA_HORROR]"-- demons
--}
end