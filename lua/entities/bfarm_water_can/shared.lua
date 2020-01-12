ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Watering Can"
ENT.Spawnable = true
ENT.Category = "Blue's Farm"

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "WaterAmount")
	self:NetworkVar("Bool" , 1 , "IsPouring")
	self:NetworkVar("Bool" , 2 , "IsOpen")
	self:NetworkVar("Angle", 3 , "PreferedAngles")
	self:NetworkVar("Int" , 2 , "CarrierID")
	self:NetworkVar("Bool" , 4 , "IsDying")
end