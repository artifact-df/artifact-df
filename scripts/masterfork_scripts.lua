-- original script from "Remove Invisible Divine Items (Lua)" by dphkraken
-- removing this means that the default angel entity wouldn't have *any* items
angel_item_gens.default = nil

local rarityless_items={
    WEAPON=true,
    AMMO=true,
    SHIELD=true,
    ARMOR=true,
    HELM=true,
    GLOVES=true,
    SHOES=true,
    PANTS=true,
}

-- so we have to overwrite
entities.vault_guardian.default=function(idx,tok)
	-- just copy from the dungeon guardian and give them all existing items
	-- don't really care right now about replicating the specific system that they use, it'll do for now
    local lines={}
    for k,v in ipairs({"WEAPON","AMMO","SHIELD","ARMOR","HELM","GLOVES","SHOES","PANTS"}) do
        for kk,vv in ipairs(world.itemdef[v:lower()]) do
            if not vv.generated then
                lines[#lines+1]="["..v..":"..vv.token..(rarityless_items[v] and "" or ":COMMON").."]"
            end
        end
    end
    lines[#lines+1]="[DIVINE_MAT_WEAPONS]"
    lines[#lines+1]="[DIVINE_MAT_ARMOR]"
    lines[#lines+1]="[DIVINE_MAT_CRAFTS]"
    lines[#lines+1]="[DIVINE_MAT_CLOTHING]"
    lines[#lines+1]="[CLOTHING]"
    lines[#lines+1]="[TRANSLATION:GEN_DIVINE]"
    return {entity=lines,weight=1}
end

-- randomly generated elementals
fb_elements = {
	{
		name="fire",
		rcm="FLAME",
		spheres={ FIRE=true },
		options={ fire_immune=true }
	},
	{
		name="earth",
		rcm="ANY_MINERAL",
		rcp_options={ always_flightless=true },
		spheres={
			EARTH=true,
			MINERALS=true
		}
	},
	{
		name="air",
		rcm="STEAM",
		spheres={
			WIND=true,
			SKY=true
		},
		options={
			always_insubstantial=true,
			intangible_flier=true
		}
	}
}

creatures.fb.elemental=function(layer_type,tok)
	local lines={}
	local options={
		strong_attack_tweak=true,
		always_make_uniform=true, --irrelevant due to sphere_rcm
		spheres={},
		sickness_name="dyskrasia",
		token=tok
	}
	lines=split_to_lines(lines,[[
		[FEATURE_BEAST]
		[ATTACK_TRIGGER:0:0:2]
		[NO_GENDER]
		[NO_EAT][NO_DRINK]
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
	
	-- Create a water elemental in water layers, otherwise use another type
	local water_elemental = {
		name="water",
		rcm="WATER",
		spheres={WATER=true},
		options={do_water=true}
	}
	local my_element = layer_type==1 and pick_random(fb_elements) or water_elemental
	
	-- Assign propertes from chosen element
	map_merge(options.spheres,my_element.spheres)
	if my_element.options then map_merge(options,my_element.options) end
	
	add_regular_tokens(lines,options)
	lines[#lines+1]=layer_type==0 and "[BIOME:SUBTERRANEAN_WATER]" or "[BIOME:SUBTERRANEAN_CHASM]"
	populate_sphere_info(lines,options)
	
	-- Set custom material
	options.sphere_rcm=my_element.rcm
	-- Build body
	local rcp=get_random_creature_profile(options)
	-- Set more options on the RCP
	if my_element.rcp_options then map_merge(rcp.options,my_element.rcp_options) end
	add_body_size(lines,math.max(10000000,rcp.min_size),options)
	lines[#lines+1]="[CREATURE_TILE:'E']"
	build_procgen_creature(rcp,lines,options)
	
	-- Generate name
	local element_name = my_element.name or "glitchstuff"
	local name_str = element_name.." elemental:"..element_name.." elemental:"..element_name.."-elemental]"
	lines[#lines+1]="[GO_TO_START]"
	lines[#lines+1]="[NAME:"..name_str
	lines[#lines+1]="[CASTE_NAME:"..name_str
	
	return {raws=lines,weight=0.15}
end

-- new generated forgotten beasts
creatures.fb.unbidden=function(layer_type,tok)
    if layer_type==0 then return nil end -- land only
    local tbl={}
    local options={
        strong_attack_tweak=true,
        always_make_uniform=true,
        always_insubstantial=true,
        intangible_flier=true,
        spheres={CAVERNS=true},
        is_evil=true,
        sickness_name="beast sickness",
        token=tok
    }
    tbl=split_to_lines(tbl,[[
    [FEATURE_BEAST]
    [ATTACK_TRIGGER:0:0:2]
    [NAME:unbidden spirit:unbidden spirit:unbidden spirit]
    [CASTE_NAME:unbidden spirit:unbidden spirit:unbidden spirit]
    [NO_GENDER]
    [CARNIVORE]
    [DIFFICULTY:10]

    [NATURAL_SKILL:WRESTLING:10]
    [NATURAL_SKILL:BITE:10]
    [NATURAL_SKILL:GRASP_STRIKE:10]
    [NATURAL_SKILL:STANCE_STRIKE:10]
    [NATURAL_SKILL:MELEE_COMBAT:10]
    [NATURAL_SKILL:DODGING:10]
    [NATURAL_SKILL:SITUATIONAL_AWARENESS:10]
    [LARGE_PREDATOR]
    ]])
    add_regular_tokens(tbl,options)
    tbl[#tbl+1]=layer_type==0 and "[BIOME:SUBTERRANEAN_WATER]" or "[BIOME:SUBTERRANEAN_CHASM]"
    if layer_type==0 then options.spheres.WATER=true end
    options.spheres[pick_random(evil_spheres)]=true
    options.do_water=layer_type==0
    populate_sphere_info(tbl,options)
    local rcp=get_random_creature_profile(options)
    add_body_size(tbl,math.max(10000000,rcp.min_size),options)
    tbl[#tbl+1]="[CREATURE_TILE:"..tile_string(rcp.tile).."]"
    build_procgen_creature(rcp,tbl,options)
    -- Weight is a float; all vanilla objects have weight 1
    return {creature=tbl,weight=0.15}
end