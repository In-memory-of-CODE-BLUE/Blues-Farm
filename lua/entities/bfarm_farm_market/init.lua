AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
include("bfarm_config.lua")

include("bfarm/bfarm_plants.lua")

function ENT:Initialize()
	self:SetModel(FARMER_MARKET_MODEL)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetBloodColor(BLOOD_COLOR_RED)
	self:SetSolid(SOLID_BBOX)
end

function ENT:StartTouch(ent)

end