creatures.fb.default=nil-- remove old forgotten beasts

-- simply limits forgotten beasts to cavern layer 2-3
creatures.fb.default=function(layer_type,tok)
    local tbl={}
    local options={
        strong_attack_tweak=true,
        spheres={CAVERNS=true},
        is_evil=true,
        sickness_name="beast sickness",
        token=tok
    }
    tbl=split_to_lines(tbl,[[
    [FEATURE_BEAST]
    [ATTACK_TRIGGER:0:0:2]
    [NAME:forgotten beast:forgotten beasts:forgotten beast]
    [CASTE_NAME:forgotten beast:forgotten beasts:forgotten beast]
    [NO_GENDER]
    [CARNIVORE]
    [DIFFICULTY:10]

    [NATURAL_SKILL:WRESTLING:6]
    [NATURAL_SKILL:BITE:6]
    [NATURAL_SKILL:GRASP_STRIKE:6]
    [NATURAL_SKILL:STANCE_STRIKE:6]
    [NATURAL_SKILL:MELEE_COMBAT:6]
    [NATURAL_SKILL:DODGING:6]
    [NATURAL_SKILL:SITUATIONAL_AWARENESS:6]
    [LARGE_PREDATOR]
    ]])
    add_regular_tokens(tbl,options)
    tbl[#tbl+1]=layer_type==0 and "[BIOME:SUBTERRANEAN_WATER]" and "[UNDERGROUND_DEPTH:2:3]" or "[BIOME:SUBTERRANEAN_CHASM]" and "[UNDERGROUND_DEPTH:2:3]"-- new and conditions
    if layer_type==0 then options.spheres.WATER=true end
    options.spheres[pick_random(evil_spheres)]=true
    options.do_water=layer_type==0
    populate_sphere_info(tbl,options)
    local rcp=get_random_creature_profile(options)
    add_body_size(tbl,math.max(10000000,rcp.min_size),options)
    tbl[#tbl+1]="[CREATURE_TILE:"..tile_string(rcp.tile).."]"
    build_procgen_creature(rcp,tbl,options)
    return {raws=tbl,weight=1}
end