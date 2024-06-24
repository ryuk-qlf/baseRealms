Cfg = {}
-- possibly GetConvar('voice_modes', '0.5;2.0;5.0')
-- possibly GetConvar('voice_modeNames', 'Whisper;Normal;Shouting') and seperate them on runtime?
if GetConvar('voice_useNativeAudio', 'false') == 'true' then
	-- native audio distance seems to be larger then regular gta units
	Cfg.voiceModes = {
		{1.0, "chuchoter", "o"}, -- Whisper speech distance in gta distance units
		{3.5, "normal", "g"}, -- Normal speech distance in gta distance units
		{8.0, "crier", "r"} -- Shout speech distance in gta distance units
	}
else
	Cfg.voiceModes = {
		{1.0, "chuchoter", "o"}, -- Whisper speech distance in gta distance units
		{3.5, "normal", "g"}, -- Normal speech distance in gta distance units
		{8.0, "crier", "r"} -- Shout speech distance in gta distance units
	}
end

logger = {
	['log'] = function(message, ...)
		print((message):format(...))
	end,
	['info'] = function(message)
		if GetConvarInt('voice_debugMode', 0) >= 1 then
			print(('[info] %s'):format(message))
		end	
	end,
	['verbose'] = function(message)
		if GetConvarInt('voice_debugMode', 0) >= 4 then
			print(('[verbose] %s'):format(message))
		end	
	end,
}


function tPrint(tbl, indent)
	indent = indent or 0
	for k, v in pairs(tbl) do
		local tblType = type(v)
		formatting = string.rep("  ", indent) .. k .. ": "
		if tblType == "table" then
			print(formatting)
			tPrint(v, indent + 1)
		elseif tblType == 'boolean' then
			print(formatting .. tostring(v))
		elseif tblType == "function" then
			print(formatting .. tostring(v))
		else
			print(formatting .. v)
		end
	end
end