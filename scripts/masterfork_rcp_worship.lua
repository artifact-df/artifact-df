-- make all large creatures into powers
btc1_tweaks.mfork_titan_worship=function(lines,options,add_to_body,add_to_body_unique,add_tweak_candidate)
	if options.body_size>=500000 then -- described as "very large", graphics size cutoff
		options.can_learn=true -- for flavor text
		lines[#lines+1]="[INTELLIGENT]"
		lines[#lines+1]="[SUPERNATURAL]" -- knows secrets according to their spheres
		lines[#lines+1]="[POWER]" -- impersonates deities
		lines[#lines+1]="[SPREAD_EVIL_SPHERES_IF_RULER]"
	end
end