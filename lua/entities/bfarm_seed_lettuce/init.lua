AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include ("shared.lua")
	
function ENT:Initialize()
	self:SetModel( "models/bluechu/bfarm/seed.mdl" )
	self:SetMaterial("models/bluechu/bfarm/seed_lettuce.vmt" , true)
	self:SetColor(Color(255,255,255))
	self:PhysicsInit( SOLID_VPHYSICS )     
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.plant = "Lettuce" --The name of the plant entity that the seeds represent
end

function ENT:OnTakeDamage()
	self:Remove()
end