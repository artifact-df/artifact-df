-- make all large creatures into powers
btc1_tweaks.titan_worship=function(lines,options,add_to_body,add_to_body_unique,add_tweak_candidate)
	if options.body_size>=500000 then -- described as "very large", graphics size cutoff
		options.can_learn=true -- for flavor text
		lines[#lines+1]="[INTELLIGENT]"
		lines[#lines+1]="[SUPERNATURAL]" -- knows secrets according to their spheres
		lines[#lines+1]="[POWER]" -- impersonates deities
		lines[#lines+1]="[SPREAD_EVIL_SPHERES_IF_RULER]"
		lines[#lines+1]="[APPLY_CREATURE_VARIATION:AURA_TERROR]"
	end
end

-- rcp tweaks
btc1_tweaks.experiment_tweaks=function(lines,options,add_to_body,add_to_body_unique,add_tweak_candidate)
tweaks={
    WINGS={
        body=function(body_str,options) add_unique(body_str,"RCP_TWO_WINGS") end,
        has_desc_func=add_wings_func,
        flavor_adj={"winged"}
    },
    WINGS_FLIGHTLESS={
        body=function(body_str,options) add_unique(body_str,"RCP_TWO_FLIGHTLESS_WINGS") end,
        has_desc_func=add_wings_func,
        flavor_adj={"winged"}
    },
    TAIL={
        body=function(body_str,options)
        --UPGRADE
            if find_in_array_part(body_str,"RCP_TAIL") then 
                remove_item(body_str,"RCP_TAIL")
                if one_in(2) then
                    body_str[#body_str+1]="RCP_2_TAILS"
                    options.tail_count=2
                else
                    body_str[#body_str+1]="RCP_3_TAILS"
                    options.tail_count=3
                end
            else
                pick_random({
                    function()
                        body_str[#body_str+1]="RCP_TAIL"
                        options.tail_count=1
                    end,
                    function()
                        body_str[#body_str+1]="RCP_2_TAILS"
                        options.tail_count=2
                    end,
                    function()
                        body_str[#body_str+1]="RCP_3_TAILS"
                        options.tail_count=3
                    end
                })()
            end
        end,
        has_desc_func=function(options)
            local tail_num,thick_tail=1,false
            --above is for graphics, not implemented yet
            local str=""
            if find_in_array_part(options.body_string,"RCP_2_TAILS") then
                str=str.." It has two "
                tail_num=2
            elseif find_in_array_part(options.body_string,"RCP_3_TAILS") then
                str=str.." It has three "
                tail_num=3
            else
                str=str.." It has a "
            end
            str=str..pick_random({
                "long, hanging",--thick_tail=true
                "long, straight",--thick_tail=true
                "long, curly",
                "short",--tail_num=0
                "stubby",--tail_num=0
                "narrow"
            })

            if tail_num>1 then str=str.." tails"
            else str=str.." tail" end
            --[[
            proc_graphics stuff that was commented out
            ]]
            return str
        end
    },
    PROBOSCIS={
        body=function(body_str,options) add_unique(body_str,"RCP_PROBOSCIS") end,
        has_desc_func=function(options) return " It has a proboscis" end
    },
    TRUNK={
        body=function(body_str,options) add_unique(body_str,"RCP_TRUNK") end,
        has_desc_func=function(options)
            return pick_random({
                function() options.pcg_layering_modifier.TRUNK="LONG" return " It has a long, swinging trunk" end,
                function() options.pcg_layering_modifier.TRUNK="SHORT" return " It has a short trunk" end,
                function() options.pcg_layering_modifier.TRUNK="FAT" return " It has a fat, bulging trunk" end,
                function() options.pcg_layering_modifier.TRUNK="TWISTING" return " It has a twisting, jointed trunk" end,
                function() options.pcg_layering_modifier.TRUNK="CURLING" return " It has a curling trunk" end,
                function() options.pcg_layering_modifier.TRUNK="KNOBBY" return " It has a knobby trunk" end,
            })()
        end
    
    },
    SHELL={
        body=function(body_str,options) add_unique(body_str,"RCP_SHELL") end,
        has_desc_func=function(options)
            return pick_random({
                " It has a round shell",
                " It has a spiral shell",
                " It has a square shell",
                " It has a knobby shell",
                " It has an enormous shell",
                " It has a broad shell",
            })
        end
    },
    ANTENNAE={
        body=function(body_str,options) add_unique(body_str,"RCP_ANTENNAE") end,
        has_desc_func=function(options)
            return pick_random({
                function() options.pcg_layering_modifier.ANTENNA="LONG" return " It has a pair of long antennae" end,
                function() options.pcg_layering_modifier.ANTENNA="FAN" return " It has a pair of fan-like antennae" end,
                function() options.pcg_layering_modifier.ANTENNA="SPINDLY" return " It has a pair of spindly antennae" end,
                function() options.pcg_layering_modifier.ANTENNA="SQUAT" return " It has a pair of squat antennae" end,
                function() options.pcg_layering_modifier.ANTENNA="BRANCHING" return " It has a pair of branching antennae" end,
                function() options.pcg_layering_modifier.ANTENNA="KNOBBING" return " It has a pair of knobby antennae" end,
            })()
        end
    },
    HEAD_HORNS={
        body=function(body_str,options)
            local amt=trandom(4)+1
            add_unique(body_str,"RCP_"..tostring(amt).."_HEAD_HORN"..((amt>1) and "S" or ""))
        end,
        has_desc_func=function(options)
            local horn_num=1
            local str=" It has "
            if find_in_array_part(options.body_string,"RCP_2_HEAD_HORNS") then
                str=str.."two "
                horn_num=2
            elseif find_in_array_part(options.body_string,"RCP_2_HEAD_HORNS") then
                str=str.."three "
                horn_num=3
            elseif find_in_array_part(options.body_string,"RCP_2_HEAD_HORNS") then
                str=str.."four "
                horn_num=4
            else
                str=str.."a "
            end
            str=str..pick_random({
                function() options.pcg_layering_modifier.HORN="LONG_SPIRAL" return "long, spiral" end,
                function() options.pcg_layering_modifier.HORN="LONG_CURVING" return " long, curving" end,
                function() options.pcg_layering_modifier.HORN="SHORT" return "short" end,
                function() options.pcg_layering_modifier.HORN="STUBBY" return "stubby" end,
                function() options.pcg_layering_modifier.HORN="BROAD" return "broad" end,
                function() options.pcg_layering_modifier.HORN="LONG_STRAIGHT" return "long, straight" end,
            })()
            if horn_num>1 then
                str=str.." horns"
            else
                str=str.." horn"
            end
            options.pcg_layering_modifier.horn_count=horn_num
            return str
        end,
        flavor_adj={"skinless"}
    },
    LARGE_MANDIBLES={
        body=function(body_str,options) add_unique(body_str,"RCP_LARGE_MANDIBLES") end,
        has_desc_func=function(options) return " It has large mandibles" end
    },
    NO_EYES={
        body=function(body_str,options) options.eyes=false end,
        adj="eyeless",
        flavor_adj={"eyeless","blind"}
    },
    ONE_EYE={
        body=function(body_str,options)
            if options.eyes then
                body_str[#body_str+1]="RCP_1_EYE"
                options.eye_count=1
                options.pcg_layering[options.pcg_layering_base.."_EYE_ONE"]=true
            end
        end,
        adj="one-eyed",
        flavor_adj={"one-eyed"}
    },
    TWO_EYES={
        body=function(body_str,options)
            if options.eyes then
                body_str[#body_str+1]="RCP_2_EYES"
                options.eye_count=2
                options.pcg_layering[options.pcg_layering_base.."_EYE_TWO"]=true
            end
        end
    },
    THREE_EYES={
        body=function(body_str,options)
            if options.eyes then
                body_str[#body_str+1]="RCP_3_EYES"
                options.eye_count=3
                options.pcg_layering[options.pcg_layering_base.."_EYE_THREE"]=true
            end
        end,
        adj="three-eyed",
        flavor_adj={"three-eyed"}
    },
    BEAK_MISSING={
        body=function(body_str,options) options.beak,options.mouth=false,false end,
        adj="beakless",
    },
    NOSE_MISSING={
        body=function(body_str,options) options.nose=false end,
        adj="noseless",
    },
    LIDLESS_EYES={
        body=function(body_str,options) options.eyelids=false end,
        with_desc="with lidless eyes",
    },
    SKINLESS={body=function(body_str,options) options.eyelids,options.cheeks,options.throat=false,false,false end,
        surface=function(lines,options)
            options.pcg_layering_modifier.SURFACE_SKINLESS=true
            lines[#lines+1]="[BODY_DETAIL_PLAN:MONSTER_MATERIALS]"
            lines[#lines+1]="[REMOVE_MATERIAL:HAIR]"
            lines[#lines+1]="[REMOVE_MATERIAL:SKIN]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:MONSTER_TISSUES]"
            lines[#lines+1]="[REMOVE_TISSUE:HAIR]"
            lines[#lines+1]="[REMOVE_TISSUE:SKIN]"
        end,
        adj="skinless",
    },
    HAIR={
        surface=function(lines,options)
            options.pcg_layering_modifier.SURFACE_FUR=true
            lines[#lines+1]="[BODY_DETAIL_PLAN:MONSTER_MATERIALS]"
            if random_creature_class[options.r_class].material_template then
                lines[#lines+1]="[USE_MATERIAL_TEMPLATE:"..random_creature_class[options.r_class].material_template.."]"
            end
            lines[#lines+1]="[BODY_DETAIL_PLAN:MONSTER_TISSUES]"
            if random_creature_class[options.r_class].tissue_template then
                lines[#lines+1]="[USE_TISSUE_TEMPLATE:"..random_creature_class[options.r_class].tissue_template.."]"
            end
        end,
        color_surf="HAIR",
        adj="hairy",
        add_wings=function(options)
            options.bat_wings=true
            options.lacy_wings=false
            options.feathered_wings=false
            return "thin wings of stretched skin"
        end,
        color_desc=function(options)
            return ". Its "..world.descriptor.color[options.clp.color[1]].name.." hair is "..pick_random({
                "long and shaggy",
                "very curly",
                "short and even",
                "patchy",
                "unkempt",
                "long and straight",
                "long and wavy"
            })
        end
    },
    FEATHERS={surface=function(lines,options)
            options.pcg_layering_modifier.SURFACE_FEATHERS=true
            lines[#lines+1]="[BODY_DETAIL_PLAN:MONSTER_MATERIALS]"
            lines[#lines+1]="[REMOVE_MATERIAL:HAIR]"
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:FEATHER:FEATHER_TEMPLATE]"
            if random_creature_class[options.r_class].material_template then
                lines[#lines+1]="[USE_MATERIAL_TEMPLATE:"..random_creature_class[options.r_class].material_template.."]"
            end
            lines[#lines+1]="[BODY_DETAIL_PLAN:MONSTER_TISSUES]"
            lines[#lines+1]="[REMOVE_TISSUE:HAIR]"
            lines[#lines+1]="[USE_TISSUE_TEMPLATE:FEATHER:FEATHER_TEMPLATE]"
            if random_creature_class[options.r_class].tissue_template then
                lines[#lines+1]="[USE_TISSUE_TEMPLATE:"..random_creature_class[options.r_class].tissue_template.."]"
            end
        end,
        color_surf="FEATHER",
        adj="feathered",
        add_wings=function(options)
            options.bat_wings=false
            options.lacy_wings=false
            options.feathered_wings=true
            return options.btc2=="FEATHERS" and "wings" or "feathered wings"
        end,
        color_desc=function(options)
            return ". Its "..world.descriptor.color[options.clp.color[1]].name.." feathers are "..pick_random({
                "fluffed-out",
                "downy",
                "long and broad",
                "long and sparse",
                "patchy",
                "long and narrow",
            })
        end
    },
    SCALES={surface=function(lines,options)
            options.pcg_layering_modifier.SURFACE_SCALES=true
            lines[#lines+1]="[BODY_DETAIL_PLAN:MONSTER_MATERIALS]"
            if options.r_class~="FLESHY" then lines[#lines+1]="[REMOVE_MATERIAL:SKIN]" end
            lines[#lines+1]="[REMOVE_MATERIAL:HAIR]"
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:SCALE:MONSTER_SCALE_TEMPLATE]"
            if random_creature_class[options.r_class].material_template then
                lines[#lines+1]="[USE_MATERIAL_TEMPLATE:"..random_creature_class[options.r_class].material_template.."]"
            end
            lines[#lines+1]="[BODY_DETAIL_PLAN:MONSTER_TISSUES]"
            if options.r_class~="FLESHY" then lines[#lines+1]="[REMOVE_TISSUE:SKIN]" end
            lines[#lines+1]="[REMOVE_TISSUE:HAIR]"
            lines[#lines+1]="[USE_TISSUE_TEMPLATE:SCALE:MONSTER_TISSUE_SCALE_TEMPLATE]"
            if random_creature_class[options.r_class].tissue_template then
                lines[#lines+1]="[USE_TISSUE_TEMPLATE:"..random_creature_class[options.r_class].tissue_template.."]"
            end
        end,
        color_surf="SCALE",
        adj="scaly",
        add_wings=function(options)
            options.bat_wings=true
            options.lacy_wings=false
            options.feathered_wings=false
            return "thin wings of stretched skin"
        end,
        color_desc=function(options)
            return ". Its "..world.descriptor.color[options.clp.color[1]].name.." scales are "..pick_random({
                "small",
                "large",
                "round",
                "blocky",
                "jagged",
                "oval-shaped",
            }).." and "..pick_random({
                "overlapping",
                "set far apart",
                "close-set"
            })
        end
    },
    SKIN_BONES={surface=function(lines,options)
            options.pcg_layering_modifier.SURFACE_SKIN=true
            lines[#lines+1]="[BODY_DETAIL_PLAN:MONSTER_MATERIALS]"
            lines[#lines+1]="[REMOVE_MATERIAL:HAIR]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:MONSTER_TISSUES]"
            lines[#lines+1]="[REMOVE_TISSUE:HAIR]"
        end,
        color_surf="SKIN",
        adj="fleshy",
        add_wings=function(options)
            options.bat_wings=true
            options.lacy_wings=false
            options.feathered_wings=false
            return "thin wings of stretched skin"
        end,
        color_desc=function(options)
            return ". Its "..world.descriptor.color[options.clp.color[1]].name.." skin is "..pick_random({
                "waxy",
                "leathery",
                "warty",
                "sleek and smooth",
                "rough and cracked",
                "wrinkled",
            })
        end
    },
    SKIN={surface=function(lines,options)
        options.pcg_layering_modifier.SURFACE_SKIN=true
            lines[#lines+1]="[BODY_DETAIL_PLAN:MONSTER_MATERIALS]"
            lines[#lines+1]="[REMOVE_MATERIAL:HAIR]"
            lines[#lines+1]="[REMOVE_MATERIAL:BONE]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:MONSTER_TISSUES]"
            lines[#lines+1]="[REMOVE_TISSUE:HAIR]"
            lines[#lines+1]="[REMOVE_TISSUE:BONE]"
        end,
        color_surf="SKIN",
        adj="fleshy",
        add_wings=function(options)
            options.bat_wings=true
            options.lacy_wings=false
            options.feathered_wings=false
            return "thin wings of stretched skin"
        end,
        color_desc=function(options)
            return ". Its "..world.descriptor.color[options.clp.color[1]].name.." skin is "..pick_random({
                "waxy",
                "leathery",
                "warty",
                "sleek and smooth",
                "rough and cracked",
                "wrinkled",
            })
        end
    },
    EXOSKELETON={surface=function(lines,options)
            options.pcg_layering_modifier.SURFACE_SKIN=true
            lines[#lines+1]="[BODY_DETAIL_PLAN:MONSTER_MATERIALS]"
            lines[#lines+1]="[REMOVE_MATERIAL:HAIR]"
            lines[#lines+1]="[REMOVE_MATERIAL:SKIN]"
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:CHITIN:MONSTER_CHITIN_TEMPLATE]"
            lines[#lines+1]="[BODY_DETAIL_PLAN:MONSTER_TISSUES]"
            lines[#lines+1]="[REMOVE_TISSUE:HAIR]"
            lines[#lines+1]="[REMOVE_TISSUE:BONE]"
            lines[#lines+1]="[USE_TISSUE_TEMPLATE:CHITIN:CHITIN_TEMPLATE]"
        end,
        color_surf="CHITIN",
        adj="armored",
        add_wings=function(options)
            options.bat_wings=false
            options.lacy_wings=true
            options.feathered_wings=false
            return "lacy wings"
        end,
        color_desc=function(options)
            return ". Its "..world.descriptor.color[options.clp.color[1]].name.." exoskeleton is "..pick_random({
                "waxy",
                "leathery",
                "warty",
                "sleek and smooth",
                "rough and cracked",
                "wrinkled",
            })
        end
    },
    SIX_LEGGED={
        adj="six-legged",
    },
    EIGHT_LEGGED={
        adj="eight-legged",
    },
    MAKE_HUMANOID={
        form_desc="in humanoid form",
        twisted_desc="twisted into humanoid form"
    },
    RIBS_EXTERNAL={
        body=function(body_string,options)
            options.pcg_layering_modifier.EXTERNAL_RIBS=true
        end,
        with_desc="with external ribs"
    }
}
end

-- redefined necromancy, increased summon wait periods
interactions.secrets.necromancer=function(idx,sph)
    if sph and sph~="DEATH" then return nil end -- no sph means it generates anyway!
    local ropar=random_object_parameters
    local animate_token=ropar.token_prefix.."SECRET_ANIMATE_"..tostring(idx)
    local raise,experimenter,summon,ghoul,ghost=true,one_in(3),one_in(3),one_in(3),false
    if not (experimenter or summon or ghoul) then
        local pick=trandom(3)
        experimenter=pick==0
        summon=pick==1
        ghoul=pick==2
    end
    raise = raise and world.param.allow_necromancer_lieutenants
    experimenter = experimenter and world.param.allow_necromancer_experiments
    ghoul = ghoul and world.param.allow_necromancer_ghouls
    local bogeyman=ropar.night_creature_def_number_bogeyman>0
    local nightmare=ropar.night_creature_def_number_nightmare>0
    summon = summon and world.param.allow_necromancer_summons and (bogeyman or nightmare)
    if not one_in(10) then
        bogeyman = bogeyman and (one_in(2) or not nightmare)
        nightmare = not bogeyman
    end
    local tbl={}
    tbl=split_to_lines(tbl,[[
        [IS_NAME:the secrets of life and death]
        [IS_SPHERE:DEATH]
        ]]..(summon and "[IS_SPHERE:NIGHTMARES]" or "")..[[
        [IS_SECRET_GOAL:IMMORTALITY]
        [IS_SECRET:SUPERNATURAL_LEARNING_POSSIBLE]
        [IS_SECRET:MUNDANE_RESEARCH_POSSIBLE]
        [IS_SECRET:MUNDANE_TEACHING_POSSIBLE]
        [IS_SECRET:MUNDANE_RECORDING_POSSIBLE:BOOK_INSTRUCTION:SECRET_DEATH]
    [I_TARGET:A:CREATURE]
        [IT_LOCATION:CONTEXT_CREATURE]
        [IT_REQUIRES:MORTAL]
        [IT_REQUIRES:CAN_LEARN]
        [IT_REQUIRES:CAN_SPEAK]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:WERECURSE]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:VAMPCURSE]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:DISTURBANCE_CURSE]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_UNDEAD]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_GHOST]
        [IT_CANNOT_HAVE_SYNDROME_CLASS:GHOUL]
		[IT_CANNOT_HAVE_SYNDROME_CLASS:DISTURBED_DEAD]
		[IT_CANNOT_HAVE_SYNDROME_CLASS:SECRET] -- new
		[IT_IMMUNE_CREATURE:DWARF:ALL]// only humans can discover the secret
		[IT_IMMUNE_CREATURE:HALFLING_CHP:ALL]
		[IT_IMMUNE_CREATURE:DARK_ELF_FFF:ALL]
		[IT_IMMUNE_CREATURE:ELF:ALL]
		[IT_IMMUNE_CREATURE:HIGH_ELF_CHP:ALL]
		[IT_IMMUNE_CREATURE:GOBLIN:ALL]
		[IT_IMMUNE_CREATURE:ORC_CHP:ALL]
		[IT_IMMUNE_CREATURE:KOBOLD:ALL]
		[IT_IMMUNE_CLASS:ANIMAL_PERSON]
    [I_EFFECT:ADD_SYNDROME]
        [IE_TARGET:A]
        [IE_IMMEDIATE]
        [IE_ARENA_NAME:Necromancer]
        [SYNDROME]
            [SYN_CLASS:NECROMANCER]
			[SYN_CLASS:SECRET]// new identifier
			[SYN_IMMUNE_CLASS:DWARF_GUILD]// new
            [SYN_CONCENTRATION_ADDED:1000:0]//just in case
            [CE_DISPLAY_TILE:TILE:165:5:0:1:START:0:ABRUPT]
            [CE_DISPLAY_NAME:NAME:necromancer:necromancers:necromantic:START:0:ABRUPT]
            [CE_ADD_TAG:NOEXERT:NO_AGING:NO_EAT:NO_DRINK:NO_SLEEP:NO_PHYS_ATT_GAIN:NO_PHYS_ATT_RUST:STERILE:NOFEAR]// made necromancers sterile and nofear
            ]]..(experimenter and ":NIGHT_CREATURE_EXPERIMENTER" or "")..[[:START:0:ABRUPT]
            [CE_CHANGE_PERSONALITY:FACET:ANXIETY_PROPENSITY:40:FACET:TRUST:-40:START:0:ABRUPT]// reduced from 50
			[CE_CHANGE_PERSONALITY:FACET:LOVE_PROPENSITY:-50:FACET:GREGARIOUSNESS:-20:FACET:BASHFUL:-20:FACET:PRIVACY:20:FACET:TOLERANT:20:FACET:EMOTIONALLY_OBSESSIVE:-50:FACET:SWAYED_BY_EMOTIONS:-50:START:0:ABRUPT]// new personality alterations
			[CE_MENT_ATT_CHANGE:EMPATHY:75:0]// less empathetic
		    [CE_MATERIAL_FORCE_MULTIPLIER:MAT_MULT:NONE:NONE:1:2:ABRUPT]// 50% resistant to all materials
			[CE_MATERIAL_FORCE_MULTIPLIER:MAT_MULT:INORGANIC:SILVER:5:1:ABRUPT]// 20% vulnerability to silver
		    [CE_MATERIAL_FORCE_MULTIPLIER:MAT_MULT:INORGANIC:MITHRIL:2:1:ABRUPT]// 50% vulnerability to mithril
            [CE_CAN_DO_INTERACTION:START:0:ABRUPT]
                [CDI:ADV_NAME:Animate corpse]
                str="[CDI:INTERACTION:]]..animate_token..[[]
                [CDI:TARGET:A:LINE_OF_SIGHT]
                [CDI:TARGET_RANGE:A:10]
                [CDI:VERB:gesture:gestures:NA]
                [CDI:TARGET_VERB:shudder and begin to move:shudders and begins to move]
                [CDI:WAIT_PERIOD:100]
                [CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_ANIMATE_CORPSE]
			[CE_CAN_DO_INTERACTION:START:0:ABRUPT]-- new ability
				[CDI:ADV_NAME:Summon skeleton]
				[CDI:INTERACTION:SUMMON_SKELETON]
				[CDI:VERB:gesture:gestures:NA]
				[CDI:TARGET_VERB:breaks free from the ground:breaks free from the ground]
				[CDI:WAIT_PERIOD:600]
                [CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_ANIMATE_CORPSE]
            [CAN_DO_INTERACTION:AURA_FEAR:START:0:ABRUPT]-- new ability
                [CDI:ADV_NAME:Fearsome]
                [CDI:USAGE_HINT:ATTACK]
                [CDI:TARGET:A:LINE_OF_SIGHT]
                [CDI:TARGET_RANGE:A:4]
                [CDI:MAX_TARGET_NUMBER:A:99]
                [CDI:TARGET_VERB:are shaken:is visibly afraid:NA]
                [CDI:FREE_ACTION]
                [CDI:WAIT_PERIOD:10]
            [CAN_DO_INTERACTION:REGENERATE_GOLEM]-- regeneration heal ability
                [CDI:ADV_NAME:Regenerate]
                [CDI:USAGE_HINT:FLEEING]
                [CDI:USAGE_HINT:DEFEND]
                [CDI:BP_REQUIRED:BY_CATEGORY:HEAD]
                [CDI:VERB:reform your body:begins to reform:begin to reform]
                [CDI:TARGET:A:SELF_ONLY:TOUCHABLE]
                [CDI:TARGET_RANGE:A:1]
                [CDI:MAX_TARGET_NUMBER:A:1]
                [CDI:FREE_ACTION]
                [CDI:WAIT_PERIOD:100]
        ]])
    local adj = pick_random(necromancer_raise_adjectives)
    local noun = pick_random(necromancer_raise_nouns)
    local raise_name = adj.." "..noun[1]
    local raise_name_plural = adj.." "..noun[2]
    local ghost_adj=pick_random(necromancer_ghost_adjs)
    local ghost_noun=pick_random(necromancer_ghost_nouns)
    local ghost_name_sing = ghost_adj.." "..ghost_noun[1]
    local ghost_name_plur = ghost_adj.." "..ghost_noun[2]
    local iu_token=ropar.token_prefix.."SECRET_UNDEAD_RES_"..tostring(idx)
    local ghost_token=ropar.token_prefix.."SECRET_UNDEAD_GST_"..tostring(idx)
    local sum_b_token=ropar.token_prefix.."SECRET_SUMMON_B_"..tostring(idx)
    local sum_n_token=ropar.token_prefix.."SECRET_SUMMON_N_"..tostring(idx)
    local ghoul_token=ropar.token_prefix.."SECRET_GHOUL_"..tostring(idx)
    if raise then
        tbl=split_to_lines(tbl,[[
        [CE_CAN_DO_INTERACTION:START:0:ABRUPT]
        [CDI:ADV_NAME:Raise ]]..raise_name..[[]
        [CDI:INTERACTION:]]..iu_token..[[]
        [CDI:TARGET:A:LINE_OF_SIGHT]
        [CDI:TARGET_RANGE:A:10]
        [CDI:VERB:gesture:gestures:NA]
        [CDI:TARGET_VERB:shudder and begin to move:shudders and begins to move]
    //************************ RITUALS
        [CDI:WAIT_PERIOD:100]
        [CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_RAISE_INTELLIGENT_UNDEAD]
    ]])
    end
    if bogeyman then
        tbl=split_to_lines(tbl,[[
        [CE_CAN_DO_INTERACTION:START:0:ABRUPT]
        [CDI:ADV_NAME:Summon bogeymen]
        [CDI:INTERACTION:]]..sum_b_token..[[]
        [CDI:VERB:call upon the night:calls upon the night:NA]
        [CDI:WAIT_PERIOD:100]
        [CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_SUMMON_BOGEYMAN]
    ]])
    end
    if nightmare then
        tbl=split_to_lines(tbl,[[
        [CE_CAN_DO_INTERACTION:START:0:ABRUPT]
        [CDI:ADV_NAME:Summon nightmare]
        [CDI:INTERACTION:]]..sum_n_token..[[]
        [CDI:VERB:call upon the night:calls upon the night:NA]
        [CDI:WAIT_PERIOD:12000]
        [CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_SUMMON_BOGEYMAN]
    ]])
    end
    if ghoul then
        tbl=split_to_lines(tbl,[[
        [CE_CAN_DO_INTERACTION:START:0:ABRUPT]
        [CDI:ADV_NAME:Create ghoul]
        [CDI:INTERACTION:]]..ghoul_token..[[]
        [CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_SUMMON_BOGEYMAN]
    ]])
    end
    -- FIXING GHOSTS
    if false and ghost then
        tbl=split_to_lines(tbl,[[
        [CE_CAN_DO_INTERACTION:START:0:ABRUPT]
        [CDI:ADV_NAME:Raise ]]..ghost_name_sing..[[]
        [CDI:INTERACTION:]]..ghost_token..[[]
        [CDI:TARGET:A:LINE_OF_SIGHT]
        [CDI:TARGET_RANGE:A:10]
        [CDI:VERB:gesture:gestures:NA]
        [CDI:TARGET_VERB:shudder and a spirit rises:shudders and a spirit rises]
    //************************ RITUALS
        [CDI:WAIT_PERIOD:100]
    ]])
    end
    tbl[#tbl+1]="[INTERACTION:"..animate_token.."]"
    tbl=add_generated_info(tbl)
    tbl=table_merge(tbl,basic_animation(false))
    if raise then
        tbl[#tbl+1]="[INTERACTION:"..iu_token.."]"
        tbl=add_generated_info(tbl)
        local t,et=basic_lieutenant(raise_name,raise_name_plural,iu_token)
        tbl=table_merge(tbl,table_merge(t,et))
    end
    if bogeyman then
        tbl[#tbl+1]="[INTERACTION:"..sum_b_token.."]"
        tbl=add_generated_info(tbl)
        tbl=split_to_lines(tbl,[[
            [I_TARGET:A:LOCATION]
            [IT_LOCATION:CONTEXT_LOCATION]
        [I_TARGET:B:LOCATION]
            [IT_LOCATION:RANDOM_NEARBY_LOCATION:A:5]
        [I_EFFECT:SUMMON_UNIT]
            [IE_TARGET:B]
            [IE_IMMEDIATE]
            [IE_CREATURE_CASTE_FLAG:NIGHT_CREATURE_BOGEYMAN]
            [IE_TIME_RANGE:200:300]
        ]])
    end
    if nightmare then
        tbl[#tbl+1]="[INTERACTION:"..sum_n_token.."]"
        tbl=add_generated_info(tbl)
        tbl=split_to_lines(tbl,[[
            [I_TARGET:A:LOCATION]
            [IT_LOCATION:CONTEXT_LOCATION]
        [I_TARGET:B:LOCATION]
            [IT_LOCATION:RANDOM_NEARBY_LOCATION:A:5]
        [I_EFFECT:SUMMON_UNIT]
            [IE_TARGET:B]
            [IE_IMMEDIATE]
            [IE_CREATURE_CASTE_FLAG:NIGHT_CREATURE_NIGHTMARE]
            [IE_TIME_RANGE:200:300]
        ]])
    end
    if false and ghost then
        tbl[#tbl+1]="[INTERACTION:"..ghost_token.."]"
        tbl=add_generated_info(tbl)
        tbl=split_to_lines(tbl,[[
					[I_TARGET:A:CORPSE]
						[IT_LOCATION:CONTEXT_ITEM]
						[IT_AFFECTED_CLASS:GENERAL_POISON]
						[IT_REQUIRES:FIT_FOR_RESURRECTION]
						[IT_REQUIRES:CAN_LEARN]
						[IT_FORBIDDEN:NOT_LIVING]
						[IT_MANUAL_INPUT:corpses]
						[IT_CANNOT_HAVE_SYNDROME_CLASS:WERECURSE]
						[IT_CANNOT_HAVE_SYNDROME_CLASS:VAMPCURSE]
						[IT_CANNOT_HAVE_SYNDROME_CLASS:DISTURBANCE_CURSE]
						[IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_UNDEAD]
						[IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_GHOST]
						[IT_CANNOT_HAVE_SYNDROME_CLASS:GHOUL]
					[I_EFFECT:RAISE_GHOST]
						[IE_TARGET:A]
						[IE_IMMEDIATE]
						[SYNDROME]
							[SYN_CLASS:RAISED_GHOST]
							[SYN_CONCENTRATION_ADDED:1000:0]//just in case
							[CE_DISPLAY_TILE:TILE:165:7:0:1:START:0:ABRUPT]
                            [CE_DISPLAY_NAME:NAME:]]..ghost_name..":"..ghost_name_plural..":"..ghost_name..[[:START:0:ABRUPT]
							[CE_PHYS_ATT_CHANGE:STRENGTH:200:1000:TOUGHNESS:200:1000:START:0:ABRUPT]
							[CE_ADD_TAG:NO_AGING:NOT_LIVING:STERILE:EXTRAVISION:NOEXERT:NOPAIN:NOBREATHE:NOSTUN:NONAUSEA:NO_DIZZINESS:NO_FEVERS:NOEMOTION:PARALYZEIMMUNE:NOFEAR:NO_EAT:NO_DRINK:NO_SLEEP:NO_PHYS_ATT_GAIN:NO_PHYS_ATT_RUST:NOTHOUGHT:NO_THOUGHT_CENTER_FOR_MOVEMENT:NO_CONNECTIONS_FOR_MOVEMENT:START:0:ABRUPT]
							[CE_REMOVE_TAG:HAS_BLOOD:TRANCES:MISCHIEVOUS:START:0:ABRUPT]
        ]])
        local t,et=basic_lieutenant_powers(ghost_token)
        tbl=table_merge(tbl,table_merge(t,et))
    end
    if ghoul then
        tbl[#tbl+1]="[INTERACTION:"..ghoul_token.."]"
        tbl[#tbl+1]="[EXPERIMENT_ONLY]"
        local adj = pick_random(ghoul_adjectives)
        local noun = pick_random(ghoul_nouns)
        local g_name_sing=adj.." "..noun[1]
        local g_name_plur=adj.." "..noun[2]
        tbl=add_generated_info(tbl)
        tbl=split_to_lines(tbl,[[
            [I_SOURCE:EXPERIMENT]
            [IS_HIST_STRING_1: infected ]
            [IS_HIST_STRING_2: with a contagious ghoulish condition]
            [IS_TRIGGER_STRING_SECOND:have]
            [IS_TRIGGER_STRING_THIRD:has]
            [IS_TRIGGER_STRING:been infected with a contagious ghoulish condition]
        [I_SOURCE:ATTACK]
            [IS_HIST_STRING_1: bit ]
            [IS_HIST_STRING_2:, passing on the ghoulish condition]
        [I_TARGET:A:CREATURE]
            [IT_LOCATION:CONTEXT_CREATURE]
            [IT_AFFECTED_CLASS:GENERAL_POISON]
            [IT_FORBIDDEN:NOT_LIVING]
            [IT_CANNOT_HAVE_SYNDROME_CLASS:WERECURSE]
            [IT_CANNOT_HAVE_SYNDROME_CLASS:VAMPCURSE]
            [IT_CANNOT_HAVE_SYNDROME_CLASS:DISTURBANCE_CURSE]
            [IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_UNDEAD]
            [IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_GHOST]
            [IT_CANNOT_HAVE_SYNDROME_CLASS:GHOUL]
            [IT_MANUAL_INPUT:victim]
        [I_EFFECT:ADD_SYNDROME]
            [IE_TARGET:A]
            IE_IMMEDIATE commented out on purpose
            [IE_ARENA_NAME:Infected ghoul]
            [SYNDROME]
                [SYN_CLASS:GHOUL]
                [SYN_CONCENTRATION_ADDED:1000:0]//just in case
                [CE_FLASH_TILE:TILE:165:4:0:1:FREQUENCY:2000:1000:START:0:ABRUPT]
                [CE_DISPLAY_NAME:NAME:]]..g_name_sing..":"..g_name_plur..":"..g_name_sing..[[:START:0:ABRUPT]
                CE_PHYS_ATT_CHANGE:STRENGTH:130:0:TOUGHNESS:300:1000:START:0:ABRUPT commented out
                1/3 chance CE_SPEED_CHANGE:SPEED_PERC:60:START:0:ABRUPT
                else 1/2 chance CE_SPEED_CHANGE:SPEED_PERC:20:START:0:ABRUPT
                [CE_ADD_TAG:NO_AGING:NOT_LIVING:OPPOSED_TO_LIFE:EXTRAVISION:NOEXERT:NOPAIN:NOBREATHE:NOSTUN:NONAUSEA:NO_DIZZINESS:NO_FEVERS:NOEMOTION:PARALYZEIMMUNE:NOFEAR:NO_EAT:NO_DRINK:NO_SLEEP:NO_PHYS_ATT_GAIN:NO_PHYS_ATT_RUST:NOTHOUGHT:NO_THOUGHT_CENTER_FOR_MOVEMENT:NO_CONNECTIONS_FOR_MOVEMENT:START:0:ABRUPT]
                [CE_REMOVE_TAG:TRANCES:MISCHIEVOUS:START:0:ABRUPT]
                [CE_SPECIAL_ATTACK_INTERACTION:INTERACTION:]]..ghoul_token..":BP:BY_CATEGORY:MOUTH:BP:BY_CATEGORY:TOOTH:START:0:ABRUPT]"
        )
    end
    local spheres={"DEATH"}
    if summon then spheres[2]="NIGHTMARES" end
    return {raws=tbl,weight=1,spheres=spheres}
end

-- redefined vampires
interactions.curse.major.vampire=function(idx,tok)
    return {raws={
    "[IS_HIST_STRING_1: cursed ]",
    "[IS_HIST_STRING_2: to prowl the night in search of blood]",
    "[IS_TRIGGER_STRING_SECOND:have]",
    "[IS_TRIGGER_STRING_THIRD:has]",
    "[IS_TRIGGER_STRING:been cursed to prowl the night in search of blood!]",
"[I_SOURCE:INGESTION]",
    "[IS_HIST_STRING_1: consumed the tainted blood of ]",
    "[IS_HIST_STRING_2: and was cursed]",
"[I_SOURCE:ATTACK]",--new
    "[IS_HIST_STRING_1: bit ]",
    "[IS_HIST_STRING_2: passing on the vampire curse]",
"[I_TARGET:A:CREATURE]",
    "[IT_LOCATION:CONTEXT_CREATURE]",
    "[IT_REQUIRES:CAN_LEARN]",
    "[IT_REQUIRES:HAS_BLOOD]",
    "[IT_FORBIDDEN:NOT_LIVING]",
    "[IT_FORBIDDEN:SUPERNATURAL]",
    "[IT_CANNOT_HAVE_SYNDROME_CLASS:WERECURSE]",
    "[IT_CANNOT_HAVE_SYNDROME_CLASS:VAMPCURSE]",
    "[IT_CANNOT_HAVE_SYNDROME_CLASS:DISTURBANCE_CURSE]",
    "[IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_UNDEAD]",
    "[IT_CANNOT_HAVE_SYNDROME_CLASS:RAISED_GHOST]",
    "[IT_CANNOT_HAVE_SYNDROME_CLASS:GHOUL]",
"[I_EFFECT:ADD_SYNDROME]",
    "[IE_TARGET:A]",
    "[IE_IMMEDIATE]",
    "[IE_ARENA_NAME:Vampire]",
    "[SYNDROME]",
    --SOME STANDARD UNDEAD PROPERTIES, BUT NOT ALL OF THEM
        "[SYN_CLASS:VAMPCURSE]",
        "[SYN_CONCENTRATION_ADDED:1000:0]",--just in case
        "[CE_ADD_TAG:BLOODSUCKER:NO_AGING:STERILE:NOT_LIVING:NOEXERT:NOPAIN:NOBREATHE:NOSTUN:NONAUSEA:NO_DIZZINESS:NO_FEVERS:PARALYZEIMMUNE:NO_EAT:NO_DRINK:NO_SLEEP:NO_PHYS_ATT_GAIN:NO_PHYS_ATT_RUST:START:0:ABRUPT]",
		"[CE_PHYS_ATT_CHANGE:STRENGTH:50:0:TOUGHNESS:50:0:AGILITY:50:0:ENDURANCE:50:0:DISEASE_RESISTANCE:50:0:START:0:ABRUPT]",-- weakens the target always
		"[CE_SPEED_CHANGE:SPEED_PERC:80:START:0:ABRUPT]",
		"[CE_MENT_ATT_CHANGE:FOCUS:50:0:START:0:ABRUPT]",
		"[CE_MENT_ATT_CHANGE:INTUITION:50:0:START:0:ABRUPT]",
		"[CE_MENT_ATT_CHANGE:SPATIAL_SENSE:50:0:START:0:ABRUPT]",
		"[CE_MENT_ATT_CHANGE:KINESTHETIC_SENSE:50:0:START:0:ABRUPT]",
		"[CE_MENT_ATT_CHANGE:WILLPOWER:50:0:START:0:ABRUPT]",
		"[CE_SPECIAL_ATTACK_INTERACTION:INTERACTION:"..tok..":BP:BY_CATEGORY:MOUTH:BP:BY_CATEGORY:TOOTH:START:0:ABRUPT]",-- vampires can spread vampirism similar to werecreatures
		"[CE_MATERIAL_FORCE_MULTIPLIER:MAT_MULT:NONE:NONE:1:2:ABRUPT]",-- 50% resistant to all materials
		"[CE_MATERIAL_FORCE_MULTIPLIER:MAT_MULT:INORGANIC:SILVER:5:1:ABRUPT]",-- 20% vulnerability to silver
		"[CE_MATERIAL_FORCE_MULTIPLIER:MAT_MULT:INORGANIC:MITHRIL:2:1:ABRUPT]",-- 50% vulnerability to mithril
        "[CE_BODY_MAT_INTERACTION:MAT_TOKEN:RESERVED_BLOOD:START:0:ABRUPT]",
        "[CE:INTERACTION:"..tok.."]",
            "[CE:SYNDROME_TAG:SYN_INGESTED]",
                    "[CE:SYNDROME_TAG:SYN_INJECTED]",
        "[CE_DISPLAY_TILE:TILE:165:4:0:0:START:0:CAN_BE_HIDDEN:ABRUPT]",
		"[CE_CHANGE_PERSONALITY:FACET:STRESS_VULNERABILITY:-25:FACET:ANXIETY_PROPENSITY:25:FACET:LOVE_PROPENSITY:-66:BASHFUL:-25:FACET:PRIVACY:66:FACET:TRUST:-66:FACET:TOLERANT:25:FACET:EMOTIONALLY_OBSESSIVE:-66:FACET:SWAYED_BY_EMOTIONS:-66:START:0:ABRUPT]",--new
        "[CE_DISPLAY_NAME:NAME:vampire:vampires:vampiric:START:0:CAN_BE_HIDDEN:ABRUPT]",
        "[CE_BP_APPEARANCE_MODIFIER:START:0:BP:BY_CATEGORY:TOOTH:APPEARANCE_MODIFIER:LENGTH:150:ABRUPT]",
            "[CE:COUNTER_TRIGGER:DRINKING_BLOOD:1:NONE:REQUIRED]",
		"[CE_BP_APPEARANCE_MODIFIER:START:0:BP:BY_CATEGORY:TOOTH:APPEARANCE_MODIFIER:BROADNESS:75:ABRUPT]",-- new, narrower teeth
			"[CE:COUNTER_TRIGGER:DRINKING_BLOOD:1:NONE:REQUIRED]",
        "[CE_SENSE_CREATURE_CLASS:START:0:CLASS:GENERAL_POISON:15:4:0:1:ABRUPT]"
		"[CE_PHYS_ATT_CHANGE:STRENGTH:250:100:TOUGHNESS:250:100:AGILITY:250:100:ENDURANCE:250:100:DISEASE_RESISTANCE:250:100:START:0:ABRUPT]",-- Strengthens the target
			"[CE:COUNTER_TRIGGER:TIME_SINCE_SUCKED_BLOOD:NONE:2400:REQUIRED:DWF_STRETCH:144]",-- (2 day duration)  Prevents the above strengthening effect from working unless the target has recently sucked blood (vampires become Thirsty at 1200)
		"[CE_SPEED_CHANGE:SPEED_PERC:120:START:0:ABRUPT]",
			"[CE:COUNTER_TRIGGER:TIME_SINCE_SUCKED_BLOOD:NONE:2400:REQUIRED:DWF_STRETCH:144]",
		"[CE_MENT_ATT_CHANGE:FOCUS:250:100:START:0:ABRUPT]",
			"[CE:COUNTER_TRIGGER:TIME_SINCE_SUCKED_BLOOD:NONE:2400:REQUIRED:DWF_STRETCH:144]",
		"[CE_MENT_ATT_CHANGE:INTUITION:250:100:START:0:ABRUPT]",
			"[CE:COUNTER_TRIGGER:TIME_SINCE_SUCKED_BLOOD:NONE:2400:REQUIRED:DWF_STRETCH:144]",
		"[CE_MENT_ATT_CHANGE:SPATIAL_SENSE:250:100:START:0:ABRUPT]",
			"[CE:COUNTER_TRIGGER:TIME_SINCE_SUCKED_BLOOD:NONE:2400:REQUIRED:DWF_STRETCH:144]",
		"[CE_MENT_ATT_CHANGE:KINESTHETIC_SENSE:250:100:START:0:ABRUPT]",
			"[CE:COUNTER_TRIGGER:TIME_SINCE_SUCKED_BLOOD:NONE:2400:REQUIRED:DWF_STRETCH:144]",
		"[CE_MENT_ATT_CHANGE:WILLPOWER:250:100:START:0:ABRUPT]",
			"[CE:COUNTER_TRIGGER:TIME_SINCE_SUCKED_BLOOD:NONE:2400:REQUIRED:DWF_STRETCH:144]",
		"[CE_ADD_TAG:CRAZED]",--goes berserk after 6 months of no blood
			"[CE:COUNTER_TRIGGER:TIME_SINCE_SUCKED_BLOOD:NONE:201600:REQUIRED:DWF_STRETCH:144]",
		"[CE_REMOVE_TAG:NOEXERT:NOPAIN:NOSTUN:NONAUSEA:EXTRAVISION:NO_DIZZINESS:NO_FEVERS:NO_PHYS_ATT_RUST:START:0:ABRUPT]",
			"[CE:COUNTER_TRIGGER:TIME_SINCE_SUCKED_BLOOD:NONE:201600:REQUIRED:DWF_STRETCH:144]",
		"[CE_CAN_DO_INTERACTION:START:0:ABRUPT]",-- new ability
		    "[CDI:ADV_NAME:Vanish]",
		    "[CDI:INTERACTION:VAMP_STEALTH]",
		    "[CDI:TARGET:A:SELF_ONLY]",
		    "[CDI:TARGET_RANGE:A:1]",
		    "[CDI:USAGE_HINT:FLEEING]",
		    "[CDI:VERB:begin to vanish:begins to vanish:NA]",
		    "[CDI:TARGET_VERB:vanish completely:vanishes completely]",
		    "[CDI:WAIT_PERIOD:172800]",
		"[CAN_DO_INTERACTION:REGENERATE_GOLEM]",-- regeneration heal ability
		    "[CDI:ADV_NAME:Regenerate]",
		    "[CDI:USAGE_HINT:FLEEING]",
		    "[CDI:USAGE_HINT:DEFEND]",
		    "[CDI:BP_REQUIRED:BY_CATEGORY:HEAD]",
		    "[CDI:VERB:reform your body:begins to reform:begin to reform]",
		    "[CDI:TARGET:A:SELF_ONLY:TOUCHABLE]",
		    "[CDI:TARGET_RANGE:A:1]",
		    "[CDI:MAX_TARGET_NUMBER:A:1]",
		    "[CDI:FREE_ACTION]",
		    "[CDI:WAIT_PERIOD:100]",
    },weight=1}
end

-- adamantine alloys
preprocess.adamantine_alloys=function()
    if not random_object_parameters.main_world_randoms then return end
    local l=get_debug_logger(2)
    local lines={}
    local reaction_lines={}
    local reaction_names={}
    local adamantine=world.inorganic.inorganic.ADAMANTINE
    if not adamantine then return end
    local adamantine_color=world.descriptor.color[world.descriptor.color_pattern[adamantine.material.color_pattern.SOLID].color[1]]
    local adamantine_modulus = 2500000  --mildly arbitrary, just below the theoretical limit
    l("Starting")
    local done_category=false
    for k,v in ipairs(world.inorganic.inorganic) do
        if not v.flags.SPECIAL and v.material.flags.IS_METAL then
            l(v.token)
            local token="GEN_ADAMANTINE_"..v.token
            lines[#lines+1]="[INORGANIC:"..token.."]"
            add_generated_info(lines)
            lines[#lines+1]="[USE_MATERIAL_TEMPLATE:METAL_TEMPLATE]"
            for kk,vv in pairs(v.material.adj) do
                lines[#lines+1]="[STATE_ADJ:"..kk..":adamantine "..vv.."]" --"adamantine molten steel"? it's fine
            end
            for kk,vv in pairs(v.material.name) do
                lines[#lines+1]="[STATE_NAME:"..kk..":adamantine "..vv.."]"
            end
            l(2)
            local mat_values={}
            -- Find the ratio for which you get closest to (but not below) 2000000 in the material's worst property
            local worst=math.min(v.material.yield.IMPACT,v.material.fracture.SHEAR)
            local wafers=1
            local bars=1
            if worst < 2000000 then
                local ratio = (2000000-3*worst)/1000000
                local best_diff=1
                for i=1,10 do
                    local wafer_amt=i*ratio
                    if wafer_amt>1 and wafer_amt<20 and math.ceil(wafer_amt)-wafer_amt<best_diff then
                        best_diff=math.ceil(wafer_amt)-wafer_amt
                        wafers=math.ceil(wafer_amt)
                        bars=i
                    end
                end
            end
            local avg_denom=1/(bars*3+wafers) -- Multiplication just a bit faster than division, we're rounding at the end anyway
            local solid_cl=nil
            for kk,vv in pairs(v.material.color_pattern) do
                -- time to get silly
                local this_color=world.descriptor.color[world.descriptor.color_pattern[vv].color[1]]
                local wanted_color={
                    r=(this_color.r*bars*3+adamantine_color.r*wafers)*avg_denom,
                    g=(this_color.g*bars*3+adamantine_color.g*wafers)*avg_denom,
                    b=(this_color.b*bars*3+adamantine_color.b*wafers)*avg_denom,
                }
                local best_total_diff=1000000000
                local best_clp=nil
                for _,clp in ipairs(world.descriptor.color_pattern) do
                    if clp.pattern=="MONOTONE" then
                        local cl=world.descriptor.color[clp.color[1]]
                        local diff=math.abs(wanted_color.r-cl.r)+math.abs(wanted_color.b-cl.b)+math.abs(wanted_color.g-cl.g)
                        if diff<best_total_diff then
                            best_clp=clp
                            best_total_diff=diff
                        end
                    end
                end
                lines[#lines+1]="[STATE_COLOR:"..kk..":"..best_clp.token.."]"
                if kk=="SOLID" then solid_cl=world.descriptor.color[best_clp.color[1]] end
            end
            local color_str=solid_cl.col_f..":0:"..solid_cl.col_br
            l(color_str)
            lines[#lines+1]="[DISPLAY_COLOR:"..color_str.."]"
            lines[#lines+1]="[BUILD_COLOR:"..color_str.."]"
            lines[#lines+1]="[ITEMS_METAL][ITEMS_HARD][ITEMS_SCALED][ITEMS_BARRED]"
            lines[#lines+1]="[SPECIAL]"
            if v.material.flags.ITEMS_DIGGER then
                lines[#lines+1]="[ITEMS_DIGGER]"
            end
            local function new_value(str)
                mat_values[str]=mat_values[str] or math.floor((adamantine.material[str]*wafers+v.material[str]*bars*3)*avg_denom+0.5)
                l(str,mat_values[str])
                return mat_values[str]
            end
            local function new_value_nested(str1,str2)
                mat_values[str1..str2]=mat_values[str1..str2] or math.floor((adamantine.material[str1][str2]*wafers+v.material[str1][str2]*bars*3)/(bars*3+wafers)+0.5)
                l(str1..str2,mat_values[str1..str2])
                return mat_values[str1..str2]
            end
            if new_value_nested("fracture","SHEAR")>170000 or new_value_nested("yield","IMPACT")>245000 then
                lines[#lines+1]="[ITEMS_WEAPON][ITEMS_AMMO]"
                if new_value("solid_density")<10000 then
                    lines[#lines+1]="[ITEMS_WEAPON_RANGED][ITEMS_ARMOR]"
                end
            end
            lines[#lines+1]="[MATERIAL_VALUE:"..new_value("base_value").."]"
            lines[#lines+1]="[SPEC_HEAT:"..new_value("temp_spec_heat").."]"
            lines[#lines+1]="[MELTING_POINT:"..new_value("temp_melting_point").."]"
            lines[#lines+1]="[BOILING_POINT:"..new_value("temp_boiling_point").."]"
            lines[#lines+1]="[SOLID_DENSITY:"..new_value("solid_density").."]"
            lines[#lines+1]="[LIQUID_DENSITY:"..new_value("liquid_density").."]"
            lines[#lines+1]="[MOLAR_MASS:"..new_value("molar_mass").."]" -- i don't think this is actually correct
            for _,thing in ipairs({"yield","fracture"}) do
                for force,_ in pairs(v.material[thing]) do
                    lines[#lines+1]="["..string.upper(force).."_"..string.upper(thing)..":"..new_value_nested(thing,force).."]"
                end
            end
            for _,force in ipairs("IMPACT","COMPRESSIVE","TENSILE","TORSION","SHEAR","BENDING") do
                local modulus = v.yield[force] / v.elasticity[force]
                local average_modulus = (adamantine_modulus*wafers + modulus*bars*3)*avg_denom
                local strain_at_yield = math.floor(new_value_nested("yield",force) / average_modulus + 0.5) -- usually zero, but can be 1 or 2 sometimes
                lines[#lines+1]="["..string.upper(force).."_YIELD:"..new_value_nested("yield",force).."]"
                lines[#lines+1]="["..string.upper(force).."_FRACTURE:"..new_value_nested("fracture",force).."]"
                lines[#lines+1]="["..string.upper(force).."_STRAIN_AT_YIELD:"..strain_at_yield.."]"
            end
            lines[#lines+1]="[MAX_EDGE:"..new_value("max_edge").."]"
            local reaction_token=token.."_MAKING"
            reaction_lines[#reaction_lines+1]="[REACTION:"..reaction_token.."]"
            add_generated_info(reaction_lines)
            reaction_lines[#reaction_lines+1]="[NAME:make adamantine "..v.material.name.SOLID.." (use bars)]"
            reaction_lines[#reaction_lines+1]="[BUILDING:BLAST_FURNACE_CHP:NONE]"
            reaction_lines[#reaction_lines+1]="[REAGENT:A:"..tostring(150*wafers)..":BAR:NO_SUBTYPE:METAL:ADAMANTINE]"
            reaction_lines[#reaction_lines+1]="[REAGENT:B:"..tostring(150*bars)..":BAR:NO_SUBTYPE:METAL:"..v.token.."]"
            reaction_lines[#reaction_lines+1]="[PRODUCT:100:"..tostring(bars+wafers)..":BAR:NO_SUBTYPE:METAL:"..token.."][PRODUCT_DIMENSION:150]"
            reaction_lines[#reaction_lines+1]="[FORTRESS_MODE_ENABLED]"
            reaction_lines[#reaction_lines+1]="[CATEGORY:ADAMANTINE_ALLOYS]"
            if not done_category then
                done_category=true
                reaction_lines[#reaction_lines+1]="[CATEGORY_NAME:Adamantine alloys]"
                reaction_lines[#reaction_lines+1]="[CATEGORY_DESCRIPTION:Debase adamantine with other metals to get extremely strong alloys.]"
                reaction_lines[#reaction_lines+1]="[CATEGORY_KEY:CUSTOM_SHIFT_A]"
            end
            reaction_lines[#reaction_lines+1]="[FUEL]"
            reaction_lines[#reaction_lines+1]="[SKILL:SMELT]"
        end
    end
    local entity_lines={}
    raws.register_inorganics(lines)
    -- not used in vanilla right now, due to lack of instruments, but you CAN do this
    raws.register_reactions(reaction_lines)
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
		
		[NATURAL_SKILL:WRESTLING:10]
		[NATURAL_SKILL:BITE:10]
		[NATURAL_SKILL:GRASP_STRIKE:10]
		[NATURAL_SKILL:STANCE_STRIKE:10]
		[NATURAL_SKILL:MELEE_COMBAT:10]
		[NATURAL_SKILL:DODGING:10]
		[NATURAL_SKILL:SITUATIONAL_AWARENESS:10]
		[LARGE_PREDATOR]
		[GENERAL_MATERIAL_FORCE_MULTIPLIER:1:3]--33% force resistance
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
	
	return {raws=lines,weight=1.5}
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
	[GENERAL_MATERIAL_FORCE_MULTIPLIER:1:3]--33% force resistance
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
    return {creature=tbl,weight=1.5}
end
