Config = {}

Config.getSharedObject = 'LandLife:GetSharedObject'  -- Configure your framework here.
Config.setJob = 'esx:setJob'  -- Configure your framework here.
Config.playerLoaded = 'esx:playerLoaded'  -- Configure your framework here.
Config.statussetDisplay = 'esx_status:setDisplay'  -- Configure your framework here.

Config.billingSystem = 'default' -- Select between 'default' system, 'okokBilling' or 'rcore_billing' or false if you are not using one
Config.billingpayBillEvent = 'esx_billing:payBill' -- The event of esx: 'esx_billing:payBill' or okokBilling: 'okokBilling:PayInvoice'

Config.okokTextUI = {
   enable = false, -- If you use false, by default there will be DrawText3D.
   colour = 'darkgreen', -- Change the color of your TextUI here.
   position = 'left', -- Change the position of the TextUI here.
}

Config.esxVersion = 'new' -- Select between old (Esx 1.1) or new (Esx 1.2, v1 final, legacy or lmodeextended).

Config.RepeatTimeout = 2000 -- Don't touch here.
Config.CallRepeats = 999999 -- Don't touch here.
Config.OpenPhone = 288 -- The key to open the phone, based on https://docs.fivem.net/docs/game-references/controls/.
Config.DisableMovement = false -- Block all the movement while you are using the phone

Config.Voice = 'pma' -- Options: 'mumble', 'toko', 'pma' or 'salty.'

Config.ValetPrice = 1000 -- Price to bring your vehicle to you.

Config.DeleteStoriesAndNotifies = true -- Do you want the notifications and stories to be deleted after a certain time?
Config.MaxApp = 36 -- Don't touch here.

Config.IbanBank = true -- If you set true to this the bank app will use an IBAN, false to use the ID of the player.
Config.okokBankingIban = false -- With the option above set in true and okokBankingIban in true you will be able to use the okokBanking Alias
--  If you use are not using Iban and the player its disconnect you will not be able to send him money.

Config.Jobs = {
    { job = 'police', name = 'Police' , img = './img/apps/police.png'},
    { job = 'ems', name = 'Ems', img = './img/apps/ambulance.png'},
    { job = 'bennys', name = 'Mécano', img = './img/apps/mechanic.png'},
}

Config.RequiredPhone = true
Config.Phones = {
    ['classic_phone'] = 'classic_frame.png',
    ['black_phone'] = 'black_frame.png',
    ['blue_phone'] = 'blue_frame.png',
    ['gold_phone'] = 'gold_frame.png',
    ['purple_phone'] = 'purple_frame.png',
    ['red_phone'] = 'red_frame.png',
}

Config.PhonesCustomWallpaper = {
    ['classic_frame.png'] = 'b4',
    ['black_frame.png'] = 'b6',
    ['blue_frame.png'] = 'b1',
    ['gold_frame.png'] = 'b5',
    ['purple_frame.png'] = 'b3',
    ['red_frame.png'] = 'b2',
}

Config.Darkweb = {
    List = {    
        [1] = { item = 'WEAPON_PISTOL', label = 'Pistol', price = 8000},
        [2] = { item = 'WEAPON_PISTOL50', label = 'Pistol 50', price = 9000},
        [3] = { item = 'WEAPON_PISTOL_MK2', label = 'Pistol MK2', price = 10000},
        [4] = { item = 'WEAPON_KNUCKLE', label = 'Knucle', price = 5000},
        [5] = { item = 'WEAPON_GRENADE', label = 'Pistol', price = 20000},
        [6] = { item = 'WEAPON_CARBINERIFLE_MK2', label = 'Carbine Rifle MK2', price = 35000},
        [7] = { item = 'WEAPON_BULLPUPRIFLE_MK2', label = 'Bullpup Rifle MK2', price = 40000},
        [8] = { item = 'WEAPON_SNIPERRIFLE', label = 'Sniper Rifle', price = 55000},
    },
}

function SendTextMessage(msg, type) --You can add your notification system here for simple messages.
    if type == 'inform' then 
      SetNotificationTextEntry('STRING')
      AddTextComponentString(msg)
      DrawNotification(0,1)
  
      --MORE EXAMPLES OF NOTIFICATIONS.
      --exports['qs-core']:Notify(msg, "primary")
      --exports['mythic_notify']:DoHudText('inform', msg)
    end
    if type == 'error' then 
      SetNotificationTextEntry('STRING')
      AddTextComponentString(msg)
      DrawNotification(0,1)
  
      --MORE EXAMPLES OF NOTIFICATIONS.
      --exports['qs-core']:Notify(msg, "error")
      --exports['mythic_notify']:DoHudText('error', msg)
    end
    if type == 'success' then 
      SetNotificationTextEntry('STRING')
      AddTextComponentString(msg)
      DrawNotification(0,1)
  
      --MORE EXAMPLES OF NOTIFICATIONS.
      --exports['qs-core']:Notify(msg, "success")
      --exports['mythic_notify']:DoHudText('success', msg)
    end
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Config.StoreAppToday = {
    {
        header = 'GAMING NEWS',
        head = 'New games available!',
        image = 'https://i.imgur.com/mfKcTUJ.png',
        footer = 'Doodle Jump now available here!'
    }
}

Config.StoreApps = { -- Apps from the App Store.
    ['instagram'] = { -- App label.
        app = "instagram", -- App label.
        color = "img/apps/instagram.png", -- App visual image.
        icon = "fab fa-spotify", -- Ignore.
        tooltipText = "Instagram",  -- Visual app name.
        tooltipPos = 'top', -- Ignore.
        job = false, -- If you want this app to work only with jobs, put them inside ' '.
        blockedjobs = {}, -- If you want this app to crash with jobs, put them inside {}.
        slot = 18, -- Slot where the app will be installed.
        Alerts = 0, -- Ignore.
        creator = "Instagram, Inc.​",
        password = false,
        isGame = false,
        description = 'Gratuit - Contient des achats intégrés.',
        score = '4.25', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
        rating = '22,5 millions d\'évaluations',
        age = '16+',
        extraDescription = {
            {
                header = 'INSTAGRAM',
                head = 'Profitez avec vos amis !',
                image = 'https://i.imgur.com/nhyfbJs.png',
                footer = 'Vous rapprocher des gens et des choses que vous aimez. — Instagram de Facebook'
            }
        }
    },

    -- ['garage'] = {
    --     app = "garage",
    --     color = "img/apps/garages.png",
    --     icon = "fas fa-warehouse",
    --     tooltipText = "My Garage",
    --     tooltipPos = 'top',
    --     job = false,
    --     blockedjobs = {},
    --     slot = 19,
    --     creator = "Raffaele Di Marzo.​",
    --     Alerts = 0,
    --     password = false,
    --     isGame = false,
    --     description = 'Manage your vehicles data.',
    --     score = '3.50', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
    --     rating = '48 Ratings',
    --     age = '18+',
    --     extraDescription = {
    --         {
    --             header = 'MY GARAGE',
    --             head = 'Manage your vehicles here.',
    --             image = 'https://i.imgur.com/Pv9W8iP.png',
    --             footer = 'My Garage is the application that all owners of cars, motorcycles or other vehicles.'
    --         }
    --     }
    -- },

    ['whatsapp'] = {
        app = "whatsapp",
        color = "img/apps/whatsapp.png",
        icon = "fas fa-warehouse",
        tooltipText = "WhatsApp",
        tooltipPos = 'top',
        job = false,
        blockedjobs = {},
        slot = 20,
        creator = "WhatsApp Inc.",
        Alerts = 0,
        password = false,
        isGame = false,
        description = 'Simple. Fiable. Privé.',
        score = '4', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
        rating = '9,6 millions d\'évaluations',
        age = '16+',
        extraDescription = {
            {
                header = 'WHATSAPP',
                head = '#3 Réseaux sociaux',
                image = 'https://i.imgur.com/kPkofEf.png',
                footer = 'WhatsApp de Facebook est une application de messagerie et d\'appel vidéo GRATUITE.'
            }
        }
    },

    -- ['twitter'] = {
    --     app = "twitter",
    --     color = "img/apps/twitter.png",
    --     icon = "fas fa-warehouse",
    --     tooltipText = "Twitter",
    --     tooltipPos = 'top',
    --     job = false,
    --     blockedjobs = {},
    --     slot = 21,
    --     creator = "Twitter, Inc.",
    --     Alerts = 0,
    --     password = false,
    --     isGame = false,
    --     description = 'Contains Ads·Offers in-app purchases',
    --     score = '3.75', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
    --     rating = '19.3M Ratings',
    --     age = '17+',
    --     extraDescription = {
    --         {
    --             header = 'TWITTER',
    --             head = 'Are you ready to Tweet?',
    --             image = 'https://i.imgur.com/DY88yuw.png',
    --             footer = 'Expand your social network and stay updated on whats trending now.'
    --         }
    --     }
    -- },

    -- ['advert'] = {
    --     app = "advert",
    --     color = "img/apps/yellow_pages.png",
    --     icon = "fas fa-warehouse",
    --     tooltipText = "Yellow Pages",
    --     tooltipPos = 'top',
    --     job = false,
    --     blockedjobs = {},
    --     slot = 22,
    --     creator = "YELLOWPAGES.COM LLC.​",
    --     Alerts = 0,
    --     password = false,
    --     isGame = false,
    --     description = 'Find local businesses near you.',
    --     score = '4', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
    --     rating = '36.1K Ratings',
    --     age = '4+',
    --     extraDescription = {
    --         {
    --             header = 'YELLOW PAGES',
    --             head = 'Advertise your articles here.',
    --             image = 'https://i.imgur.com/hBFxTdz.png',
    --             footer = 'More than 30,000 people publish their articles here!'
    --         }
    --     }
    -- },

    -- ['tinder'] = {
    --     app = "tinder",
    --     color = "img/apps/tinder.png",
    --     icon = "fas fa-warehouse",
    --     tooltipText = "Tinder",
    --     tooltipPos = 'top',
    --     job = false,
    --     blockedjobs = {},
    --     slot = 23,
    --     creator = "Tinder Inc.​",
    --     Alerts = 0,
    --     password = false,
    --     isGame = false,
    --     description = 'Charla y conoce gente nueva.',
    --     score = '4.25', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
    --     rating = '10.5M Ratings',
    --     age = '16+',
    --     extraDescription = {
    --         {
    --             header = 'TINDER',
    --             head = 'Con 30 mil millones de matches a la fecha de hoy',
    --             image = 'https://i.imgur.com/C1Zeq0R.png',
    --             footer = 'Tinder es la aplicación más popular en el mundo para conocer gente nueva.'
    --         }
    --     }
    -- },

    ['youtube'] = {
        app = "youtube",
        color = "img/apps/youtube.png",
        icon = "fas fa-warehouse",
        tooltipText = "YouTube",
        tooltipPos = 'top',
        job = false,
        blockedjobs = {},
        slot = 24,
        creator = "Google LLC.​",
        Alerts = 0,
        password = false,
        isGame = false,
        description = 'Vidéos, musique et diffusions en direct',
        score = '3.25', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
        rating = '24,3 millions d\'évaluations',
        age = '17+',
        extraDescription = {
            {
                header = 'YOUTUBE',
                head = 'Vos vidéos et créateurs préférés.',
                image = 'https://i.imgur.com/CINQAni.png',
                footer = 'Découvrez un grand nombre de vidéos et de créateurs de contenu !'
            }
        }
    },
    
    -- ['uber'] = {
    --     app = "uber",
    --     color = "img/apps/uber.png",
    --     icon = "fas fa-warehouse",
    --     tooltipText = "Uber Eats",
    --     tooltipPos = 'top',
    --     job = false,
    --     blockedjobs = {},
    --     slot = 25,
    --     creator = "Uber Technologies, Inc.​",
    --     Alerts = 0,
    --     password = false,
    --     isGame = false,
    --     description = 'Any takeout order to your door!',
    --     score = '3.75', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
    --     rating = '4.9M Ratings',
    --     age = '12+',
    --     extraDescription = {
    --         {
    --             header = 'UBER EATS',
    --             head = 'Find food delivery on your budget.',
    --             image = 'https://i.imgur.com/FaP1KMs.png',
    --             footer = 'Start working now, with a simple click!'
    --         }
    --     }
    -- },

    -- ['darkweb'] = {
    --     app = "darkweb",
    --     color = "img/apps/darkweb.png",
    --     icon = "fas fa-warehouse",
    --     tooltipText = "Onion Browser",
    --     tooltipPos = 'top',
    --     job = false,
    --     blockedjobs = {'police'},
    --     slot = 26,
    --     creator = "Mike Tigas.​",
    --     Alerts = 0,
    --     password = false,
    --     isGame = false,
    --     description = 'Secure, anonymous web with Tor.',
    --     score = '3.25', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
    --     rating = '1.2K Ratings',
    --     age = '18+',
    --     extraDescription = {
    --         {
    --             header = 'ONION OR TOR',
    --             head = 'Secure, anonymous web/shop with Tor',
    --             image = 'https://i.imgur.com/Otm6QCe.png',
    --             footer = 'The best Tor-related offering on iOS right now is Onion Browser'
    --         }
    --     }
    -- },

    -- ['radio'] = {
    --     app = "radio",
    --     color = "img/apps/radio.png",
    --     icon = "fas fa-warehouse",
    --     tooltipText = "Radio",
    --     tooltipPos = 'top',
    --     job = false,
    --     blockedjobs = {},
    --     slot = 27,
    --     creator = "LS Radio Inc.​",
    --     Alerts = 0,
    --     password = false,
    --     isGame = false,
    --     description = 'Radio work for all users.',
    --     score = '3.25', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
    --     rating = ' 332 Ratings',
    --     age = '16+',
    --     extraDescription = {
    --         {
    --             header = 'RADIO',
    --             head = 'A radio to connect to many frequencies!',
    --             image = 'https://i.imgur.com/ENBVOUI.png',
    --             footer = 'Communicate quickly and safely.'
    --         }
    --     }
    -- },

    -- ['state'] = {
    --     app = "state",
    --     color = "img/apps/workspace.png",
    --     icon = "fas fa-warehouse",
    --     tooltipText = "State",
    --     tooltipPos = 'top',
    --     job = false,
    --     blockedjobs = {},
    --     slot = 28,
    --     creator = "Los Santos Inc.​",
    --     Alerts = 0,
    --     password = false,
    --     isGame = false,
    --     description = 'Contact Los Santos employees.',
    --     score = '4.25', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
    --     rating = ' 12M Ratings',
    --     age = '4+',
    --     extraDescription = {
    --         {
    --             header = 'STATE',
    --             head = 'Police, ambulances and much more here',
    --             image = 'https://i.imgur.com/c5HevoW.png',
    --             footer = 'Contact them directly now.'
    --         }
    --     }
    -- },

    -- ['meos'] = {
    --     app = "meos",
    --     color = "img/apps/police.png",
    --     icon = "fas fa-warehouse",
    --     tooltipText = "Police",
    --     tooltipPos = 'top',
    --     job = 'police',
    --     blockedjobs = {},
    --     slot = 29,
    --     creator = "LS Department.​",
    --     Alerts = 0,
    --     password = false,
    --     isGame = false,
    --     description = 'Exclusive MDT for policemen.',
    --     score = '5', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
    --     rating = ' 12 Ratings',
    --     age = '18+',
    --     extraDescription = {
    --         {
    --             header = 'MDT',
    --             head = 'Database for police!',
    --             image = 'https://i.imgur.com/xIn2bWQ.png',
    --             footer = 'The Saints are safe thanks to your work.'
    --         }
    --     }
    -- },

    ['jump'] = {
        app = "jump",
        color = "img/apps/jump.png",
        icon = "fas fa-warehouse",
        tooltipText = "Doodle Jump",
        tooltipPos = 'top',
        job = false,
        blockedjobs = {},
        slot = 30,
        creator = "Hydra Dev.​",
        Alerts = 0,
        password = false,
        isGame = true,
        description = 'ATTENTION : incroyablement addictif !',
        score = '4.75', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
        rating = ' 660 Ratings',
        age = '4+',
        extraDescription = {
            {
                header = 'DOODLE JUMP',
                head = 'ATTENTION : incroyablement addictif !',
                image = 'https://i.imgur.com/N9MvHFm.png',
                footer = 'Jeu de saut très amusant !'
            }
        }
    },

    -- ['tetris'] = {
    --     app = "tetris",
    --     color = "img/apps/tetris.png",
    --     icon = "fas fa-warehouse",
    --     tooltipText = "Tetris",
    --     tooltipPos = 'top',
    --     job = false,
    --     blockedjobs = {},
    --     slot = 31,
    --     creator = "Hydra Dev.​",
    --     Alerts = 0,
    --     password = false,
    --     isGame = true,
    --     description = 'The Official Block Puzzle Game',
    --     score = '3', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
    --     rating = ' 40K Ratings',
    --     age = '4+',
    --     extraDescription = {
    --         {
    --             header = 'TETRIS',
    --             head = 'The Official Block Puzzle Game',
    --             image = 'https://i.imgur.com/syM6WDb.png',
    --             footer = 'Official mobile app for the worlds favorite puzzle game!'
    --         }
    --     }
    -- },

    --[[ ['rentel'] = { -- Rental DLC.
        app = "rentel",
        color = "img/apps/rentel.png",
        icon = "fas fa-warehouse",
        tooltipText = "Nextbike",
        tooltipPos = 'top',
        job = false,
        blockedjobs = {},
        slot = 32,
        creator = "nextbike.​",
        Alerts = 0,
        password = false,
        isGame = false,
        description = 'Start cycling!',
        score = '3.50', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
        rating = '333 Ratings',
        age = '4+',
        extraDescription = {
            {
                header = 'NEXTBIKE',
                head = 'The best bike rental app!',
                image = 'https://i.imgur.com/WPzp1PV.png',
                footer = 'Find bike rental areas or even make friends!'
            }
        }
    }, ]]

    --[[ ['racing'] = { -- Racing DLC.
        app = "racing",
        color = "img/apps/racing.png",
        icon = "fas fa-warehouse",
        tooltipText = "Racing",
        tooltipPos = 'top',
        job = false,
        blockedjobs = {'police'},
        slot = 33,
        creator = "Los Santos Customs.​",
        Alerts = 0,
        password = false,
        isGame = false,
        description = 'Los Santos Illegal Racing App.',
        score = '4.25', -- Options: 0, 0.25, 0.5, 0.75, 1, 1.25, 1.50, 1.75, 2, 2.25, 2.50, 2.75, 3, 3.25, 3.50, 3.75, 4, 4.25, 4.50, 4.75, 5
        rating = '5M Ratings',
        age = '16+',
        extraDescription = {
            {
                header = 'RACING',
                head = 'Illegal racing in Los Santos!',
                image = 'https://i.imgur.com/OJ4Zxtn.png',
                footer = 'Application created by LS Customs, to provide comfort to drivers.'
            }
        }
    }, ]]
}


Config.PhoneApplications = { -- Pre-installed applications (If you modify them, remember to empty the "apps" column of your sql "users").
    [1] = { -- Slot id.
        app = "phone", -- App label.
        color = "img/apps/phone.png", -- App visual image.
        icon = "fa fa-phone-alt", -- Ignore.
        tooltipText = "Téléphone", -- Ignore.
        tooltipPos = "top", -- Ignore.
        job = false, -- Ignore.
        blockedjobs = {}, -- Ignore.
        slot = 1, -- Slot where the app will appear.
        Alerts = 0, -- Alerts that will appear in the app as soon as you use the phone.
        bottom = true, -- Ignore.
    },

    [2] = {
        app = "photos",
        color = "img/apps/gallery.png",
        icon = "fab fa-spotify",
        tooltipText = "Gallerie",
        job = false,
        blockedjobs = {},
        slot = 2,
        Alerts = 0,
        bottom = true,
    },

    [3] = {
        app = "messages",
        color = "img/apps/messages.png",
        icon = "fas fa-university",
        tooltipText = "Messages",
        job = false,
        slot = 3,
        blockedjobs = {},
        Alerts = 0,
        bottom = true
    },

    [4] = {
        app = "settings",
        color = "img/apps/settings.png",
        icon = "fa fa-cog",
        tooltipText = "Paramètres",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 4,
        Alerts = 0,
        bottom = true
    },

    [5] = {
        app = "clock",
        color = "img/apps/clock.png",
        icon = "fab fa-spotify",
        tooltipText = "Horloge",
        job = false,
        slot = 5,
        blockedjobs = {},
        Alerts = 0,
    },

    [6] = {
        app = "camera",
        color = "img/apps/camera.png",
        icon = "fab fa-spotify",
        tooltipText = "Caméra",
        job = false,
        blockedjobs = {},
        slot = 6,
        Alerts = 0,
    },

    [7] = {
        app = "mail",
        color = "img/apps/mail.png",
        icon = "fas fa-envelope",
        tooltipText = "Mail",
        job = false,
        blockedjobs = {},
        slot = 7,
        Alerts = 0,
    },

    [8] = {
        app = "bank",
        color = "img/apps/banksign.png",
        icon = "fas fa-university",
        tooltipText = "Banque",
        job = false,
        slot = 8,
        blockedjobs = {},
        Alerts = 0,
    },

    [9] = {
        app = "calendar",
        color = "img/apps/system_calendar_1.png",
        icon = "fab fa-spotify",
        tooltipText = "Calendrier",
         job = false,
         blockedjobs = {},
         slot = 9,
         Alerts = 0,
    },

    [10] = {
        app = "weather",
        color = "img/apps/weather.png",
        icon = "&nbsp;",
        tooltipText = "Météo",
         job = false,
         blockedjobs = {},
         slot = 10,
         Alerts = 0,
    },

    [11] = {
        app = "notes",
        color = "img/apps/notes.png",
        icon = "fab fa-spotify",
        tooltipText = "Notes",
         job = false,
         blockedjobs = {},
         slot = 11,
         Alerts = 0,
    },

    [12] = {
        app = "calculator",
        color = "img/apps/calculator.png",
        icon = "fab fa-spotify",
        tooltipText = "Calculatrice",
         job = false,
         blockedjobs = {},
         slot = 12,
         Alerts = 0,
    },

    [13] = {
        app = "store",
        color = "img/apps/appstore.png",
        icon = "fas fa-user-tie",
        tooltipText = "App Store",
        job = false,
        blockedjobs = {},
        slot = 13,
        Alerts = 0,
    },

    -- [14] = {
    --     app = "help",
    --     color = "img/apps/tips.png",
    --     icon = "fab fa-spotify",
    --     tooltipText = "Tips",
    --      job = false,
    --      blockedjobs = {},
    --      slot = 14,
    --      Alerts = 0,
    -- },

    -- [14] = {
    --     app = "music",
    --     color = "img/apps/music.png",
    --     icon = "",
    --     tooltipText = "Music",
    --     job = false,
    --     slot = 15,
    --     blockedjobs = {},
    --     Alerts = 0,
    --     bottom = true
    -- },

--Critical Scripts collaboration in progress, not yet available.
    --[[ [16] = {
        app = "cs-stories",
        color = "img/apps/facetime.png",
        icon = "cs-stories-dummy-icon-do-not-change-this-value",
        tooltipText = "FaceTime",
        job = false,
        slot = 15,
        blockedjobs = {},
        Alerts = 0,
    }, ]]
    
-- To run this app, you need to use the qs-crypto DLC.
    --[[ [16] = {
        app = "crypto",
        color = "img/apps/wallet.png",
        icon = "fas fa-user-tie",
        tooltipText = "Crypto",
        job = false,
        blockedjobs = {},
        slot = 16,
        Alerts = 0,
    }, ]]

-- It will only work if you use qs-housing, if you have this resource, you can enable it.
    --[[ [17] = {
        app = "houses",
        color = "img/apps/home.png",
        icon = "",
        tooltipText = "Home",
        job = false,
        slot = 17,
        blockedjobs = {},
        Alerts = 0,
        bottom = true
    }, ]]
}