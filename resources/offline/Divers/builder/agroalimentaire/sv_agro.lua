RegisterNetEvent('CreateJobFarm')
AddEventHandler('CreateJobFarm', function(label, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM jobs WHERE name = @name', {
		['@name'] = label
	}, function(result) 
		 if not result then
            MySQL.Async.execute('INSERT INTO jobs (name, label) VALUES (@name, @label)', {
                ['@name'] = label, 
                ['@label'] = label
            })
         end
	end)

    Wait(550)
    ESX.RefreshJobs()
end)