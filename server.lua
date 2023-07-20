ESX = exports["es_extended"]:getSharedObject()

------ simpan data kendaraan yang disita
ESX.RegisterServerCallback('indonusa:server:simpan', function(source, cb, arg)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
        
    if xPlayer.job.name == "police" then
        MySQL.Async.execute('INSERT INTO idn_impound (plate,tgl_masuk,tgl_keluar,denda,catatan) VALUES (@plate,@tglmasuk,@tglkeluar,@denda,@catatan)', {
            ['@plate'] = arg['plate'],
            ['@tglmasuk'] = arg['tglMasuk'],
            ['@tglkeluar'] = arg['tglKeluar'],
            ['@denda'] = arg['denda'],
            ['@catatan	'] = arg['catatan']
        }, function(result)
            if result then
               cb(true)
            else
               cb(false)
            end
        end)
    else
        TriggerClientEvent('okokNotify:Alert', src, "", "Anda bukan petugas polisi", 4000, 'error')
    end
end)

---- keluarkan garasi dari penyitaan
ESX.RegisterServerCallback('indonusa:server:keluarkankendaraan', function(source, cb, arg)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
        
    if xPlayer.job.name == "police" then
        MySQL.Async.execute('DELETE FROM idn_impound WHERE plate = @plate', {
            ['@plate'] = arg['plate'],
        }, function(result)
            if result then
               MySQL.Async.execute('UPDATE owned_vehicles SET garage = @garage, stored = @stored, impounded = @impounded WHERE plate = @plate AND owner = @owner', {
                    ['@plate'] = arg['plate'],
                    ['@garage'] = 'Garkot',
                    ['@impounded'] = 0,
                    ['@stored'] = 1,
                    ['@owner'] = arg['owner']
                }, function(hasil)
                    if hasil then
                        MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate AND owner = @owner',{
                           ['@plate'] = arg['plate'],
                           ['@owner'] = arg['owner']
						}, function(veh)
                        	if veh[1] ~= nil then
                                print('ada data')
                             	cb(veh[1]) 
                            else
                                                print('tidak data')
                                cb(false)
                            end
                        end)
                    end
                end)
            else
               cb(false)
            end
        end)
    else
        TriggerClientEvent('okokNotify:Alert', src, "", "Anda bukan petugas polisi", 4000, 'error')
    end
end)

------ cek sumua kendaraan yang disita
ESX.RegisterServerCallback('indonusa:server:getimpond', function(source, cb)
 	local spawnmenu = {}
	MySQL.Async.fetchAll('SELECT a.owner,b.plate, DATE_FORMAT(b.tgl_masuk, "%d/%m/%Y") as tgl_masuk, DATE_FORMAT(b.tgl_keluar, "%d/%m/%Y") as tgl_keluar, b.denda, b.catatan , c.firstname, c.lastname FROM owned_vehicles a LEFT JOIN idn_impound b ON a.plate=b.plate LEFT JOIN users c ON a.owner=c.identifier WHERE a.garage = @garage AND a.impounded = @impounded',{
                ['@garage'] = 'Penyitaan',
                ['@impounded'] = 1
            },
    function(result)
        if result ~= nil then
            for k, v in pairs(result) do
                table.insert(spawnmenu, {
                                plate = v.plate, 
                                owner = v.owner, 
                                tgl_masuk = v.tgl_masuk,
                                tgl_keluar = v.tgl_keluar,
                                firstname = v.firstname,
                                lastname = v.lastname,
                                denda = v.denda,
                                catatan = v.catatan
                            })
            end
            cb(spawnmenu)
        else
            cb(false)
        end
    end)
end)

---- rekap update status kendaraan yang disita 
RegisterServerEvent('indonusa:server:samsat', function(plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.job.name == "police" then
        MySQL.Async.execute('UPDATE owned_vehicles SET garage = @garage, stored = @stored, impounded = @impounded WHERE plate = @plate', {
            ['@plate'] = plate,
            ['@garage'] = 'Penyitaan',
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