ESX = nil

local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  BlipsJobs()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
  BlipsJobs()
end)

local blips = {
    {title = "LTD - Nord", scale = 0.7, colour=1, id=52, x = 1697.92, y = 4924.46, z = 41.09},
    {title = "LTD - Sud", scale = 0.7, colour=1, id=52, x = -707.31, y = -914.66, z = 18.24},
    {title = "LTD - Groove Street", scale = 0.7, colour=1, id=52, x = -47.187, y = -1750.61,   z = 33.97},
    {title = "LTD - Forum Drive", scale = 0.7, colour=1, id=52, x = 25.73, y = -1347.27, z = 28.516},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = -1222.26, y = -906.86, z = 11.40},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = -1487.62,  y = -378.60, z = 39.20},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = 1135.7, y = -982.79, z = 45.46},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = 373.55, y = 325.52, z = 102.60},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = 1163.67, y = -323.92, z = 68.26},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = 2557.44, y = 382.03, z = 107.65},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = -3039.16, y = 585.71, z = 6.95},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = -3242.11, y = 1001.20, z = 11.86},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = -2967.78, y = 391.49, z = 14.06},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = -1820.38, y = 792.69, z = 137.16},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = 547.75, y = 2671.53, z = 41.20},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = 1165.36, y = 2709.45, z = 37.20},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = 2678.82, y = 3280.36, z = 54.27},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = 1961.17, y = 3740.5, z = 31.38},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = 1393.13, y = 3605.2, z = 33.99},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = 1728.78, y = 6414.41, z = 34.06},
    {title = "Magasin Alimentaire", scale = 0.7, colour=43, id=628, x = -2065.37, y = -329.56, z = 17.67},
    {title = "Ammu-nation", scale = 0.7, colour=1, id=313, x = 20.22, y = -1112.08, z = 42.37},
    {title = "Ammu-nation", scale = 0.7, colour=1, id=313, x = -663.33, y = -946.43, z = 21.83},
    {title = "Ammu-nation", scale = 0.7, colour=1, id=313, x = -331.86, y = 6084.98, z = 30.45}, 
    {title = "Ammu-nation", scale = 0.7, colour=1, id=313, x = 253.92, y = -50.43, z = 68.94}, 
    {title = "Ammu-nation", scale = 0.7, colour=1, id=313, x = 842.51, y = -1035.33, z = 27.19},
    {title = "Ammu-nation", scale = 0.7, colour=1, id=313, x = 810.05, y = -2159.21, z = 28.62},
    {title = "Ammu-nation", scale = 0.7, colour=1, id=313, x = -1119.06, y = 2699.75, z = 17.55},
    {title = "Ammu-nation", scale = 0.7, colour=1, id=313, x = 2567.92, y = 292.51, z = 107.73},
    {title = "Ammu-nation", scale = 0.7, colour=1, id=313, x = 1692.04, y = 3760.88, z = 33.71},
    {title = "Ammu-nation", scale = 0.7, colour=1, id=313, x = -1305.40, y = -394.12, z = 36.69},
    {title = "Magasins de Vêtements", scale = 0.7, colour=81, id=73, x = -1193.16, y = -767.98, z = 16.35},
    {title = "Magasins de Vêtements", scale = 0.7, colour=81, id= 73, x = -822.42, y = -1073.55, z = 10.35},
    {title = "Magasins de Vêtements", scale = 0.7, colour=81, id= 73, x = 75.34, y = -1393.00, z = 28.40},
    {title = "Magasins de Vêtements", scale = 0.7, colour=81, id= 73, x = -709.86, y = -153.1, z = 36.46},
    {title = "Magasins de Vêtements", scale = 0.7, colour=81, id= 73, x = -163.37, y = -302.73, z = 38.76},
    {title = "Magasins de Vêtements", scale = 0.7, colour=81, id= 73, x = 425.59, y = -806.15, z = 28.52},
    {title = "Magasins de Vêtements", scale = 0.7, colour=81, id= 73, x = -1450.42, y = -237.66, z = 48.85},
    {title = "Magasins de Vêtements", scale = 0.7, colour=81, id= 73, x = 4.87, y = 6512.46, z = 30.91},
    {title = "Magasins de Vêtements", scale = 0.7, colour=81, id= 73, x = 125.77, y = -223.9, z = 53.60},
    {title = "Magasins de Vêtements", scale = 0.7, colour=81, id= 73, x = 1693.92, y = 4822.82, z = 41.10},
    {title = "Magasins de Vêtements", scale = 0.7, colour=81, id= 73, x = 614.19, y = 2762.79, z = 41.12},
    {title = "Magasins de Vêtements", scale = 0.7, colour=81, id= 73, x = 1196.61, y = 2710.25, z = 37.26},
    {title = "Magasins de Vêtements", scale = 0.7, colour=81, id= 73, x = -3170.54, y = 1043.68, z = 19.90},
    {title = "Magasins de Vêtements", scale = 0.7, colour=81, id= 73, x = -1101.48, y = 2710.57, z = 18.16}, 
    {title = "Salon de tatouage", scale = 0.8, colour = 1, id = 75, x = 1322.92, y = -1652.12, z = 51.29},
    {title = "Salon de tatouage", scale = 0.8, colour = 1, id = 75, x = -1153.97, y = -1425.57, z = 3.96},
    {title = "Salon de tatouage", scale = 0.8, colour = 1, id = 75, x = 322.02, y = 180.58, z = 102.60},
    {title = "Salon de tatouage", scale = 0.8, colour = 1, id = 75, x = 1863.96, y = 3747.84, z = 32.04},
    {title = "Zone de Marécage", scale = 0.7, colour = 47, id = 143, x = -2115.37, y = 2614.36, z = 0.97},
    {title = "Auto Ecole", scale = 0.8, colour = 0, id = 326, x = 233.22, y = 368.62, z = 106.13},
    {title = "Magasin de masques", scale = 0.7, colour = 5, id = 362, x = -1337.25, y = -1277.54, z = 3.88},
    {title = "Pacific Standard Bank", scale = 1.2, colour = 2, id = 277, x = 243.17, y = 224.69, z = 106.28},
    {title = "Los Santos Police Department", scale = 0.7, colour = 3, id = 60, x = -1089.172, y = -819.009, z = 19.83},
    {title = "Blaine County Sheriff Office", scale = 0.7, colour = 3, id = 60, x = -446.16, y = 6015.37, z = 31.71},
    {title = "Pawn Shop - Jewerly LOANS", scale = 0.7, colour = 5, id = 617, x = -1459.42, y = -413.60, z = 106.28},
    {title = "Pawn Shop - Route 68", scale = 0.7, colour = 5, id = 617, x = 1224.75, y = 2727.38, z = 38.00},
    {title = "Conforama", scale = 0.8, colour = 47, id = 478, x = 58.92, y = -1733.58, z = 106.28},
    {title = "Vente de poisson(s)", scale = 0.7, colour = 1, id = 270, x = 1465.55, y = 6548.10, z = 14.0},
    {title = "Concessionnaire", scale = 0.8, colour = 4, id = 523, x = -786.48, y = -229.71, z = 37.07},
    {title = "Hopital", scale = 0.7, colour = 1, id = 61, x = 313.13, y = -590.53, z = 44.86},
    {title = "Mayans Motors", scale = 0.7, colour = 47, id = 446, x = 115.01, y = 277.52, z = 109.0},
    {title = "Benny's", scale = 0.7, colour = 47, id = 446, x = -212.11, y = -1323.61, z = 30.89},
    {title = "Grim Motors", scale = 0.7, colour = 47, id = 446, x = 42.02, y = 6458.47, z = 31.42},
    {title = "Forum Drive Motors", scale = 0.7, colour = 47, id = 446, x = -3.35, y = -1398.84, z = 28.29},
    {title = "William", scale = 0.8, colour = 5, id = 480, x = 482.81, y = -1324.42, z = 29.20},
    {title = "Dylan", scale = 0.8, colour = 5, id = 480, x = 1723.26, y = 4735.15, z = 42.13},
    {title = "Marchand de vélo(s)", scale = 0.8, colour = 0, id = 792, x = -828.72, y = -1085.63, z = 10.13},
    {title = "Harmony Repair", scale = 0.7, colour = 47, id = 446, x = 1185.08, y = 2649.92, z = 43.34},
    {title = "Récolte de Raisin", scale = 0.6, colour = 50, id = 143, x = -1867.461, y = 2235.968, z = 87.566},
    {title = "Traitement de Raisin", scale = 0.6, colour = 50, id = 143, x = 612.97, y = 2794.14, z = 42.07},
    {title = "Vente de Raisin", scale = 0.6, colour = 50, id = 143, x = 2547.82, y = 342.42, z = 108.46},
    {title = "Récolte de planche(s)", scale = 0.6, colour = 3, id = 143, x = 1202.51, y = -1319.24, z = 106.28},
    {title = "Traitement de planche(s)", scale = 0.6, colour = 3, id = 143, x = -108.61, y = -1060.16, z = 106.28},
    {title = "Vente de meuble(s)", scale = 0.6, colour = 3, id = 143, x = 1183.48, y = -3304.06, z = 6.91},
    {title = "Pharmacie", scale = 0.7, colour = 2, id = 51, x = 96.19, y = -228.44, z = 6.91},
    {title = "Motor's & co", scale = 0.7, colour = 26, id = 566, x = 2042.49, y = 3174.818, z = 45.01},
    {title = "Vanilla Unicorn", scale = 0.7, colour = 27, id = 121, x = 129.246, y = -1299.363, z = 29.501},
    {title = "Bahama Mamas", scale = 0.7, colour = 27, id = 93, x = -1388.44, y = -586.74, z = 30.21},
    {title = "The Palace", scale = 0.7, colour = 27, id = 93, x = -314.20, y = -1036.14, z = 36.35},
    {title = "Gouvernement", scale = 0.8, colour = 0, id = 419, x = -538.18, y = -215.02, z = 37.64},
    {title = "Centre des Métier", scale = 0.7, colour = 0, id = 590, x = -867.63, y = -1274.91, z = 4.15},
    {title = "Wu-Chang Studio", scale = 0.8, colour = 49, id = 136, x = -828.22, y = -698.32, z = 28.05},
    {title = "Weazel News", scale = 0.8, colour = 0, id = 135, x = -600.53, y = -929.69, z = 23.86},
    {title = "Cayo Repair", scale = 0.7, colour = 47, id = 446, x = 4958.81, y = -5102.60, z = 10.06},
    {title = "Bowling", scale = 0.7, colour = 1, id = 103, x = -141.83, y = -252.71, z = 44.0},
    {title = "Los Santos Customs", scale = 0.7, colour = 47, id = 446, x = -358.28, y = -109.14, z = 37.69},
    {title = "Sandy Benny's", scale = 0.7, colour = 47, id = 446, x = 1984.24, y = 3786.28, z = 31.18},
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
        info.blip2 = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip2, info.id)
        SetBlipDisplay(info.blip2, 4)
        SetBlipScale(info.blip2, info.scale)
        SetBlipColour(info.blip2, info.colour)
        SetBlipAsShortRange(info.blip2, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip2)
    end
end)

local blipsJobs = {
    {job = "pawnshop", name = "Pawn Shop - Vente d'objets", scale = 0.7, couleur = 5, id = 478, coords = vector3(1154.12, -386.01, 67.33)},
    {job = "pawnnord", name = "Pawn Shop - Vente d'objets", scale = 0.7, couleur = 5, id = 478, coords = vector3(-1128.95, 2692.57, 18.80)},
    {job = "motors&co", name = "Récolte Fer", scale = 0.7, colour = 26, id = 143, coords = vector3(2052.66, 3192.07, 45.18)},
    {job = "motors&co", name = "Traitement Fer", scale = 0.7, colour = 26, id = 143, coords = vector3(135.40, -375.03, 43.25)},
    {job = "motors&co", name = "Troc Motor's & co", scale = 0.7, colour = 26, id = 143, coords = vector3(-1371.07, -460.3302, 34.47)},
}

function BlipsJobs()
    for _, v in pairs(blipsJobs) do
        if not DoesBlipExist(v.blipsJob) then
            if PlayerData.job.name == v.job then
                v.blipsJob = AddBlipForCoord(v.coords)
                SetBlipSprite(v.blipsJob, v.id)
                SetBlipDisplay(v.blipsJob, 4)
                SetBlipScale(v.blipsJob, v.scale)
                SetBlipColour(v.blipsJob, v.couleur)
                SetBlipAsShortRange(v.blipsJob, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.name)
                EndTextCommandSetBlipName(v.blipsJob)
            end
        end
    end
end