AddCSLuaFile("bfarm_config.lua")
AddCSLuaFile("bfarm/bfarm_plants.lua")

include("bfarm_config.lua")
include("bfarm/bfarm_plants.lua")

local function SaveBFarm()
	local farmers = ents.FindByClass("bfarm_farm_market")
	local data = {}
	if farmers ~= nil and table.Count(farmers) > 0 then
		for k ,v in pairs(farmers) do
			local entry = {}
			entry.position = v:GetPos()
			entry.angle = v:GetAngles()
			table.insert(data , entry)
		end
		file.Write("bfarm_data.txt",util.TableToJSON(data))
	else
		file.Write("bfarm_data.txt","[]")
	end
end

local function ClearBFarm()
	local farmers = ents.FindByClass("bfarm_farm_market")
	if farmers ~= nil and table.Count(farmers) > 0 then
		for k ,v in pairs(farmers) do
			v:Remove()
		end
	end
end

local function LoadBFarm()
	local data = file.Read( "bfarm_data.txt", "DATA" ) 
	if data ~= nil then
		data = util.JSONToTable(data)
		for k ,v in pairs(data) do
			local e = ents.Create("bfarm_farm_market")
			e:SetPos(v.position)
			e:SetAngles(v.angle)
			e:Spawn()
		end
	end
end

hook.Add( "InitPostEntity", "LoadBFarmNPCs", function()
	LoadBFarm()
end )

hook.Add("PlayerSay", "SaveBFarmStuff" , function(sender , text)
	if string.lower(string.sub(text , 1 , 10)) == "!savebfarm" then
		if table.HasValue(BFARM_AUTHORISED_RANKS,sender:GetUserGroup()) then
			SaveBFarm()
			sender:ChatPrint("[BFARM] Saving all NPC's on the map!")
		else
			sender:ChatPrint("[BFARM] You do not have permission to do this, if you think this is a mistake contact the dev/owner")
		end
	end
	if string.lower(string.sub(text , 1 , 11)) == "!clearbfarm" then
		if table.HasValue(BFARM_AUTHORISED_RANKS,sender:GetUserGroup()) then
			ClearBFarm()
			sender:ChatPrint("[BFARM] Removed all NPC's on the map, Dont forget to do !savebfarm if you want to permanently remove them!")
		else
			sender:ChatPrint("[BFARM] You do not have permission to do this, if you think this is a mistake contact the dev/owner")
		end
	end
end)

