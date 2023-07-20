ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('minyakhitung3', function(source, data, cb)
	print(data)
end)

RegisterServerEvent('indonusa:server:samsat', function(plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.job.name == "police" then
        MySQL.Async.execute('UPDATE owned_vehicles SET garage = @garage, stored = @stored, impounded = @impounded WHERE plate = @plate', {
            ['@plate'] = plate,
            ['@garage'] = 'samsat',
            ['@impounded'] = 1,
            ['@stored'] = 1,
        }, function(rowsChanged)
            if rowsChanged == 0 then
                TriggerClientEvent('okokNotify:Alert', src, "", "Kendaraan Tersita", 4000, 'succcess')
            end
        end)
    else
        TriggerClientEvent('okokNotify:Alert', src, "", "Anda bukan petugas polisi", 4000, 'error')
    end
end)