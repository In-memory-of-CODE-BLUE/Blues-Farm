AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include ("shared.lua")

include("bfarm/bfarm_plants.lua")
	 
function ENT:Initialize()
	self:SetColor(Color(255,255,255))
	self:PhysicsInit( SOLID_VPHYSICS )     
	self:SetMoveType( MOVETYPE_NONE )   
	self:SetSolid( SOLID_NONE )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.nextGrowTime = CurTime() + 4
end

function ENT:SetupPlant(plantInfo, owningPot)
	plantInfo = BFARM_PLANTS[plantInfo]
	self:SetModel(plantInfo.model) 
	self:SetModelScale(0.1,0)
	self:SetPlantType(plantInfo.name)
	self:SetGrowthAmount(0)
	self.plantInfo = plantInfo
	self.owningPot = owningPot
	self:SetIsPlanted(true)
end

function ENT:Think()
	if self.nextGrowTime <= CurTime() then
		self:Grow()
		self.nextGrowTime = CurTime() + 4
	end
end

function ENT:Use(act , call)
	if self:GetIsPlanted() and self:GetGrowthAmount() / self.plantInfo.growthTime >= 1 then
		self:SetParent(nil)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self.owningPot:RemovePlant(self)
		self:SetPos(self:GetPos() + (self:GetAngles():Up() * 30))
		self:SetIsPlanted(false)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:CPPISetOwner(act)
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
end

--Used to step growth
function ENT:Grow()
	if not self:GetIsPlanted() then return end
	local growAmount = 4
	if self.owningPot:GetWaterLevel() <= 0 then
		if DIE_WHEN_NO_WATER then
			self.owningPot:RemovePlant(self)
			self:Remove()
			return false
		else
			return false
		end
	end

	growAmount = growAmount * (self.owningPot:GetSunLevel() / 5)

	self:SetGrowthAmount(self:GetGrowthAmount() + growAmount)

	if self:GetGrowthAmount() / self.plantInfo.growthTime < 0.3 then
		if self:GetBodygroup(0) ~= 1 then
			self:SetBodygroup(0,0)
		end
	elseif self:GetGrowthAmount() / self.plantInfo.growthTime < 1 then
		if self:GetBodygroup(1) ~= 1 then
			self:SetBodygroup(0,1)
		end
	elseif self:GetGrowthAmount() / self.plantInfo.growthTime >= 1 and self:GetIsPlanted() == true then
		if self:GetBodygroup(2) ~= 1 then
			self:SetBodygroup(0,2)
			self:SetSolid(SOLID_VPHYSICS)
		end
	end
end