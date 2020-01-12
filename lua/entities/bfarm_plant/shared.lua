ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Plant Base"
ENT.Spawnable = true
ENT.Category = "Blue's Farm"


function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "GrowthAmount")
	self:NetworkVar("String", 0, "PlantType")
	self:NetworkVar("Bool" , 0 , "IsPlanted")
end 