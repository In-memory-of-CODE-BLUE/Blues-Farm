--THIS IS NOT A CONFIG, DO NOT EDIT THIS!

BFARM_PLANTS = {}

--Used to register a plant
local function CreatePlant(name, model, growthTime, sellPrice)
	local p = {}
	p.name = name
	p.model = model
	p.growthTime = growthTime
	p.sellPrice = sellPrice
	BFARM_PLANTS[p.name] = p 
end

--Create the base plants

CreatePlant("Lettuce" , "models/bluechu/bfarm/plant_lettuce.mdl" , LETTUCE_GROW_TIME , LETTUCE_SELL_AMOUNT)
CreatePlant("Potato" , "models/bluechu/bfarm/plant_potato.mdl" , POTATO_GROW_TIME , POTATO_SELL_AMOUNT)
CreatePlant("Carrot" , "models/bluechu/bfarm/plant_carrot.mdl" , CARROT_GROW_TIME , CARROT_SELL_TIME)

BFARM_SEEDS = {
	"bfarm_seed_carrot",
	"bfarm_seed_potato",
	"bfarm_seed_lettuce"
}

--Used to check if an ent is a seed
function IsBFARMSeed(ent)
	local class = ent:GetClass()
	return table.HasValue(BFARM_SEEDS,class)
end