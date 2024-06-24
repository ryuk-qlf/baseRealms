AddEventHandler('LandLife:GetSharedObject', function(cb)
	cb(ESX)
end)

exports("getSharedObject", function()
	return ESX
end)

exports("getlmodeextendedObject", function()
	return ExM
end)