--PLEASE READ THIS FIRST!!!
--If you want to save the NPC('s) then do !savebfarm
--If you want to delete every NPC on the map do !clearbfarm


--This means should it use light to effect growth speed, ligh only comes from the sky
--so if you plant is inside it will not grow. This works on almost all maps but some maps (rare) dont work so you will need to disable this.
USE_LIGHTING = true

--If this is set to true then when the plant pot runs out of water all planted plants
--in it will dies. If false, then the plants just stop growing until water is replenished
DIE_WHEN_NO_WATER = true

--These are ranks that can save the NPC. Dont forget to make sure your rank is on here before trying to save
--or it will not work!
BFARM_AUTHORISED_RANKS = {
	"owner",
	"superadmin"
}


LETTUCE_GROW_TIME = 120 --The time (in seconds) it takes to grow
LETTUCE_SELL_AMOUNT = 2500 --The price it sells for per unit

POTATO_GROW_TIME = 120 * 2 --The time (in seconds) it takes to grow
POTATO_SELL_AMOUNT = 6000 --The price it sells for per unit

CARROT_GROW_TIME = 80 --The time (in seconds) it takes to grow
CARROT_SELL_AMOUNT= 1000 --The price it sells for per unit

--This is the model of the farmer NPC, if changing make sure to replace it with a ragdoll NOT a player model
FARMER_MARKET_MODEL = "models/odessa.mdl" 

--Below are the add entities, remove them, change them etc do what you want :D

hook.Add( "Initialize", "AddBFarmEntities", function()

	DarkRP.createCategory{
		name = "Farming", -- The name of the category.
		categorises = "entities", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
		startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
		color = Color(170,130,40, 255), -- The color of the category header.
		canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
		sortOrder = 100
	}

	DarkRP.createEntity("Small Plant Pot", {
		ent = "bfarm_pot_01",
		model = "models/bluechu/bfarm/pot_01.mdl",
		price = 1000,
		max = 6,
		cmd = "buyplantpot",
		category = "Farming",
	})

	DarkRP.createEntity("Large Plant Pot", {
		ent = "bfarm_pot_04",
		model = "models/bluechu/bfarm/pot_04.mdl",
		price = 3000,
		max = 4,
		cmd = "buylargeplantpot",
		category = "Farming",
	})

	DarkRP.createEntity("Soil Bag", {
		ent = "bfarm_soil_bag",
		model = "models/bluechu/bfarm/bagdirt.mdl",
		price = 250,
		max = 4,
		cmd = "buysoilbag",
		category = "Farming",
	})

	DarkRP.createEntity("Watering Can", {
		ent = "bfarm_water_can",
		model = "models/bluechu/bfarm/watercan.mdl",
		price = 150,
		max = 4,
		cmd = "buywatercan",
		category = "Farming",
	})

	DarkRP.createEntity("Carrot Seed", {
		ent = "bfarm_seed_carrot",
		model = "models/bluechu/bfarm/seed.mdl",
		price = 150,
		max = 8,
		cmd = "buycarrotseed",
		category = "Farming",
	})

	DarkRP.createEntity("Lettuce Seed", {
		ent = "bfarm_seed_lettuce",
		model = "models/bluechu/bfarm/seed.mdl",
		price = 250,
		max = 8,
		cmd = "buylettuceseed",
		category = "Farming",
	})

	DarkRP.createEntity("Potato Seed", {
		ent = "bfarm_seed_potato",
		model = "models/bluechu/bfarm/seed.mdl",
		price = 500,
		max = 8,
		cmd = "buypotatoseed",
		category = "Farming",
	})

	DarkRP.createEntity("Shipping Crate", {
		ent = "bfarm_shipping_crate",
		model = "models/bluechu/bfarm/crate.mdl",
		price = 500,
		max = 2,
		cmd = "buyshippingcontainer",
		category = "Farming",
	})

end)