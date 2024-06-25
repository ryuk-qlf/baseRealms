ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("SetBucket")
AddEventHandler("SetBucket", function(number)
    local _src = source
    SetPlayerRoutingBucket(_src, number)
end)

function sendToDiscordWithSpecialURL(name,message,color,url)
    local DiscordWebHook = 'https://discord.com/api/webhooks/1015438984085766194/KDILCeItq_4zfP1VyXk30R2xL6lPxNCl-Eb1glhHOHLwAQHRvXyDX0Az3tLDIFT8_MRe'
    -- Modify here your discordWebHook username = name, content = message,embeds = embeds
  
  local embeds = {
      {
          ["title"]=message,
          ["type"]="rich",
          ["color"]=color,
          ["footer"]={
          ["text"]=os.date("%Y/%m/%d %H:%M:%S"),
         },
      }
  }
  
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("SetIdentity")
AddEventHandler("SetIdentity", function(NDF, Prenom, DDN, Sexe, Taille, LDN)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute("UPDATE users SET firstname = @firstname, lastname = @lastname, dateofbirth = @dateofbirth, sex = @sex, height = @height, ldn = @ldn WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier,
        ["@lastname"] = NDF,
        ["@firstname"] = Prenom,
        ["@dateofbirth"] = DDN,
        ["@sex"] = Sexe,
        ["@height"] = Taille,
        ["@ldn"] = LDN
    })

    if xPlayer.canCarryItem("bread", 5) then
        xPlayer.addInventoryItem('bread', 5)
    end
    if xPlayer.canCarryItem("water", 5) then
        xPlayer.addInventoryItem('water', 5)
    end

    identifiers = GetNumPlayerIdentifiers(xPlayer.source)
	for i = 0, identifiers + 1 do
		if GetPlayerIdentifier(xPlayer.source, i) ~= nil then
			if string.match(GetPlayerIdentifier(xPlayer.source, i), "discord") then
				discord = GetPlayerIdentifier(xPlayer.source, i)
			end
		end
	end
    sendToDiscordWithSpecialURL("offline Logger","Utilisateur **"..Prenom.." "..NDF.."**\nsID: "..xPlayer.source.."\n[DiscordId: "..discord.."]\nAction : Viens de créer son personnage", 16711680, "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw")

    TriggerEvent("UpdateAdminList")

    MySQL.Async.fetchAll("SELECT * FROM permission WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)
        if result[1] then
            local group = result[1].group
            xPlayer.setGroup(group)
            TriggerClientEvent("addPermMenuAdmin", xPlayer.source, group)
            Wait(150)
            ESX.SavePlayer(xPlayer, function()
            end)
        end
    end)
end)