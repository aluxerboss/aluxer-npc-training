--[[
    Resource Name : ALUXER NPC TRAINING
    Developer : ALUXER#9951 (Discord)
]]
local npc_entity = {}
local location = nil
local num = 1
local delnpc = false

function SpawnNpcBoost()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local v = Aluxer['about']['zone'][tonumber(location)]
    if v ~= nil then
	local ped_model = string.upper(v.model)
	RequestModel(GetHashKey(ped_model))
	while not HasModelLoaded(GetHashKey(ped_model)) or not HasCollisionForModelLoaded(GetHashKey(ped_model)) do
		Citizen.Wait(1)
	end
	local dist = v.dist or 20.0
	local newX = v.coords.x + math.random(-dist, dist)
	local newY = v.coords.y + math.random(-dist, dist)
	local _, newZ = GetGroundZFor_3dCoord(newX+.0, newY+.0, v.coords.z+999.0, 1)
	local ped = CreatePed(4, GetHashKey(ped_model), newX, newY, newZ, 0.0, false, false)
	SetEntityHealth(ped, 300)
	SetPedArmour(ped, 10000)
	FreezeEntityPosition(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	TaskStartScenarioInPlace(ped, "anim@heists@narcotics@funding@gang_idle", "gang_chatting_idle01", 0, false)
	RequestAnimDict("anim@heists@narcotics@funding@gang_idle", "gang_chatting_idle01")
	TaskPlayAnim(ped, "anim@heists@narcotics@funding@gang_idle", "gang_chatting_idle01", 20.0, -20.0, -1, 1, 0, false, false, false)
	table.insert(npc_entity,{entity = ped})
	num = num + 1
	Citizen.Wait(1000)
    end
end

function GetLocationPoint()
    local w = nil
    local playerCoords = GetEntityCoords(PlayerPedId())
    for k,v in pairs(Aluxer['about']['zone']) do
        if GetDistanceBetweenCoords(playerCoords, v.coords.x, v.coords.y, v.coords.z, true) < v.dist then
            w = k
            return w
        end
    end
    return w
end

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        location = GetLocationPoint()
        local v = Aluxer['about']['zone'][tonumber(location)]
        if v ~= nil and GetDistanceBetweenCoords(playerCoords, v.coords.x, v.coords.y, v.coords.z, true) < v.dist then
	   if #npc_entity < v.max then
	      SpawnNpcBoost()
	   end
	   Citizen.Wait(v.respawn)
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
   while true do
	Citizen.Wait(0)
	local w = true
	if not delnpc then
	   for k, v in pairs(npc_entity) do
	      if DoesEntityExist(v.entity) then
		local coords_ped = GetEntityCoords(v.entity)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local health_ped = GetEntityHealth(v.entity)
		local dist = GetDistanceBetweenCoords(playerCoords,coords_ped, true)
		if health_ped <= 0 then
		   w = false
		   SetEntityAsNoLongerNeeded(v.entity)
		   DeleteEntity(v.entity)
		   npc_entity[k] = nil
		   num = num - 1
		end
		if dist > 100 then
		   DeleteNpc()
		end
	     end
	   end
	end
	if w then
	   Citizen.Wait(500)
	end
   end
end)

function DeleteNpc()
   if delnpc then return end
   delnpc = true
   for k,v in pairs(npc_entity) do
      SetEntityAsNoLongerNeeded(v.entity)
      DeleteEntity(v.entity)
      npc_entity[k] = nil
      num = num - 1
   end
   delnpc = false
   print('[ALUXER] NPC BOOST : DELETE')
end

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
      for k,v in pairs(npc_entity) do
         SetEntityAsNoLongerNeeded(v.entity)
         DeleteEntity(v.entity)
      end
   end
end)
