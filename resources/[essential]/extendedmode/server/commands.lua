ESX.RegisterCommand('tpc', 'admin', function(xPlayer, args, showError)
	xPlayer.setCoords({x = args.x, y = args.y, z = args.z})
end, false, {help = _U('command_setcoords'), validate = true, arguments = {
	{name = 'x', help = _U('command_setcoords_x'), type = 'number'},
	{name = 'y', help = _U('command_setcoords_y'), type = 'number'},
	{name = 'z', help = _U('command_setcoords_z'), type = 'number'}
}})

ESX.RegisterCommand({'clear', 'cls'}, 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('chat:clear')
end, false, {help = _U('command_clear')})

ESX.RegisterCommand({'clearall', 'clsall'}, 'admin', function(xPlayer, args, showError)
	TriggerClientEvent('chat:clear', -1)
end, false, {help = _U('command_clearall')})

ESX.RegisterCommand('clearinventory', 'admin', function(xPlayer, args, showError)
	for k,v in ipairs(args.playerId.inventory) do
		if v.count > 0 then
			args.playerId.setInventoryItem(v.name, 0)
		end
	end
end, true, {help = _U('command_clearinventory'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('save', 'admin', function(xPlayer, args, showError)
	print(('[lmodeextended] [^2INFO^7] Manual player data save triggered for "%s"'):format(args.playerId.name))
	ESX.SavePlayer(args.playerId, function(rowsChanged)
		if rowsChanged ~= 0 then
			print(('[lmodeextended] [^2INFO^7] Saved player data for "%s"'):format(args.playerId.name))
		else
			print(('[lmodeextended] [^3WARNING^7] Failed to save player data for "%s"! This may be caused by an internal error on the MySQL server.'):format(args.playerId.name))
		end
	end)
end, true, {help = _U('command_save'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('saveall', 'admin', function(xPlayer, args, showError)
	print('[lmodeextended] [^2INFO^7] Manual player data save triggered')
	ESX.SavePlayers(function(result)
		if result then
			print('[lmodeextended] [^2INFO^7] Saved all player data')
		else
			print('[lmodeextended] [^3WARNING^7] Failed to save player data! This may be caused by an internal error on the MySQL server.')
		end
	end)
end, true, {help = _U('command_saveall')})