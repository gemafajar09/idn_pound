ESX = exports["es_extended"]:getSharedObject()
local bones = {'bonnet', 'boot'}

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
            title = 'Kendaraan Kecelakaan',
            description = '',
            icon = 'circle',
            onSelect = function()
              TriggerEvent('indonusa:client:Kecelakaan')
            end,
          },
          {
            title = 'Pelanggaran Parkir',
            description = '',
            icon = 'circle',
            onSelect = function()
              TriggerEvent('indonusa:client:PelanggaranParkir')
            end,
          },
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

RegisterNetEvent('indonusa:client:Kecelakaan', function()
    if lib.progressCircle({
        duration = 7000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
    }) then 
        TriggerServerEvent("indonusa:server:Kecelakanaan")
    end
end)

RegisterNetEvent('indonusa:client:PelanggaranParkir', function()
    
    if lib.progressCircle({
        duration = 7000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
    }) then 
        TriggerServerEvent("indonusa:server:PelangaranParkir")
    end
end)

RegisterNetEvent('indonusa:client:Samsat', function()
    TriggerServerEvent("indonusa:server:samsat")
end)