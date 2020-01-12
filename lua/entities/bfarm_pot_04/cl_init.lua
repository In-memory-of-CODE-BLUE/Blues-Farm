include("shared.lua")

function ENT:Initialize()
	self.bfarm = {}
	self.a = 0
	print("Init?")
	PrintTable( self:GetSequenceList() )
	self:SetBodygroup(0,1)
	self:SetBodygroup(0,0)
	self:UseClientSideAnimation()
	self:SetSequence(1)
	self:ResetSequence(1)
	self.smoothSoilAmount = 0
	self.cam2d3dSin = 0
	self.smoothLight = 0
end

--Credit to the Wiki for this func (slightly modified though)
function draw.Circle( x, y, radius, seg , percent )
	local cir = {}
	if percent == nil then 	percent = 100 end
	percent = percent / 100.0
	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ((( i / seg ) * -360) * percent ) + 180)
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end
	local a = math.rad( 0 )
	surface.DrawPoly( cir )
end


local icon_dirt = Material("models/bluechu/bfarm/icon_dirt.png","noclamp smooth")
local icon_water = Material("models/bluechu/bfarm/icon_water.png","noclamp smooth")
local icon_sun = Material("models/bluechu/bfarm/icon_sun.png","noclamp smooth")

function ENT:Draw()
	self:DrawModel() 

	--These draw the sun beams for debug purpouses
--	render.DrawLine( self:GetPos() + (self:GetAngles():Up() * 25), self:GetPos() + (self:GetAngles():Up() * 100000), Color(0,0,255), true )
--	render.DrawLine( self:GetPos() + (self:GetAngles():Up() * 25), self:GetPos() + (self:GetAngles():Up() * 100000) + (self:GetAngles():Right() * 35000), Color(0,0,255), true )
--	render.DrawLine( self:GetPos() + (self:GetAngles():Up() * 25), self:GetPos() + (self:GetAngles():Up() * 100000) + (self:GetAngles():Right() * -35000), Color(0,0,255) , true)
--	render.DrawLine( self:GetPos() + (self:GetAngles():Up() * 25), self:GetPos() + (self:GetAngles():Up() * 100000) + (self:GetAngles():Forward() * 35000), Color(0,0,255), true )
--	render.DrawLine( self:GetPos() + (self:GetAngles():Up() * 25), self:GetPos() + (self:GetAngles():Up() * 100000) + (self:GetAngles():Forward() * -35000), Color(0,0,255), true )


	--Now do the cam2D3D
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 250 then
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 200.0)
		alpha = math.Clamp(1.25 - alpha, 0 ,1)
		local a = Angle(0,0,0) 
		a:RotateAroundAxis(Vector(1,0,0),90)
		a.y = LocalPlayer():GetAngles().y - 90
		self.smoothLight = Lerp(4 * FrameTime() , self.smoothLight , self:GetSunLevel())
		cam.Start3D2D(self:GetPos() + Vector(0,0,56), a , 0.10)

			draw.RoundedBox(8,-150,-100,300,100 , Color(45,45,45,255 * alpha))

			local tri = {{x = -25 , y = 0},{x = 25 , y = 0},{x = 0 , y = 25}}
			surface.SetDrawColor(Color(45,45,45,255 * alpha))
			draw.NoTexture()
			surface.DrawPoly( tri )

			--Now draw the icons and such

			--Draw Soil
			surface.SetDrawColor(Color(139/2,69/2,19/2 , 255 * alpha))
			draw.Circle( (300/3 - 50) - 150, 50 - 100 , 45, 18)

			surface.SetDrawColor(Color(139,69,19 , 255 * alpha))
			draw.Circle( (300/3 - 50) - 150, 50 - 100 , 45, 18 , (self:GetSoilAmount()/self:GetMaxSoilAmount()) * 100)

			surface.SetDrawColor(Color(60,60,60,255 * alpha))
			draw.Circle( (300/3 - 50) - 150, 50 - 100 , 35, 18)

			surface.SetDrawColor(Color(139,69,19 , 255 * alpha))
			surface.SetMaterial(icon_dirt)
			surface.DrawTexturedRect(((300/3 - 50) - 150) - 25 , 50 - 100 - 25 , 50 , 50)
			draw.NoTexture()

			--Draw Water
			surface.SetDrawColor(Color(100/4,100/4,255/4 , 255 * alpha))
			draw.Circle( ((300/3) * 2) - 50  - 150, 50 - 100 , 45, 18)

			surface.SetDrawColor(Color(100,100,255 , 255 * alpha))
			draw.Circle( ((300/3) * 2) - 50  - 150, 50 - 100 , 45, 18 , (self:GetWaterLevel()/self:GetMaxWaterAmount())*100)

			surface.SetDrawColor(Color(60,60,60,255 * alpha))
			draw.Circle( ((300/3) * 2) - 50  - 150, 50 - 100 , 35, 18)

			surface.SetDrawColor(Color(100,100,255, 255 * alpha))
			surface.SetMaterial(icon_water)
			surface.DrawTexturedRect( ((300/3) * 2) - 50  - 150 - 25, 50 - 100 - 25 , 50 , 50)
			draw.NoTexture()

			--Draw Sun
			surface.SetDrawColor(Color(255/4,255/4,0 , 255 * alpha))
			draw.Circle( ((300/3) * 3) - 50  - 150, 50 - 100 , 45, 18)

			surface.SetDrawColor(Color(255,255,0 , 255 * alpha))
			draw.Circle( ((300/3) * 3) - 50  - 150, 50 - 100 , 45, 18 , (self.smoothLight / 5) * 100)

			surface.SetDrawColor(Color(60,60,60,255 * alpha))
			draw.Circle( ((300/3) * 3) - 50  - 150, 50 - 100 , 35, 18)

			surface.SetDrawColor(Color(255,255,0, 255 * alpha))
			surface.SetMaterial(icon_sun)
			surface.DrawTexturedRect( ((300/3) * 3) - 50  - 150 - 25, 50 - 100 - 25 , 50 , 50)
			draw.NoTexture()


		cam.End3D2D()
	end 
end

--Animates the soil
function ENT:Think()
	self.cam2d3dSin = self.cam2d3dSin + (1.5 * FrameTime())
	if self:GetSoilAmount() > 0 then
		self:SetBodygroup(0,1)
		self:SetBodygroup(1,0)
		self:SetCycle(self.smoothSoilAmount / self:GetMaxSoilAmount())
	else
		self:SetBodygroup(1,1)
		self:SetBodygroup(0,0)
		self:SetCycle(0)
	end
	self.smoothSoilAmount = Lerp(8 * FrameTime() , self.smoothSoilAmount , self:GetSoilAmount())
end
