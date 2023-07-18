ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('indonusa:server:Kecelakanaan', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    TriggerClientEvent('QBCore:Command:DeleteVehicle', src)
end)

RegisterServerEvent('indonusa:server:PelangaranParkir', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.job.name == "police" then
        TriggerClientEvent('QBCore:Command:DeleteVehicle', src)
        TriggerClientEvent('okokNotify:Alert', src, "", "Permintaan Penyitaan Diterima", 4000, 'success')
    else
        TriggerClientEvent('okokNotify:Alert', src, "", "Anda bukan petugas polisi", 4000, 'error')
    end
end)

RegisterServerEvent('indonusa:server:samsat', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer.job.name == "police" then
        TriggerClientEvent("police:client:ImpoundVehicle", src, true)
    else
        TriggerClientEvent('okokNotify:Alert', src, "", "Anda bukan petugas polisi", 4000, 'error')
    end
end)