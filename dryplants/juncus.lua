-----------------------------------------------------------------------------------------------
-- Grasses - Juncus 0.0.5
-----------------------------------------------------------------------------------------------
-- by Mossmanikin
-- textures & ideas partly by Neuromancer

-- Contains code from:		biome_lib
-- Looked at code from:		default
-----------------------------------------------------------------------------------------------

-- support for i18n
local S = minetest.get_translator("dryplants")

abstract_dryplants.grow_juncus = function(pos)
	local juncus_type = math.random(2,3)
	local right_here = {x=pos.x, y=pos.y+1, z=pos.z}
	if minetest.get_node(right_here).name == "air"  -- instead of check_air = true,
	or minetest.get_node(right_here).name == "default:junglegrass" then
		if juncus_type == 2 then
			minetest.swap_node(right_here, {name="dryplants:juncus_02"})
		else
			minetest.swap_node(right_here, {name="dryplants:juncus"})
		end
	end
end

minetest.register_node("dryplants:juncus", {
	description = S("Juncus"),
	drawtype = "plantlike",
	visual_scale = math.sqrt(8),
	paramtype = "light",
	tiles = {"dryplants_juncus_03.png"},
	inventory_image = "dryplants_juncus_inv.png",
	walkable = false,
	buildable_to = true,
	groups = {
		snappy=3,
		flammable=2,
		attached_node=1,
		flora=1
		--not_in_creative_inventory=1
	},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7/16, -1/2, -7/16, 7/16, 0, 7/16},
	},
	on_place = function(itemstack, placer, pointed_thing)
		local playername = placer:get_player_name()
		if minetest.is_protected(pointed_thing.above, playername) or
			minetest.is_protected(pointed_thing.under, playername) then
			minetest.chat_send_player(playername, "Someone else owns that spot.")
			return
		end
		local pos = pointed_thing.under
		local juncus_type = math.random(2,3)
		local right_here = {x=pos.x, y=pos.y+1, z=pos.z}
		if juncus_type == 2 then
			minetest.swap_node(right_here, {name="dryplants:juncus_02"})
		else
			minetest.swap_node(right_here, {name="dryplants:juncus"})
		end
		if not minetest.setting_getbool("creative_mode") then
			itemstack:take_item()
		end
		return itemstack
	end,
})
minetest.register_node("dryplants:juncus_02", {
	description = S("Juncus"),
	drawtype = "plantlike",
	visual_scale = math.sqrt(8),
	paramtype = "light",
	tiles = {"dryplants_juncus_02.png"},
	walkable = false,
	buildable_to = true,
	groups = {
		snappy=3,
		flammable=2,
		attached_node=1,
		flora=1,
		not_in_creative_inventory=1
	},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7/16, -1/2, -7/16, 7/16, 0, 7/16},
	},
	drop = "dryplants:juncus",
})
-----------------------------------------------------------------------------------------------
-- GENERATE SMALL JUNCUS
-----------------------------------------------------------------------------------------------
-- near water or swamp
pl.register_on_generate({
		surface = {
			"default:dirt_with_grass",
			--"default:desert_sand",
			--"default:sand",
			"stoneage:grass_with_silex",
			"sumpf:peat",
			"sumpf:sumpf"
		},
		noise_params = pl.generate_noise_params({max_count = JUNCUS_NEAR_WATER_PER_MAPBLOCK, rarity = 101 - JUNCUS_NEAR_WATER_RARITY}),
		min_elevation = 1, -- above sea level
		near_nodes = {"default:water_source","sumpf:dirtywater_source","sumpf:sumpf"},
		near_nodes_size = 2,
		near_nodes_vertical = 1,
		near_nodes_count = 1,
	},
	"dryplants:juncus_near_water",
	abstract_dryplants.grow_juncus
)
-- at dunes/beach
pl.register_on_generate({
		surface = {
			--"default:dirt_with_grass",
			--"default:desert_sand",
			"default:sand",
			--"stoneage:grass_with_silex",
			--"sumpf:peat",
			--"sumpf:sumpf"
		},
		noise_params = pl.generate_noise_params({max_count = JUNCUS_AT_BEACH_PER_MAPBLOCK, rarity = 101 - JUNCUS_AT_BEACH_RARITY}),
		min_elevation = 1, -- above sea level
		near_nodes = {"default:dirt_with_grass"},
		near_nodes_size = 2,
		near_nodes_vertical = 1,
		near_nodes_count = 1,
	},
	"dryplants:junces_at_beach",
	abstract_dryplants.grow_juncus
)
