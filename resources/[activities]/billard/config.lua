

Config = {
    NotificationDistance = 10.0,
    PropsToRemove = {
        vector3(1992.803, 3047.312, 46.22865),
        vector3(-36.301, 6391.44, 31.6047),
        vector3(550.147, -174.76, 50.6930),
        vector3(-574.17, 288.834, 79.1766),
    },

    CustomNotifications = true,

    CustomMenu = false,

    PayForSettingBalls = false,
    BallSetupCost = nil, -- for example: "$1" or "$200" - any text

    AllowTakePoolCueFromStand = true,

    DoNotRotateAroundTableWhenAiming = false,

    MenuColor = {245, 127, 23},
    Keys = {
        BACK = {code = 200, label = 'INPUT_FRONTEND_PAUSE_ALTERNATE'},
        ENTER = {code = 38, label = 'INPUT_PICKUP'},
        SETUP_MODIFIER = {code = 21, label = 'INPUT_SPRINT'},
        CUE_HIT = {code = 179, label = 'INPUT_CELLPHONE_EXTRA_OPTION'},
        CUE_LEFT = {code = 174, label = 'INPUT_CELLPHONE_LEFT'},
        CUE_RIGHT = {code = 175, label = 'INPUT_CELLPHONE_RIGHT'},
        AIM_SLOWER = {code = 21, label = 'INPUT_SPRINT'},
        BALL_IN_HAND = {code = 29, label = 'INPUT_SPECIAL_ABILITY_SECONDARY'},

        BALL_IN_HAND_LEFT = {code = 174, label = 'INPUT_CELLPHONE_LEFT'},
        BALL_IN_HAND_RIGHT = {code = 175, label = 'INPUT_CELLPHONE_RIGHT'},
        BALL_IN_HAND_UP = {code = 172, label = 'INPUT_CELLPHONE_UP'},
        BALL_IN_HAND_DOWN = {code = 173, label = 'INPUT_CELLPHONE_DOWN'},
    },
    Text = {
        BACK = "Arrière",
        HIT = "Frapper",
        BALL_IN_HAND = "prendre le ballon",
        BALL_IN_HAND_BACK = "Placer",
        AIM_LEFT = "Tourner à gauche",
        AIM_RIGHT = "Tournez à droite",
        AIM_SLOWER = "visée lente",

        POOL = 'Billard',
        POOL_GAME = 'mode de jeu',
        POOL_SUBMENU = 'mode de jeu',
        TYPE_8_BALL = '8 balles',
        TYPE_STRAIGHT = 'Piscine droite',

        HINT_SETUP = 'Appuyez sur ~INPUT_SPRINT~ + ~INPUT_CONTEXT~ pour choisir le ~b~mode de Jeux~s~.',
        HINT_TAKE_CUE = 'Appuyez sur ~INPUT_CONTEXT~ pour ~b~prendre une queue de billard~s~.',
        HINT_RETURN_CUE = 'Appuyez sur ~INPUT_CONTEXT~ pour ~b~remettez la queue~s~.',
        HINT_HINT_TAKE_CUE = 'Pour jouer au billard, vous devez avoir une queue de billard',
        HINT_PLAY = '~INPUT_SPRINT~ + ~INPUT_CONTEXT~ pour changer le mode de jeux\n~INPUT_CONTEXT~ pour jouer au billard.',

        BALL_IN_HAND_LEFT = 'Gauche',
        BALL_IN_HAND_RIGHT = 'Droite',
        BALL_IN_HAND_UP = 'Au dessus',
        BALL_IN_HAND_DOWN = 'Vers le bas',
        BALL_POCKETED = '%s tu mets la balle dans le trou',
        BALL_IN_HAND_NOTIFY = 'Vous avez la boule de billard',
        BALL_LABELS = {
            [-1] = 'Cue',
            [1] = '~y~Solid 1~s~',
            [2] = '~b~Solid 2~s~',
            [3] = '~r~Solid 3~s~',
            [4] = '~p~Solid 4~s~',
            [5] = '~o~Solid 5~s~',
            [6] = '~g~Solid 6~s~',
            [7] = '~r~Solid 7~s~',
            [8] = 'Black solid 8',
            [9] = '~y~Striped 9~s~',
            [10] = '~b~Striped 10~s~',
            [11] = '~r~Striped 11~s~',
            [12] = '~p~Striped 12~s~',
            [13] = '~o~Striped 13~s~',
            [14] = '~g~Striped 14~s~',
            [15] = '~r~Striped 15~s~',
         }
    },
}