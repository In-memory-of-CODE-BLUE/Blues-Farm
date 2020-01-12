AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include ("shared.lua")

include("bfarm/bfarm_plants.lua")

util.AddNetworkString("bfarm_show_receipt")
util.AddNetworkString("sell_shipping_box")

function ENT:Initialize()
	self:SetModel( "models/bluechu/bfarm/crate.mdl" )
	self:SetColor(Color(255,255,255))
	self:PhysicsInit( SOLID_VPHYSICS )     
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:StartTouch(e)
	if e:GetClass() == "bfarm_plant" then
		self:AddItem(e.plantInfo.name)
		e:Remove()
	end
end

function ENT:Use(ACT , CALL)
	net.Start("bfarm_show_receipt")
		net.WriteEntity(self)
	net.Send(CALL)
end

function ENT:AddItem(itemType)
	if itemType == "Carrot" then
		self:SetCarrotAmount(self:GetCarrotAmount() + 1)
	elseif itemType == "Tomato" then
		self:SetTomatoAmount(self:GetTomatoAmount() + 1)
	elseif itemType == "Lettuce" then
		self:SetLettuceAmount(self:GetLettuceAmount() + 1)
	elseif itemType == "Potato" then
		self:SetPotatoAmount(self:GetPotatoAmount() + 1)
	end
end

function ENT:SellCrate(seller)
	--first is there a dealer close by
	local dealers = ents.FindByClass("bfarm_farm_market")

	local ourPos = self:GetPos()
	if dealers == nil or table.Count(dealers) < 1 then return end
	local inrange = false
	for k, v in pairs(dealers) do
		if ourPos:Distance(v:GetPos()) < 150 then
			inrange = true
			break
		end
	end

	if not inrange then return end

	local salePrice = (CARROT_SELL_AMOUNT * self:GetCarrotAmount()) + 
									(LETTUCE_SELL_AMOUNT * self:GetLettuceAmount()) + 
									(POTATO_SELL_AMOUNT * self:GetPotatoAmount())
  if seller ~= nil then
  	seller:addMoney(salePrice)
  	seller:ChatPrint("You sold the crate to the farm for '$"..salePrice.."'!")
  	self:Remove()
  end
end

net.Receive("sell_shipping_box" , function(len, ply)
	local crate = net.ReadEntity()
	if crate ~= nil and crate:GetClass() == "bfarm_shipping_crate" then
		if ply:GetPos():Distance(crate:GetPos()) < 250 then
			crate:SellCrate(ply)
		end
	end
end)

function ENT:OnTakeDamage()
	self:Remove()
end