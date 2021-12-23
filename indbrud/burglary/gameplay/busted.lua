terstart1 = ""
terstart = ""
ternu = ""
ternu1 = ""
callonetime = false
timestup = false
sstimerstart1 = ""
ssstimerstart1 = ""
RegisterNetEvent('starttimer')
AddEventHandler('starttimer',function()
	TriggerServerEvent('currenttime1')
end)
RegisterNetEvent('sendtime1234596')
AddEventHandler('sendtime1234596', function(minutter10,skunder10,timer10)
	
if callonetime == false then
	--Make this double of the daytimer

	terstart1 = ""
                terstart = ""
                ternu = ""
                ternu1 = ""
terstart = minutter10 + 4
terstart1 = skunder10 + 0
sstimerstart1 = timer10 + 0
if terstart > 60 then
	print('more than 60 min ')
  
    terstart = terstart - 60
    sstimerstart1 = sstimerstart1 + 1
    print(sstimerstart1)  print(terstart)
end
callonetime = true
end
ternu = minutter10 + 0
ternu1 = skunder10 + 0
ssstimerstart1 = timer10 + 0

local left = TimeToSeconds(sstimerstart1,terstart,terstart1) - TimeToSeconds(ssstimerstart1,ternu,ternu1)
if left > 240 then
	print('something went wrong with the time resetting')
	ternu = 0
    ternu1 = 0
	terstart = 0
	terstart1 = 0

end
if left / 2 < -1 then
	callonetime = false
	TriggerServerEvent('currenttime1')
       
	
end
end)

RegisterNetEvent("burglary:finished")
CreateThread(function()
	while true do
		Wait(0)
	
		if onMission then
			local door = doors[lastDoor].coords
            local minutterstart = terstart
			local minutternu = ternu
			Citizen.Wait(1000)
			TriggerServerEvent('currenttime1')
			print(TimeToSeconds(sstimerstart1,terstart,terstart1) - TimeToSeconds(ssstimerstart1,ternu,ternu1))
			-- if time is up
			if TimeToSeconds(sstimerstart1,terstart,terstart1) == TimeToSeconds(ssstimerstart1,ternu,ternu1) then
				--print('times up')
				timestup = false
				
				
				-- if still in the house
				if GetCurrentHouse() then
					-- mission failed we'll get em next time
					ShowMPMessage("~r~Burglary failed", "You didn't leave the house before daylight.", 3500)
					TriggerEvent('cooldowntimer')
					TriggerServerEvent("burglary:ended", true, true, lastDoor, GetStreet(door.x, door.y, door.z))
					--print('15')
				else
					 print('player made it before time')
					--print('enden timer')
					TriggerEvent('cooldowntimer')
					print('burg ended called')
					TriggerServerEvent("burglary:ended", false)
					--print('14')
				end
				
				ForceEndMission()
			end
	
			if CanPedHearPlayer(PlayerId(), peds[1]) then
				--print('you woke up a resident')
				ShowMPMessage("~r~Burglary failed", "You woke up a resident.", 3500)
				TriggerEvent('cooldowntimer')
				TriggerServerEvent("burglary:ended", true, true, lastDoor, GetStreet(door.x, door.y, door.z))
				--print('13')
				ClearPedTasks(peds[1])
				PlayPain(peds[1], 7, 0)
				
				-- if resident is aggresive
				if HasPedGotWeapon(peds[1], GetHashKey("WEAPON_PISTOL"), false) then
					SetCurrentPedWeapon(peds[1], GetHashKey("WEAPON_PISTOL"), true)
					
					TaskShootAtEntity(peds[1], PlayerPedId(), -1, 2685983626)
				end
				
				ForceEndMission()
			end
			
			if IsPedCuffed(PlayerPedId()) then
				ShowMPMessage("~r~Burglary failed", "You got arrested.", 3500)
				TriggerEvent('cooldowntimer')
				TriggerServerEvent("burglary:ended", true, false)
				--print('12')
				ForceEndMission()
			end
			
			-- cancel mission if player is dead
			if IsPedDeadOrDying(PlayerPedId()) then
				TriggerEvent('cooldowntimer')
				TriggerServerEvent("burglary:ended", true, false)
				--print('1')
				ForceEndMission()
			end
			
			-- check if van is not destroyed
			--[[if IsEntityDead(currentVan) and onMission then
				ShowMPMessage("~r~Burglary failed", "Your van got destroyed.", 3500)
				TriggerServerEvent("burglary:ended", true, false)
				
				ForceEndMission()
			end]]--
		end
	end
end)

function ForceEndMission()
	if isHolding then
		DetachEntity(holdingProp)
	end
	
	-- lot of cleanup
	isHolding = false
	holdingProp = nil
	
	stolenItems = {}
	currentItem = {}
	
	-- reset anim
	ClearPedTasks(PlayerPedId())
	SetPedCanSwitchWeapon(PlayerPedId(), not isHolding)
	
	onMission = false
	SetVehicleAsNoLongerNeeded(NetToVeh(currentVan))
	
	RemoveBlips()
	RemovePickups()
end

AddEventHandler("burglary:finished", function(sum)
	--print('give the money punk !')
	if sum ~= nil then
	local pengene = sum
	print('event')
	TriggerServerEvent('asd',source,pengene)
	ShowMPMessage("~g~Burglary successful", "You sold all your items for a value of $" .. sum, 3500)
	end
end)
