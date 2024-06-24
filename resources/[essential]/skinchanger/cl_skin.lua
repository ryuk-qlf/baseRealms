local Components = {
	{name = 'sex',				value = 0},
	{name = 'face',				value = 0},
	{name = 'skin',				value = 0},
	{name = 'hair_1',			value = 0},
	{name = 'hair_2',			value = 0},
	{name = 'hair_color_1',		value = 0},
	{name = 'hair_color_2',		value = 0},
	{name = 'tshirt_1',			value = 0},
	{name = 'tshirt_2',			value = 0},
	{name = 'torso_1',			value = 0},
	{name = 'torso_2',			value = 0},
	{name = 'decals_1',			value = 0},
	{name = 'decals_2',			value = 0},
	{name = 'arms',				value = 0},
	{name = 'arms_2',			value = 0},
	{name = 'pants_1',			value = 0},
	{name = 'pants_2',			value = 0},
	{name = 'shoes_1',			value = 0},
	{name = 'shoes_2',			value = 0},
	{name = 'mask_1',			value = 0},
	{name = 'mask_2',			value = 0},
	{name = 'bproof_1',			value = 0},
	{name = 'bproof_2',			value = 0},
	{name = 'chain_1',			value = 0},
	{name = 'chain_2',			value = 0},
	{name = 'helmet_1',			value = -1},
	{name = 'helmet_2',			value = 0},
	{name = 'glasses_1',		value = 0},
	{name = 'glasses_2',		value = 0},
	{name = 'watches_1',		value = -1},
	{name = 'watches_2',		value = 0},
	{name = 'bracelets_1',		value = -1},
	{name = 'bracelets_2',		value = 0},
	{name = 'bags_1',			value = 0},
	{name = 'bags_2',			value = 0},
	{name = 'eye_color',		value = 0},
	{name = 'eyebrows_2',		value = 0},
	{name = 'eyebrows_1',		value = 0},
	{name = 'eyebrows_3',		value = 0},
	{name = 'eyebrows_4',		value = 0},
	{name = 'makeup_1',			value = 0},
	{name = 'makeup_2',			value = 0},
	{name = 'makeup_3',			value = 0},
	{name = 'makeup_4',			value = 0},
	{name = 'lipstick_1',		value = 0},
	{name = 'lipstick_2',		value = 0},
	{name = 'lipstick_3',		value = 0},
	{name = 'lipstick_4',		value = 0},
	{name = 'ears_1',			value = -1},
	{name = 'ears_2',			value = 0},
	{name = 'chest_1',			value = 0},
	{name = 'chest_2',			value = 0},
	{name = 'chest_3',			value = 0},
	{name = 'bodyb_1',			value = 0},
	{name = 'bodyb_2',			value = 0},
	{name = 'age_1',			value = 0},
	{name = 'age_2',			value = 0},
	{name = 'blemishes_1',		value = 0},
	{name = 'blemishes_2',		value = 0},
	{name = 'blush_1',			value = 0},
	{name = 'blush_2',			value = 0},
	{name = 'blush_3',			value = 0},
	{name = 'complexion_1',		value = 0},
	{name = 'complexion_2',		value = 0},
	{name = 'sun_1',			value = 0},
	{name = 'sun_2',			value = 0},
	{name = 'moles_1',			value = 0},
	{name = 'moles_2',			value = 0},
	{name = 'beard_1',			value = 0},
	{name = 'beard_2',			value = 0},
	{name = 'beard_3',			value = 0},
	{name = 'beard_4',			value = 0},
	{name = 'mom',				value = 0.0},
	{name = 'dad',				value = 0.0},
	{name = 'nose_1',			value = 0.0},
	{name = 'nose_2',			value = 0.0},
	{name = 'nose_3',			value = 0.0},
	{name = 'nose_4',			value = 0.0},
	{name = 'nose_5',			value = 0.0},
	{name = 'nose_6',			value = 0.0},
	{name = 'eyebrows_5',		value = 0.0},
	{name = 'eyebrows_6',		value = 0.0},
	{name = 'cheeks_1',			value = 0.0},
	{name = 'cheeks_2',			value = 0.0},
	{name = 'cheeks_3',			value = 0.0},
	{name = 'eye_open',			value = 0.0},
	{name = 'lips_thick',		value = 0.0},
	{name = 'jaw_1',			value = 0.0},
	{name = 'jaw_2',			value = 0.0},
	{name = 'chin_height',		value = 0.0},
	{name = 'chin_lenght',		value = 0.0},
	{name = 'chin_width',		value = 0.0},
	{name = 'chin_hole',		value = 0.0},
	{name = 'neck_thick',		value = 0.0},
}

local LastSex     = -1
local LoadSkin    = nil
local LoadClothes = nil
local Character   = {}

for i=1, #Components, 1 do
	Character[Components[i].name] = Components[i].value
end

function LoadDefaultModel(loadMale, cb)

	local playerPed = GetPlayerPed(-1)
 	local characterModel

	if loadMale then
		characterModel = GetHashKey('mp_m_freemode_01')
	else
		characterModel = GetHashKey('mp_f_freemode_01');
	end

	RequestModel(characterModel)

	Citizen.CreateThread(function()

		while not HasModelLoaded(characterModel) do
			RequestModel(characterModel)
			Citizen.Wait(0)
		end

		if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
			SetPlayerModel(PlayerId(), characterModel)
			SetPedDefaultComponentVariation(playerPed)
		end

		SetModelAsNoLongerNeeded(characterModel)

		if cb ~= nil then
			cb()
		end

		TriggerEvent('skinchanger:modelLoaded')

	end)

end

function GetMaxVals()

  local playerPed = GetPlayerPed(-1)

	local data = {
		sex				= 626,
		mom				= 45, -- numbers 21-41 and 45 are female (22 total)
		dad				= 44, -- numbers 0-20 and 42-44 are male (24 total)
		skin			= 45,
		age_1			= GetNumHeadOverlayValues(3)-1,
		age_2			= 10,
		beard_1			= GetNumHeadOverlayValues(1)-1,
		beard_2			= 10,
		beard_3			= GetNumHairColors()-1,
		beard_4			= GetNumHairColors()-1,
		hair_1			= GetNumberOfPedDrawableVariations		(playerPed, 2) - 1,
		hair_2			= GetNumberOfPedTextureVariations		(playerPed, 2, Character['hair_1']) - 1,
		hair_color_1	= GetNumHairColors()-1,
		hair_color_2	= GetNumHairColors()-1,
		eye_color		= 31,
		eyebrows_1		= GetNumHeadOverlayValues(2)-1,
		eyebrows_2		= 10,
		eyebrows_3		= GetNumHairColors()-1,
		eyebrows_4		= GetNumHairColors()-1,
		makeup_1		= GetNumHeadOverlayValues(4)-1,
		makeup_2		= 10,
		makeup_3		= GetNumHairColors()-1,
		makeup_4		= GetNumHairColors()-1,
		lipstick_1		= GetNumHeadOverlayValues(8)-1,
		lipstick_2		= 10,
		lipstick_3		= GetNumHairColors()-1,
		lipstick_4		= GetNumHairColors()-1,
		blemishes_1		= GetNumHeadOverlayValues(0)-1,
		blemishes_2		= 10,
		blush_1			= GetNumHeadOverlayValues(5)-1,
		blush_2			= 10,
		blush_3			= GetNumHairColors()-1,
		complexion_1	= GetNumHeadOverlayValues(6)-1,
		complexion_2	= 10,
		sun_1			= GetNumHeadOverlayValues(7)-1,
		sun_2			= 10,
		moles_1			= GetNumHeadOverlayValues(9)-1,
		moles_2			= 10,
		chest_1			= GetNumHeadOverlayValues(10)-1,
		chest_2			= 10,
		chest_3			= GetNumHairColors()-1,
		bodyb_1			= GetNumHeadOverlayValues(11)-1,
		bodyb_2			= 10,
		ears_1			= GetNumberOfPedPropDrawableVariations	(playerPed, 1) - 1,
		ears_2			= GetNumberOfPedPropTextureVariations	(playerPed, 1, Character['ears_1'] - 1),
		tshirt_1		= GetNumberOfPedDrawableVariations		(playerPed, 8) - 1,
		tshirt_2		= GetNumberOfPedTextureVariations		(playerPed, 8, Character['tshirt_1']) - 1,
		torso_1			= GetNumberOfPedDrawableVariations		(playerPed, 11) - 1,
		torso_2			= GetNumberOfPedTextureVariations		(playerPed, 11, Character['torso_1']) - 1,
		decals_1		= GetNumberOfPedDrawableVariations		(playerPed, 10) - 1,
		decals_2		= GetNumberOfPedTextureVariations		(playerPed, 10, Character['decals_1']) - 1,
		arms			= GetNumberOfPedDrawableVariations		(playerPed, 3) - 1,
		arms_2			= 10,
		pants_1			= GetNumberOfPedDrawableVariations		(playerPed, 4) - 1,
		pants_2			= GetNumberOfPedTextureVariations		(playerPed, 4, Character['pants_1']) - 1,
		shoes_1			= GetNumberOfPedDrawableVariations		(playerPed, 6) - 1,
		shoes_2			= GetNumberOfPedTextureVariations		(playerPed, 6, Character['shoes_1']) - 1,
		mask_1			= GetNumberOfPedDrawableVariations		(playerPed, 1) - 1,
		mask_2			= GetNumberOfPedTextureVariations		(playerPed, 1, Character['mask_1']) - 1,
		bproof_1		= GetNumberOfPedDrawableVariations		(playerPed, 9) - 1,
		bproof_2		= GetNumberOfPedTextureVariations		(playerPed, 9, Character['bproof_1']) - 1,
		chain_1			= GetNumberOfPedDrawableVariations		(playerPed, 7) - 1,
		chain_2			= GetNumberOfPedTextureVariations		(playerPed, 7, Character['chain_1']) - 1,
		bags_1			= GetNumberOfPedDrawableVariations		(playerPed, 5) - 1,
		bags_2			= GetNumberOfPedTextureVariations		(playerPed, 5, Character['bags_1']) - 1,
		helmet_1		= GetNumberOfPedPropDrawableVariations	(playerPed, 0) - 1,
		helmet_2		= GetNumberOfPedPropTextureVariations	(playerPed, 0, Character['helmet_1']) - 1,
		glasses_1		= GetNumberOfPedPropDrawableVariations	(playerPed, 1) - 1,
		glasses_2		= GetNumberOfPedPropTextureVariations	(playerPed, 1, Character['glasses_1'] - 1),
		watches_1		= GetNumberOfPedPropDrawableVariations	(playerPed, 6) - 1,
		watches_2		= GetNumberOfPedPropTextureVariations	(playerPed, 6, Character['watches_1']) - 1,
		bracelets_1		= GetNumberOfPedPropDrawableVariations	(playerPed, 7) - 1,
		bracelets_2		= GetNumberOfPedPropTextureVariations	(playerPed, 7, Character['bracelets_1'] - 1),
		nose_1	= 10,	
		nose_2	=	10,	
		nose_3	=	10,
		nose_4	=	10,
		nose_5	=		10,
		nose_6	=	10,
		eyebrows_5	=	10,
		eyebrows_6	=	10,
		cheeks_3 =		10,
		cheeks_2 =			10,
		cheeks_1 = 			10,
		eye_open = 		10,
		lips_thick = 		10,
		jaw_1 =10,
		jaw_2 =	10,	
		chin_height	=	10,
		chin_width =		10,
		chin_hole =	10,
		neck_thick	=10
	}

	return data

end

function ApplySkin(skin, clothes)

	local playerPed = GetPlayerPed(-1)

	for k,v in pairs(skin) do
		Character[k] = v
	end

	if clothes ~= nil then

		for k,v in pairs(clothes) do
			if
			k ~= 'sex'				and
			k ~= 'mom'				and
			k ~= 'dad'				and
			k ~= 'age_1'			and
			k ~= 'age_2'			and
			k ~= 'eye_color'		and
			k ~= 'beard_1'			and
			k ~= 'beard_2'			and
			k ~= 'beard_3'			and
			k ~= 'beard_4'			and
			k ~= 'hair_1'			and
			k ~= 'hair_2'			and
			k ~= 'hair_color_1'		and
			k ~= 'hair_color_2'		and
			k ~= 'eyebrows_1'		and
			k ~= 'eyebrows_2'		and
			k ~= 'eyebrows_3'		and
			k ~= 'eyebrows_4'		and
			k ~= 'makeup_1'			and
			k ~= 'makeup_2'			and
			k ~= 'makeup_3'			and
			k ~= 'makeup_4'			and
			k ~= 'lipstick_1'		and
			k ~= 'lipstick_2'		and
			k ~= 'lipstick_3'		and
			k ~= 'lipstick_4'		and
			k ~= 'blemishes_1'		and
			k ~= 'blemishes_2'		and
			k ~= 'blush_1'			and
			k ~= 'blush_2'			and
			k ~= 'blush_3'			and
			k ~= 'complexion_1'		and
			k ~= 'complexion_2'		and
			k ~= 'sun_1'			and
			k ~= 'sun_2'			and
			k ~= 'moles_1'			and
			k ~= 'moles_2'			and
			k ~= 'chest_1'			and
			k ~= 'chest_2'			and
			k ~= 'chest_3'			and
			k ~= 'bodyb_1'			and
			k ~= 'bodyb_2'			and
			k ~= 'nose_1'			and
			k ~= 'nose_2'			and
			k ~= 'nose_3'			and
			k ~= 'nose_4'			and
			k ~= 'nose_5'			and
			k ~= 'nose_6'			and
			k ~= 'eyebrows_5'		and
			k ~= 'eyebrows_6'		and
			k ~= 'cheeks_3'			and
			k ~= 'cheeks_2'			and
			k ~= 'cheeks_1'			and
			k ~= 'eye_open'			and
			k ~= 'lips_thick'		and
			k ~= 'jaw_1'			and
			k ~= 'jaw_2'			and
			k ~= 'chin_height'		and
			k ~= 'chin_width'		and
			k ~= 'chin_hole'		and
			k ~= 'face_ped'		and
			k ~= 'mask_ped'		and
			k ~= 'neck_thick'			
		then
			Character[k] = v
		end
	end
end

	-- SetPedHeadBlendData            (playerPed, Character['dad'], Character['mom'], nil, 0, 0, nil, Character['face'], false, nil, true)
	SetPedHeadBlendData			(playerPed, Character['dad'], Character['mom'], nil, Character['dad'], Character['mom'], nil, Character['face'], Character['skin'], nil, true)
	
	SetPedFaceFeature			(playerPed,			0,								(Character['nose_1'] / 10) + 0.0)			-- Nose Width
	SetPedFaceFeature			(playerPed,			1,								(Character['nose_2'] / 10) + 0.0)			-- Nose Peak Height
	SetPedFaceFeature			(playerPed,			2,								(Character['nose_3'] / 10) + 0.0)			-- Nose Peak Length
	SetPedFaceFeature			(playerPed,			3,								(Character['nose_4'] / 10) + 0.0)			-- Nose Bone Height
	SetPedFaceFeature			(playerPed,			4,								(Character['nose_5'] / 10) + 0.0)			-- Nose Peak Lowering
	SetPedFaceFeature			(playerPed,			5,								(Character['nose_6'] / 10) + 0.0)			-- Nose Bone Twist
	SetPedFaceFeature			(playerPed,			6,								(Character['eyebrows_5'] / 10) + 0.0)		-- Eyebrow height
	SetPedFaceFeature			(playerPed,			7,								(Character['eyebrows_6'] / 10) + 0.0)		-- Eyebrow depth
	SetPedFaceFeature			(playerPed,			9,								(Character['cheeks_1'] / 10) + 0.0)			-- Cheekbones Height
	SetPedFaceFeature			(playerPed,			8,								(Character['cheeks_2'] / 10) + 0.0)			-- Cheekbones Width
	SetPedFaceFeature			(playerPed,			10,								(Character['cheeks_3'] / 10) + 0.0)			-- Cheeks Width

	SetPedFaceFeature			(playerPed,			11,								(Character['eye_open'] / 10) + 0.0)		-- Eyes squint
	SetPedFaceFeature			(playerPed,			12,								(Character['lips_thick'] / 10) + 0.0)	-- Lip Fullness
	SetPedFaceFeature			(playerPed,			13,								(Character['jaw_1'] / 10) + 0.0)			-- Jaw Bone Width
	SetPedFaceFeature			(playerPed,			14,								(Character['jaw_2'] / 10) + 0.0)			-- Jaw Bone Length
	SetPedFaceFeature			(playerPed,			15,								(Character['chin_height'] / 10) + 0.0)			-- Chin Height
	SetPedFaceFeature			(playerPed,			16,								(Character['chin_lenght'] / 10) + 0.0)			-- Chin Length
	SetPedFaceFeature			(playerPed,			17,								(Character['chin_width'] / 10) + 0.0)			-- Chin Width
	SetPedFaceFeature			(playerPed,			18,								(Character['chin_hole'] / 10) + 0.0)			-- Chin Hole Size
	SetPedFaceFeature			(playerPed,			19,								(Character['neck_thick'] / 10) + 0.0)	-- Neck Thickness

	SetPedHairColor				(playerPed,			Character['hair_color_1'],		Character['hair_color_2'])					-- Hair Color
	SetPedHeadOverlay			(playerPed, 3,		Character['age_1'],				(Character['age_2'] / 10) + 0.0)			-- Age + opacity
	SetPedHeadOverlay			(playerPed, 1,		Character['beard_1'],			(Character['beard_2'] / 10) + 0.0)			-- Beard + opacity
	SetPedEyeColor				(playerPed,			Character['eye_color'], 0, 1)												-- Eyes color
	SetPedHeadOverlay			(playerPed, 2,		Character['eyebrows_1'],		(Character['eyebrows_2'] / 10) + 0.0)		-- Eyebrows + opacity
	SetPedHeadOverlay			(playerPed, 4,		Character['makeup_1'],			(Character['makeup_2'] / 10) + 0.0)			-- Makeup + opacity
	SetPedHeadOverlay			(playerPed, 8,		Character['lipstick_1'],		(Character['lipstick_2'] / 10) + 0.0)		-- Lipstick + opacity
	SetPedComponentVariation	(playerPed, 2,		Character['hair_1'],			Character['hair_2'], 2)						-- Hair
	SetPedComponentVariation	(playerPed, 0,		Character['face_ped'],			Character['face_ped2'], 2)						-- PEd
	SetPedComponentVariation	(playerPed, 1,		Character['mask_ped'],			Character['mask_ped'], 2)						-- PEd
	SetPedHeadOverlayColor		(playerPed, 1, 1,	Character['beard_3'],			Character['beard_4'])						-- Beard Color
	SetPedHeadOverlayColor		(playerPed, 2, 1,	Character['eyebrows_3'],		Character['eyebrows_4'])					-- Eyebrows Color
	SetPedHeadOverlayColor		(playerPed, 4, 1,	Character['makeup_3'],			Character['makeup_4'])						-- Makeup Color
	SetPedHeadOverlayColor		(playerPed, 8, 1,	Character['lipstick_3'],		Character['lipstick_4'])					-- Lipstick Color
	SetPedHeadOverlay			(playerPed, 5,		Character['blush_1'],			(Character['blush_2'] / 10) + 0.0)			-- Blush + opacity
	SetPedHeadOverlayColor		(playerPed, 5, 2,	Character['blush_3'])														-- Blush Color
	SetPedHeadOverlay			(playerPed, 6,		Character['complexion_1'],		(Character['complexion_2'] / 10) + 0.0)		-- Complexion + opacity
	SetPedHeadOverlay			(playerPed, 7,		Character['sun_1'],				(Character['sun_2'] / 10) + 0.0)			-- Sun Damage + opacity
	SetPedHeadOverlay			(playerPed, 9,		Character['moles_1'],			(Character['moles_2'] / 10) + 0.0)			-- Moles/Freckles + opacity
	SetPedHeadOverlay			(playerPed, 0,		Character['blemishes_1'],		(Character['blemishes_2'] / 10) + 0.0)		-- Blemishes + opacity
	SetPedHeadOverlay			(playerPed, 10,		Character['chest_1'],			(Character['chest_2'] / 10) + 0.0)			-- Chest Hair + opacity
	SetPedHeadOverlayColor		(playerPed, 10, 1,	Character['chest_3'])														-- Torso Color
	SetPedHeadOverlay			(playerPed, 11,		Character['bodyb_1'],			(Character['bodyb_2'] / 10) + 0.0)			-- Body Blemishes + opacity

	if Character['ears_1'] == -1 then
		ClearPedProp(playerPed, 2)
	else
		SetPedPropIndex			(playerPed, 2,		Character['ears_1'],			Character['ears_2'], 2)						-- Ears Accessories
	end

	SetPedComponentVariation	(playerPed, 8,		Character['tshirt_1'],			Character['tshirt_2'], 2)					-- Tshirt
	SetPedComponentVariation	(playerPed, 11,		Character['torso_1'],			Character['torso_2'], 2)					-- torso parts
	SetPedComponentVariation	(playerPed, 3,		Character['arms'],				Character['arms_2'], 2)						-- Amrs
	SetPedComponentVariation	(playerPed, 10,		Character['decals_1'],			Character['decals_2'], 2)					-- decals
	SetPedComponentVariation	(playerPed, 4,		Character['pants_1'],			Character['pants_2'], 2)					-- pants
	SetPedComponentVariation	(playerPed, 6,		Character['shoes_1'],			Character['shoes_2'], 2)					-- shoes
	SetPedComponentVariation	(playerPed, 1,		Character['mask_1'],			Character['mask_2'], 2)						-- mask
	SetPedComponentVariation	(playerPed, 9,		Character['bproof_1'],			Character['bproof_2'], 2)					-- bulletproof
	SetPedComponentVariation	(playerPed, 7,		Character['chain_1'],			Character['chain_2'], 2)					-- chain
	SetPedComponentVariation	(playerPed, 5,		Character['bags_1'],			Character['bags_2'], 2)						-- Bag

	if Character['helmet_1'] == -1 then
		ClearPedProp(playerPed, 0)
	else
		SetPedPropIndex			(playerPed, 0,		Character['helmet_1'],			Character['helmet_2'], 2)					-- Helmet
	end

	if Character['glasses_1'] == -1 then
		ClearPedProp(playerPed, 1)
	else
		SetPedPropIndex			(playerPed, 1,		Character['glasses_1'],			Character['glasses_2'], 2)					-- Glasses
	end

	if Character['watches_1'] == -1 then
		ClearPedProp(playerPed, 6)
	else
		SetPedPropIndex			(playerPed, 6,		Character['watches_1'],			Character['watches_2'], 2)					-- Watches
	end

	if Character['bracelets_1'] == -1 then
		ClearPedProp(playerPed,	7)
	else
		SetPedPropIndex			(playerPed, 7,		Character['bracelets_1'],		Character['bracelets_2'], 2)				-- Bracelets
	end
end    					-- Glasses

AddEventHandler('skinchanger:loadDefaultModel', function(loadMale, cb)
	LoadDefaultModel(loadMale, cb)
end)

AddEventHandler('skinchanger:getData', function(cb)

	local components = json.decode(json.encode(Components))

	for k,v in pairs(Character) do
		for i=1, #components, 1 do
			if k == components[i].name then
				components[i].value = v
			end
		end
	end

	cb(components, GetMaxVals())
end)

AddEventHandler('skinchanger:change', function(key, val)
	Character[key] = val
	if key == 'sex' then
		TriggerEvent('skinchanger:loadSkin', Character)
	else
		ApplySkin(Character)
	end

end)

AddEventHandler('skinchanger:getSkin', function(cb)
	cb(Character)
end)

AddEventHandler('skinchanger:modelLoaded', function()
	ClearPedProp(GetPlayerPed(-1), 0)
	if LoadSkin ~= nil then
		ApplySkin(LoadSkin)
		LoadSkin = nil
	end
	if LoadClothes ~= nil then
		ApplySkin(LoadClothes.playerSkin, LoadClothes.clothesSkin)
		LoadClothes = nil
	end
end)

RegisterNetEvent('skinchanger:loadSkin')
AddEventHandler('skinchanger:loadSkin', function(skin, cb)
	local playerPed = GetPlayerPed(-1)
	local characterModel
	if skin['sex'] ~= LastSex then
		LoadSkin = skin

		if skin['sex'] == 0 then
			TriggerEvent('skinchanger:loadDefaultModel', true, cb)
		elseif skin['sex'] > 1 then
			characterModel = Config.pedList[skin.sex - 1]
		else
			TriggerEvent('skinchanger:loadDefaultModel', false, cb)
		end
		RequestModel(characterModel)
	else
		ApplySkin(skin)
		-- TriggerServerEvent("Sac", skin)

		if cb ~= nil then
			cb()
		end
	end

	LastSex = skin['sex']
	
	Citizen.CreateThread(function()

		if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
	
			while not HasModelLoaded(characterModel) do
				Citizen.Wait(0)
			end
	
			SetPlayerModel(PlayerId(), characterModel)
			SetPedDefaultComponentVariation(PlayerPedId())
			SetModelAsNoLongerNeeded(characterModel)
	
			TriggerEvent('skinchanger:modelLoaded')
		end
	end)
end)

RegisterNetEvent('skinchanger:loadClothes')
AddEventHandler('skinchanger:loadClothes', function(playerSkin, clothesSkin)
	local playerPed = GetPlayerPed(-1)
	local characterModel
	if playerSkin['sex'] ~= LastSex then
		LoadClothes = {
			playerSkin	= playerSkin,
			clothesSkin	= clothesSkin
		}

		if playerSkin['sex'] == 0 then
			TriggerEvent('skinchanger:loadDefaultModel', true)
		elseif playerSkin['sex'] > 1 then
			characterModel = Config.pedList[playerSkin.sex - 1]
		else
			TriggerEvent('skinchanger:loadDefaultModel', false)
		end
		RequestModel(characterModel)
	else
		ApplySkin(playerSkin, clothesSkin)
		-- TriggerServerEvent("Sac", clothesSkin)
	end

	LastSex = playerSkin['sex']
	
	Citizen.CreateThread(function()

		if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
	
			while not HasModelLoaded(characterModel) do
				Citizen.Wait(0)
			end
	
			SetPlayerModel(PlayerId(), characterModel)
			SetPedDefaultComponentVariation(PlayerPedId())
			SetModelAsNoLongerNeeded(characterModel)
	
			TriggerEvent('skinchanger:modelLoaded')
		end
	end)
end)