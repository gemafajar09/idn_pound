ESX = exports["es_extended"]:getSharedObject()
local bones = {'bonnet', 'boot'}
local display = false

CreateThread(function()
    exports.qtarget:AddTargetBone(bones, {
        options = {
            {
                icon = "fas fa-lock",
                label = "Impound Request",
                event = "indonusa:client:menu",
                job = {['police'] = 0},
            }
        },
        distance = 1.3
    })
end)

exports['qtarget']:AddBoxZone("samsat", vector3(-1059.21, -841.88, 5.04), 0.6, 0.6, {
      name="samsat",
      heading=310,
      --debugPoly=true,
      minZ=2.04,
      maxZ=6.04
    }, {
        options = {
            {
                event = "indonusa:client:getkendaraan",
                icon = "fas fa-clipboard",
                label = "Samsat",
                job = { ["police"] = 5 },
            },
        },
        distance = 2.5
    })

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				type = "exit"
			})
		end
	end
end)

RegisterNetEvent('indonusa:client:OpenImpound', function()
    lib.registerContext({
        id = 'impound_menu',
        title = 'Menu Penyitaan',
        options = {
          {
            title = 'Penyitaan Samsat',
            description = '',
            icon = 'circle',
            onSelect = function()
              TriggerEvent('indonusa:client:Samsat')
            end,
          },
        }
    })
end)

AddEventHandler('indonusa:client:getkendaraan', function()
	ESX.TriggerServerCallback('indonusa:server:getimpond', function(isi)
        if isi ~= nil then
        	local playerPed = PlayerPedId()
            TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_CLIPBOARD', 0, true)
            SetNuiFocus(true, true)
            SetDisplays(not display,isi)
        else
            lib.notify({
                title = 'Empty',
                description = 'Tidak Ada Data Kendaraan Tersita',
                type = 'error'
            })        
        end
              
    end)
end)

AddEventHandler('indonusa:client:menu', function()
    local playerPed     = PlayerPedId()
    local coordA        = GetEntityCoords(playerPed, 1)
	local coordB        = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 20.0, 0.0)
	local jarakkendaraan = ESX.Game.GetVehicleInDirection(coordA, coordB)
        
    if jarakkendaraan == nil then
        exports['okokNotify']:Alert("error", "Tidak Ada Kendaraan Disekitar", 4000, 'error')
    else
        local playerPed = PlayerPedId()
        TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_CLIPBOARD', 0, true)
        SetNuiFocus(true, true)
        SetDisplay(not display)
    end
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = 'samsat',
        status = bool
    })
end

function SetDisplays(bool,data)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = 'kendaraan',
        status = bool,
        list = data
    })
end

RegisterNUICallback("exit", function(data)
    local playerPed = PlayerPedId()
    ClearPedTasksImmediately(playerPed)
    SetNuiFocus(false, false)
    SetDisplay(false)
end)

RegisterNUICallback("simpan", function(data)
    SetDisplay(false)
    local playerPed = PlayerPedId()
    ClearPedTasksImmediately(playerPed)
        
    local coordA        = GetEntityCoords(playerPed, 1)
	local coordB        = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 20.0, 0.0)
	local targetVehicle = ESX.Game.GetVehicleInDirection(coordA, coordB)
    local plate         = GetVehicleNumberPlateText(targetVehicle)
    local array = {
            		plate = plate,
					tglMasuk = data.tglMasuk,
					tglKeluar = data.tglKeluar,
            		denda = data.denda,
            		catatan = data.catatan
				}
    ESX.TriggerServerCallback('indonusa:server:simpan', function(out)
      if out then
		TriggerEvent('indonusa:client:Samsat')
      else
        print('belum ada')
      end
    end, array)
    
end)

RegisterNUICallback("ambilkendaraan", function(data)
    SetDisplay(false)
    local playerPed = PlayerPedId()
    ClearPedTasksImmediately(playerPed)
        
    local arrays = {
            		plate = data.plate,
					owner = data.owner
				}
    ESX.TriggerServerCallback('indonusa:server:keluarkankendaraan', function(veh)
      if veh ~= false then
		print(ESX.DumpTable(veh['vehicle']))
        spawnVehicle(json.decode(veh['vehicle']), json.decode(veh['vehicle']).fuel, json.decode(veh['vehicle']).engine, json.decode(veh['vehicle']).body, json.decode(veh['vehicle']).plate)
      else
        print('belum ada')
      end
    end, arrays)
    
end)

RegisterNetEvent('indonusa:client:Samsat', function()
    local playerPed     = PlayerPedId()
    local coordA        = GetEntityCoords(playerPed, 1)
	local coordB        = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 20.0, 0.0)
	local targetVehicle = ESX.Game.GetVehicleInDirection(coordA, coordB)
    local plate         = GetVehicleNumberPlateText(targetVehicle)

    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
    if lib.progressCircle({
        duration = 20000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        
    }) then 
        TriggerServerEvent("indonusa:server:samsat",plate)
        ClearPedTasks(playerPed)
        ESX.Game.DeleteVehicle(targetVehicle)
    end
end)

spawnVehicle = function(vehicle, fuel, enginehealth, bodyhealth, plate)
    ESX.Game.SpawnVehicle(vehicle.model, vector3(-1052.28, -846.96, 4.88), 211.12, function(veh)
		ESX.Game.SetVehicleProperties(veh, vehicle)
        SetEntityAsMissionEntity(veh, true, true)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        -- penambahan baru
		SetVehicleAutoRepairDisabled(veh, true)
        SetVehicleBodyHealth(veh, bodyhealth - 1)
        SetVehicleEngineHealth(veh, enginehealth + 0.0)
        Entity(veh).state.fuel = fuel
        SetVehicleEngineOn(veh, true, true)
    end)
end
