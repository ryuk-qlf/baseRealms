ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function GetVehicleProperties(vehicle)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local extras = {}

		for id=0, 12 do
			if DoesExtraExist(vehicle, id) then
				local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
				extras[tostring(id)] = state
			end
		end

		return {
			model             = GetEntityModel(vehicle),

			plate             = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),
			plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

			bodyHealth        = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
			engineHealth      = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1),

			fuelLevel         = ESX.Math.Round(GetVehicleFuelLevel(vehicle), 1),
			dirtLevel         = ESX.Math.Round(GetVehicleDirtLevel(vehicle), 1),
			color1            = colorPrimary,
			color2            = colorSecondary,
            InteriorColor	  = GetVehicleInteriorColor(vehicle),
            dashboardColour   = GetVehicleDashboardColor(vehicle),

			pearlescentColor  = pearlescentColor,
			wheelColor        = wheelColor,

			wheels            = GetVehicleWheelType(vehicle),
			windowTint        = GetVehicleWindowTint(vehicle),
			xenonColor        = GetVehicleXenonLightsColour(vehicle),

			neonEnabled       = {
				IsVehicleNeonLightEnabled(vehicle, 0),
				IsVehicleNeonLightEnabled(vehicle, 1),
				IsVehicleNeonLightEnabled(vehicle, 2),
				IsVehicleNeonLightEnabled(vehicle, 3)
			},

			neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
			extras            = extras,
			tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

			modSpoilers       = GetVehicleMod(vehicle, 0),
			modFrontBumper    = GetVehicleMod(vehicle, 1),
			modRearBumper     = GetVehicleMod(vehicle, 2),
			modSideSkirt      = GetVehicleMod(vehicle, 3),
			modExhaust        = GetVehicleMod(vehicle, 4),
			modFrame          = GetVehicleMod(vehicle, 5),
			modGrille         = GetVehicleMod(vehicle, 6),
			modHood           = GetVehicleMod(vehicle, 7),
			modFender         = GetVehicleMod(vehicle, 8),
			modRightFender    = GetVehicleMod(vehicle, 9),
			modRoof           = GetVehicleMod(vehicle, 10),

			modEngine         = GetVehicleMod(vehicle, 11),
			modBrakes         = GetVehicleMod(vehicle, 12),
			modTransmission   = GetVehicleMod(vehicle, 13),
			modHorns          = GetVehicleMod(vehicle, 14),
			modSuspension     = GetVehicleMod(vehicle, 15),
			modArmor          = GetVehicleMod(vehicle, 16),

			modTurbo          = IsToggleModOn(vehicle, 18),
			modSmokeEnabled   = IsToggleModOn(vehicle, 20),
			modXenon          = IsToggleModOn(vehicle, 22),

			modFrontWheels    = GetVehicleMod(vehicle, 23),
			modBackWheels     = GetVehicleMod(vehicle, 24),

			modPlateHolder    = GetVehicleMod(vehicle, 25),
			modVanityPlate    = GetVehicleMod(vehicle, 26),
			modTrimA          = GetVehicleMod(vehicle, 27),
			modOrnaments      = GetVehicleMod(vehicle, 28),
			modDashboard      = GetVehicleMod(vehicle, 29),
			modDial           = GetVehicleMod(vehicle, 30),
			modDoorSpeaker    = GetVehicleMod(vehicle, 31),
			modSeats          = GetVehicleMod(vehicle, 32),
			modSteeringWheel  = GetVehicleMod(vehicle, 33),
			modShifterLeavers = GetVehicleMod(vehicle, 34),
			modAPlate         = GetVehicleMod(vehicle, 35),
			modSpeakers       = GetVehicleMod(vehicle, 36),
			modTrunk          = GetVehicleMod(vehicle, 37),
			modHydrolic       = GetVehicleMod(vehicle, 38),
			modEngineBlock    = GetVehicleMod(vehicle, 39),
			modAirFilter      = GetVehicleMod(vehicle, 40),
			modStruts         = GetVehicleMod(vehicle, 41),
			modArchCover      = GetVehicleMod(vehicle, 42),
			modAerials        = GetVehicleMod(vehicle, 43),
			modTrimB          = GetVehicleMod(vehicle, 44),
			modTank           = GetVehicleMod(vehicle, 45),
			modWindows        = GetVehicleMod(vehicle, 46),
			modLivery         = GetVehicleMod(vehicle, 48)
		}
	else
		return
	end
end

function SetVehicleProperties(vehicle, props)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        local InteriorColor = GetVehicleInteriorColor(vehicle)

		SetVehicleModKit(vehicle, 0)

		if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
		if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
		if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
		if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
		if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
		if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
		if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
		if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
        if props.InteriorColor then SetVehicleInteriorColour(vehicle, props.color1 or InteriorColor) end
		if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
		if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
		if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
		if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end
        if props.dashboardColour then SetVehicleDashboardColour(vehicle, props.dashboardColour) end

		if props.neonEnabled then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end

		if props.extras then
			for id,enabled in pairs(props.extras) do
				if enabled then
					SetVehicleExtra(vehicle, tonumber(id), 0)
				else
					SetVehicleExtra(vehicle, tonumber(id), 1)
				end
			end
		end

		if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
		if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
		if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
		if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
		if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
		if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
		if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
		if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
		if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
		if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
		if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
		if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
		if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
		if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
		if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
		if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
		if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
		if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
		if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
		if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
		if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
		if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
		if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
		if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
		if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
		if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
		if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
		if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
		if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
		if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
		if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
		if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
		if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
		if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
		if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
		if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
		if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
		if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
		if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
		if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
		if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
		if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
		if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
		if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
		if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
		if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
		if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end

		if props.modLivery then
			SetVehicleMod(vehicle, 48, props.modLivery, false)
			SetVehicleLivery(vehicle, props.modLivery)
		end
	end
end

local LsCustoms = {

    Pos = {
        {pos = vector3(-210.09, -1325.69, 30.57), job = "bennys", notif = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~b~Benny's~s~.", size = 10.0},
        {pos = vector3(-338.94, -137.03, 38.68), job = "lscustoms", notif = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~b~Los Santos Customs~s~.", size = 10.0},
        {pos = vector3(1978.37, 3774.87, 31.86), job = "sandybennys", notif = "Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~b~Sandy Benny's~s~.", size = 10.0},
    },

    DefaultPrimaireColour = 1,
    DefaultSecondaireColour = 1,
    DefaultInteriorColour = 1,
    DefaultDashboardColour = 1,
    DefaultNacrageColour = 1,
    DefaultTypeRouesColour = 1,
    DefaultJantesPrincipales = 1,
    DefaultColourJantes = 1,
    DefaultKlaxon = 1,
    DefaultTeinteVitres = 1,
    DefaultTypesPlaques = 1,
    DefaultLivery = 1,
    DefaultColourPhares = 1,
    DefaultFrein = 1,
    DefaultMoteur = 1,
    DefaultTransmission = 1,
    DefaultSuspension = 1,

    DefaultAileron = 1,
    DefaultParechocAvant = 1,
    DefaultParechocArriere = 1,
    DefaultCarrosserie = 1,
    DefaultEchappement = 1,
    DefaultCadre = 1,
    DefaultCalandre = 1,
    DefaultCapot = 1,
    DefaultAutocollantGauche = 1,
    DefaultAutocollantDroit = 1,
    DefaultToit = 1,
    DefaultSupportPlaque = 1,
    DefaultPlaqueAvant = 1,
    DefaultFigurine = 1,
    DefaultDashboardMotif = 1,
    DefaultCadran = 1,
    DefaultHautParleurPortes = 1,
    DefaultMotifSieges = 1,
    DefaultVolant = 1,
    DefaultLevier = 1,
    DefaultLogoCustom = 1,
    DefaultHautParleurVitre = 1,
    DefaultHautParleurCoffre = 1,
    DefaultHydrolique = 1,
    DefaultVisualMoteur = 1,
    DefaultFiltresAir = 1,
    DefaultEntretoises = 1,
    DefaultCouverture = 1,
    DefaultAntenne = 1,
    DefaultStyle = 1,
    DefaultFenetre = 1,
    DefaultReservoir = 1,

    Price = 0,
    PriceExtra = 0,
    PricePrimary = 0,
    PriceSecondary = 0,
    PriceInterieurs = 0,
    PriceDashboard = 0,
    PriceNacrage = 0,
    PriceJantesPrincipales = 0,
    PriceWheelColor = 0,
    PriceKlaxon = 0,
    PricePharesXenons = 0,
    PricePlateIndex = 0,
    PriceLivery = 0,
    PriceColorPhares = 0,
    PriceAileron = 0,
    PriceParechocAvant = 0,
    PriceParechocArriere = 0,
    PriceCarrosserie = 0,
    PriceEchappement = 0,
    PriceCadre = 0,
    PriceCalandre = 0,
    PriceCapot = 0,
    PriceAutocollantGauche = 0,
    PriceAutocollantDroit = 0,
    PriceToit = 0,
    PriceSupportPlaque = 0,
    PricePlaqueAvant = 0,
    PriceFigurine = 0,
    PriceDashboardMotif = 0,
    PriceCadran = 0,
    PriceHautParleurPortes = 0,
    PriceMotifSieges = 0,
    PriceVolant = 0,
    PriceLevier = 0,
    PriceLogo = 0,
    PriceHautParleurVitre = 0,
    PriceHautParleurCoffre = 0,
    PriceHydrolique = 0,
    PriceVisualMoteur = 0,
    PriceFiltresAir = 0,
    PriceEntretoises = 0,
    PriceCouverture = 0,
    PriceAntenne = 0,
    PriceReservoir = 0,
    PriceFenetre = 0,
    PriceStyle = 0,
    PriceSuspension = 0,
    PriceTransmission = 0,
    PriceMoteur = 0,
    PriceFrein = 0,
    PriceTurbo = 0,

    ExtraList = {
        { id = 1, index = 1 },
        { id = 2, index = 1 },
        { id = 3, index = 1 },
        { id = 4, index = 1 },
        { id = 5, index = 1 },
        { id = 6, index = 1 },
        { id = 7, index = 1 },
        { id = 8, index = 1 },
        { id = 9, index = 1 },
        { id = 10, index = 1 },
        { id = 11, index = 1 },
        { id = 12, index = 1 },
        { id = 13, index = 1 },
        { id = 14, index = 1 },
        { id = 15, index = 1 },
        { id = 16, index = 1 },
        { id = 17, index = 1 },
        { id = 18, index = 1 },
        { id = 19, index = 1 },
        { id = 20, index = 1 },
    },
}

LsCustoms.openedMenu = false
LsCustoms.mainMenu = RageUI.CreateMenu(" ", "Ls Customs", nil, nil, 'shopui_title_supermod', 'shopui_title_supermod')
LsCustoms.subMenuColour = RageUI.CreateSubMenu(LsCustoms.mainMenu, " ", "Ls Customs", nil, nil, 'shopui_title_supermod', 'shopui_title_supermod')
LsCustoms.subMenuRoues = RageUI.CreateSubMenu(LsCustoms.mainMenu, " ", "Ls Customs", nil, nil, 'shopui_title_supermod', 'shopui_title_supermod')
LsCustoms.subMenuClassiques = RageUI.CreateSubMenu(LsCustoms.mainMenu, " ", "Ls Customs", nil, nil, 'shopui_title_supermod', 'shopui_title_supermod')
LsCustoms.subMenuCustoms = RageUI.CreateSubMenu(LsCustoms.mainMenu, " ", "Ls Customs", nil, nil, 'shopui_title_supermod', 'shopui_title_supermod')
LsCustoms.subMenuPerf = RageUI.CreateSubMenu(LsCustoms.mainMenu, " ", "Ls Customs", nil, nil, 'shopui_title_supermod', 'shopui_title_supermod')
LsCustoms.subMenuExtra = RageUI.CreateSubMenu(LsCustoms.mainMenu, " ", "Ls Customs", nil, nil, 'shopui_title_supermod', 'shopui_title_supermod')
LsCustoms.subMenuModification = RageUI.CreateSubMenu(LsCustoms.mainMenu, " ", "Ls Customs", nil, nil, 'shopui_title_supermod', 'shopui_title_supermod')

LsCustoms.mainMenu:DisplayGlare(false)
LsCustoms.subMenuColour:DisplayGlare(false)
LsCustoms.subMenuRoues:DisplayGlare(false)
LsCustoms.subMenuClassiques:DisplayGlare(false)
LsCustoms.subMenuCustoms:DisplayGlare(false)
LsCustoms.subMenuPerf:DisplayGlare(false)
LsCustoms.subMenuExtra:DisplayGlare(false)
LsCustoms.subMenuModification:DisplayGlare(false)

LsCustoms.mainMenu.Closable = false

function ResetAll()
    LsCustoms.openedMenu = false
    LsCustoms.Price = 0
    LsCustoms.PriceExtra = 0
    LsCustoms.PricePrimary = 0
    LsCustoms.PriceSecondary = 0
    LsCustoms.PriceInterieurs = 0
    LsCustoms.PriceDashboard = 0
    LsCustoms.PriceNacrage = 0
    LsCustoms.PriceJantesPrincipales = 0
    LsCustoms.PriceWheelColor = 0
    LsCustoms.PriceKlaxon = 0
    LsCustoms.PricePharesXenons = 0
    LsCustoms.PricePlateIndex = 0
    LsCustoms.PriceLivery = 0
    LsCustoms.PriceColorPhares = 0
    LsCustoms.PriceAileron = 0
    LsCustoms.PriceParechocAvant = 0
    LsCustoms.PriceParechocArriere = 0
    LsCustoms.PriceCarrosserie = 0
    LsCustoms.PriceEchappement = 0
    LsCustoms.PriceCadre = 0
    LsCustoms.PriceCalandre = 0
    LsCustoms.PriceCapot = 0
    LsCustoms.PriceAutocollantGauche = 0
    LsCustoms.PriceAutocollantDroit = 0
    LsCustoms.PriceToit = 0
    LsCustoms.PriceSupportPlaque = 0
    LsCustoms.PricePlaqueAvant = 0
    LsCustoms.PriceFigurine = 0
    LsCustoms.PriceDashboardMotif = 0
    LsCustoms.PriceCadran = 0
    LsCustoms.PriceHautParleurPortes = 0
    LsCustoms.PriceMotifSieges = 0
    LsCustoms.PriceVolant = 0
    LsCustoms.PriceLevier = 0
    LsCustoms.PriceLogo = 0
    LsCustoms.PriceHautParleurVitre = 0
    LsCustoms.PriceHautParleurCoffre = 0
    LsCustoms.PriceHydrolique = 0
    LsCustoms.PriceVisualMoteur = 0
    LsCustoms.PriceFiltresAir = 0
    LsCustoms.PriceEntretoises = 0
    LsCustoms.PriceCouverture = 0
    LsCustoms.PriceAntenne = 0
    LsCustoms.PriceReservoir = 0
    LsCustoms.PriceFenetre = 0
    LsCustoms.PriceStyle = 0
    LsCustoms.PriceSuspension = 0
    LsCustoms.PriceTransmission = 0
    LsCustoms.PriceMoteur = 0
    LsCustoms.PriceFrein = 0
    LsCustoms.PriceTurbo = 0
end

function GetModObjects(veh, mod)
	local int = {"Default"}
	for i = 0, tonumber(GetNumVehicleMods(veh, mod)) - 1 do
		local toBeInserted = i
		local labelName = GetModTextLabel(veh, mod, i)
		if labelName ~= nil then
			local name = tostring(GetLabelText(labelName))
			if name ~= "NULL" then
				toBeInserted = name
			end
		end
		int[#int + 1] = toBeInserted
	end

	return int
end

function GetMitrailVeh(TableCustoms)
    local mitraill = false

    for k, v in pairs(TableCustoms) do
        if string.match(v, "Mitraill") or string.match(v, "Gun") then
            mitraill = true
        end
    end
    return mitraill
end

function DrawTextPrice(Text, Justi, havetext)
    SetTextFont(4)
    SetTextScale(1.1, 1.1)
    SetTextColour(255, 255, 255, 255)
    SetTextJustification(0)
    SetTextEntry("STRING")
    if havetext then 
        SetTextWrap(0.5, 0.6)
    end
    AddTextComponentString(Text)
    DrawText(0.5, 0.90)
end

function MenuCustomization()
    if not RageUI.GetInMenu() then
        return
    end
    if LsCustoms.openedMenu then
        LsCustoms.openedMenu = false
        RageUI.Visible(LsCustoms.mainMenu, false)
    else
        LsCustoms.Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        LsCustoms.Prop = GetVehicleProperties(LsCustoms.Vehicle)
        Wait(150)
        LsCustoms.ColourPrimarySecondaryColourJantes = {}
        LsCustoms.ColourIntDashNacrage = {}
        LsCustoms.JantesPrincipales = {}
        LsCustoms.JantesArrieres = {}
        LsCustoms.MaxLivery = {}
        LsCustoms.MaxKlaxon = {}
        LsCustoms.CoulorPhares = {}
        for i = 1, 160, 1 do 
            table.insert(LsCustoms.ColourPrimarySecondaryColourJantes, i) 
        end 
        for i = 1, 158, 1 do 
            table.insert(LsCustoms.ColourIntDashNacrage, i) 
        end
        for i = 1, GetNumVehicleMods(LsCustoms.Vehicle, 23) + 1, 1 do
            table.insert(LsCustoms.JantesPrincipales, i) 
        end
        for i = 1, GetNumVehicleMods(LsCustoms.Vehicle, 24) + 1, 1 do
            table.insert(LsCustoms.JantesArrieres, i) 
        end
        for i = 1, GetVehicleLiveryCount(LsCustoms.Vehicle), 1 do
            table.insert(LsCustoms.MaxLivery, i) 
        end
        for i = 1, 59, 1 do 
            table.insert(LsCustoms.MaxKlaxon, i) 
        end
        for i = 1, 12, 1 do 
            table.insert(LsCustoms.CoulorPhares, i)
        end
        if IsToggleModOn(LsCustoms.Vehicle, 22) then
            LsCustoms.DefaultPharesXenons = true
        else
            LsCustoms.DefaultPharesXenons = false
        end
        if IsToggleModOn(LsCustoms.Vehicle, 18) then
            LsCustoms.DefaultTurbo = true
        else
            LsCustoms.DefaultTurbo = false
        end
        SetVehicleModKit(LsCustoms.Vehicle, 0)
        Wait(150)
        LsCustoms.openedMenu = true
        RageUI.Visible(LsCustoms.mainMenu, true)
            CreateThread(function()
                while LsCustoms.openedMenu do
                    LsCustoms.Price = LsCustoms.PriceExtra+LsCustoms.PricePrimary+LsCustoms.PriceSecondary+LsCustoms.PriceInterieurs+LsCustoms.PriceDashboard+LsCustoms.PriceNacrage+LsCustoms.PriceJantesPrincipales+LsCustoms.PriceWheelColor+LsCustoms.PriceKlaxon+LsCustoms.PricePharesXenons+LsCustoms.PricePlateIndex+LsCustoms.PriceLivery+LsCustoms.PriceColorPhares+LsCustoms.PriceAileron+LsCustoms.PriceParechocAvant+LsCustoms.PriceParechocArriere+LsCustoms.PriceCarrosserie+LsCustoms.PriceEchappement+LsCustoms.PriceCadre+LsCustoms.PriceCalandre+LsCustoms.PriceCapot+LsCustoms.PriceAutocollantGauche+LsCustoms.PriceAutocollantDroit+LsCustoms.PriceToit+LsCustoms.PriceSupportPlaque+LsCustoms.PricePlaqueAvant+LsCustoms.PriceFigurine+LsCustoms.PriceDashboardMotif+LsCustoms.PriceCadran+LsCustoms.PriceHautParleurPortes+LsCustoms.PriceMotifSieges+LsCustoms.PriceVolant+LsCustoms.PriceLevier+LsCustoms.PriceLogo+LsCustoms.PriceHautParleurVitre+LsCustoms.PriceHautParleurCoffre+LsCustoms.PriceHydrolique+LsCustoms.PriceVisualMoteur+LsCustoms.PriceFiltresAir+LsCustoms.PriceEntretoises+LsCustoms.PriceCouverture+LsCustoms.PriceAntenne+LsCustoms.PriceReservoir+LsCustoms.PriceFenetre+LsCustoms.PriceStyle+LsCustoms.PriceSuspension+LsCustoms.PriceTransmission+LsCustoms.PriceMoteur+LsCustoms.PriceFrein+LsCustoms.PriceTurbo
                    if LsCustoms.Price > 0 then 
                        DrawTextPrice("Total facture : ~b~"..math.floor(LsCustoms.Price*1.6).."$~s~. Total entreprise : ~g~"..LsCustoms.Price.."$~s~.")
                    end
                    RageUI.IsVisible(LsCustoms.mainMenu, function()
                        RageUI.Button("Peinture", nil, {RightLabel = "→"}, true, {}, LsCustoms.subMenuColour)
                        RageUI.Button("Roues", nil, {RightLabel = "→"}, true, {}, LsCustoms.subMenuRoues)
                        RageUI.Button("Classiques", nil, {RightLabel = "→"}, true, {}, LsCustoms.subMenuClassiques)
                        RageUI.Button("Customs", nil, {RightLabel = "→"}, true, {}, LsCustoms.subMenuCustoms)
                        RageUI.Button("Performances", nil, {RightLabel = "→"}, true, {}, LsCustoms.subMenuPerf)
                        RageUI.Button("Extra", nil, {RightLabel = "→"}, true, {}, LsCustoms.subMenuExtra)
                        RageUI.Button("Valider les modifications", nil, {RightLabel = "→"}, true, {}, LsCustoms.subMenuModification)
                    end)
                    RageUI.IsVisible(LsCustoms.subMenuModification, function()
                        if LsCustoms.Price > 0 then
                            RageUI.Button("Valider les modifications", nil, {RightLabel = "~g~"..LsCustoms.Price.."$"}, true, {
                                onSelected = function()
                                    LsCustoms.openedMenu = false
                                    RageUI.CloseAll()
                                    TriggerServerEvent("BuyLsCustoms", LsCustoms.Prop, LsCustoms.Price)
                                    ResetAll()
                                end
                            })
                        end
                        RageUI.Button("Annuler les modifications", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                LsCustoms.openedMenu = false
                                RageUI.CloseAll()
                                SetVehicleProperties(LsCustoms.Vehicle, LsCustoms.Prop)
                                ResetAll()
                                ESX.ShowNotification("Vous avez ~r~annuler~s~ toutes ~r~les modifications~s~.")
                            end
                        })
                        if LsCustoms.PriceExtra > 0 then
                            RageUI.Button("Extra", nil, {RightLabel = "~g~"..LsCustoms.PriceExtra.."$"}, true, {})
                        end
                        if LsCustoms.PricePrimary > 0 then
                            RageUI.Button("Primaire", nil, {RightLabel = "~g~"..LsCustoms.PricePrimary.."$"}, true, {})
                        end
                        if LsCustoms.PriceSecondary > 0 then
                            RageUI.Button("Secondaire", nil, {RightLabel = "~g~"..LsCustoms.PriceSecondary.."$"}, true, {})
                        end
                        if LsCustoms.PriceInterieurs > 0 then
                            RageUI.Button("Intérieurs", nil, {RightLabel = "~g~"..LsCustoms.PriceInterieurs.."$"}, true, {})
                        end
                        if LsCustoms.PriceDashboard > 0 then
                            RageUI.Button("Tableau de bord", nil, {RightLabel = "~g~"..LsCustoms.PriceDashboard.."$"}, true, {})
                        end
                        if LsCustoms.PriceNacrage > 0 then
                            RageUI.Button("Nacrage", nil, {RightLabel = "~g~"..LsCustoms.PriceNacrage.."$"}, true, {})
                        end
                        if LsCustoms.PriceJantesPrincipales > 0 then
                            RageUI.Button("Jantes principales", nil, {RightLabel = "~g~"..LsCustoms.PriceJantesPrincipales.."$"}, true, {})
                        end
                        if LsCustoms.PriceWheelColor > 0 then
                            RageUI.Button("Couleurs des jantes", nil, {RightLabel = "~g~"..LsCustoms.PriceWheelColor.."$"}, true, {})
                        end
                        if LsCustoms.PriceKlaxon > 0 then
                            RageUI.Button("Klaxon", nil, {RightLabel = "~g~"..LsCustoms.PriceKlaxon.."$"}, true, {})
                        end
                        if LsCustoms.PricePharesXenons > 0 then
                            RageUI.Button("Phares xenons", nil, {RightLabel = "~g~"..LsCustoms.PricePharesXenons.."$"}, true, {})
                        end
                        if LsCustoms.PricePlateIndex > 0 then
                            RageUI.Button("Types de plaques", nil, {RightLabel = "~g~"..LsCustoms.PricePlateIndex.."$"}, true, {})
                        end
                        if LsCustoms.PriceLivery > 0 then
                            RageUI.Button("Livery", nil, {RightLabel = "~g~"..LsCustoms.PriceLivery.."$"}, true, {})
                        end
                        if LsCustoms.PriceColorPhares > 0 then
                            RageUI.Button("Couleur des phares", nil, {RightLabel = "~g~"..LsCustoms.PriceColorPhares.."$"}, true, {})
                        end
                        if LsCustoms.PriceAileron > 0 then
                            RageUI.Button("Aileron", nil, {RightLabel = "~g~"..LsCustoms.PriceAileron.."$"}, true, {})
                        end
                        if LsCustoms.PriceParechocAvant > 0 then
                            RageUI.Button("Pare-choc avant", nil, {RightLabel = "~g~"..LsCustoms.PriceParechocAvant.."$"}, true, {})
                        end
                        if LsCustoms.PriceParechocArriere > 0 then
                            RageUI.Button("Pare-choc arrière", nil, {RightLabel = "~g~"..LsCustoms.PriceParechocArriere.."$"}, true, {})
                        end
                        if LsCustoms.PriceCarrosserie > 0 then
                            RageUI.Button("Carrosserie", nil, {RightLabel = "~g~"..LsCustoms.PriceCarrosserie.."$"}, true, {})
                        end
                        if LsCustoms.PriceEchappement > 0 then
                            RageUI.Button("Echappement", nil, {RightLabel = "~g~"..LsCustoms.PriceEchappement.."$"}, true, {})
                        end
                        if LsCustoms.PriceCadre > 0 then
                            RageUI.Button("Cadre", nil, {RightLabel = "~g~"..LsCustoms.PriceCadre.."$"}, true, {})
                        end
                        if LsCustoms.PriceCalandre > 0 then
                            RageUI.Button("Calandre", nil, {RightLabel = "~g~"..LsCustoms.PriceCalandre.."$"}, true, {})
                        end
                        if LsCustoms.PriceCapot > 0 then
                            RageUI.Button("PriceCapot", nil, {RightLabel = "~g~"..LsCustoms.PriceCapot.."$"}, true, {})
                        end
                        if LsCustoms.PriceAutocollantGauche > 0 then
                            RageUI.Button("Autocollant gauche", nil, {RightLabel = "~g~"..LsCustoms.PriceAutocollantGauche.."$"}, true, {})
                        end
                        if LsCustoms.PriceAutocollantDroit > 0 then
                            RageUI.Button("Autocollant droit", nil, {RightLabel = "~g~"..LsCustoms.PriceAutocollantDroit.."$"}, true, {})
                        end
                        if LsCustoms.PriceToit > 0 then
                            RageUI.Button("Toit", nil, {RightLabel = "~g~"..LsCustoms.PriceToit.."$"}, true, {})
                        end
                        if LsCustoms.PriceSupportPlaque > 0 then
                            RageUI.Button("Support de plaque", nil, {RightLabel = "~g~"..LsCustoms.PriceSupportPlaque.."$"}, true, {})
                        end
                        if LsCustoms.PricePlaqueAvant > 0 then
                            RageUI.Button("Plaque avant", nil, {RightLabel = "~g~"..LsCustoms.PricePlaqueAvant.."$"}, true, {})
                        end
                        if LsCustoms.PriceFigurine > 0 then
                            RageUI.Button("Figurine", nil, {RightLabel = "~g~"..LsCustoms.PriceFigurine.."$"}, true, {})
                        end
                        if LsCustoms.PriceDashboardMotif > 0 then
                            RageUI.Button("Tableau de bord motif", nil, {RightLabel = "~g~"..LsCustoms.PriceDashboardMotif.."$"}, true, {})
                        end      
                        if LsCustoms.PriceCadran > 0 then
                            RageUI.Button("Cadran", nil, {RightLabel = "~g~"..LsCustoms.PriceCadran.."$"}, true, {})
                        end
                        if LsCustoms.PriceHautParleurPortes > 0 then
                            RageUI.Button("Haut parleur portes", nil, {RightLabel = "~g~"..LsCustoms.PriceHautParleurPortes.."$"}, true, {})
                        end
                        if LsCustoms.PriceMotifSieges > 0 then
                            RageUI.Button("Motif Sieges", nil, {RightLabel = "~g~"..LsCustoms.PriceMotifSieges.."$"}, true, {})
                        end
                        if LsCustoms.PriceVolant > 0 then
                            RageUI.Button("Volant", nil, {RightLabel = "~g~"..LsCustoms.PriceVolant.."$"}, true, {})
                        end
                        if LsCustoms.PriceLevier > 0 then
                            RageUI.Button("Levier", nil, {RightLabel = "~g~"..LsCustoms.PriceLevier.."$"}, true, {})
                        end
                        if LsCustoms.PriceLogo > 0 then
                            RageUI.Button("Logo custom", nil, {RightLabel = "~g~"..LsCustoms.PriceLogo.."$"}, true, {})
                        end
                        if LsCustoms.PriceHautParleurVitre > 0 then
                            RageUI.Button("Haut parleur vitre", nil, {RightLabel = "~g~"..LsCustoms.PriceHautParleurVitre.."$"}, true, {})
                        end
                        if LsCustoms.PriceHautParleurCoffre > 0 then
                            RageUI.Button("Haut parleur coffre", nil, {RightLabel = "~g~"..LsCustoms.PriceHautParleurCoffre.."$"}, true, {})
                        end

                        if LsCustoms.PriceLevier > 0 then
                            RageUI.Button("Levier", nil, {RightLabel = "~g~"..LsCustoms.PriceLevier.."$"}, true, {})
                        end
                        if LsCustoms.PriceLevier > 0 then
                            RageUI.Button("Levier", nil, {RightLabel = "~g~"..LsCustoms.PriceLevier.."$"}, true, {})
                        end
                        if LsCustoms.PriceLevier > 0 then
                            RageUI.Button("Levier", nil, {RightLabel = "~g~"..LsCustoms.PriceLevier.."$"}, true, {})
                        end
                        if LsCustoms.PriceLevier > 0 then
                            RageUI.Button("Levier", nil, {RightLabel = "~g~"..LsCustoms.PriceLevier.."$"}, true, {})
                        end

                        if LsCustoms.PriceHydrolique > 0 then
                            RageUI.Button("Hydrolique", nil, {RightLabel = "~g~"..LsCustoms.PriceHydrolique.."$"}, true, {})
                        end
                        if LsCustoms.PriceVisualMoteur > 0 then
                            RageUI.Button("Moteur", nil, {RightLabel = "~g~"..LsCustoms.PriceVisualMoteur.."$"}, true, {})
                        end
                        if LsCustoms.PriceFiltresAir > 0 then
                            RageUI.Button("Filtres à Air", nil, {RightLabel = "~g~"..LsCustoms.PriceFiltresAir.."$"}, true, {})
                        end
                        if LsCustoms.PriceLevier > 0 then
                            RageUI.Button("Levier", nil, {RightLabel = "~g~"..LsCustoms.PriceLevier.."$"}, true, {})
                        end
                        if LsCustoms.PriceEntretoises > 0 then
                            RageUI.Button("Entretoises", nil, {RightLabel = "~g~"..LsCustoms.PriceEntretoises.."$"}, true, {})
                        end
                        
                        if LsCustoms.PriceCouverture > 0 then
                            RageUI.Button("Couverture", nil, {RightLabel = "~g~"..LsCustoms.PriceCouverture.."$"}, true, {})
                        end
                        if LsCustoms.PriceAntenne > 0 then
                            RageUI.Button("Antenne", nil, {RightLabel = "~g~"..LsCustoms.PriceAntenne.."$"}, true, {})
                        end
                        if LsCustoms.PriceReservoir > 0 then
                            RageUI.Button("Reservoir", nil, {RightLabel = "~g~"..LsCustoms.PriceReservoir.."$"}, true, {})
                        end
                        if LsCustoms.PriceFenetre > 0 then
                            RageUI.Button("Fenêtre", nil, {RightLabel = "~g~"..LsCustoms.PriceFenetre.."$"}, true, {})
                        end
                        if LsCustoms.PriceEntretoises > 0 then
                            RageUI.Button("Entretoises", nil, {RightLabel = "~g~"..LsCustoms.PriceEntretoises.."$"}, true, {})
                        end
                        if LsCustoms.PriceStyle > 0 then
                            RageUI.Button("Stickers", nil, {RightLabel = "~g~"..LsCustoms.PriceStyle.."$"}, true, {})
                        end
                        if LsCustoms.PriceSuspension > 0 then
                            RageUI.Button("Suspension", nil, {RightLabel = "~g~"..LsCustoms.PriceSuspension.."$"}, true, {})
                        end
                        if LsCustoms.PriceTransmission > 0 then
                            RageUI.Button("Transmission", nil, {RightLabel = "~g~"..LsCustoms.PriceTransmission.."$"}, true, {})
                        end
                        if LsCustoms.PriceMoteur > 0 then
                            RageUI.Button("Moteur", nil, {RightLabel = "~g~"..LsCustoms.PriceMoteur.."$"}, true, {})
                        end
                        if LsCustoms.PriceFrein > 0 then
                            RageUI.Button("Frein", nil, {RightLabel = "~g~"..LsCustoms.PriceFrein.."$"}, true, {})
                        end
                        if LsCustoms.PriceTurbo > 0 then
                            RageUI.Button("Turbo", nil, {RightLabel = "~g~"..LsCustoms.PriceTurbo.."$"}, true, {})
                        end
                    end)
                    RageUI.IsVisible(LsCustoms.subMenuColour, function()
                        RageUI.List("Primaire", LsCustoms.ColourPrimarySecondaryColourJantes, LsCustoms.DefaultPrimaireColour, nil, {}, true, {
                            onListChange = function(Index)
                                LsCustoms.DefaultPrimaireColour = Index

                                local primaire, secondaire = GetVehicleColours(LsCustoms.Vehicle)
                                ClearVehicleCustomPrimaryColour(LsCustoms.Vehicle)
                                SetVehicleColours(LsCustoms.Vehicle, LsCustoms.DefaultPrimaireColour, secondaire)

                                local primaire, secondaire = GetVehicleColours(LsCustoms.Vehicle)
                                if LsCustoms.Prop.color1 == primaire then
                                    LsCustoms.PricePrimary = 0
                                else
                                    LsCustoms.PricePrimary = 150
                                end
                            end,
                        })
                        RageUI.List("Secondaire", LsCustoms.ColourPrimarySecondaryColourJantes, LsCustoms.DefaultSecondaireColour, nil, {}, true, {
                            onListChange = function(Index)
                                LsCustoms.DefaultSecondaireColour = Index

                               local primaire, secondaire = GetVehicleColours(LsCustoms.Vehicle)
                                ClearVehicleCustomSecondaryColour(LsCustoms.Vehicle)
                                SetVehicleColours(LsCustoms.Vehicle, primaire, LsCustoms.DefaultSecondaireColour)

                                local primaire, secondaire = GetVehicleColours(LsCustoms.Vehicle)
                                if LsCustoms.Prop.color2 == secondaire then
                                    LsCustoms.PriceSecondary = 0
                                else
                                    LsCustoms.PriceSecondary = 150
                                end
                            end,
                        })
                        RageUI.List("Intérieurs", LsCustoms.ColourIntDashNacrage, LsCustoms.DefaultInteriorColour, nil, {}, true, {
                            onListChange = function(Index)
                                LsCustoms.DefaultInteriorColour = Index

                                SetVehicleInteriorColour(LsCustoms.Vehicle, LsCustoms.DefaultInteriorColour)
                                
                                if LsCustoms.Prop.InteriorColor == GetVehicleInteriorColor(LsCustoms.Vehicle) then
                                    LsCustoms.PriceInterieurs = 0
                                else
                                    LsCustoms.PriceInterieurs = 150
                                end
                            end,
                        })
                        RageUI.List("Tableau de bord", LsCustoms.ColourIntDashNacrage, LsCustoms.DefaultDashboardColour, nil, {}, true, {
                            onListChange = function(Index)
                                LsCustoms.DefaultDashboardColour = Index

                                if GetFollowVehicleCamViewMode() ~= 4 then
                                    SetFollowVehicleCamViewMode(4)
                                end
                                SetVehicleDashboardColour(LsCustoms.Vehicle, LsCustoms.DefaultDashboardColour)

                                if LsCustoms.Prop.dashboardColour == GetVehicleDashboardColor(LsCustoms.Vehicle) then
                                    LsCustoms.PriceDashboard = 0
                                else
                                    LsCustoms.PriceDashboard = 75
                                end
                            end,
                        })
                        RageUI.List("Nacrage", LsCustoms.ColourIntDashNacrage, LsCustoms.DefaultNacrageColour, nil, {}, true, {
                            onListChange = function(Index)
                                LsCustoms.DefaultNacrageColour = Index

                                local _, nacrage = GetVehicleExtraColours(LsCustoms.Vehicle)
                                SetVehicleExtraColours(LsCustoms.Vehicle, LsCustoms.DefaultNacrageColour, nacrage)

                                local pearlescentColor, _ = GetVehicleExtraColours(LsCustoms.Vehicle)
                                if LsCustoms.Prop.pearlescentColor == pearlescentColor then
                                    LsCustoms.PriceNacrage = 0
                                else
                                    LsCustoms.PriceNacrage = 150
                                end
                            end,
                        })
                    end)
                    RageUI.IsVisible(LsCustoms.subMenuRoues, function()
                        RageUI.List("Type de roues", {"Sport", "Muscle", "Lowrider", "SUV", "Offroad", "Tuner", "Moto", "High end", "Bespokes Originals", "Bespokes Smokes"}, LsCustoms.DefaultTypeRouesColour, nil, {}, true, {
                            onListChange = function(Index)
                                LsCustoms.DefaultTypeRouesColour = Index
                                LsCustoms.DefaultJantesPrincipales = 1

                                SetVehicleWheelType(LsCustoms.Vehicle, LsCustoms.DefaultTypeRouesColour - 1)

                                LsCustoms.JantesLoadPrincipales = {}
                                LsCustoms.JantesLoadArrieres = {}
                                for i = 1, GetNumVehicleMods(LsCustoms.Vehicle, 23) + 1, 1 do
                                    table.insert(LsCustoms.JantesLoadPrincipales, i) 
                                end
                                LsCustoms.JantesPrincipales = LsCustoms.JantesLoadPrincipales
                            end,
                        })
                        RageUI.List("Jantes principales", LsCustoms.JantesPrincipales, LsCustoms.DefaultJantesPrincipales, nil, {}, true, {
                            onListChange = function(Index)
                                LsCustoms.DefaultJantesPrincipales = Index

                                SetVehicleMod(LsCustoms.Vehicle, 23, LsCustoms.DefaultJantesPrincipales - 2, GetVehicleModVariation(LsCustoms.Vehicle, 23))

                                if LsCustoms.Prop.modFrontWheels == GetVehicleMod(LsCustoms.Vehicle, 23) then
                                    LsCustoms.PriceJantesPrincipales = 0
                                else
                                    LsCustoms.PriceJantesPrincipales = 800
                                end
                            end,
                        })
                        RageUI.List("Couleurs des jantes", LsCustoms.ColourPrimarySecondaryColourJantes, LsCustoms.DefaultColourJantes, nil, {}, true, {
                            onListChange = function(Index)
                                LsCustoms.DefaultColourJantes = Index

                                local extraJantes = GetVehicleExtraColours(LsCustoms.Vehicle)
		                        SetVehicleExtraColours(LsCustoms.Vehicle, extraJantes, LsCustoms.DefaultColourJantes - 1)

                                local _, wheelColor = GetVehicleExtraColours(LsCustoms.Vehicle)

                                if LsCustoms.Prop.wheelColor == wheelColor then
                                    LsCustoms.PriceWheelColor = 0
                                else
                                    LsCustoms.PriceWheelColor = 200
                                end
                            end,
                        })
                    end)
                    RageUI.IsVisible(LsCustoms.subMenuClassiques, function()
                        RageUI.List("Klaxon", LsCustoms.MaxKlaxon, LsCustoms.DefaultKlaxon, nil, {}, true, {
                            onListChange = function(Index)
                                LsCustoms.DefaultKlaxon = Index

                                SetVehicleMod(LsCustoms.Vehicle, 14, LsCustoms.DefaultKlaxon - 2, false)

                                if LsCustoms.Prop.modHorns == GetVehicleMod(LsCustoms.Vehicle, 14) then
                                    LsCustoms.PriceKlaxon = 0
                                else
                                    LsCustoms.PriceKlaxon = 130
                                end
                            end,
                        })
                        RageUI.List("Teinte des vitres", {"Normal", "Black", "Smoke Black", "Simple Smoke", "Stock", "Limo"}, LsCustoms.DefaultTeinteVitres, nil, {}, true, {
                            onListChange = function(Index)
                                LsCustoms.DefaultTeinteVitres = Index
           
                                SetVehicleWindowTint(LsCustoms.Vehicle, LsCustoms.DefaultTeinteVitres - 1)

                                if LsCustoms.Prop.windowTint + 1 == GetVehicleWindowTint(LsCustoms.Vehicle) then
                                    LsCustoms.PriceKlaxon = 0
                                else
                                    LsCustoms.PriceKlaxon = 330
                                end
                            end,
                        })
                        RageUI.Checkbox("Phares xenons", false, LsCustoms.DefaultPharesXenons, {}, {
                            onChecked = function()
                                ToggleVehicleMod(LsCustoms.Vehicle, 22, true)
                                LsCustoms.PricePharesXenons = 530
                            end,
                            onUnChecked = function()
                                ToggleVehicleMod(LsCustoms.Vehicle, 22, false)
                                LsCustoms.PricePharesXenons = 0
                            end,

                            onSelected = function(Index)
                                LsCustoms.DefaultPharesXenons = Index
                            end
                        })
                        RageUI.List("Types de plaques", {"Default", "Sa Black", "Sa Blue", "Sa White", "Simple White", "NY White"}, LsCustoms.DefaultTypesPlaques, nil, {}, true, {
                            onListChange = function(Index)
                                LsCustoms.DefaultTypesPlaques = Index

                                SetVehicleNumberPlateTextIndex(LsCustoms.Vehicle, LsCustoms.DefaultTypesPlaques - 1)

                                if LsCustoms.Prop.plateIndex == GetVehicleNumberPlateTextIndex(LsCustoms.Vehicle) then
                                    LsCustoms.PricePlateIndex = 0
                                else
                                    LsCustoms.PricePlateIndex = 130
                                end
                            end,
                        })
                        if json.encode(LsCustoms.MaxLivery) ~= "[]" then
                            RageUI.List("Livery", LsCustoms.MaxLivery, LsCustoms.DefaultLivery, nil, {}, true, {
                                onListChange = function(Index)
                                    LsCustoms.DefaultLivery = Index
            
                                    SetVehicleLivery(LsCustoms.Vehicle, LsCustoms.DefaultLivery - 2)

                                    if LsCustoms.Prop.modLivery == LsCustoms.DefaultLivery - 2 then
                                        LsCustoms.PriceLivery = 0
                                    else
                                        LsCustoms.PriceLivery = 150
                                    end
                                end,
                            })
                        else
                            RageUI.Button("Livery", nil, {}, false, {})
                        end
                        if IsToggleModOn(LsCustoms.Vehicle, 22) then
                            RageUI.List("Couleur des phares", LsCustoms.CoulorPhares, LsCustoms.DefaultColourPhares, nil, {}, true, {
                                onListChange = function(Index)
                                    LsCustoms.DefaultColourPhares = Index

                                    SetVehicleXenonLightsColour(LsCustoms.Vehicle, LsCustoms.DefaultColourPhares - 1)

                                    if LsCustoms.DefaultColourPhares - 1 == 0 then
                                        LsCustoms.PriceColorPhares = 0
                                    else
                                        LsCustoms.PriceColorPhares = 550
                                    end
                                end,
                            })
                        else
                            RageUI.Button("Couleur des phares", nil, {}, false, {})
                        end
                    end)

                    RageUI.IsVisible(LsCustoms.subMenuCustoms, function()
                        if GetNumVehicleMods(LsCustoms.Vehicle, 0) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 0)) then
                                RageUI.List("Aileron", GetModObjects(LsCustoms.Vehicle, 0), LsCustoms.DefaultAileron, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultAileron = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 0, LsCustoms.DefaultAileron - 2, false)

                                        if LsCustoms.Prop.modSpoilers == GetVehicleMod(LsCustoms.Vehicle, 0) then
                                            LsCustoms.PriceAileron = 0
                                        else
                                            LsCustoms.PriceAileron = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 1) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 1)) then
                                RageUI.List("Pare-choc avant", GetModObjects(LsCustoms.Vehicle, 1), LsCustoms.DefaultParechocAvant, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultParechocAvant = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 1, LsCustoms.DefaultParechocAvant - 2, false)

                                        if LsCustoms.Prop.modFrontBumper == GetVehicleMod(LsCustoms.Vehicle, 1) then
                                            LsCustoms.PriceParechocAvant = 0
                                        else
                                            LsCustoms.PriceParechocAvant = 450
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 2) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 2)) then
                                RageUI.List("Pare-choc arrière", GetModObjects(LsCustoms.Vehicle, 2), LsCustoms.DefaultParechocArriere, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultParechocArriere = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 2, LsCustoms.DefaultParechocArriere - 2, false)

                                        if LsCustoms.Prop.modRearBumper == GetVehicleMod(LsCustoms.Vehicle, 2) then
                                            LsCustoms.PriceParechocArriere = 0
                                        else
                                            LsCustoms.PriceParechocArriere = 450
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 3) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 3)) then
                                RageUI.List("Carrosserie", GetModObjects(LsCustoms.Vehicle, 3), LsCustoms.DefaultCarrosserie, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultCarrosserie = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 3, LsCustoms.DefaultCarrosserie - 2, false)

                                        if LsCustoms.Prop.modSideSkirt == GetVehicleMod(LsCustoms.Vehicle, 3) then
                                            LsCustoms.PriceCarrosserie = 0
                                        else
                                            LsCustoms.PriceCarrosserie = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 4) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 4)) then
                                RageUI.List("Echappement", GetModObjects(LsCustoms.Vehicle, 4), LsCustoms.DefaultEchappement, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultEchappement = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 4, LsCustoms.DefaultEchappement - 2, false)

                                        if LsCustoms.Prop.modExhaust == GetVehicleMod(LsCustoms.Vehicle, 4) then
                                            LsCustoms.PriceEchappement = 0
                                        else
                                            LsCustoms.PriceEchappement = 600
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 5) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 5)) then
                                RageUI.List("Cadre", GetModObjects(LsCustoms.Vehicle, 5), LsCustoms.DefaultCadre, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultCadre = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 5, LsCustoms.DefaultCadre - 2, false)

                                        if LsCustoms.Prop.modFrame == GetVehicleMod(LsCustoms.Vehicle, 5) then
                                            LsCustoms.PriceCadre = 0
                                        else
                                            LsCustoms.PriceCadre = 600
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 6) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 6)) then
                                RageUI.List("Calandre", GetModObjects(LsCustoms.Vehicle, 6), LsCustoms.DefaultCalandre, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultCalandre = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 6, LsCustoms.DefaultCalandre - 2, false)

                                        if LsCustoms.Prop.modGrille == GetVehicleMod(LsCustoms.Vehicle, 6) then
                                            LsCustoms.PriceCalandre = 0
                                        else
                                            LsCustoms.PriceCalandre = 450
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 7) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 7)) then
                                RageUI.List("Capot", GetModObjects(LsCustoms.Vehicle, 7), LsCustoms.DefaultCapot, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultCapot = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 7, LsCustoms.DefaultCapot - 2, false)

                                        if LsCustoms.Prop.modHood == GetVehicleMod(LsCustoms.Vehicle, 7) then
                                            LsCustoms.PriceCapot = 0
                                        else
                                            LsCustoms.PriceCapot = 600
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 8) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 8)) then
                                RageUI.List("Autocollant gauche", GetModObjects(LsCustoms.Vehicle, 8), LsCustoms.DefaultAutocollantGauche, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultAutocollantGauche = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 8, LsCustoms.DefaultAutocollantGauche - 2, false)

                                        if LsCustoms.Prop.modFender == GetVehicleMod(LsCustoms.Vehicle, 8) then
                                            LsCustoms.PriceAutocollantGauche = 0
                                        else
                                            LsCustoms.PriceAutocollantGauche = 350
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 9) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 9)) then
                                RageUI.List("Autocollant droit", GetModObjects(LsCustoms.Vehicle, 9), LsCustoms.DefaultAutocollantDroit, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultAutocollantDroit = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 9, LsCustoms.DefaultAutocollantDroit - 2, false)

                                        if LsCustoms.Prop.modRightFender == GetVehicleMod(LsCustoms.Vehicle, 9) then
                                            LsCustoms.PriceAutocollantDroit = 0
                                        else
                                            LsCustoms.PriceAutocollantDroit = 350
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 10) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 10)) then
                                RageUI.List("Toit", GetModObjects(LsCustoms.Vehicle, 10), LsCustoms.DefaultToit, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultToit = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 10, LsCustoms.DefaultToit - 2, false)

                                        if LsCustoms.Prop.modRightFender == GetVehicleMod(LsCustoms.Vehicle, 10) then
                                            LsCustoms.PriceToit = 0
                                        else
                                            LsCustoms.PriceToit = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 25) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 25)) then
                                RageUI.List("Support de plaque", GetModObjects(LsCustoms.Vehicle, 25), LsCustoms.DefaultSupportPlaque, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultSupportPlaque = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 25, LsCustoms.DefaultSupportPlaque - 2, false)

                                        if LsCustoms.Prop.modPlateHolder == GetVehicleMod(LsCustoms.Vehicle, 25) then
                                            LsCustoms.PriceSupportPlaque = 0
                                        else
                                            LsCustoms.PriceSupportPlaque = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 26) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 26)) then
                                RageUI.List("Plaque avant", GetModObjects(LsCustoms.Vehicle, 26), LsCustoms.DefaultPlaqueAvant, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultPlaqueAvant = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 26, LsCustoms.DefaultPlaqueAvant - 2, false)

                                        if LsCustoms.Prop.modVanityPlate == GetVehicleMod(LsCustoms.Vehicle, 26) then
                                            LsCustoms.PricePlaqueAvant = 0
                                        else
                                            LsCustoms.PricePlaqueAvant = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 28) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 28)) then
                                RageUI.List("Figurine", GetModObjects(LsCustoms.Vehicle, 28), LsCustoms.DefaultFigurine, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultFigurine = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 28, LsCustoms.DefaultFigurine - 2, false)

                                        if LsCustoms.Prop.modOrnaments == GetVehicleMod(LsCustoms.Vehicle, 28) then
                                            LsCustoms.PriceFigurine = 0
                                        else
                                            LsCustoms.PriceFigurine = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 29) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 29)) then
                                RageUI.List("Tableau de bord motif", GetModObjects(LsCustoms.Vehicle, 29), LsCustoms.DefaultDashboardMotif, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultDashboardMotif = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 29, LsCustoms.DefaultDashboardMotif - 2, false)

                                        if LsCustoms.Prop.modDashboard == GetVehicleMod(LsCustoms.Vehicle, 29) then
                                            LsCustoms.PriceDashboardMotif = 0
                                        else
                                            LsCustoms.PriceDashboardMotif = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 30) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 30)) then
                                RageUI.List("Cadran", GetModObjects(LsCustoms.Vehicle, 30), LsCustoms.DefaultCadran, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultCadran = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 30, LsCustoms.DefaultCadran - 2, false)

                                        if LsCustoms.Prop.modDial == GetVehicleMod(LsCustoms.Vehicle, 30) then
                                            LsCustoms.PriceCadran = 0
                                        else
                                            LsCustoms.PriceCadran = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 31) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 31)) then
                                RageUI.List("Haut parleur portes", GetModObjects(LsCustoms.Vehicle, 31), LsCustoms.DefaultHautParleurPortes, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultHautParleurPortes = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 31, LsCustoms.DefaultHautParleurPortes - 2, false)

                                        if LsCustoms.Prop.modDoorSpeaker == GetVehicleMod(LsCustoms.Vehicle, 31) then
                                            LsCustoms.PriceHautParleurPortes = 0
                                        else
                                            LsCustoms.PriceHautParleurPortes = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 32) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 32)) then
                                RageUI.List("Motif sieges", GetModObjects(LsCustoms.Vehicle, 32), LsCustoms.DefaultMotifSieges, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultMotifSieges = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 32, LsCustoms.DefaultMotifSieges - 2, false)

                                        if LsCustoms.Prop.modSeats == GetVehicleMod(LsCustoms.Vehicle, 32) then
                                            LsCustoms.PriceMotifSieges = 0
                                        else
                                            LsCustoms.PriceMotifSieges = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 33) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 33)) then
                                RageUI.List("Volant", GetModObjects(LsCustoms.Vehicle, 33), LsCustoms.DefaultVolant, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultVolant = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 33, LsCustoms.DefaultVolant - 2, false)

                                        if LsCustoms.Prop.modSteeringWheel == GetVehicleMod(LsCustoms.Vehicle, 33) then
                                            LsCustoms.PriceVolant = 0
                                        else
                                            LsCustoms.PriceVolant = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 34) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 34)) then
                                RageUI.List("Levier", GetModObjects(LsCustoms.Vehicle, 34), LsCustoms.DefaultLevier, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultLevier = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 34, LsCustoms.DefaultLevier - 2, false)

                                        if LsCustoms.Prop.modShifterLeavers == GetVehicleMod(LsCustoms.Vehicle, 34) then
                                            LsCustoms.PriceLevier = 0
                                        else
                                            LsCustoms.PriceLevier = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 35) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 35)) then
                                RageUI.List("Logo custom", GetModObjects(LsCustoms.Vehicle, 35), LsCustoms.DefaultLogoCustom, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultLogoCustom = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 35, LsCustoms.DefaultLogoCustom - 2, false)

                                        if LsCustoms.Prop.modAPlate == GetVehicleMod(LsCustoms.Vehicle, 35) then
                                            LsCustoms.PriceLogo = 0
                                        else
                                            LsCustoms.PriceLogo = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 36) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 36)) then
                                RageUI.List("Haut parleur vitre", GetModObjects(LsCustoms.Vehicle, 36), LsCustoms.DefaultHautParleurVitre, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultHautParleurVitre = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 36, LsCustoms.DefaultHautParleurVitre - 2, false)

                                        if LsCustoms.Prop.modSpeakers == GetVehicleMod(LsCustoms.Vehicle, 36) then
                                            LsCustoms.PriceHautParleurVitre = 0
                                        else
                                            LsCustoms.PriceHautParleurVitre = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 37) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 37)) then
                                RageUI.List("Haut parleur coffre", GetModObjects(LsCustoms.Vehicle, 37), LsCustoms.DefaultHautParleurCoffre, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultHautParleurCoffre = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 37, LsCustoms.DefaultHautParleurCoffre - 2, false)

                                        if LsCustoms.Prop.modTrunk == GetVehicleMod(LsCustoms.Vehicle, 37) then
                                            LsCustoms.PriceHautParleurCoffre = 0
                                        else
                                            LsCustoms.PriceHautParleurCoffre = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 38) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 38)) then
                                RageUI.List("Hydrolique", GetModObjects(LsCustoms.Vehicle, 38), LsCustoms.DefaultHydrolique, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultHydrolique = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 38, LsCustoms.DefaultHydrolique - 2, false)

                                        if LsCustoms.Prop.modHydrolic == GetVehicleMod(LsCustoms.Vehicle, 38) then
                                            LsCustoms.PriceHydrolique = 0
                                        else
                                            LsCustoms.PriceHydrolique = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 39) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 39)) then
                                RageUI.List("Moteur", GetModObjects(LsCustoms.Vehicle, 39), LsCustoms.DefaultVisualMoteur, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultVisualMoteur = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 39, LsCustoms.DefaultVisualMoteur - 2, false)

                                        if LsCustoms.Prop.modEngineBlock == GetVehicleMod(LsCustoms.Vehicle, 39) then
                                            LsCustoms.PriceVisualMoteur = 0
                                        else
                                            LsCustoms.PriceVisualMoteur = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 40) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 40)) then
                                RageUI.List("Filtres à air", GetModObjects(LsCustoms.Vehicle, 40), LsCustoms.DefaultFiltresAir, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultFiltresAir = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 40, LsCustoms.DefaultFiltresAir - 2, false)

                                        if LsCustoms.Prop.modAirFilter == GetVehicleMod(LsCustoms.Vehicle, 40) then
                                            LsCustoms.PriceFiltresAir = 0
                                        else
                                            LsCustoms.PriceFiltresAir = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 41) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 41)) then
                                RageUI.List("Entretoises", GetModObjects(LsCustoms.Vehicle, 41), LsCustoms.DefaultEntretoises, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultEntretoises = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 41, LsCustoms.DefaultEntretoises - 2, false)

                                        if LsCustoms.Prop.modStruts == GetVehicleMod(LsCustoms.Vehicle, 41) then
                                            LsCustoms.PriceEntretoises = 0
                                        else
                                            LsCustoms.PriceEntretoises = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 42) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 42)) then
                                RageUI.List("Couverture", GetModObjects(LsCustoms.Vehicle, 42), LsCustoms.DefaultCouverture, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultCouverture = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 42, LsCustoms.DefaultCouverture - 2, false)

                                        if LsCustoms.Prop.modArchCover == GetVehicleMod(LsCustoms.Vehicle, 42) then
                                            LsCustoms.PriceCouverture = 0
                                        else
                                            LsCustoms.PriceCouverture = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 43) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 43)) then
                                RageUI.List("Antenne", GetModObjects(LsCustoms.Vehicle, 43), LsCustoms.DefaultAntenne, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultAntenne = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 43, LsCustoms.DefaultAntenne - 2, false)

                                        if LsCustoms.Prop.modAerials == GetVehicleMod(LsCustoms.Vehicle, 43) then
                                            LsCustoms.PriceAntenne = 0
                                        else
                                            LsCustoms.PriceAntenne = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 45) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 45)) then
                                RageUI.List("Reservoir", GetModObjects(LsCustoms.Vehicle, 45), LsCustoms.DefaultReservoir, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultReservoir = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 45, LsCustoms.DefaultReservoir - 2, false)

                                        if LsCustoms.Prop.modTank == GetVehicleMod(LsCustoms.Vehicle, 45) then
                                            LsCustoms.PriceReservoir = 0
                                        else
                                            LsCustoms.PriceReservoir = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 46) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 46)) then
                                RageUI.List("Fenêtre", GetModObjects(LsCustoms.Vehicle, 46), LsCustoms.DefaultFenetre, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultFenetre = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 46, LsCustoms.DefaultFenetre - 2, false)

                                        if LsCustoms.Prop.modWindows == GetVehicleMod(LsCustoms.Vehicle, 46) then
                                            LsCustoms.PriceFenetre = 0
                                        else
                                            LsCustoms.PriceFenetre = 400
                                        end
                                    end,
                                })
                            end
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 48) > 0 then
                            if not GetMitrailVeh(GetModObjects(LsCustoms.Vehicle, 48)) then
                                RageUI.List("Stickers", GetModObjects(LsCustoms.Vehicle, 48), LsCustoms.DefaultStyle, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.DefaultStyle = Index

                                        SetVehicleMod(LsCustoms.Vehicle, 48, LsCustoms.DefaultStyle - 2, false)

                                        if LsCustoms.Prop.modLivery == GetVehicleMod(LsCustoms.Vehicle, 48) then
                                            LsCustoms.PriceStyle = 0
                                        else
                                            LsCustoms.PriceStyle = 400
                                        end
                                    end,
                                })
                            end
                        end
                    end)
                    RageUI.IsVisible(LsCustoms.subMenuPerf, function()
                        if GetNumVehicleMods(LsCustoms.Vehicle, 15) > 0 then
                            RageUI.List("Suspension", {"Stock", "Discount", "Street", "Sport", "Race"}, LsCustoms.DefaultSuspension, nil, {}, true, {
                                onListChange = function(Index)
                                    LsCustoms.DefaultSuspension = Index

                                    SetVehicleMod(LsCustoms.Vehicle, 15, LsCustoms.DefaultSuspension - 2)

                                    if LsCustoms.Prop.modSuspension == GetVehicleMod(LsCustoms.Vehicle, 15) then
                                        LsCustoms.PriceSuspension = 0
                                    else
                                        LsCustoms.PriceSuspension = 2000
                                    end
                                end,
                            })
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 13) > 0 then
                            RageUI.List("Transmission", {"Stock","Street", "Sport", "Race"}, LsCustoms.DefaultTransmission, nil, {}, true, {
                                onListChange = function(Index)
                                    LsCustoms.DefaultTransmission = Index

                                    SetVehicleMod(LsCustoms.Vehicle, 13, LsCustoms.DefaultTransmission - 2)

                                    if LsCustoms.Prop.modTransmission == GetVehicleMod(LsCustoms.Vehicle, 13) then
                                        LsCustoms.PriceTransmission = 0
                                    else
                                        LsCustoms.PriceTransmission = 2000
                                    end
                                end,
                            })
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 11) > 0 then
                            RageUI.List("Moteur", {"Stock", "Discount", "Street", "Sport", "Race"}, LsCustoms.DefaultMoteur, nil, {}, true, {
                                onListChange = function(Index)
                                    LsCustoms.DefaultMoteur = Index

                                    SetVehicleMod(LsCustoms.Vehicle, 11, LsCustoms.DefaultMoteur - 2)

                                    if LsCustoms.Prop.modEngine == GetVehicleMod(LsCustoms.Vehicle, 11) then
                                        LsCustoms.PriceMoteur = 0
                                    else
                                        LsCustoms.PriceMoteur = 12000
                                    end
                                end,
                            })
                        end
                        if GetNumVehicleMods(LsCustoms.Vehicle, 12) > 0 then
                            RageUI.List("Frein", {"Stock", "Street", "Sport", "Race"}, LsCustoms.DefaultFrein, nil, {}, true, {
                                onListChange = function(Index)
                                    LsCustoms.DefaultFrein = Index

                                    SetVehicleMod(LsCustoms.Vehicle, 12, LsCustoms.DefaultFrein - 2)

                                    if LsCustoms.Prop.modBrakes == GetVehicleMod(LsCustoms.Vehicle, 12) then
                                        LsCustoms.PriceFrein = 0
                                    else
                                        LsCustoms.PriceFrein = 4000
                                    end
                                end,
                            })
                        end
                        RageUI.Checkbox("Turbo", false, LsCustoms.DefaultTurbo, {}, {
                            onChecked = function()
                                ToggleVehicleMod(LsCustoms.Vehicle, 18, true)
                                LsCustoms.PriceTurbo = 14000
                            end,
                            onUnChecked = function()
                                ToggleVehicleMod(LsCustoms.Vehicle, 18, false)
                                LsCustoms.PriceTurbo = 0
                            end,
                            onSelected = function(Index)
                                LsCustoms.DefaultTurbo = Index
                            end
                        })
                    end)
                    RageUI.IsVisible(LsCustoms.subMenuExtra, function()
                        for i = 1, #LsCustoms.ExtraList, 1 do
                    		if DoesExtraExist(LsCustoms.Vehicle, LsCustoms.ExtraList[i].id) then
                                if IsVehicleExtraTurnedOn(LsCustoms.Vehicle, i) then
                                    LsCustoms.ExtraList[i].index = 2
                                else
                                    LsCustoms.ExtraList[i].index = 1
                                end
                                RageUI.List("Extra #"..i, {"Inactif", "Actif"}, LsCustoms.ExtraList[i].index, nil, {}, true, {
                                    onListChange = function(Index)
                                        LsCustoms.ExtraList[i].index = Index
        
                                        if IsVehicleExtraTurnedOn(LsCustoms.Vehicle, i) then
                                            SetVehicleExtra(LsCustoms.Vehicle, LsCustoms.ExtraList[i].id, 1)
                                            LsCustoms.PriceExtra = 220
                                        else
                                            SetVehicleExtra(LsCustoms.Vehicle, LsCustoms.ExtraList[i].id, 0)
                                            LsCustoms.PriceExtra = 0
                                        end
                                    end,
                                })
                            end
                    	end
                    end)
                Wait(1)
            end
        end)
    end
end

RegisterNetEvent('CancelLsCustoms')
AddEventHandler('CancelLsCustoms', function()
	ESX.ShowNotification("La ~r~commande~s~ a été ~r~refusé~s~ car l'entreprise n'a plus assez de ~r~fonds nécessaires~s~.")
	SetVehicleProperties(LsCustoms.Vehicle, LsCustoms.Prop)
end)

Citizen.CreateThread(function()
    while true do 
        local wait = 1000
        local pPed = PlayerPedId()
        local pPos = GetEntityCoords(pPed)

        if IsPedInAnyVehicle(pPed, false) and (GetPedInVehicleSeat(GetVehiclePedIsIn(pPed, false), -1) == pPed) then 
            for k,v in pairs(LsCustoms.Pos) do 
                local dist = Vdist(pPos, v.pos)
                if ESX.PlayerData.job.name and ESX.PlayerData.job.name == v.job then 
                    if dist <= v.size then 
                        wait = 5
                        DisplayNotification(v.notif)
                        if IsControlJustPressed(0, 51) then 
                            MenuCustomization()
                        end
					elseif dist >= v.size then 
						if LsCustoms.openedMenu then 
                            LsCustoms.openedMenu = false
                            RageUI.CloseAll()
                            SetVehicleProperties(LsCustoms.Vehicle, LsCustoms.Prop)
                            ResetAll()
                            wait = 1000
						end
                    end
                end
            end
        else
            if LsCustoms.openedMenu then 
                LsCustoms.openedMenu = false
                RageUI.CloseAll()
                SetVehicleProperties(LsCustoms.Vehicle, LsCustoms.Prop)
                ResetAll()
                wait = 1000
			end
        end
        Wait(wait)
    end
end)