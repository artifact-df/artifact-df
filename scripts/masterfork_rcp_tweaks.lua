tweaks=nil-- remove old rcp tweaks

-- redefined rcp bodies
btc1_tweaks.mfork_rcp_tweaks=function(lines,options,add_to_body,add_to_body_unique,add_tweak_candidate)
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
