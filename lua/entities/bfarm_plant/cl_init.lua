include("shared.lua")
include("bfarm/bfarm_plants.lua")

function ENT:Initialize()
	self.smoothGrowth = 0
end

local GrowthIcon = Material("models/bluechu/bfarm/icon_growth.png")
local DoneIcon = Material("models/bluechu/bfarm/icon_done.png")

function ENT:Draw() 
	self:DrawModel()


	if LocalPlayer():GetPos():Distance(self:GetPos()) < 250 and self:GetIsPlanted() then
		local s = math.Clamp(self.smoothGrowth + 0.5,0,1.5)
		self:SetModelScale(s * 0.5,0) 
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 200.0)
		alpha = math.Clamp(1.25 - alpha, 0 ,1)
		local a = Angle(0,0,0)
		a:RotateAroundAxis(Vector(1,0,0),90)
		a.y = LocalPlayer():GetAngles().y - 90
		cam.Start3D2D(self:GetPos() + Vector(0,0,13), a , 0.074)

			draw.RoundedBox(8,-50,-100,100,100 , Color(45,45,45,255 * alpha))
			local tri = {{x = -25 , y = 0},{x = 25 , y = 0},{x = 0 , y = 25}}
			surface.SetDrawColor(Color(45,45,45,255 * alpha))
			draw.NoTexture()
			surface.DrawPoly( tri )

			if (self:GetGrowthAmount() / BFARM_PLANTS[self:GetPlantType()].growthTime) >= 1 then

				surface.SetDrawColor(Color(90,255,90 , 255 * alpha))
				draw.Circle(0, 50 - 100 , 45, 25 , 100)

				surface.SetDrawColor(Color(60,60,60,255 * alpha)) 
				surface.SetMaterial(DoneIcon)
				surface.DrawTexturedRect( -25 , 50 - 100 - 25 , 50 , 50)
				draw.NoTexture()
			else
				--Draw percent
				surface.SetDrawColor(Color(90/2,255/2,90/2 , 255 * alpha))
				draw.Circle(0, 50 - 100 , 45, 14)

				surface.SetDrawColor(Color(90,255,90 , 255 * alpha))
				draw.Circle(0, 50 - 100 , 45, 14 , self.smoothGrowth * 100)

				surface.SetDrawColor(Color(60,60,60,255 * alpha))
				draw.Circle(0, 50 - 100 , 35, 14)

				surface.SetDrawColor(Color(90,255,90, 255 * alpha))
				surface.SetMaterial(GrowthIcon)
				surface.DrawTexturedRect( -25 , 50 - 100 - 25 , 50 , 50)
				draw.NoTexture()
			end
		cam.End3D2D()
	end
end

function ENT:Think()
	self.smoothGrowth = Lerp(0.7 * FrameTime() ,self.smoothGrowth,(self:GetGrowthAmount() / BFARM_PLANTS[self:GetPlantType()].growthTime))
	self.smoothGrowth = math.Clamp(self.smoothGrowth,0 , 1)
end