local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

local moneys = 0

RegisterServerEvent('dispatch1')
AddEventHandler('dispatch1', function(x,y,z,message)
	local players = {}
	local users = vRP.getUsers({})
	local isPolice = false
	local isEMS = false
 --print('hello1')
    for k,v in pairs(users) do
    	
      	local player = vRP.getUserSource({k})
      	
      	if player ~= nil then
      		local user_id = vRP.getUserId({player})

      		isPolice = vRP.hasGroup({user_id,"Politi-Job"})
      		isEMS = vRP.hasGroup({user_id,"EMS-Job"})

	      	if isPolice or isEMS then
	      		table.insert(players,player)
	      	end
			  --print(players)
      	end
	end

	for k,v in pairs(players) do
		
  		TriggerClientEvent('notifyDispatch1', v, x,y,z,message)
    end
end)

RegisterServerEvent('asd')
AddEventHandler('asd',function(pengene)
	local user_id = vRP.getUserId({source})
	print(user_id)
	print(moneys)
	local moneys = moneys
	TriggerClientEvent('cooldowntimer',source)
	vRP.giveMoney({user_id,moneys})
end)


local robbers = {}

-- functions
function onNet (name, func)
    RegisterNetEvent(name)
    return AddEventHandler(name, func)
end

function insert(id, item)
    if not robbers[id] then
        robbers[id] = {}
    end

    table.insert(robbers[id], item)
end

-- events
onNet('burglary:collected', function (item, house)
	insert(source, { item = item, house = house })
end)

onNet('burglary:ended', function (failed, alert, door, street)
	print('im calling you baby')
	
	TriggerClientEvent('lockalldoors',source)
print(failed)
	if failed == false then
		print('0')
		if robbers[source] then
			local sum = 0
			print('1')
			for _,v in pairs(robbers[source]) do
				-- get price from houses/pickups table
				local item = houses[v.house].pickups[v.item]
				print('2')
				if tonumber(item.value) ~= nil then
					sum = sum + item.value
					print('3')
				end
			end
			print(sum)
			print("[Burglary] " .. GetPlayerName(source) ..  " stole " .. #robbers[source] .. " items with a value of $" .. sum)
			robbers[source] = nil
			
			-- tell the client how much money he made
			print('4')
			TriggerClientEvent("burglary:finished",source,sum )
			TriggerClientEvent('cooldowntimer',source)
			-- resources can listen for this event to give money using their own framework
			-- sum = amount of money
			-- source = source of player
			print('5')
			moneys = sum
			TriggerEvent("burglary:money", sum, source)
			print('6')
			--print('cooldown timer starrtet')
		
			print('7')
		end
	else
		if alert then
			
			print('alert')
		

			-- resources can listen for this event to for example alert cops
			-- house = houseid
			-- coords = door coordinates of house
			-- source = source of player failing
			TriggerClientEvent('misionfailed',source)
			TriggerEvent("burglary:failed", doors[door].house, doors[door].coords, source, street)
			--print('cooldown timer starrtet')
			TriggerClientEvent('cooldowntimer',source)
			
		end
		--print('cooldown timer starrtet')
		TriggerClientEvent('cooldowntimer', source)
		
		if robbers[source] then
			print('empty items')
			print(robbers[source])
			robbers[source] = nil
		end
	end
	
end)

RegisterServerEvent('currenttime1')
AddEventHandler('currenttime1',function()
	minutter10 = os.date("%M")
	skunder10 = os.date("%S")
	
	--print('minutter')
	--print(minutter10)
	TriggerClientEvent('sendtime1234596', source,minutter10,skunder10)
end)

RegisterServerEvent('currenttime2')
AddEventHandler('currenttime2',function()
	minutter10 = os.date("%M")
	skunder10 = os.date("%S")
	--print('minutter')
	--print(minutter10)
	TriggerClientEvent('sendtime12', source,minutter10,skunder10)
end)

AddEventHandler('playerDropped', function (source, reason)
    if robbers[source] then
        robbers[source] = nil
    end
end)