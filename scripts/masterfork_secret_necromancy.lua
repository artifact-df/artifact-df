interactions.secrets.necromancer=nil-- disables vanilla necromancy

-- redefined necromancy, increased summon wait periods, new abilities
interactions.secrets.death=function(idx,sph)
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
		[IT_CANNOT_HAVE_SYNDROME_CLASS:NECROMANCER]//new
		[IT_AFFECTED_CREATURE:HUMAN:FEMALE_NOBLE]// only human nobles can initially learn the secret
		[IT_AFFECTED_CREATURE:HUMAN:MALE_NOBLE]
    [I_EFFECT:ADD_SYNDROME]
        [IE_TARGET:A]
        [IE_IMMEDIATE]
        [IE_ARENA_NAME:Necromancer]
        [SYNDROME]
            [SYN_CLASS:NECROMANCER]
            [SYN_CONCENTRATION_ADDED:1000:0]//just in case
			[SYN_NO_HOSPITAL]//new
            [CE_DISPLAY_TILE:TILE:165:5:0:1:START:0:ABRUPT]
            [CE_DISPLAY_NAME:NAME:necromancer:necromancers:necromantic:START:0:ABRUPT]
            [CE_ADD_TAG:NOEXERT:NO_AGING:STERILE:NO_EAT:NO_DRINK:NO_SLEEP:NO_PHYS_ATT_GAIN:NO_PHYS_ATT_RUST]]..(experimenter and ":NIGHT_CREATURE_EXPERIMENTER" or "")..[[:START:0:ABRUPT]// added sterile
            [CE_CHANGE_PERSONALITY:FACET:ANXIETY_PROPENSITY:50:FACET:TRUST:-50:START:0:ABRUPT]
			[CE_CHANGE_PERSONALITY:FACET:LOVE_PROPENSITY:-33:FACET:EMOTIONALLY_OBSESSIVE:-33:FACET:SWAYED_BY_EMOTIONS:-33:START:0:ABRUPT]// new personality alterations, necromancers are less emotional
			[CE_MENT_ATT_CHANGE:EMPATHY:75:0]// necromancers are less empathetic
			[CE_MATERIAL_FORCE_MULTIPLIER:MAT_MULT:NONE:NONE:1:2:ABRUPT]
            [CE_CAN_DO_INTERACTION:START:0:ABRUPT]
                [CDI:ADV_NAME:Animate corpse]
                str="[CDI:INTERACTION:]]..animate_token..[[]
                [CDI:TARGET:A:LINE_OF_SIGHT]
                [CDI:TARGET_RANGE:A:10]
                [CDI:VERB:gesture:gestures:NA]
                [CDI:TARGET_VERB:shudder and begin to move:shudders and begins to move]
                [CDI:WAIT_PERIOD:100]
                [CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_ANIMATE_CORPSE]
			[CE_CAN_DO_INTERACTION:START:0:ABRUPT]// new summon skeleton ability
				[CDI:ADV_NAME:Summon skeleton]
				[CDI:INTERACTION:SUMMON_SKELETON]
				[CDI:VERB:gesture:gestures:NA]
				[CDI:TARGET_VERB:breaks free from the ground:breaks free from the ground]
				[CDI:WAIT_PERIOD:600]
                [CDI:DEFAULT_ICON:ADVENTURE_INTERACTION_ICON_ANIMATE_CORPSE]
            [CE_CAN_DO_INTERACTION:START:0:ABRUPT]// new fear aura ability
                [CDI:ADV_NAME:Fearsome]
				[CDI:INTERACTION:AURA_FEAR]
                [CDI:USAGE_HINT:ATTACK]
                [CDI:TARGET:A:LINE_OF_SIGHT]
                [CDI:TARGET_RANGE:A:4]
                [CDI:MAX_TARGET_NUMBER:A:99]
                [CDI:TARGET_VERB:are shaken:is visibly afraid:NA]
                [CDI:FREE_ACTION]
                [CDI:WAIT_PERIOD:10]
            [CE_CAN_DO_INTERACTION:START:0:ABRUPT]// new regeneration ability
                [CDI:ADV_NAME:Regenerate]
				[CDI:INTERACTION:REGENERATE_CREATURE]
                [CDI:USAGE_HINT:FLEEING]
                [CDI:USAGE_HINT:DEFEND]
                [CDI:BP_REQUIRED:BY_CATEGORY:HEAD]
                [CDI:VERB:reform your body:begins to reform:begin to reform]
                [CDI:TARGET:A:SELF_ONLY:TOUCHABLE]
                [CDI:TARGET_RANGE:A:1]
                [CDI:MAX_TARGET_NUMBER:A:1]
                [CDI:FREE_ACTION]
                [CDI:WAIT_PERIOD:1000]
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
    if summon then 
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
							[SYN_NO_HOSPITAL]//new
							[SYN_CONCENTRATION_ADDED:1000:0]//just in case
							[CE_DISPLAY_TILE:TILE:165:7:0:1:START:0:ABRUPT]
                            [CE_DISPLAY_NAME:NAME:]]..ghost_name..":"..ghost_name_plural..":"..ghost_name..[[:START:0:ABRUPT]
							[CE_PHYS_ATT_CHANGE:STRENGTH:200:1000:TOUGHNESS:200:1000:START:0:ABRUPT]
							[CE_ADD_TAG:NO_AGING:NOT_LIVING:STERILE:EXTRAVISION:NOEXERT:NOPAIN:NOBREATHE:NOSTUN:NONAUSEA:NO_DIZZINESS:NO_FEVERS:NOEMOTION:PARALYZEIMMUNE:NOFEAR:NO_EAT:NO_DRINK:NO_SLEEP:NO_PHYS_ATT_GAIN:NO_PHYS_ATT_RUST:NOTHOUGHT:NO_THOUGHT_CENTER_FOR_MOVEMENT:NO_CONNECTIONS_FOR_MOVEMENT:START:0:ABRUPT]
							[CE_REMOVE_TAG:HAS_BLOOD:TRANCES:MISCHIEVOUS:START:0:ABRUPT]
							[CE_MATERIAL_FORCE_MULTIPLIER:MAT_MULT:NONE:NONE:1:2:ABRUPT]//new
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
				[SYN_NO_HOSPITAL]//new
                [SYN_CONCENTRATION_ADDED:1000:0]//just in case
                [CE_FLASH_TILE:TILE:165:4:0:1:FREQUENCY:2000:1000:START:0:ABRUPT]
                [CE_DISPLAY_NAME:NAME:]]..g_name_sing..":"..g_name_plur..":"..g_name_sing..[[:START:0:ABRUPT]
                CE_PHYS_ATT_CHANGE:STRENGTH:130:0:TOUGHNESS:300:1000:START:0:ABRUPT commented out
                1/3 chance CE_SPEED_CHANGE:SPEED_PERC:60:START:0:ABRUPT
                else 1/2 chance CE_SPEED_CHANGE:SPEED_PERC:20:START:0:ABRUPT
                [CE_ADD_TAG:NO_AGING:NOT_LIVING:OPPOSED_TO_LIFE:EXTRAVISION:NOEXERT:NOPAIN:NOBREATHE:NOSTUN:NONAUSEA:NO_DIZZINESS:NO_FEVERS:NOEMOTION:PARALYZEIMMUNE:NOFEAR:NO_EAT:NO_DRINK:NO_SLEEP:NO_PHYS_ATT_GAIN:NO_PHYS_ATT_RUST:NOTHOUGHT:NO_THOUGHT_CENTER_FOR_MOVEMENT:NO_CONNECTIONS_FOR_MOVEMENT:START:0:ABRUPT]
                [CE_REMOVE_TAG:TRANCES:MISCHIEVOUS:START:0:ABRUPT]
				[CE_MATERIAL_FORCE_MULTIPLIER:MAT_MULT:NONE:NONE:1:2:ABRUPT]//new
                [CE_SPECIAL_ATTACK_INTERACTION:INTERACTION:]]..ghoul_token..":BP:BY_CATEGORY:MOUTH:BP:BY_CATEGORY:TOOTH:START:0:ABRUPT]"
        )
    end
    local spheres={"DEATH"}
    if summon then spheres[2]="NIGHTMARES" end
    return {raws=tbl,weight=1,spheres=spheres}
end