local PlayerDiamond = {}

function GetDiamondPlayer(src, xPlayer)
    MySQL.Async.fetchAll("SELECT * FROM diamond WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)

        if result[1] then
            return true
        else
            if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
                return true
            elseif xPlayer.getGroup() == "user" then
                return false
            end
        end
    end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    
    if not PlayerDiamond[_src] then
        if GetDiamondPlayer(_src, xPlayer) ~= nil then
            PlayerDiamond[_src] = GetDiamondPlayer(_src)
        end
    end
end)

function SalaireAutomatique(xPlayer, salary, type)
	MySQL.Async.fetchAll('SELECT * FROM bank_account WHERE courant = 1 AND license = @license', {
		['@license'] = xPlayer.identifier
	}, function(result)
		if json.encode(result) ~= "[]" then
			local Balance = result[1].balance
			local Numero = result[1].Numero

			if type == 1 then
				MySQL.Async.execute("UPDATE bank_account SET balance='" .. Balance + tonumber(salary) .. "' WHERE Numero ='" .. Numero .. "';", {})
				xPlayer.showNotification("Salaire : ~g~+"..(salary).."$")
			elseif type == 2 then
				MySQL.Async.execute("UPDATE bank_account SET balance='" .. Balance + tonumber(salary*2) .. "' WHERE Numero ='" .. Numero .. "';", {})
				xPlayer.showNotification("Salaire : ~g~+"..(salary*2).."$~s~ ~b~x2")
			end
		else
			xPlayer.showNotification("~g~Salaire~s~\nVous n'avez pas de compte courant.")
		end
	end)
end

function SalaryAuto()
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		local job     = xPlayer.job.name
		local salary  = xPlayer.job.grade_salary

		print(salary)

		if salary > 0 then
			if PlayerDiamond[xPlayer.source] then
				SalaireAutomatique(xPlayer, salary, 2)
			else
				if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
					SalaireAutomatique(xPlayer, salary, 2)
				elseif xPlayer.getGroup() == "user" then
					SalaireAutomatique(xPlayer, salary, 1)
				end
			end
		end
	end
end

Citizen.CreateThread(function()
	while true do 
		Wait(Config.PaycheckInterval)
		print("SalaryAuto")
		SalaryAuto()
	end
end)