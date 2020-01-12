AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include ("shared.lua")

local pourOffset = Vector(-17,0,0)

local pots = {
	"bfarm_pot_01",
	"bfarm_pot_04",
}

function ENT:Initialize()
	self:SetModel( "models/bluechu/bfarm/watercan.mdl" )
	self:SetColor(Color(255,255,255))
	self:PhysicsInit( SOLID_VPHYSICS )     
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )
	self.bfarm = {}   
	self.bfarm.isBeingPickedUp = false
	self.bfarm.carrier = false
	self.nextLeakUpdate = 0
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self:SetWaterAmount(1000)
	self:SetIsPouring(false)
	self:SetCarrierID(-1)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
end

--Used to change open or close state.
function ENT:Use(act , cal)
	--self:SetIsOpen(not self:GetIsOpen())
end

--Used to check if an entity is a pot
local function IsPot(ent)
	for k ,v in pairs(pots) do
		if ent:GetClass() == v then
			return true
		end
	end
	return false
end

function ENT:Think()
	if self.nextLeakUpdate <= CurTime() and self.bfarm.carrier ~= nil and self:GetWaterAmount() > 0 then
		self.nextLeakUpdate = CurTime() + 0.5
		local tr = util.TraceLine( {
			start = self:GetPos() - pourOffset,
			endpos = (self:GetPos() - pourOffset) + Vector(0,0,-150),
			filter = {self}
		} )

		if IsValid(tr.Entity) and IsPot(tr.Entity) then
			self:SetIsOpen(true)
			tr.Entity:AddWater(25)
			self:SetWaterAmount(self:GetWaterAmount() - 25)
			if self:GetWaterAmount() <= 0 then
				self:SetIsPouring(false) 
			else
				self:SetIsPouring(true) 
			end
		else
			self:SetIsOpen(false)
			self:SetIsPouring(false) 
		end
	end

	if self.bfarm.carrier ~= nil and self:GetWaterAmount() < 0 then
		self:SetIsPouring(false)
	end

	if self:GetIsDying() == false and self:GetWaterAmount() <= 0 then
		self:SetIsDying(true)
	end
end

hook.Add( "GetPreferredCarryAngles", "WaterCanPreferedAngles", function( ent )
	if ent:GetClass() == "bfarm_water_can" and IsValid(ent.bfarm.carrier) then
		ang = Angle(35 , 0, 0)
		return ang
	end
end)

hook.Add("GravGunOnPickedUp" , "HandleWaterCan" , function(ply , ent)
	if ent:GetClass() == "bfarm_water_can" then
		if ent:GetWaterAmount() > 0 then
			ent:SetIsPouring(true)
		end
		ent:GetIsOpen(true)
		ent:SetIsPouring(true) 
		ent.bfarm.carrier = ply
		ent:SetCarrierID(ply:UserID())
		
		ang = Angle(35 , 0, 0)
		ent:SetPreferedAngles(ang)
		ent:SetAngles(ang)
	end
end)

hook.Add("GravGunOnDropped" , "HandlerWaterCan" , function(ply , ent)
	if ent:GetClass() == "bfarm_water_can" then
		ent:SetIsPouring(false)
		ent:GetIsOpen(false) 
		ang = Angle(0 , 0, 0)
		ent:SetPreferedAngles(ang)
		ent:SetCarrierID(-1)
		ent.bfarm.carrier = nil
		if ent:GetIsOpen() then
			ent:SetAngles(ang)
		end
		if ent:GetIsDying() == true then
			ent:Remove()
		end
	end
end)

function ENT:OnTakeDamage()
	self:Remove()
end