-- extends add_regular_tokens() to add new lines to all generated creatures
old_add_regular_tokens=add_regular_tokens
function add_regular_tokens(lines,options)
	old_add_regular_tokens(lines,options)
	lines[#lines+1]="[APPLY_CREATURE_VARIATION:MEGABEAST_FORCE_RESISTANCE]"-- very high resistance against non-metal weapons
	lines[#lines+1]="[STANCE_CLIMBER]"-- so rcp creatures can climb
	lines[#lines+1]="[NATURAL_SKILL:CLIMBING:1]"-- nat climbing skill
end