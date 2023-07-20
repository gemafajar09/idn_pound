ESX = exports["es_extended"]:getSharedObject()
local bones = {'bonnet', 'boot'}
local display = false

CreateThread(function()
    exports['qtarget']:AddTargetBone(bones, {
        options = {
            ["Impound"] = {
                icon = "fas fa-lock",
                label = "Impound Request",
                event = "indonusa:client:OpenImpound",
                distance = 1.3
            }
        }
    })
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

AddEventHandler('indonusa:client:menu', function()
    local playerPed     = PlayerPedId()
    local coordA        = GetEntityCoords(playerPed, 1)
	  local coordB        = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 20.0, 0.0)
	  local jarakkendaraan = ESX.Game.GetVehicleInDirection(coordA, coordB)
    print(jarakkendaraan)
    if jarakkendaraan == nil then
        exports['okokNotify']:Alert("error", "Tidak Ada KEndaraan Disekitar", 4000, 'error')
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
        type = "samsat",
        status = bool
    })
end

RegisterNUICallback("exit", function(data)
    local playerPed = PlayerPedId()
    ClearPedTasksImmediately(playerPed)
    SetNuiFocus(false, false)
    SetDisplay(false)
    SetDisplayBilling(false)
end)

RegisterNUICallback("simpan", function(data)
    SetDisplay(false)
    local playerPed = PlayerPedId()
    ClearPedTasksImmediately(playerPed)
    ESX.TriggerServerCallback('indonusa:server:simpan', function(data ,out)
      if out then

      end
    end)
    TriggerEvent('indonusa:client:Samsat')
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

RegisterCommand('testimpound', function()
	TriggerEvent('indonusa:client:menu')
end)