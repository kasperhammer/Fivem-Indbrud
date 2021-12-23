unlock = false
onMission = false
alertcops = false
startrobbery = true
blips = {}
peds = {}
pickups = {}
hasexited = true
lastDoor = 1
currentVan = nil
hours1, minutes1, seconds1 = 0,0,0
shouldDraw = false
inMissionVehicle = false
sleft = ""
left = ""
missionVehicles = {
	`Rumpo`,
	`boxville2`,
	`boxville3`,
	`boxville4`
}
ready = false

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
  end
RegisterNetEvent('misionfailed')
AddEventHandler('misionfailed',function()

	alertcops = true
end)
-- slower thread in idle state
CreateThread(function()
	while true do
		Wait(2000)

		local player = PlayerPedId()
		if IsPedInAnyVehicle(player) then
			local vehicle = GetVehiclePedIsIn(player)
			inMissionVehicle = IsMissionVehicle(GetEntityModel(vehicle))
		end
	end
end)

CreateThread(function()
	if not HasStreamedTextureDictLoaded('timerbars') then
		RequestStreamedTextureDict('timerbars')
		while not HasStreamedTextureDictLoaded('timerbars') do
			Wait(0)
		end
	end
	
	-- load ipls
	RequestIpl("hei_hw1_blimp_interior_v_studio_lo_milo_")
	RequestIpl("hei_hw1_blimp_interior_v_apart_midspaz_milo_")

	while true do
		Wait(0)
		
		-- if pressed E in a vehicle and not onMission
		  if inMissionVehicle and not onMission and IsControlJustPressed(0, 51) then
			if startrobbery == true then
            	stolenItems = {}
             	currentItem = {}

			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
			TriggerServerEvent('currenttime1')
			TriggerServerEvent('starttimer')
			if IsMissionVehicle(GetEntityModel(veh)) then
				local time = TimeToSeconds(GetClockTime())
				     
				    resettimer()
					onMission = true
					
				
					-- spawn blips
					for _,door in pairs(doors) do
						unlock = false
						local blip = AddBlipForCoord(door.coords.x, door.coords.y, door.coords.z)
						SetBlipSprite(blip, 40)
						SetBlipColour(blip, 1)
						SetBlipAsShortRange(blip, true)
						
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("House")
						EndTextCommandSetBlipName(blip)
						
						table.insert(blips, blip)
					end
					
					currentVan = VehToNet(veh)
					SetEntityAsMissionEntity(veh, false, false)
					
					ShowMPMessage("Indbrud", "Find et ~r~hus ~s~og bryd ind.", 3500)
					
					--ShowSubtitle("Find a ~r~house ~s~ to rob")
				
			end
		else
			
              value = sleft / 60
			  value = round(value,2)
			  str ="Du skal vente i "..value.. " minutter inden du kan ~r~røve ~s~ et nyt hus. "
			ShowMPMessage("Indbrud", str, 3500)
		end
		  end
	  
		
	end
end)
function DADA()
	if alertcops == true then
	
	local player = GetPlayerPed(-1)
	local message = ""
	local alreadyNotified = true
	local playerCoords = GetEntityCoords(player)
	--local street = GetStreetName(playerCoords)
	
	alertcops = false
	local gender = ""

	
		gender = "en person"
	

		local street = GetStreetName(playerCoords)

		message = "^7^*Der er inbrud på " .. street .. "!"
	
	if message ~= "" then
		local handle, object = FindFirstPed()
	
		local success
			
				NotifyPeople(message, playerCoords, object)
				alreadyNotified = false
				Citizen.Wait(5000)
		

			

		EndFindPed(handle)
	end
end
end

function resettimer()
    hours1, minutes1, seconds1 = GetClockTime()
	--minutes1 = minutes1 + 0
	hours1 = hours1 + 4
end
terstart111 = ""
terstart11 = ""
ternu11 = ""
ternu111 = ""
callonetime111 = false
RegisterNetEvent('sendtime1234596')
AddEventHandler('sendtime1234596', function(minutter10,skunder10)
	
if callonetime111 == false then
	--Make this double of the daytimer

	terstart111 = ""
	ready = true
                terstart11 = ""
                ternu11 = ""
                ternu111 = ""
terstart11 = minutter10 + 4
terstart111 = skunder10 + 0 
callonetime111 = true
end
ternu11 = minutter10 + 0
ternu111 = skunder10 + 0
 left = TimeToSeconds(0,terstart11,terstart111) - TimeToSeconds(0,ternu11,ternu111)

if left / 2 < -1 then
	callonetime = false
	TriggerServerEvent('currenttime1')

	
end
end)
CreateThread(function()
resettimer()
	while true do
		
		Wait(0)
		if ready == true then
		if onMission then
		
			-- maths to calculate time until daylight
		
		
		
			local time = SecondsToTime(left)
			
			-- draw info
			DrawTimerBar("ITEMS", #stolenItems, 2)
			DrawTimerBar("DAYLIGHT", AddLeadingZero(time.minutes) .. ":" .. AddLeadingZero(time.seconds), 1)

			
		end
	end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		
		if onMission then		
			local coords = GetEntityCoords(PlayerPedId())

			for k,door in pairs(doors) do
				-- draw marker
				if Vdist(coords, door.coords.x, door.coords.y, door.coords.z) < 100 then
					DrawMarker(0, door.coords.x, door.coords.y, door.coords.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 204, 255, 0, 50, true, true, 2, nil, nil, false)
				end
				
				-- can enter
				if Vdist(coords, door.coords.x, door.coords.y, door.coords.z) < 2 then
					DisplayHelpText("Tryk ~INPUT_CONTEXT~ for at komme ind i huset.")
					
					if IsControlJustPressed(0, 51) then

						
                      if door.unlock == false then
						TriggerEvent('lockpickdoor')
					  else
						local house = houses[door.house]
						
						SetEntityCoords(PlayerPedId(), house.coords.x, house.coords.y, house.coords.z)
						hasexited = false
						SetEntityHeading(PlayerPedId(), house.coords.heading)
						
						lastDoor = k
						shouldDraw = true
						
						SpawnResidents(door.house)
						
						SpawnPickups(door.house, k)
						
						ShowSubtitle("Du er nu i huset, værd forsigtig og lav ikke for meget larm . (snige)")
					  end
					end
				end
			end
		end
	--[[	
		function housedoors()
			if onMission then		
				local coords = GetEntityCoords(PlayerPedId())
	
				for k,door in pairs(doors) do
					-- draw marker
					if Vdist(coords, door.coords.x, door.coords.y, door.coords.z) < 100 then
						DrawMarker(0, door.coords.x, door.coords.y, door.coords.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 204, 255, 0, 50, true, true, 2, nil, nil, false)
					end
					
					-- can enter
					if Vdist(coords, door.coords.x, door.coords.y, door.coords.z) < 2 then
						DisplayHelpText("Press ~INPUT_CONTEXT~ to enter this house.")
						
						if unlock == true then
	
	                         
							
							local house = houses[door.house]
							
							SetEntityCoords(PlayerPedId(), house.coords.x, house.coords.y, house.coords.z)
							hasexited = false
							SetEntityHeading(PlayerPedId(), house.coords.heading)
							
							lastDoor = k
							shouldDraw = true
							
							SpawnResidents(door.house)
							
							SpawnPickups(door.house, k)
							
							ShowSubtitle("You are in the house now, be carefull to not make too much noise. (sneaking)")
						end
					end
				end
			end
		end
]]
 callonce = false
RegisterNetEvent('alertpolice')
AddEventHandler('alertpolice', function()

		
     if callonce == false then
	     
			alertcops = true
			callonce = true
			DADA()
			Citizen.Wait(1000)
			
    end
			
end)

RegisterNetEvent('lockalldoors')
AddEventHandler('lockalldoors',function()
	for k,door in pairs(doors) do
		
		
		
		
			door.unlock = false
			
		
	end
end)

		RegisterNetEvent('unlockdoor')
		AddEventHandler('unlockdoor', function()
			
			if onMission then		
				local coords = GetEntityCoords(PlayerPedId())
	
				for k,door in pairs(doors) do
					-- draw marker
					if Vdist(coords, door.coords.x, door.coords.y, door.coords.z) < 100 then
						DrawMarker(0, door.coords.x, door.coords.y, door.coords.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 204, 255, 0, 50, true, true, 2, nil, nil, false)
					end
					
					-- can enter
					if Vdist(coords, door.coords.x, door.coords.y, door.coords.z) < 2 then
						
						
						door.unlock = true
						
						if door.unlock == true then
	
	                         
							
							local house = houses[door.house]
							
							SetEntityCoords(PlayerPedId(), house.coords.x, house.coords.y, house.coords.z)
							hasexited = false
							SetEntityHeading(PlayerPedId(), house.coords.heading)
							
							lastDoor = k
							shouldDraw = true
							
							SpawnResidents(door.house)
							
							SpawnPickups(door.house, k)
							
							ShowSubtitle("You are in the house now, be carefull to not make too much noise. (sneaking)")
						end
					end
				end
			end
					
                      
					--housedoors()
			
			          
		end)

		if shouldDraw then
			local coords = GetEntityCoords(PlayerPedId())

			-- check inside
			for _,house in pairs(houses) do
				--DrawBox(house.area[1], house.area[2], 255, 255, 255, 50)
				if IsEntityInArea(PlayerPedId(), house.area[1], house.area[2], 0, 0, 0) then
					if onMission then
						DrawNoiseBar(GetPlayerCurrentStealthNoise(PlayerId()), 3)
					end
					
					-- draw exit doors in houses (even if not in mission)
					DrawMarker(0, house.door, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 204, 255, 0, 50, true, true, 2, nil, nil, false)

					if Vdist(coords, house.door) < 1 then
						local door = doors[lastDoor]
					
						SetEntityCoords(PlayerPedId(), door.coords.x, door.coords.y, door.coords.z)
						hasexited = true
						DADA()
						RemoveResidents()
						RemovePickups()
						
						shouldDraw = false
						
						-- play holding anim if holding something after teleported outside
						if isHolding then
							TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "walk", 1.0, 1.0, -1, 1 | 16 | 32, 0.0, 0, 0, 0)
						end
					end
				end
			end
		end
	end
end)

function SpawnPickups(house, door)
	for k,pickup in pairs(houses[house].pickups) do
		if not IsAlreadyStolen(door, k) then
			-- spawn prop
			RequestModel(pickup.model)
			
			while not HasModelLoaded(pickup.model) do
				Wait(0)
			end
			
			local prop = CreateObject(GetHashKey(pickup.model), pickup.coord, false, false, false)
			SetEntityHeading(prop, pickup.rotation)
			
			-- create blip
			local blip = AddBlipForCoord(pickup.coord)
			SetBlipColour(blip, 2)
			SetBlipScale(blip, 0.7)
			
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(pickup.model)
			EndTextCommandSetBlipName(blip)
			
			table.insert(pickups, {
				blip = blip,
				prop = prop,
				item = { house = house, id = k, door = door }
			})
		end
	end
end

function RemovePickups()
	for k,pickup in pairs(pickups) do
		RemoveBlip(pickup.blip)
		
		SetObjectAsNoLongerNeeded(pickup.prop)
		DeleteObject(pickup.prop)
	end
	
	pickups = {}
end

function SpawnResidents(house)
	for _,resident in pairs(residents) do
		if resident.house == house then
			RequestModel(resident.model)
		
			while not HasModelLoaded(resident.model) do 
				Wait(0)
			end
			
			local ped = CreatePed(4, resident.model, resident.coord, resident.rotation, false, false)
			table.insert(peds, ped)
			
			-- animation
			RequestAnimDict(resident.animation.dict)
	
			while not HasAnimDictLoaded(resident.animation.dict) do 
				Wait(0) 
			end
			
			if resident.aggressive then
				GiveWeaponToPed(ped, `WEAPON_PISTOL`, 255, true, false)
			end
			
			TaskPlayAnimAdvanced(ped, resident.animation.dict, resident.animation.anim, resident.coord, 0.0, 0.0, resident.rotation, 8.0, 1.0, -1, 1, 1.0, true, true)
			SetFacialIdleAnimOverride(ped, "mood_sleeping_1", 0)
			
			SetPedHearingRange(ped, 0.50)
			SetPedSeeingRange(ped, 0.0)
			SetPedAlertness(ped, 0)
		end
	end
end

function RemoveResidents()
	for k,ped in pairs(peds) do
		SetPedAsNoLongerNeeded(ped)
		DeletePed(ped)
	end
	
	peds = {}
end

function IsAlreadyStolen(door, id)
	for _,v in pairs(stolenItems) do
		if v.door == door and v.id == id then
			return true
		end
	end
	
	return false
end

function GetCurrentHouse()
	for index,house in pairs(houses) do
		if IsEntityInArea(PlayerPedId(), house.area[1], house.area[2], 0, 0, 0) then
			return true, index
		end
	end
	
	return false, index
end

function RemoveBlips()
	for _,blip in pairs(blips) do
		RemoveBlip(blip)
	end
	
	blips = {}
end

function IsMissionVehicle(model)
	for _,v in pairs(missionVehicles) do
		if model == v then
			return true
		end
	end
	
	return false
end



function CheckDistance(object, pos, checkAlertness)
	
	
    local pedCoords = GetEntityCoords(object)
    local dis = Vdist(pos.x, pos.y, pos.z, pedCoords.x, pedCoords.y, pedCoords.z)
	
    
	
        --Citizen.Trace(tostring(dis))
        if checkAlertness then
            if GetPedAlertness(object) >= 1 then
				
                return true
				
            else
                return false
            end
        end

      
    

    return true
end

function GetStreetName(playerPos)
    local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, playerPos.x, playerPos.y, playerPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)

    if s2 == 0 then
        return street1
    elseif s2 ~= 0 then
        return street1 .. " - " .. street2
    end
end

local blipList = {}




RegisterNetEvent('notifyDispatch1')
AddEventHandler('notifyDispatch1', function(x,y,z,message)
    local ped = GetPlayerPed(PlayerPedId())
    local blip = AddBlipForCoord(x+0.001,y+0.001,z+0.001)
    SetBlipSprite(blip, 304)
    SetBlipColour(blip, 67)
    SetBlipAlpha(blip, 250)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Alarmcentralen")
    SetBlipScale(blip, 0.8)
    EndTextCommandSetBlipName(blip)

    table.insert(blipList, blip)
   
    --Citizen.Trace("x:" .. x .. " y:" .. y .. " z:" .. z)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    TriggerEvent('chatMessage', '^3[Alarmcentralen]', "^3[Alarmcentralen]", message)
end)

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(PlayerPedId())
        for k,v in pairs(blipList) do
            RemoveBlip(v)
        end
        blipList = {}
        Citizen.Wait(180000)
    end
end)


function NotifyPeople(message, pos, npc)

    TriggerServerEvent('dispatch1', pos.x, pos.y, pos.z, message)
end

RegisterCommand("CancelRobbery", function(source, args, rawCommand)
if hasexited == true then

	
	TriggerServerEvent("burglary:ended", true, false)
end

end)


keepgoing = true
RegisterNetEvent('cooldowntimer')
AddEventHandler('cooldowntimer', function()
	keepgoing = true
	startrobbery = false
	print('cooldown triggered')
    Citizen.CreateThread(function()
		
        while keepgoing == true do
			  
			  Citizen.Wait(1000)	
			  TriggerServerEvent('currenttime2')		
			  
				
			
		end

    end)

end)
stimerstart1 = ""
stimerstart11 = ""
sterstart1 = ""
sterstart = ""
sternu = ""
sternu1 = ""
callonetime1 = false
RegisterNetEvent('sendtime12')
AddEventHandler('sendtime12', function(minutter10,skunder10,timer10)
if callonetime1 == false then
	--Make this double of the daytimer
	stimerstart1 = ""
	stimerstart11 = ""
	            sterstart1 = ""
                sterstart = ""
                sternu = ""
                sternu1 = ""
sterstart = minutter10 + 20
sterstart1 = skunder10 + 0
stimerstart1 = timer10 + 0
stimerstart1 = stimerstart1 + 0
if sterstart > 60 then
	print('more than 20 min remaining')
  
    sterstart = sterstart - 60
    stimerstart1 = stimerstart1 + 1
    print(stimerstart1)  print(sterstart)
end



callonetime1 = true
end
sternu = minutter10 + 0
sternu1 = skunder10 + 0
stimerstart11 = timer10 + 0


 sleft = TimeToSeconds(stimerstart1,sterstart,sterstart1) - TimeToSeconds(stimerstart11,sternu,sternu1)
 
 print(sleft / 2)
 if sleft > 1200 then
	print('something went wrong with the time resetting')
	sleft = -10

end


if sleft / 2 < -1 then
	callonetime1 = false
	callonetime = false
	callonetime111 = false
	keepgoing = false
	startrobbery = true
	TriggerServerEvent('currenttime2')

	
end

end)