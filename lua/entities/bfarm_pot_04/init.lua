AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include ("shared.lua")
include("bfarm/bfarm_plants.lua")

function ENT:Initialize()
	self:SetModel( "models/bluechu/bfarm/pot_04.mdl" )
	self:SetColor(Color(255,255,255))
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.bfarm = {}
	self.bfarm.plantedPlants = {}
	self.bfarm.maxPlants = 4
	self.bfarm.plantOrigins = {Vector(12.5,27.65,8) , Vector(-12.5,27.65,8) , Vector(12.5,27.65,-8) , Vector(-12.5,27.65,-8)}
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake() 
	end

	self:SetBodygroup(0,1)
	self:SetBodygroup(0,0)
	self:UseClientSideAnimation()
	self:SetSequence(1)
	self:ResetSequence(1)

	self:SetMaxSoilAmount(1000)
	self:SetWaterLevel(350)
	self:SetMaxWaterAmount(350)
	self:SetSoilAmount(0)

	self.nextWaterDepleteTime = CurTime() + 4
	self.recalulateLightTime = CurTime() + 2
	self:RecalculateLightLevels()
end

function ENT:Use(act , cal)
	self:SetBodygroup(0,1)
	self:SetBodygroup(1,0)
end

--Used to add soil to the pot. Will return false if already full
function ENT:AddSoil(amount)
	local s = self:GetSoilAmount()
	s = s + amount
	if s >= self:GetMaxSoilAmount() then
		s = self:GetMaxSoilAmount()
		self:SetBodygroup(0,1)
		self:SetBodygroup(0,0)
	end
	self:SetSoilAmount(s)
end

--Used to add water to the pot
function ENT:AddWater(amount)
	local s = self:GetWaterLevel()
	s = s + amount
	if s >= self:GetMaxWaterAmount() then
		s = self:GetMaxWaterAmount()
	end
	self:SetWaterLevel(s)
end

--Handles water deplete
function ENT:Think()
	if self.nextWaterDepleteTime <= CurTime() then
		self.nextWaterDepleteTime = CurTime() + 4
		self:SetWaterLevel(self:GetWaterLevel() - 6)
	end

	if self.recalulateLightTime <= CurTime() then
		self:RecalculateLightLevels()
		self.recalulateLightTime = 1 + CurTime()
	end
	
end 

function ENT:StartTouch(e)
	if IsBFARMSeed(e) then
		self:AddPlant(e)
		self:RecalculateLightLevels()
	end
end

--Works out how much sun light is around the plant pot.
function ENT:RecalculateLightLevels()
	local totalCount = 0
 	if not USE_LIGHTING then
		if self:GetSunLevel() ~= 5 then
			self:SetSunLevel(5) 
		end
		return
	end
	local tr = util.TraceLine( {
		start = self:GetPos() + (self:GetAngles():Up() * 25),
		endpos = self:GetPos() + (self:GetAngles():Up() * 100000),
		filter = {self , self.bfarm.plantedPlant}
	} )
	if tr.HitSky == true then
		totalCount = totalCount + 1
	end

	tr = util.TraceLine( {
		start = self:GetPos() + (self:GetAngles():Up() * 25),
		endpos = self:GetPos() + (self:GetAngles():Up() * 100000) + (self:GetAngles():Right() * 35000),
		filter = {self , self.bfarm.plantedPlant}
	} )
	if tr.HitSky == true then
		totalCount = totalCount + 1
	end


	tr = util.TraceLine( {
		start = self:GetPos() + (self:GetAngles():Up() * 25),
		endpos = self:GetPos() + (self:GetAngles():Up() * 100000) + (self:GetAngles():Right() * -35000),
		filter = {self , self.bfarm.plantedPlant}
	} )
	if tr.HitSky == true then
		totalCount = totalCount + 1
	end


	tr = util.TraceLine( {
		start = self:GetPos() + (self:GetAngles():Up() * 25),
		endpos = self:GetPos() + (self:GetAngles():Up() * 100000) + (self:GetAngles():Forward() * 35000),
		filter = {self , self.bfarm.plantedPlant}
	} )
	if tr.HitSky == true then
		totalCount = totalCount + 1
	end

	tr = util.TraceLine( {
		start = self:GetPos() + (self:GetAngles():Up() * 25),
		endpos = self:GetPos() + (self:GetAngles():Up() * 100000) + (self:GetAngles():Forward() * -35000),
		filter = {self , self.bfarm.plantedPlant}
	} )
	if tr.HitSky == true then
		totalCount = totalCount + 1
	end

	if self:GetSunLevel() ~= totalCount then
		self:SetSunLevel(totalCount) 
	end
end

function ENT:FindEmptySlot()
	for i = 1 , self.bfarm.maxPlants do
		if self.bfarm.plantedPlants[i] == nil then
			return i
		end
	end
	return false
end

--Used to add plants to it, as some pots have multiple plants we use the same function name to add as many as we want
function ENT:AddPlant(seed)
	local slot = self:FindEmptySlot()
	if slot then
		local offset = self.bfarm.plantOrigins[slot]
		if self:GetSoilAmount() >= self:GetMaxSoilAmount() then
			local plant = ents.Create("bfarm_plant")
			plant:SetPos(self:GetPos() + (self:GetAngles():Up() * offset.y) + (self:GetAngles():Right() * offset.x) + (self:GetAngles():Forward() * offset.z))
			plant:SetAngles(self:GetAngles())
			plant:SetParent(self)
			plant:SetupPlant(seed.plant , self) --Sets the model and stuff for that plant
			plant:Spawn()
			plant.slotID = slot
			self.bfarm.plantedPlants[slot] = plant
			seed:Remove() --Remove the seed of course
		end
	end
end

--Removes the plant passed from the pot (Used for seperation such as harvesting)
function ENT:RemovePlant(plant)
	self.bfarm.plantedPlants[plant.slotID] = nil
end

--Usefull for keeping it upright when the player knocks it over
hook.Add("GravGunOnDropped" , "HandlePot01Upright" , function(ply , ent)
	if ent:GetClass() == "bfarm_pot_01" then
		ent:SetAngles(Angle(0,0,0))
	end
end)

function ENT:OnTakeDamage()
	self:Remove()
end
