include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH

surface.CreateFont( "Farmer_NPC_Font", {
	font = "Roboto Lt",
	extended = false,
	size = 65,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function ENT:Draw()
	self:DrawModel()

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 550 then
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 500.0)
		alpha = math.Clamp(1.25 - alpha, 0 ,1)
		local a = Angle(0,0,0)
		a:RotateAroundAxis(Vector(1,0,0),90)
		a.y = LocalPlayer():GetAngles().y - 90
		cam.Start3D2D(self:GetPos() + Vector(0,0,80), a , 0.074)
			draw.RoundedBox(8,-225,-75,450,75 , Color(45,45,45,255 * alpha))
			local tri = {{x = -25 , y = 0},{x = 25 , y = 0},{x = 0 , y = 25}}
			surface.SetDrawColor(Color(45,45,45,255 * alpha))
			draw.NoTexture()
			surface.DrawPoly( tri )

			draw.SimpleText("Farmers Market","Farmer_NPC_Font",0,-40,Color(255,255,255,255) , 1 , 1)
		cam.End3D2D()
	end
end

function ENT:SetRagdollBones( b )
	self.m_bRagdollSetup = b
end

function ENT:DrawTranslucent()
	self:Draw()
end


