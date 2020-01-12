ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "POT 01"
ENT.Spawnable = true
ENT.Category = "Blue's Farm"


function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "SoilAmount")
	self:NetworkVar("Int", 1, "MaxSoilAmount")
	self:NetworkVar("Float" ,  5 , "MaxWaterAmount")
	self:NetworkVar("Float" ,  2 , "WaterLevel")
	self:NetworkVar("Float", 3 , "SunLevel") --Between 0 and 5
end