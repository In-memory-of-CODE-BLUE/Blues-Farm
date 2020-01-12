include("shared.lua")

local icon_carrot = Material("models/bluechu/bfarm/icon_carrot.png")
local icon_lettuce = Material("models/bluechu/bfarm/icon_lettuce.png")
local icon_tomato = Material("models/bluechu/bfarm/icon_tomato.png")
local icon_potato = Material("models/bluechu/bfarm/icon_potato.png")

local recieptPos = ScrH()
local showReceipt = false

surface.CreateFont( "shipping_info", {
	font = "Robot Lt", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 45,
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

surface.CreateFont( "shipping_info2", {
	font = "Robot Lt", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 25,
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

surface.CreateFont( "shipping_info3", {
	font = "Robot Lt", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 18,
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

function ENT:Initialize()
	self.sellAlpha = 0
end

local receiptMat = Material("models/bluechu/bfarm/receipt.png","noclamp")

function ENT:Draw() 
	self:DrawModel()
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 300 then
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 250.0)
		alpha = math.Clamp(1.25 - alpha, 0 ,1)
		local a = Angle(0,0,0)
		a:RotateAroundAxis(Vector(1,0,0),90)
		a.y = LocalPlayer():GetAngles().y - 90
		cam.Start3D2D(self:GetPos() + Vector(0,0,45), a , 0.074)
			draw.RoundedBox(8,-155,-125,155  * 2,105 , Color(45,45,45,255 * alpha))
			local tri = {{x = -25 , y = -20},{x = 25 , y = 0 -20},{x = 0 , y = 25 -20}}
			surface.SetDrawColor(Color(45,45,45,255 * alpha))
			draw.NoTexture()
			surface.DrawPoly( tri )

			--Draw Icons Here
			draw.NoTexture()
			surface.SetDrawColor(Color(20,20,20,255 * alpha))
			draw.Circle(-100 , -72 , 44, 32)
			surface.SetDrawColor(Color(67,67,67,255 * alpha))
			draw.Circle(-100 , -72 , 42, 32)
			
			surface.SetDrawColor(Color(255,255,255, 255 * alpha))
			surface.SetMaterial(icon_carrot)
			surface.DrawTexturedRect( -125 , -100 , 50 , 50)

			draw.NoTexture()
			surface.SetDrawColor(Color(0,0,0,200 * alpha))
			draw.Circle(-100 , -72 , 42, 32)

			draw.SimpleText(self:GetCarrotAmount(),"shipping_info",-100 , -74 ,Color(180,180,180,100),1,1)



			draw.NoTexture()
			surface.SetDrawColor(Color(20,20,20,255 * alpha))
			draw.Circle(-0 , -72 , 44, 32)
			surface.SetDrawColor(Color(67,67,67,255 * alpha))
			draw.Circle(-0 , -72 , 42, 32)
			
			surface.SetDrawColor(Color(255,255,255, 255 * alpha))
			surface.SetMaterial(icon_lettuce)
			surface.DrawTexturedRect( -25 , -100 , 50 , 50)

			draw.NoTexture()
			surface.SetDrawColor(Color(0,0,0,200 * alpha))
			draw.Circle(-0 , -72 , 42, 32)

			draw.SimpleText(self:GetLettuceAmount(),"shipping_info",-0 , -74 ,Color(180,180,180,100),1,1)




			draw.NoTexture()
			surface.SetDrawColor(Color(20,20,20,255 * alpha))
			draw.Circle(100 , -72 , 44, 32)
			surface.SetDrawColor(Color(67,67,67,255 * alpha))
			draw.Circle(100 , -72 , 42, 32)
			
			surface.SetDrawColor(Color(255,255,255, 255 * alpha))
			surface.SetMaterial(icon_potato)
			surface.DrawTexturedRect( 75 , -100 , 50 , 50)

			draw.NoTexture()
			surface.SetDrawColor(Color(0,0,0,200 * alpha))
			draw.Circle(100 , -72 , 42, 32)

			draw.SimpleText(self:GetPotatoAmount(),"shipping_info", 100 , -74 ,Color(180,180,180,100),1,1)

			--Draw sell infomation now

			local sellers = ents.FindByClass("bfarm_farm_market")
			local canSell = false
			for k ,v in pairs(sellers) do
				if v:GetPos():Distance(self:GetPos()) < 150 then
					canSell = true
					break
				end
			end

			if canSell then
				self.sellAlpha = Lerp(3 * FrameTime() , self.sellAlpha , 1)
			else
				self.sellAlpha = Lerp(6 * FrameTime() , self.sellAlpha , 0)
			end

			draw.RoundedBox(8,-155,-125,155  * 2,105 , Color(15,15,15,225 * self.sellAlpha))
			draw.SimpleText("Press 'E' to sell","shipping_info",0,-75 , Color(180,180,180,255 * self.sellAlpha) , 1,1)
			surface.SetDrawColor(Color(15,15,15,225 * self.sellAlpha))
			draw.NoTexture()
			surface.DrawPoly( tri )
		cam.End3D2D()
	end
end

local windowOpen = false
net.Receive("bfarm_show_receipt",function()
	local crate = net.ReadEntity()
	if(showReceipt or windowOpen) then return end
	local sellers = ents.FindByClass("bfarm_farm_market")
	local canSell = false
	for k ,v in pairs(sellers) do
		if v:GetPos():Distance(crate:GetPos()) < 150 then
			canSell = true
			break
		end
	end
	if not canSell then return end
	showReceipt = true
	recieptPos = ScrH() + 10

	local receiptWindow = vgui.Create("DFrame")
	receiptWindow:SetTitle("")
	receiptWindow:ShowCloseButton(false)
	receiptWindow:MakePopup()
	receiptWindow:SetSize(1050/2 , 1050/2)
	receiptWindow:SetPos((ScrW()/2) - (1050/4) , ScrH() + 10)
	receiptWindow.Think = function(s)
		windowOpen = true
		if showReceipt then
			recieptPos = Lerp(6 * FrameTime() , recieptPos , ScrH() - (1050/2))
		else
			recieptPos = Lerp(12 * FrameTime() , recieptPos , ScrH() + 10)
			if recieptPos - ScrH() >= 0 then
				s:Remove()
				windowOpen = false
			end
		end
		s:SetPos(ScrW()/2 - (1050 / 4) , recieptPos)
	end
	receiptWindow.Close = function(s)
		showReceipt = false
	end
	receiptWindow.Paint = function(s , w , h)
		surface.SetDrawColor(Color(255,255,255,255))
		surface.SetMaterial(receiptMat)
		surface.DrawTexturedRect(0, 0 , w , h)
		if showReceipt then
		--Draw the contents
			draw.SimpleText("ITEMS","shipping_info2",w/2 , 190, Color(35,35,35,255), 1 , 1)
			local PosX = 240
			draw.SimpleText("CARROTS x"..crate:GetCarrotAmount(),"shipping_info3",128 , PosX, Color(35,35,35,255), 0 , 0)
			draw.SimpleText("$"..(CARROT_SELL_AMOUNT * crate:GetCarrotAmount()),"shipping_info3",(1050/2) - 128 , PosX, Color(35,35,35,255), 2 , 0)
			PosX = PosX + 24
			draw.SimpleText("LETTUCE x"..crate:GetLettuceAmount(),"shipping_info3",128 , PosX, Color(35,35,35,255), 0 , 0)
			draw.SimpleText("$"..(LETTUCE_SELL_AMOUNT * crate:GetLettuceAmount()),"shipping_info3",(1050/2) - 128 , PosX, Color(35,35,35,255), 2 , 0)
			PosX = PosX + 24
			draw.SimpleText("POTATO x"..crate:GetPotatoAmount(),"shipping_info3",128 , PosX, Color(35,35,35,255), 0 , 0)
			draw.SimpleText("$"..(POTATO_SELL_AMOUNT * crate:GetPotatoAmount()),"shipping_info3",(1050/2) - 128 , PosX, Color(35,35,35,255), 2 , 0)
			PosX = PosX + 27
			draw.RoundedBox(3,128 , PosX , (1050/2) - (128 * 2) , 2 , Color(35,35,35,150))
			PosX = PosX + 20
			draw.SimpleText("TOTAL AMOUNT","shipping_info3",128 , PosX, Color(35,35,35,255), 0 , 0)
			local salePrice = (CARROT_SELL_AMOUNT * crate:GetCarrotAmount()) + 
												(LETTUCE_SELL_AMOUNT * crate:GetLettuceAmount()) + 
												(POTATO_SELL_AMOUNT * crate:GetPotatoAmount())
			draw.SimpleText("$"..salePrice,"shipping_info3",(1050/2) - 128 , PosX, Color(35,35,35,255), 2 , 0)
		end
	end

	local cancelButton = vgui.Create("DButton",receiptWindow)
	cancelButton:SetSize(128,45)
	cancelButton:SetPos((1050/4) - 128 - 15 , 400)
	cancelButton:SetText("")
	cancelButton.Paint = function(s , w , h)
		draw.RoundedBox(8,0,0,w,h,Color(255,120,120,255))
		draw.SimpleText("CANCEL","shipping_info2",w/2 , h/2, Color(35,35,35,255), 1 , 1)	
	end
	cancelButton.DoClick = function(s)
		showReceipt = false
	end

	local sellButton = vgui.Create("DButton",receiptWindow)
	sellButton:SetSize(128,45)
	sellButton:SetPos((1050/4) + 15 , 400)
	sellButton:SetText("")
	sellButton.Paint = function(s , w , h)
		draw.RoundedBox(8,0,0,w,h,Color(90,200,90,255))
		draw.SimpleText("SELL","shipping_info2",w/2 , h/2, Color(35,35,35,255), 1 , 1)
	end
	sellButton.DoClick = function(s)
		net.Start("sell_shipping_box")
			net.WriteEntity(crate)
		net.SendToServer()
		showReceipt = false
	end

end)
