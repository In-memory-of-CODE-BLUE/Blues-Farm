ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Shipping Crate"
ENT.Spawnable = true
ENT.Category = "Blue's Farm"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "CarrotAmount")
	self:NetworkVar("Int", 1, "LettuceAmount")
	self:NetworkVar("Int", 3 , "PotatoAmount") --Between 0 and 5
end