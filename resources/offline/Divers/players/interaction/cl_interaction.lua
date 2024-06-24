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
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

local ListeAnimations = {
    ["S'asseoir"] = {
        {name = "S'asseoir posé", anim = {"timetable@tracy@ig_14@", "ig_14_base_tracy"}, mouvement = 1},
        {name = "S'asseoir droit", anim = {"timetable@ron@ig_5_p3", "ig_5_p3_base"}, mouvement = 1},
        {name = "S'asseoir chill 01", anim = {"timetable@reunited@ig_10", "base_amanda"}, mouvement = 1},
        {name = "S'asseoir impatient", anim = {"timetable@ron@ig_3_couch", "base"}, mouvement = 1},
        {name = "S'asseoir chill 02", anim = {"timetable@maid@couch@", "base"}, mouvement = 1},
        {name = "S'asseoir chill 03", anim = {"missheistpaletoscoresetupleadin", "rbhs_mcs_1_leadin"}, mouvement = 1},
        {name = "S'asseoir cool", anim = {"missfam2leadinoutmcs3", "onboat_leadin_pornguy_a"}, mouvement = 1},
        {name = "S'asseoir cool 2", anim = {"anim@heists@heist_safehouse_intro@phone_couch@male", "phone_couch_male_idle"}, mouvement = 1},
        {name = "Accouder flow 01", anim = {"missheistdockssetup1ig_12@base", "talk_gantry_idle_base_worker2"}, mouvement = 1},
        {name = "Accouder flow 02", anim = {"missheistdockssetup1ig_12@base", "talk_gantry_idle_base_worker4"}, mouvement = 1},
        {name = "S'asseoir au sol 01", anim = {"anim@heists@fleeca_bank@ig_7_jetski_owner", "owner_idle"}, mouvement = 1},
        {name = "S'asseoir au sol 02", anim = {"rcm_barry3", "barry_3_sit_loop"}, mouvement = 1},
        {name = "S'asseoir au sol 03", anim = {"amb@world_human_picnic@male@idle_a", "idle_a"}, mouvement = 1},
        {name = "S'asseoir au sol 04", anim = {"amb@world_human_picnic@female@idle_a", "idle_a"}, mouvement = 1},
        {name = "S'asseoir au sol 05", anim = {"timetable@jimmy@mics3_ig_15@", "idle_a_jimmy"}, mouvement = 1},
        {name = "S'asseoir au sol 06", anim = {"anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_sleeping-noworkfemale"}, mouvement = 1},
        {name = "Méditation", anim = {"rcmcollect_paperleadinout@", "meditiate_idle"}, mouvement = 1},
        {name = "Genoux au sol", anim = {"amb@medic@standing@kneel@base", "base"}, mouvement = 1}
    },

    ["Divers"] = {
        {name = "Applaudissements énervés", anim = {"anim@arena@celeb@flat@solo@no_props@", "angry_clap_a_player_a"}, mouvement = 1},
        {name = "Réparation accroupie", anim = {"anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"}, mouvement = 2},
        {name = "Réparation couchée", anim = {"anim@amb@garage@chassis_repair@", "look_up_01_amy_skater_01"}, mouvement = 2},
        {name = "Réajuster sa chemise 1", anim = {"clothingtie", "try_tie_neutral_d"}},
        {name = "Réajuster sa chemise 2", anim = {"clothingtie", "try_tie_positive_a"}},
        {name = "Je brûle !", anim = {"ragdoll@human", "on_fire"}, mouvement = 2},
        {name = "Stress HoldUp", anim = {"anim@move_hostages@male", "male_idle"}, mouvement = 2},
        {name = "Slide", anim = {"anim@arena@celeb@flat@solo@no_props@", "slide_a_player_a"}},
        {name = "Reverence", anim = {"anim@arena@celeb@podium@no_prop@", "regal_c_1st"}},
        {name = "Pleure a genoux", anim = {"mp_bank_heist_1", "f_cower_01"}, mouvement = 1},
        {name = "Sortir son carnet", anim = "CODE_HUMAN_MEDIC_TIME_OF_DEATH"},
        {name = "Siffler", anim = {"rcmnigel1c", "hailing_whistle_waive_a"}, mouvement = 48},
        {name = "Je me sens pas bien", anim = {"missfam5_blackout", "pass_out"}},
        {name = "Locoooo", anim = {"anim@mp_player_intcelebrationmale@you_loco", "you_loco"}},
        {name = "Wank", anim = {"anim@mp_player_intcelebrationmale@wank", "wank"}},
        {name = "Laché moi", anim = {"anim@mp_player_intcelebrationmale@freakout", "freakout"}},
        {name = "Slow Clap", anim = {"anim@mp_player_intcelebrationmale@slow_clap", "slow_clap"}},
        {name = "Appel téléphonique", anim = {"cellphone@", "cellphone_call_listen_base"}, mouvement = 49},
        {name = "Encouragement", anim = {"mini@triathlon", "male_one_handed_a"}},
        {name = "Bras tendu", anim = {"nm@hands", "flail"}, mouvement = 1},
        {name = "Yoga", anim = {"amb@world_human_yoga@male@base", "base_a"}},
        {name = "Mîme", anim = {"special_ped@mime@monologue_5@monologue_5a", "10_ig_1_wa_0"}},
        {name = "Acrobatie 1", anim = {"anim@arena@celeb@flat@solo@no_props@", "cap_a_player_a"}},
        {name = "Acrobatie 2", anim = {"anim@arena@celeb@flat@solo@no_props@", "flip_a_player_a"}},
        {name = "Acrobatie 3", anim = {"anim@arena@celeb@flat@solo@no_props@", "pageant_a_player_a"}},
        {name = "Radio", anim = {"random@arrests", "generic_radio_chatter"}, mouvement = 49},
        {name = "BBQ 1", anim = {"amb@prop_human_bbq@male@idle_b", "idle_d"}, mouvement = 1},
        {name = "BBQ 2", anim = {"amb@prop_human_bbq@male@idle_a", "idle_c"}, mouvement = 1}
    },

    ["Gestures"] = {
        {name = "Bise au doigt", anim = {"anim@mp_player_intcelebrationfemale@finger_kiss", "finger_kiss"}},
        {name = "Quoi", anim = {"gestures@f@standing@casual", "gesture_bring_it_on"}, mouvement = 48},
        {name = "Casse-toi", anim = {"gestures@f@standing@casual", "gesture_bye_hard"}, mouvement = 48},
        {name = "Salut", anim = {"gestures@f@standing@casual", "gesture_bye_soft"}, mouvement = 48},
        {name = "Viens voir", anim = {"gestures@f@standing@casual", "gesture_come_here_hard"}, mouvement = 48},
        {name = "Allez viens..", anim = {"gestures@f@standing@casual", "gesture_come_here_soft"}, mouvement = 48},
        {name = "Damn", anim = {"gestures@f@standing@casual", "gesture_damn"}, mouvement = 48},
        {name = "Tsss", anim = {"gestures@f@standing@casual", "gesture_displeased"}, mouvement = 48},
        {name = "Hey calme", anim = {"gestures@f@standing@casual", "gesture_easy_now"}, mouvement = 48},
        {name = "ICI", anim = {"gestures@f@standing@casual", "gesture_hand_down"}, mouvement = 48},
        {name = "Gauche", anim = {"gestures@f@standing@casual", "gesture_hand_left"}, mouvement = 48},
        {name = "Droite", anim = {"gestures@f@standing@casual", "gesture_hand_right"}, mouvement = 48},
        {name = "Oh non", anim = {"gestures@f@standing@casual", "gesture_head_no"}, mouvement = 48},
        {name = "Hey toi", anim = {"gestures@f@standing@casual", "gesture_hello"}, mouvement = 48},
        {name = "Lourd", anim = {"gestures@f@standing@casual", "gesture_i_will"}, mouvement = 48},
        {name = "Moi ?!", anim = {"gestures@f@standing@casual", "gesture_me_hard"}, mouvement = 48},
        {name = "Moi", anim = {"gestures@f@standing@casual", "gesture_me"}, mouvement = 48},
        {name = "Pas moyen", anim = {"gestures@f@standing@casual", "gesture_no_way"}, mouvement = 48},
        {name = "Non non", anim = {"gestures@f@standing@casual", "gesture_nod_no_hard"}, mouvement = 48},
        {name = "Non soft", anim = {"gestures@f@standing@casual", "gesture_nod_no_soft"}, mouvement = 48},
        {name = "Oui fonce", anim = {"gestures@f@standing@casual", "gesture_nod_yes_hard"}, mouvement = 48},
        {name = "Mouai", anim = {"gestures@f@standing@casual", "gesture_nod_yes_soft"}, mouvement = 48},
        {name = "C'est ça", anim = {"gestures@f@standing@casual", "gesture_pleased"}, mouvement = 48},
        {name = "My man", anim = {"gestures@f@standing@casual", "gesture_point"}, mouvement = 48},
        {name = "Aucune idée", anim = {"gestures@f@standing@casual", "gesture_shrug_hard"}, mouvement = 48},
        {name = "Aucune idée soft", anim = {"gestures@f@standing@casual", "gesture_shrug_soft"}, mouvement = 48},
        {name = "Quoi ?!", anim = {"gestures@f@standing@casual", "gesture_what_hard"}, mouvement = 48},
        {name = "Quoi soft", anim = {"gestures@f@standing@casual", "gesture_what_soft"}, mouvement = 48},
        {name = "Toi", anim = {"gestures@f@standing@casual", "gesture_you_hard"}, mouvement = 48},
        {name = "Toi soft", anim = {"gestures@f@standing@casual", "gesture_you_soft"}, mouvement = 48},
        {name = "C'est à moi", anim = {"gestures@f@standing@casual", "getsure_its_mine"}, mouvement = 48},
        {name = "Ramène-toi !", anim = {"friends@frt@ig_1", "trevor_arrival_1"}, mouvement = 48},
        {name = "Signe d'appel", anim = {"missfra1leadinoutmcs_1", "_leadin_action_lamar"}},
        {name = "Je vais te tuer !", anim = {"anim@mp_player_intcelebrationfemale@cut_throat", "cut_throat"}, mouvement = 48},
        {name = "Provoquer", anim = {"oddjobs@assassinate@vice@hooker", "argue_a"}, mouvement = 48},
        {name = "Qu'est-ce qui se passe ?!", anim = {"mini@triathlon", "wot_the_fuck"}, mouvement = 48},
        {name = "Rien à voir ici !", anim = {"timetable@lamar@ig_4", "nothing_to_see_here_stretch"}, mouvement = 48},
        {name = "Filez d'ici !", anim = {"timetable@lamar@ig_4", "ride_on_through_stretch"}, mouvement = 48},
        {name = "Écoute-le", anim = {"timetable@lamar@ig_2", "nothing_tosee_here_stretch"}, mouvement = 1},
        {name = "Appeller quelqu'un du doigt", anim = {"missfra0_chop_find", "call_chop_r"}, mouvement = 48}
    },

    ["Expressions"] = {
        {name = "A couvert", anim = {"amb@code_human_cower@male@base", "base"}, mouvement = 2},
        {name = "Etirement jambe", anim = {"rcmfanatic1maryann_stretchidle_b", "idle_e"}},
        {name = "Envie pressante", anim = {"misscarsteal4@toilet", "desperate_toilet_base_idle"}, mouvement = 2},
        {name = "Jouer avec un chien",anim = {"switch@franklin@plays_w_dog", "001916_01_fras_v2_9_plays_w_dog_idle"}, mouvement = 1},
        {name = "Regarder au sol", anim = {"switch@franklin@admire_motorcycle", "base_franklin"}, mouvement = 2},
        {name = "Loose Thumbs 1", anim = {"anim@arena@celeb@flat@solo@no_props@", "thumbs_down_a_player_a"}, mouvement = 48},
        {name = "Mort de rire", anim = {"anim@arena@celeb@flat@solo@no_props@", "taunt_d_player_b"}},
        {name = "Badmood 1", anim = {"amb@world_human_stupor@male@base", "base"}, mouvement = 1},
        {name = "Badmood 2", anim = {"amb@world_human_stupor@male_looking_left@base", "base"}, mouvement = 1},
        {name = "Bisou", anim = {"mp_ped_interaction", "kisses_guy_a"}},
        {name = "Stressé", anim = {"rcmme_tracey1", "nervous_loop"}, mouvement = 1},
        {name = "Peace", anim = {"anim@mp_player_intcelebrationmale@peace", "peace"}, mouvement = 48},
        {name = "Clown teubé", anim = {"move_clown@p_m_two_idles@", "fidget_short_dance"}},
        {name = "Face Palm", anim = {"anim@mp_player_intcelebrationmale@face_palm", "face_palm"}},
        {name = "Patience", anim = {"special_ped@impotent_rage@base", "base"}, mouvement = 1},
        {name = "Respect", anim = {"mp_player_int_upperbro_love", "mp_player_int_bro_love_fp"}, mouvement = 48},
        {name = "Inspecter ses lunettes", anim = {"clothingspecs", "try_glasses_positive_a"}, mouvement = 48},
        {name = "Réflexion", anim = {"misscarsteal4@aliens", "rehearsal_base_idle_director"}, mouvement = 49},
        {name = "Check mon flow", anim = {"clothingshirt", "try_shirt_positive_d"}, mouvement = 48},
        {name = "VICTOIRE", anim = {"mini@tennisexit@", "tennis_outro_win_01_female"}},
        {name = "Le plus fort", anim = {"rcmbarry", "base"}},
        {name = "Ta géré", anim = {"anim@mp_player_intcelebrationmale@thumbs_up", "thumbs_up"}},
        {name = "Mal de tête", anim = {"misscarsteal4@actor", "stumble"}},
        {name = "Bro love", anim = {"anim@mp_player_intcelebrationmale@bro_love", "bro_love"}},
        {name = "Craquer les poignets", anim = {"anim@mp_player_intcelebrationmale@knuckle_crunch", "knuckle_crunch"}},
        {name = "Signe Families", anim = {"amb@code_human_in_car_mp_actions@gang_sign_b@low@ps@base", "idle_a"}, mouvement = 49},
        {name = "Signe Families 2",anim = {"amb@code_human_in_car_mp_actions@gang_sign_b@std@rps@base", "idle_a"}, mouvement = 49},
        {name = "Signe Vagos", anim = {"amb@code_human_in_car_mp_actions@v_sign@std@rds@base", "idle_a"}, mouvement = 49},
        {name = "Signe Vagos 2", anim = {"mp_player_int_upperv_sign", "mp_player_int_v_sign"}, mouvement = 49},
        {name = "Signe Ballas", anim = {"mp_player_int_uppergang_sign_b", "mp_player_int_gang_sign_b"}, mouvement = 49},
        {name = "Signe Marabunta", anim = {"mp_player_int_uppergang_sign_a", "mp_player_int_gang_sign_a"}, mouvement = 49},
        {name = "Check", anim = {"mp_ped_interaction", "handshake_guy_a"}},
        {name = "Check 2", anim = {"mp_ped_interaction", "hugs_guy_a"}},
        {name = "A vos marque", anim = {"random@street_race", "grid_girl_race_start"}},
        {name = "Il a gagné", anim = {"random@street_race", "_streetracer_accepted"}},
        {name = "Ceinturons", anim = {"amb@code_human_wander_idles_cop@male@static", "static"}, mouvement = 49},
        {name = "On arrête tous", anim = {"anim@heists@ornate_bank@chat_manager", "fail"}, mouvement = 48}
    },

    ["Poses"] = {
        {name = "Faire du stop", anim = {"random@hitch_lift", "idle_f"}, mouvement = 1},
        {name = "Attente 2", anim = {"random@shop_tattoo", "_idle"}},
        {name = "Massage cardiaque", anim = {"mini@cpr@char_a@cpr_str", "cpr_pumpchest"}, mouvement = 1},
        {name = "Assis mal au coeur", anim = {"anim@heists@prison_heistig_5_p1_rashkovsky_idle", "idle_180"}, mouvement = 1},
        {name = "Bras dans le dos", anim = {"anim@miss@low@fin@vagos@", "idle_ped06"}, mouvement = 49},
        {name = "Main sur la hanche", anim = {"anim@amb@casino@hangout@ped_male@stand@03b@base", "base"}, mouvement = 49},
        {name = "Attente", anim = {"timetable@amanda@ig_9", "ig_9_base_amanda"}, mouvement = 49},
        {name = "Désespéré debout", anim = {"anim@amb@casino@out_of_money@ped_male@01b@base", "base"}, mouvement = 49},
        {name = "Apeuré au sol", anim = {"rcmtmom_2leadinout", "tmom_2_leadout_loop"}, mouvement = 1},
        {name = "A genoux, mains en l’air", anim = {"missheist_jewel", "manageress_kneel_loop"}, mouvement = 1},
        {name = "Mains sur la tête", anim = {"busted", "idle_b"}, mouvement = 48},
        {name = "Dos comptoir", anim = {"anim@amb@clubhouse@bar@bartender@", "base_bartender"}, mouvement = 1},
        {name = "Dormir sur place", anim = {"mp_sleep", "sleep_loop"}, mouvement = 49},
        {name = "PLS", anim = {"timetable@tracy@sleep@", "idle_c"}, mouvement = 1},
        {name = "Blessé couché", anim = {"combat@damage@writheidle_c", "writhe_idle_g"}, mouvement = 1},
        {name = "Roule au sol", anim = {"missfinale_a_ig_2", "trevor_death_reaction_pt"}, mouvement = 2},
        {name = "Blessé au sol", anim = {"combat@damage@rb_writhe", "rb_writhe_loop"}, mouvement = 1},
        {name = "Désespéré", anim = {"rcmnigel1c", "idle_d"}, mouvement = 1},
        {name = "Essouffler", anim = {"re@construction", "out_of_breath"}},
        {name = "Zombie", anim = {"special_ped@zombie@monologue_1@monologue_1c", "iamundead_2"}, mouvement = 1},
        {name = "Pose garde", anim = {"amb@world_human_stand_guard@male@base", "base"}, mouvement = 49},
        {name = "Bras croisé lourd", anim = {"anim@heists@heist_corona@single_team", "single_team_loop_boss"}, mouvement = 1},
        {name = "Bras croisé", anim = {"random@street_race", "_car_b_lookout"}, mouvement = 1},
        {name = "Bras croisé 2", anim = {"anim@amb@casino@hangout@ped_male@stand@01b@base", "base"}, mouvement = 1},
        {name = "Faire le maik", anim = {"anim@heists@heist_corona@single_team", "single_team_intro_two"}, mouvement = 49},
        {name = "Holster", anim = {"reaction@intimidation@cop@unarmed", "intro"}, mouvement = 50},
        {name = "Patauge", anim = {"move_m@wading", "walk"}},
        {name = "Discussion 1", anim = {"friends@frl@ig_1", "idle_a_lamar"}, mouvement = 1},
        {name = "Discussion 2", anim = {"anim@amb@casino@peds@", "amb_world_human_hang_out_street_male_c_base"}, mouvement = 1},
        {name = "Discussion 3", anim = {"amb@world_human_hang_out_street@male_b@idle_a", "idle_c"}, mouvement = 1},
        {name = "Discussion gang", anim = {"timetable@lamar@ig_3", "steve_jobs_died_lamar"}, mouvement = 1},
        {name = "Discussion de rue 1", anim = {"timetable@lamar@ig_3", "las_ig_3_pt1_soul_pole_stretch"}, mouvement = 1},
        {name = "Discussion de rue 2", anim = {"switch@franklin@gang_taunt_p4", "gang_taunt_with_lamar_loop_g1"}, mouvement = 1},
        {name = "Accoudé contre un véhicule", anim = {"misscarstealfinalecar_5_ig_1", "waitloop_lamar"}, mouvement = 1},
        {name = "Accoudé", anim = {"amb@prop_human_bum_shopping_cart@male@base", "base"}, mouvement = 1},
        {name = "Salut militaire", anim = {"anim@mp_player_intuppersalute", "idle_a"}, mouvement = 49},
        {name = "Salut militaire 2", anim = {"anim@mp_player_intincarsalutestd@ds@", "idle_a"}, mouvement = 49},
        {name = "Tenir son gilet pare-balle", anim = {"move_m@hiking", "idle"}, mouvement = 49},
        {name = "Pose police", anim = {"amb@world_human_cop_idles@female@idle_a", "idle_a"}, mouvement = 49},
        {name = "Pouces en l'air", anim = {"anim@mp_player_intupperthumbs_up", "idle_a"}, mouvement = 48}
    },

    ["Festives"] = {
        {name = "Suspens", anim = {"anim@amb@nightclub@dancers@black_madonna_entourage@", "li_dance_facedj_11_v1_male^1"}, mouvement = 1},
        {name = "Coincé", anim = {"anim@amb@nightclub@dancers@black_madonna_entourage@", "li_dance_facedj_15_v2_male^2"}, mouvement = 1},
        {name = "Enchainé", anim = {"anim@amb@nightclub@dancers@black_madonna_entourage@", "hi_dance_facedj_09_v2_male^5"}, mouvement = 1},
        {name = "Hey man", anim = {"anim@amb@nightclub@dancers@club_ambientpeds@", "mi-hi_amb_club_09_v1_male^1"}, mouvement = 1},
        {name = "Move 01", anim = {"anim@mp_player_intupperuncle_disco", "idle_a"}, mouvement = 1},
        {name = "Move 02", anim = {"anim@mp_player_intuppersalsa_roll", "idle_a"}, mouvement = 1},
        {name = "Move 03", anim = {"anim@mp_player_intupperraise_the_roof", "idle_a"}, mouvement = 1},
        {name = "Move 04", anim = {"anim@mp_player_intupperoh_snap", "idle_a"}, mouvement = 1},
        {name = "Move 05", anim = {"anim@mp_player_intupperheart_pumping", "idle_a"}, mouvement = 1},
        {name = "Move 06", anim = {"anim@mp_player_intupperfind_the_fish", "idle_a"}, mouvement = 1},
        {name = "Move 07", anim = {"anim@mp_player_intuppercats_cradle", "idle_a"}, mouvement = 1},
        {name = "Move 08", anim = {"anim@mp_player_intupperbanging_tunes", "idle_a"}, mouvement = 1},
        {name = "Move 09", anim = {"anim@mp_player_intupperbanging_tunes_right", "idle_a"}, mouvement = 1},
        {name = "Move 10", anim = {"anim@mp_player_intupperbanging_tunes_left", "idle_a"}, mouvement = 1},
        {name = "DJ", anim = {"anim@mp_player_intcelebrationmale@dj", "dj"}},
        {name = "Fausse guitare", anim = {"anim@mp_player_intcelebrationmale@air_guitar", "air_guitar"}},
        {name = "Mains Jazz", anim = {"anim@mp_player_intcelebrationfemale@jazz_hands", "jazz_hands"}},
        {name = "Rock'n roll", anim = {"anim@mp_player_intcelebrationmale@rock", "rock"}}
    },

    ["Insolentes"] = {
        {name = "Mort de rire", anim = {"anim@arena@celeb@flat@solo@no_props@", "giggle_a_player_a"}},
        {name = "Doigt dans le nez", anim = {"anim@mp_player_intcelebrationmale@nose_pick", "nose_pick"}},
        {name = "Doigt d'honneur 1", anim = {"anim@mp_player_intcelebrationmale@finger", "finger"}},
        {name = "Doigt d'honneur 2", anim = {"random@shop_gunstore", "_negative_goodbye"}},
        {name = "Doigt d'honneur 3", anim = {"mp_player_int_upperfinger", "mp_player_int_finger_01"}, mouvement = 49},
        {name = "Nananère", anim = {"anim@mp_player_intcelebrationmale@thumb_on_ears", "thumb_on_ears"}},
        {name = "DTC", anim = {"anim@mp_player_intcelebrationmale@dock", "dock"}},
        {name = "Chuuuuute", anim = {"anim@mp_player_intcelebrationmale@shush", "shush"}},
        {name = "Poule Mouillé", anim = {"anim@mp_player_intcelebrationmale@chicken_taunt", "chicken_taunt"}},
        {name = "Uriner", anim = {"misscarsteal2peeing", "peeing_intro"}},
        {name = "Se gratter le cul", anim = {"mp_player_int_upperarse_pick", "mp_player_int_arse_pick"}, mouvement = 49},
        {name = "Se gratter les couilles", anim = {"mp_player_int_uppergrab_crotch", "mp_player_int_grab_crotch"}, mouvement = 49},
        {name = "Pluie de fric", anim = {"anim@arena@celeb@flat@solo@props@", "make_it_rain_b_player_b"}},
        {name = "Pluie de fric 2", anim = {"anim@mp_player_intcelebrationmale@raining_cash", "raining_cash"}}
    },

    ["Animations Sexy"] = {
        {name = "Fellation", anim = {"misscarsteal2pimpsex", "pimpsex_hooker"}},
        {name = "Se faire sucer 01", anim = {"misscarsteal2pimpsex", "pimpsex_pimp"}},
        {name = "Se faire sucer 02", anim = {"misscarsteal2pimpsex", "pimpsex_punter"}},
        {name = "Danse sexy", anim = {"mp_safehouse", "lap_dance_girl"}},
        {name = "Danse Twerk", anim = {"mini@strip_club@private_dance@part3", "priv_dance_p3"}},
        {name = "Montrer sa poitrine", anim = {"mini@strip_club@backroom@", "stripper_b_backroom_idle_b"}},
        {name = "Montrer ses fesses", anim = {"switch@trevor@mocks_lapdance", "001443_01_trvs_28_idle_stripper"}, mouvement = 49},
        {name = "Etrangler", anim = {"mini@prostitutes@sexlow_veh", "low_car_sex_loop_player"}, mouvement = 49},
        {name = "Mon coeur", anim = {"mini@hookers_spvanilla", "idle_a"}}
    },

    ["Danses"] = {
        {name = "Danser", anim = {"misschinese2_crystalmazemcs1_cs", "dance_loop_tao"}},
        {name = "Danser stylé", anim = {"missfbi3_sniping", "dance_m_default"}, mouvement = 1},
        {name = "Danse banale", anim = {"rcmnigel1bnmt_1b", "dance_loop_tyler"}, mouvement = 1},
        {name = "Danse spéciale 01", anim = {"timetable@tracy@ig_5@idle_a", "idle_a"}, mouvement = 1},
        {name = "Danse spéciale 02", anim = {"timetable@tracy@ig_5@idle_a", "idle_b"}, mouvement = 1},
        {name = "Danse spéciale 03", anim = {"timetable@tracy@ig_5@idle_b", "idle_e"}, mouvement = 1},
        {name = "Danse spéciale 04", anim = {"timetable@tracy@ig_5@idle_b", "idle_d"}, mouvement = 1},
        {name = "Danse de pecno", anim = {"special_ped@mountain_dancer@monologue_3@monologue_3a", "mnt_dnc_buttwag"}, mouvement = 1},
        {name = "Danse basique", anim = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_hi_06_base_laz"}, mouvement = 1},
        {name = "Danse turnaround", anim = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_hi_11_turnaround_laz"}, mouvement = 1},
        {name = "Danse crotchgrab", anim = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_hi_13_crotchgrab_laz"}, mouvement = 1},
        {name = "Danse flying", anim = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_hi_13_flyingv_laz"}, mouvement = 1},
        {name = "Danse robot", anim = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_mi_15_robot_laz"}, mouvement = 1},
        {name = "Danse shimmy", anim = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_mi_15_shimmy_laz"}, mouvement = 1},
        {name = "Danse crazyrobot", anim = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_hi_15_crazyrobot_laz"}, mouvement = 1},
        {name = "Danse smack", anim = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_hi_17_smackthat_laz"}, mouvement = 1},
        {name = "Danse spider", anim = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_hi_17_spiderman_laz"}, mouvement = 1},
        {name = "Danse hipswivel", anim = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_li_13_hipswivel_laz"}, mouvement = 1},
        {name = "Danse Grind", anim = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_li_15_sexygrind_laz"}, mouvement = 1},
        {name = "Danse point", anim = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_mi_11_pointthrust_laz"}, mouvement = 1},
        {name = "Danse miturn", anim = {"anim@amb@nightclub@lazlow@hi_podium@", "danceidle_mi_13_turnaround_laz"}, mouvement = 1},
        {name = "Danse du ventre", anim = {"mini@strip_club@private_dance@idle", "priv_dance_idle"}, mouvement = 1},
        {name = "Dance Salsa Roll", anim = {"anim@mp_player_intcelebrationmale@salsa_roll", "salsa_roll"}, mouvement = 1},
        {name = "Danse de soirée 1", anim = {"anim@amb@nightclub@dancers@crowddance_facedj@", "hi_dance_facedj_09_v1_male^4"}, mouvement = 1},
        {name = "Danse de soirée 2", anim = {"anim@amb@nightclub@dancers@crowddance_facedj@", "hi_dance_facedj_09_v2_female^1"}, mouvement = 1},
        {name = "Danse de soirée 3", anim = {"anim@amb@nightclub@dancers@crowddance_facedj@", "hi_dance_facedj_09_v2_female^2"}, mouvement = 1},
        {name = "Danse de soirée 4", anim = {"anim@amb@nightclub@dancers@crowddance_facedj@", "hi_dance_facedj_09_v2_male^2"}, mouvement = 1},
        {name = "Danse de soirée 5", anim = {"anim@amb@nightclub@dancers@crowddance_facedj@", "hi_dance_facedj_11_v2_male^2"}, mouvement = 1},
        {name = "Danse de soirée 6", anim = {"anim@amb@nightclub@dancers@crowddance_groups@", "hi_dance_crowd_09_v1_female^1"}, mouvement = 1},
        {name = "Danse de soirée 7", anim = {"anim@amb@nightclub@dancers@crowddance_groups@", "hi_dance_crowd_09_v1_female^3"}, mouvement = 1},
        {name = "Danse de soirée 8", anim = {"anim@amb@nightclub@djs@black_madonna@", "dance_b_idle_a_blamadon"}, mouvement = 1},
        {name = "Danse de soirée 9", anim = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center"}, mouvement = 1},
        {name = "Danse festive 1", anim = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "med_center"}, mouvement = 1},
        {name = "Danse festive 2", anim = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "high_center_up"}, mouvement = 1},
        {name = "Danse festive 3", anim = {"anim@amb@nightclub@dancers@solomun_entourage@", "mi_dance_facedj_17_v1_female^1"}, mouvement = 1},
        {name = "Danse festive 4", anim = {"anim@amb@nightclub@dancers@podium_dancers@", "hi_dance_facedj_17_v2_male^5"}, mouvement = 1},
        {name = "Danse festive 5", anim = {"anim@amb@nightclub@dancers@crowddance_groups@", "mi_dance_crowd_17_v1_female^6"}, mouvement = 1},
        {name = "Danse festive 6", anim = {"anim@amb@nightclub@dancers@crowddance_groups@", "mi_dance_crowd_17_v2_female^1"}, mouvement = 1},
        {name = "Danse festive 7", anim = {"anim@amb@nightclub@dancers@crowddance_groups@", "mi_dance_crowd_13_v2_male^4"}, mouvement = 1},
        {name = "Dance Disco", anim = {"anim@mp_player_intcelebrationmale@uncle_disco", "uncle_disco"}, mouvement = 1}
    },
    
    ["Armes"] = {
        {name = "Animation execution", anim = {"oddjobs@suicide", "bystander_pointinto"}, mouvement = 50},
        {name = "Animation suicide", anim = {"mp_suicide", "pistol"}, mouvement = 2},
        {name = "Check arme", anim = {"mp_corona@single_team", "single_team_intro_one"}},
        {name = "Arme pointé", anim = {"random@arrests", "cop_gunaimed_door_open_idle"}},
        {name = "Melée 1", anim = {"anim@deathmatch_intros@melee@2h", "intro_male_melee_2h_b"}},
        {name = "Melée 2", anim = {"anim@deathmatch_intros@melee@1h", "intro_male_melee_1h_b"}},
        {name = "Melée 3", anim = {"anim@deathmatch_intros@melee@1h", "intro_male_melee_1h_c"}},
        {name = "Melée 4", anim = {"mp_deathmatch_intros@melee@2h", "intro_male_melee_2h_d"}},
        {name = "Melée 5", anim = {"mp_deathmatch_intros@melee@2h", "intro_male_melee_2h_a_gclub"}},
        {name = "Melée 6", anim = {"mp_deathmatch_intros@melee@1h", "intro_male_melee_1h_b"}},
        {name = "Fight 1", anim = {"anim@deathmatch_intros@unarmed", "intro_male_unarmed_e"}},
        {name = "Fight 2", anim = {"anim@deathmatch_intros@unarmed", "intro_male_unarmed_d"}},
        {name = "Fight 3", anim = {"anim@deathmatch_intros@unarmed", "intro_male_unarmed_b"}}
    }
}

local ListeDemarches = {
    {name = "Normale"},
    {name = "Gangster 1", dict = "move_f@gangster@ng"},
    {name = "Gangster 2", dict = "move_m@fire"},
    {name = "Gangster 3", dict = "move_m@gangster@generic"},
    {name = "Gangster 4", dict = "move_m@gangster@ng"},
    {name = "Apeuré", dict = "move_f@scared@"},
    {name = "Sexy", dict = "move_f@sexy@a"},
    {name = "Efféminé 1", dict = "move_f@tough_guy@"},
    {name = "Efféminé 2", dict = "move_m@confident"},
    {name = "Efféminé 3", dict = "move_m@femme@"},
    {name = "Efféminé 4", dict = "move_m@sassy"},
    {name = "Clochard 2", dict = "move_m@buzzed"},
    {name = "Brave 1", dict = "move_m@brave"},
    {name = "Brave 2", dict = "move_m@brave@a"},
    {name = "Bravo 3", dict = "move_m@brave@b"},
    {name = "Casu 1", dict = "move_m@casual@a"},
    {name = "Casu 2", dict = "move_m@casual@b"},
    {name = "Casu 3", dict = "move_m@casual@c"},
    {name = "Casu 4", dict = "move_m@casual@d"},
    {name = "Casu 5", dict = "move_m@casual@e"},
    {name = "Casu 6", dict = "move_m@casual@f"},
    {name = "Casu 7", dict = "move_m@fat@"},
    {name = "Déprimé", dict = "move_m@depressed@a"},
    {name = "Bourré 1", dict = "move_m@drunk@moderatedrunk"},
    {name = "Bourré 2", dict = "move_m@drunk@slightlydrunk"},
    {name = "Bourré 3", dict = "move_m@drunk@verydrunk"},
    {name = "Hipster", dict = "move_m@hipster@a"},
    {name = "Pressé 1", dict = "move_m@hurry_butch@c"},
    {name = "Blessé", dict = "move_m@injured"},
    {name = "Jogging 1", dict = "move_m@jog@"},
    {name = "Riche", dict = "move_m@money"},
    {name = "Musclé", dict = "move_m@muscle@"},
    {name = "Non chalant", dict = "ove_m@non_chalant"},
    {name = "Hautain", dict = "move_m@posh@"},
    {name = "Coincé", dict = "move_m@quick"},
    {name = "Triste 1", dict = "move_m@sad@a"},
    {name = "Triste 2", dict = "move_m@sad@b"},
    {name = "Triste 3", dict = "move_m@sad@c"},
    {name = "Triste 4", dict = "move_m@leaf_blower"},
    {name = "Efféminé 5", dict = "move_m@sassy"},
    {name = "Shady 1", dict = "move_m@shadyped@a"},
    {name = "Swag 1", dict = "move_m@swagger"},
    {name = "Swag 2", dict = "move_m@swagger@b"},
    {name = "Brute", dict = "move_m@tough_guy@"},
    {name = "Franklin 1", dict = "move_p_m_one"},
    {name = "Trevor 1", dict = "move_p_m_two"},
    {name = "Michael 1", dict = "move_p_m_zero"},
    {name = "Lent", dict = "move_p_m_zero_slow"},
    {name = "Jimmy 1", dict = "move_characters@jimmy@slow@"},
    {name = "Dave", dict = "move_characters@dave_n@core"},
    {name = "Grooving F1", dict = "anim@move_f@grooving@slow@"},
    {name = "Grooving F2", dict = "anim@move_f@grooving@"},
    {name = "Grooving H1", dict = "anim@move_m@grooving@"},
    {name = "Grooving H2", dict = "anim@move_m@grooving@slow@"}
}

local ListeHumeurs = {
    {name = "Normale"},
    {name = "Blessé", dict = "mood_injured_1"},
    {name = "Chic", dict = "mood_smug_1"},
    {name = "Colère", dict = "mood_angry_1"},
    {name = "Concentration", dict = "mood_aiming_1"},
    {name = "Dormir", dict = "mood_sleeping_1"},
    {name = "Heureux", dict = "mood_happy_1"},
    {name = "Triste", dict = "mood_sulk_1"},
    {name = "Soul", dict = "mood_drunk_1"},
    {name = "Stressé", dict = "mood_stressed_1"}
}

local InteractionMenu = {
    Select = {
        "Avant Gauche",
        "Avant Droite",
        "Arrière Gauche",
        "Arrière Droite",
        "Coffre",
        "Capot",
        FrontLeft = false,
        FrontRight = false,
        BackLeft = false,
        BackRight = false,
        Hood = false,
        Trunk = false,
    },
    Select2 = {
        "Avant Gauche",
        "Avant Droite",
        "Arrière Gauche",
        "Arrière Droite",
        FrontLeft2 = false,
        FrontRight2 = false,
        BackLeft2 = false,
        BackRight2 = false,
    },
    NumLim = {"50", "80", "100", "130", "Aucun"},
    Index = 1,
    Index2 = 1,
    IndexLim = 1,
    IndexCheckbox = false,
    IndexCheckbox2 = false,
    IndexCheckbox3 = true,
    CheckboxService = false,

    Animation = {},
    AnimIndex = 1,
    BindIndex = 1,
    BindIndex2 = 1,
    AnimCategorie = {},
    AnimCategorieIndex = 1,
    FactureIndex = 1,

    GetPermSellVehicle = {},
    GetVehicleCrew = {},
    GetVehicleJob = {},
    GetVehiclePerso = {},
    GetVehiclePret = {},
    GetInventory = {},
}

InteractionMenu.openedMenu = false
InteractionMenu.mainMenu = RageUI.CreateMenu("Interaction", "Interaction")
InteractionMenu.subMenuVeh = RageUI.CreateSubMenu(InteractionMenu.mainMenu, "Gestion Véhicule", "Véhicule")
InteractionMenu.subKeyMenuVeh = RageUI.CreateSubMenu(InteractionMenu.mainMenu, "Gestion Clés", "Véhicule")
InteractionMenu.subKeyCrewMenu = RageUI.CreateSubMenu(InteractionMenu.subKeyMenuVeh, "Gestion Clés", "Crew")
InteractionMenu.subGiveKeyMenu = RageUI.CreateSubMenu(InteractionMenu.subKeyMenuVeh, "Gestion Clés", "Crew")
InteractionMenu.subKeyJobMenu = RageUI.CreateSubMenu(InteractionMenu.subKeyMenuVeh, "Gestion Clés", "Métier")
InteractionMenu.subKeyPersoMenu = RageUI.CreateSubMenu(InteractionMenu.subKeyMenuVeh, "Gestion Clés", "Personnel")
InteractionMenu.subKeyPretMenu = RageUI.CreateSubMenu(InteractionMenu.subKeyMenuVeh, "Liste des clés prêtés", "Personnel")
InteractionMenu.subMenuDivers = RageUI.CreateSubMenu(InteractionMenu.mainMenu, "Divers", "Confirmation")
InteractionMenu.subMenuConfirm = RageUI.CreateSubMenu(InteractionMenu.subMenuDivers, "Divers", "Divers")
InteractionMenu.subMenuAnim = RageUI.CreateSubMenu(InteractionMenu.mainMenu, "Animations", "Animations")
InteractionMenu.subMenuListeAnim = RageUI.CreateSubMenu(InteractionMenu.subMenuAnim, "Animations", "Animations")
InteractionMenu.subMenuListeDemarche = RageUI.CreateSubMenu(InteractionMenu.subMenuAnim, "Animations", "Animations")
InteractionMenu.subMenuListeHumeur = RageUI.CreateSubMenu(InteractionMenu.subMenuAnim, "Animations", "Animations")
InteractionMenu.subMenuActionAnim = RageUI.CreateSubMenu(InteractionMenu.subMenuListeAnim, "Animations", "Animations")
InteractionMenu.subMenuActions = RageUI.CreateSubMenu(InteractionMenu.subMenuAnim, "Actions", "Actions")

InteractionMenu.mainMenu.Closed = function()
    InteractionMenu.openedMenu = false
end

function openInteractionMenu()
    if not RageUI.GetInMenu() then
        return
    end
    if InteractionMenu.openedMenu then
        InteractionMenu.openedMenu = false
        RageUI.Visible(InteractionMenu.mainMenu, false)
    else
        InteractionMenu.openedMenu = true
        RageUI.Visible(InteractionMenu.mainMenu, true)
            CreateThread(function()
                while InteractionMenu.openedMenu do
                    RageUI.IsVisible(InteractionMenu.mainMenu, function()
                        RageUI.Button("Animations", nil, {RightLabel = "→"}, true, {}, InteractionMenu.subMenuAnim)
                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            RageUI.Button("Gestion Véhicule", nil, {RightLabel = "→"}, true, {}, InteractionMenu.subMenuVeh)
                        else
                            RageUI.Button("Gestion Véhicule", nil, {RightLabel = "→"}, false, {})
                        end
                        RageUI.Button("Gestion Clés", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback("GetPermSellVehicle", function(cb)
                                    InteractionMenu.GetPermSellVehicle = cb
                                end)
                                Wait(50)
                                RageUI.CloseAll()
                                RageUI.Visible(InteractionMenu.subKeyMenuVeh, true)
                            end
                        })
                        RageUI.Button("Divers", nil, {RightLabel = "→"}, true, {}, InteractionMenu.subMenuDivers)
                        RageUI.Button("Actions", nil, {RightLabel = "→"}, true, {}, InteractionMenu.subMenuActions)
                    end)

                    RageUI.IsVisible(InteractionMenu.subMenuActions, function()
                        RageUI.List("Facture", {{Name = "Personnel"}, {Name = "Entreprise"}}, InteractionMenu.FactureIndex, nil, {}, true, {
                            onListChange = function(Index)
                                InteractionMenu.FactureIndex = Index;
                            end,
                            onSelected = function(Index)
                                if Index == 1 then 
                                    ExecuteCommand('facture personnel')
                                elseif Index == 2 then 
                                    ExecuteCommand('facture entreprise')
                                end
                            end
                        })
                        if PlayerData.job and PlayerData.job.name == 'realestateagent' or PlayerData.job.name == 'unicorn' or PlayerData.job.name == 'thepalace' or PlayerData.job.name == 'bahama' or PlayerData.job.name == 'police' or PlayerData.job.name == 'usss' or PlayerData.job.name == 'mayansmotors' or PlayerData.job.name == 'bennys' or PlayerData.job.name == 'fdmotors' or PlayerData.job.name == 'cayom' or PlayerData.job.name == 'lscustoms' or PlayerData.job.name == 'sandybennys' or PlayerData.job.name == 'harmonyrepair' or PlayerData.job.name == 'grimmotors' or PlayerData.job.name == 'ems' or PlayerData.job.name == 'pawnshop' or PlayerData.job.name == "pawnnord" or PlayerData.job.name == 'pharma' then
                            RageUI.Checkbox("Service", false, InteractionMenu.CheckboxService, {}, {
                                onChecked = function()
                                    ESX.Notification("Vous avez ~g~activé~s~ votre service.")
                                    if PlayerData.job and PlayerData.job.name == 'police' then
                                        TriggerServerEvent("player:serviceOn", "police")
                                    end
                                    if PlayerData.job and PlayerData.job.name == 'usss' then
                                        TriggerServerEvent("player:serviceOn", "usss")
                                    end
                                    if PlayerData.job and PlayerData.job.name == 'pawnshop' or PlayerData.job.name == 'pawnnord' or PlayerData.job.name == 'unicorn' or PlayerData.job.name == 'thepalace' or PlayerData.job.name == 'bahama' then
                                        onChecked = true
                                    end
                                    if PlayerData.job and PlayerData.job.name == 'ems' then
                                        TriggerServerEvent("player:serviceOn", "ems")
                                    end
                                    if PlayerData.job and PlayerData.job.name == 'pharma' then
                                        TriggerServerEvent("player:serviceOn", "pharma")
                                    end
                                end,
                                onUnChecked = function()
                                    ESX.Notification("Vous avez ~r~désactivé~s~ votre service.")
                                    if PlayerData.job and PlayerData.job.name == 'police' then
                                        TriggerServerEvent("player:serviceOff", "police")
                                    end
                                    if PlayerData.job and PlayerData.job.name == 'usss' then
                                        TriggerServerEvent("player:serviceOff", "usss")
                                    end
                                    if PlayerData.job and PlayerData.job.name == 'pawnshop' or PlayerData.job.name == 'pawnnord' or PlayerData.job.name == 'unicorn' or PlayerData.job.name == 'thepalace' or PlayerData.job.name == 'bahama' then
                                        onChecked = false
                                    end
                                    if PlayerData.job and PlayerData.job.name == 'ems' then
                                        TriggerServerEvent("player:serviceOff", "ems")
                                    end
                                    if PlayerData.job and PlayerData.job.name == 'pharma' then
                                        TriggerServerEvent("player:serviceOff", "pharma")
                                    end
                                end,
                                onSelected = function(Index)
                                    InteractionMenu.CheckboxService = Index
                                end
                            })
                        else
                            RageUI.Button("Service", nil, {RightLabel = "→"}, false, {})
                        end
                        if onChecked then
                            RageUI.Button("Annonce", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local input = ESX.KeyboardInput("Annonce", 50)
                                    if input ~= nil and #input > 5 then
                                        if PlayerData.job and PlayerData.job.name == 'pawnnord' or PlayerData.job.name == 'pawnshop' then
                                            TriggerServerEvent("annoncePawnShop", input)
                                        elseif PlayerData.job and PlayerData.job.name == 'unicorn' then
                                            TriggerServerEvent("annonceUnicorn", input)
                                        elseif PlayerData.job and PlayerData.job.name == 'bahama' then
                                            TriggerServerEvent("annonceBahama", input)
                                        elseif PlayerData.job and PlayerData.job.name == 'thepalace' then
                                            TriggerServerEvent("annonceThePalace", input)
                                        end
                                    end
                                end
                            })
                        end
                    end)

                    RageUI.IsVisible(InteractionMenu.subMenuAnim, function()
                        RageUI.Button("Démarches", nil, {RightLabel = "→"}, true, {}, InteractionMenu.subMenuListeDemarche)
                        RageUI.Button("Humeurs", nil, {RightLabel = "→"}, true, {}, InteractionMenu.subMenuListeHumeur)
                        RageUI.Separator("-------------------------------------")
                        RageUI.Button("S'asseoir", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                Categorie = "S'asseoir"
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(InteractionMenu.subMenuListeAnim, true)
                            end
                        })
                        RageUI.Button("Divers", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                Categorie = "Divers"
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(InteractionMenu.subMenuListeAnim, true)
                            end
                        })
                        RageUI.Button("Gestures", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                Categorie = "Gestures"
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(InteractionMenu.subMenuListeAnim, true)
                            end
                        })
                        RageUI.Button("Expressions", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                Categorie = "Expressions"
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(InteractionMenu.subMenuListeAnim, true)
                            end
                        })
                        RageUI.Button("Poses", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                Categorie = "Poses"
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(InteractionMenu.subMenuListeAnim, true)
                            end
                        })
                        RageUI.Button("Festives", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                Categorie = "Festives"
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(InteractionMenu.subMenuListeAnim, true)
                            end
                        })
                        RageUI.Button("Insolentes", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                Categorie = "Insolentes"
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(InteractionMenu.subMenuListeAnim, true)
                            end
                        })
                        RageUI.Button("Animations Sexy", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                Categorie = "Animations Sexy"
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(InteractionMenu.subMenuListeAnim, true)
                            end
                        })
                        RageUI.Button("Danses", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                Categorie = "Danses"
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(InteractionMenu.subMenuListeAnim, true)
                            end
                        })
                        RageUI.Button("Armes", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                Categorie = "Armes"
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(InteractionMenu.subMenuListeAnim, true)
                            end
                        })
                    end) 

                    RageUI.IsVisible(InteractionMenu.subMenuListeDemarche, function()
                        for i = 1, #ListeDemarches do
                            RageUI.Button(ListeDemarches[i].name, nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    Dict = ListeDemarches[i].dict

                                    ESX.Notification("Vous avez choisi ~b~"..ListeDemarches[i].name.."~s~ comme démarche par défaut.")
                                    if Dict then
                                        RequestAnimSet(Dict)
                                        while not HasAnimSetLoaded(Dict) do
                                            Citizen.Wait(100)
                                        end
                                        SetPedMovementClipset(PlayerPedId(), Dict, 0)
                                        ESX.SetFieldValueFromNameEncode("OfflineDemarche", Dict)
                                    else
                                        ResetPedMovementClipset(PlayerPedId(), 0)
                                        ESX.SetFieldValueFromNameEncode("OfflineDemarche", nil)
                                    end
                                end
                            })
                        end
                    end)

                    RageUI.IsVisible(InteractionMenu.subMenuListeHumeur, function()
                        for i = 1, #ListeHumeurs do
                            RageUI.Button(ListeHumeurs[i].name, nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    Dict = ListeHumeurs[i].dict

                                    ESX.Notification("Vous avez choisi ~b~"..ListeHumeurs[i].name.."~s~ comme humeur par défaut.")
                                    if Dict then
                                        SetFacialIdleAnimOverride(PlayerPedId(), Dict, 0)
                                        ESX.SetFieldValueFromNameEncode("OfflineHumeur", Dict)
                                    else
                                        ResetPedMovementClipset(PlayerPedId(), 0)
                                        ESX.SetFieldValueFromNameEncode("OfflineHumeur", nil)
                                    end
                                end
                            })
                        end
                    end)

                    RageUI.IsVisible(InteractionMenu.subMenuListeAnim, function()
                        if Categorie then
                            for i = 1, #ListeAnimations[Categorie] do
                                RageUI.Button(ListeAnimations[Categorie][i].name, nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        DictAnim = ListeAnimations[Categorie][i].anim[1]
                                        PlayAnim = ListeAnimations[Categorie][i].anim[2]
                                        MouvAnim = ListeAnimations[Categorie][i].mouvement
                                        LabelAnim = ListeAnimations[Categorie][i].name
                                    end
                                }, InteractionMenu.subMenuActionAnim)
                            end
                        end   
                    end)

                    RageUI.IsVisible(InteractionMenu.subMenuActionAnim, function()
                        if DictAnim and PlayAnim and LabelAnim then
                            RageUI.Button("Jouer l'animation", nil, {}, true, {
                                onSelected = function()
                                    if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                                        if not IsEntityPlayingAnim(PlayerPedId(), DictAnim, PlayAnim, 3) then
                                            if PlayAnim and not HasAnimDictLoaded(DictAnim) then
                                                if DoesAnimDictExist(DictAnim) then
                                                    RequestAnimDict(DictAnim)
                                                    while not HasAnimDictLoaded(DictAnim) do
                                                        Citizen.Wait(10)
                                                    end
                                                end
                                            end
                                            if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_unarmed") then
                                                ClearPedTasks(PlayerPedId())
                                                TaskPlayAnim(PlayerPedId(), DictAnim, PlayAnim, 8.0, 8.0, -1, MouvAnim or 0, 1, 0, 0, 0)
                                            end
                                        else
                                            ClearPedTasks(PlayerPedId())
                                        end
                                    end
                                end
                            })
                            RageUI.Button("Annuler l'animation", nil, {}, true, {
                                onSelected = function()
                                    ClearPedTasks(PlayerPedId())
                                end
                            })
                            RageUI.List("Bind l'Animation", {"Touche 0", "Touche 1", "Touche 2", "Touche 3", "Touche 4", "Touche 5", "Touche 6", "Touche 7", "Touche 8", "Touche 9"}, InteractionMenu.BindIndex, nil, {}, true, {
                                onListChange = function(Index)
                                    InteractionMenu.BindIndex = Index
                                end,

                                onSelected = function(Index)
                                    local BindAnim = {name = DictAnim, anim = PlayAnim, mouv = MouvAnim}
                                    ESX.SetFieldValueFromNameEncode("OfflineBind"..Index-1, BindAnim)
                                    ESX.ShowNotification("Vous avez bind l'animation ~b~"..LabelAnim.."~s~ sur la Touche ~b~"..(Index-1).."~s~.")
                                end,
                            })
                            RageUI.List("Supprimer l'animation", {"Touche 0", "Touche 1", "Touche 2", "Touche 3", "Touche 4", "Touche 5", "Touche 6", "Touche 7", "Touche 8", "Touche 9"}, InteractionMenu.BindIndex2, nil, {}, true, {
                                onListChange = function(Index)
                                    InteractionMenu.BindIndex2 = Index
                                end,

                                onSelected = function(Index)
                                    ESX.SetFieldValueFromNameEncode("OfflineBind"..Index-1, nil)
                                    ESX.ShowNotification("Vous avez supprimer l'animation de la touche ~b~"..(Index-1).."~s~.")
                                end,
                            })
                        end
                    end)
                    
                    RageUI.IsVisible(InteractionMenu.subMenuVeh, function()
                        RageUI.List("Limiteur de vitesse", InteractionMenu.NumLim, InteractionMenu.IndexLim, nil, {}, true, {
                            onListChange = function(Index)
                                InteractionMenu.IndexLim = Index;
                            end,
                            
                            onSelected = function(Index)
                                ped = GetPlayerPed(-1)
                                pedCar = GetVehiclePedIsIn(ped, false)
                                if Index == 1 then
                                    SetEntityMaxSpeed(pedCar, 13.8)
                                elseif Index == 2 then
                                    SetEntityMaxSpeed(pedCar, 22.0)
                                elseif Index == 3 then
                                    SetEntityMaxSpeed(pedCar, 27.7)
                                elseif Index == 4 then
                                    SetEntityMaxSpeed(pedCar, 36.0)
                                elseif Index == 5 then
                                    SetEntityMaxSpeed(pedCar, 1000.0)                                    
                                end
                            end
                        })
                        RageUI.Button("Allumer/Eteindre", nil, {RightLabel = ""}, true, {
                            onSelected = function()
                                id = GetPlayerPed(-1)
                                vehicle = GetVehiclePedIsIn(id, false)
                                if GetIsVehicleEngineRunning(vehicle) then
                                    SetVehicleEngineOn(vehicle, false, false, true)
                                    SetVehicleUndriveable(vehicle, true)
                                elseif not GetIsVehicleEngineRunning(vehicle) then
                                    SetVehicleEngineOn(vehicle, true, false, true)
                                    SetVehicleUndriveable(vehicle, false)
                                end
                            end
                        })
                        RageUI.Checkbox("Conduite Auto", false, InteractionMenu.IndexCheckbox2, {}, {
                            onChecked = function()
                                local blip = GetFirstBlipInfoId(8)
                                if DoesBlipExist(blip) then
                                    local coords = GetBlipCoords(blip)
                                    Active = true
                                    TaskVehicleDriveToCoordLongrange(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), coords.x, coords.y, coords.z, 13.0, 447, 2.0)
                                end
                            end,
                            onUnChecked = function()
                                ClearPedTasks(PlayerPedId())
                                Active = false
                            end,

                            onSelected = function(Index)
                                InteractionMenu.IndexCheckbox2 = Index
                            end,
                        })
                        if Active then
                            local blipcoord = GetBlipCoords(GetFirstBlipInfoId(8))
                            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), blipcoord.x, blipcoord.y, blipcoord.z, true) <= 50.0 then 
                                InteractionMenu.IndexCheckbox2 = false
                                Active = false
                            end
                        end
                        RageUI.List("Porte", InteractionMenu.Select, InteractionMenu.Index, nil, {}, true, {
                            onListChange = function(Index)
                                InteractionMenu.Index = Index;
                            end,
                            
                            onSelected = function(Index)
                                if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                                elseif IsPedSittingInAnyVehicle(PlayerPedId()) then
                                    local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                    if Index == 1 then
                                        if not InteractionMenu.Select.FrontLeft then
                                            InteractionMenu.Select.FrontLeft = true
                                            SetVehicleDoorOpen(plyVeh, 0, false, false)
                                        elseif InteractionMenu.Select.FrontLeft then
                                            InteractionMenu.Select.FrontLeft = false
                                            SetVehicleDoorShut(plyVeh, 0, false, false)
                                        end
                                    elseif Index == 2 then
                                        if not InteractionMenu.Select.FrontRight then
                                            InteractionMenu.Select.FrontRight = true
                                            SetVehicleDoorOpen(plyVeh, 1, false, false)
                                        elseif InteractionMenu.Select.FrontRight then
                                            InteractionMenu.Select.FrontRight = false
                                            SetVehicleDoorShut(plyVeh, 1, false, false)
                                        end
                                    elseif Index == 3 then
                                        if not InteractionMenu.Select.BackLeft then
                                            InteractionMenu.Select.BackLeft = true
                                            SetVehicleDoorOpen(plyVeh, 2, false, false)
                                        elseif InteractionMenu.Select.BackLeft then
                                            InteractionMenu.Select.BackLeft = false
                                            SetVehicleDoorShut(plyVeh, 2, false, false)
                                        end
                                    elseif Index == 4 then
                                        if not InteractionMenu.Select.BackRight then
                                            InteractionMenu.Select.BackRight = true
                                            SetVehicleDoorOpen(plyVeh, 3, false, false)
                                        elseif InteractionMenu.Select.BackRight then
                                            InteractionMenu.Select.BackRight = false
                                            SetVehicleDoorShut(plyVeh, 3, false, false)
                                        end
                                    elseif Index == 5 then
                                        if not InteractionMenu.Select.Trunk then
                                            InteractionMenu.Select.Trunk = true
                                            SetVehicleDoorOpen(plyVeh, 5, false, false)
                                        elseif InteractionMenu.Select.Trunk then
                                            InteractionMenu.Select.Trunk = false
                                            SetVehicleDoorShut(plyVeh, 5, false, false)
                                        end
                                    elseif Index == 6 then
                                        if not InteractionMenu.Select.Hood then
                                            InteractionMenu.Select.Hood = true
                                            SetVehicleDoorOpen(plyVeh, 4, false, false)
                                        elseif InteractionMenu.Select.Hood then
                                            InteractionMenu.Select.Hood = false
                                            SetVehicleDoorShut(plyVeh, 4, false, false)
                                        end
                                    end
                                end
                            end
                        })
                        RageUI.List("Fenêtres", InteractionMenu.Select2, InteractionMenu.Index2, nil, {}, true, {
                            onListChange = function(Index)
                                InteractionMenu.Index2 = Index;
                            end,
                            
                            onSelected = function(Index)
                                local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                                elseif IsPedSittingInAnyVehicle(PlayerPedId()) then
                                    if Index == 1 then
                                        if not InteractionMenu.Select2.FrontLeft2 then
                                            InteractionMenu.Select2.FrontLeft2 = true
                                            RollDownWindow(plyVeh, 0)
                                        elseif InteractionMenu.Select2.FrontLeft2 then
                                            InteractionMenu.Select2.FrontLeft2 = false
                                            RollUpWindow(plyVeh, 0)
                                        end
                                    elseif Index == 2 then
                                        if not InteractionMenu.Select2.FrontRight2 then
                                            InteractionMenu.Select2.FrontRight2 = true
                                            RollDownWindow(plyVeh, 1)
                                        elseif InteractionMenu.Select2.FrontRight2 then
                                            InteractionMenu.Select2.FrontRight2 = false
                                            RollUpWindow(plyVeh, 1)
                                        end
                                    elseif Index == 3 then
                                        if not InteractionMenu.Select2.BackLeft2 then
                                            InteractionMenu.Select2.BackLeft2 = true
                                            RollDownWindow(plyVeh, 2)
                                        elseif InteractionMenu.Select2.BackLeft2 then
                                            InteractionMenu.Select2.BackLeft2 = false
                                            RollUpWindow(plyVeh, 2)
                                        end
                                    elseif Index == 4 then
                                        if not InteractionMenu.Select2.BackRight2 then
                                            InteractionMenu.Select2.BackRight2 = true
                                            RollDownWindow(plyVeh, 3)
                                        elseif InteractionMenu.Select2.BackRight2 then
                                            InteractionMenu.Select2.BackRight2 = false
                                            RollUpWindow(plyVeh, 3)
                                        end
                                    end
                                end
                            end
                        })
                        RageUI.Button("Vider Coffre", nil, {RightLabel = ""}, true, {})
                    end)

                    RageUI.IsVisible(InteractionMenu.subKeyMenuVeh, function()
                        if InteractionMenu.GetPermSellVehicle == true then
                            RageUI.Button("Véhicule Crew", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ESX.TriggerServerCallback("GetVehicleCrewPawn", function(cb)
                                        InteractionMenu.GetVehicleCrew = cb
                                    end)
                                    Wait(150)
                                    RageUI.CloseAll()
                                    RageUI.Visible(InteractionMenu.subKeyCrewMenu, true)
                                end
                            })
                        end
                        if PlayerData.job.grade_name == "boss" then
                            RageUI.Button("Véhicule Entreprise", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ESX.TriggerServerCallback("GetVehicleJobPawn", function(cb)
                                        InteractionMenu.GetVehicleJob = cb
                                    end, PlayerData.job.name)
                                    Wait(150)
                                    RageUI.CloseAll()
                                    RageUI.Visible(InteractionMenu.subKeyJobMenu, true)
                                end
                            })
                        end
                        RageUI.Button("Véhicule Personnel", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback("GetVehiclePersoPawn", function(cb)
                                    InteractionMenu.GetVehiclePerso = cb
                                end)
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(InteractionMenu.subKeyPersoMenu, true)
                            end
                        })
                    end)

                    RageUI.IsVisible(InteractionMenu.subKeyCrewMenu, function()
                        if #InteractionMenu.GetVehicleCrew >= 1 then
                            for k, v in pairs(InteractionMenu.GetVehicleCrew) do
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.model)), nil, {RightLabel = v.plate}, true, {
                                    onSelected = function()
                                        Type = "crew"
                                        Custom = v.custom 
                                        Model = v.model 
                                        Plate = v.plate
                                        print(Type)
                                        Wait(150)
                                        RageUI.CloseAll()
                                        RageUI.Visible(InteractionMenu.subGiveKeyMenu, true)
                                    end
                                })
                            end
                        else
                            RageUI.Separator("~r~Aucun véhicules")
                        end
                    end)

                    RageUI.IsVisible(InteractionMenu.subKeyJobMenu, function()
                        if #InteractionMenu.GetVehicleJob >= 1 then
                            for k, v in pairs(InteractionMenu.GetVehicleJob) do
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.model)), nil, {RightLabel = v.plate}, true, {
                                    onSelected = function()
                                        Type = "job"
                                        Custom = v.custom 
                                        Model = v.model 
                                        Plate = v.plate
                                    end
                                }, InteractionMenu.subGiveKeyMenu)
                            end
                        else
                            RageUI.Separator("~r~Aucun véhicules")
                        end
                    end)

                    RageUI.IsVisible(InteractionMenu.subKeyPersoMenu, function()
                        if #InteractionMenu.GetVehiclePerso >= 1 then
                            for k, v in pairs(InteractionMenu.GetVehiclePerso) do
                                RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.model)), nil, {RightLabel = v.plate}, true, {
                                    onSelected = function()
                                        Type = "perso"
                                        Model = v.model
                                        Custom = v.custom
                                        Plate = v.plate
                                    end
                                }, InteractionMenu.subGiveKeyMenu)
                            end
                        else
                            RageUI.Separator("~r~Aucun véhicules")
                        end
                    end)

                    RageUI.IsVisible(InteractionMenu.subGiveKeyMenu, function()
                        if Type == "job" and PlayerData.job.name == "pawnshop" or PlayerData.job.name == "pawnnord" then
                            RageUI.Button("Attribuer les clés en Crew", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local target = GetNearbyPlayer(2)
                                    local coords = GetEntityCoords(PlayerPedId())
                                    local vehicle, distance = ESX.Game.GetClosestVehicle(coords)
                                    if target then
                                        if distance < 3 then
                                            if GetVehicleNumberPlateText(vehicle) == Plate then
                                                TriggerServerEvent("giveCarSell", Custom, Model, Plate, GetPlayerServerId(target), "crew")
                                                RageUI.GoBack()
                                            else
                                                ESX.ShowNotification("~r~Vous devez être à côté du véhicule désiré.")
                                            end
                                        else
                                            ESX.ShowNotification("~r~Vous devez être à côté du véhicule désiré.")
                                        end
                                    end
                                end
                            })
                            RageUI.Button("Attribuer les clés en Métier", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local target = GetNearbyPlayer(2)
                                    local coords = GetEntityCoords(PlayerPedId())
                                    local vehicle, distance = ESX.Game.GetClosestVehicle(coords)
                                    if target then
                                        if distance < 3 then
                                            if GetVehicleNumberPlateText(vehicle) == Plate then
                                                TriggerServerEvent("giveCarSell", Custom, Model, Plate, GetPlayerServerId(target), "job")
                                                RageUI.GoBack()
                                            else
                                                ESX.ShowNotification("~r~Vous devez être à côté du véhicule désiré.")
                                            end
                                        else
                                            ESX.ShowNotification("~r~Vous devez être à côté du véhicule désiré.")
                                        end
                                    end
                                end
                            })
                            RageUI.Button("Attribuer les clés en Personnel", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local target = GetNearbyPlayer(2)
                                    local coords = GetEntityCoords(PlayerPedId())
                                    local vehicle, distance = ESX.Game.GetClosestVehicle(coords)
                                    if target then
                                        if distance < 3 then
                                            if GetVehicleNumberPlateText(vehicle) == Plate then
                                                TriggerServerEvent("giveCarSell", Custom, Model, Plate, GetPlayerServerId(target), "perso")
                                                RageUI.GoBack()
                                            else
                                                ESX.ShowNotification("~r~Vous devez être à côté du véhicule désiré.")
                                            end
                                        else
                                            ESX.ShowNotification("~r~Vous devez être à côté du véhicule désiré.")
                                        end
                                    end
                                end
                            })
                        else
                            RageUI.Button("Vendre le véhicule", "Appuyez sur [~b~ENTRER~s~] pour vendre le véhicule à un employé du Pawn Shop.", {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local target = GetNearbyPlayer(2)
                                    local coords = GetEntityCoords(PlayerPedId())
                                    local vehicle, distance = ESX.Game.GetClosestVehicle(coords)
                                    if target then
                                        if distance < 3 then
                                            if GetVehicleNumberPlateText(vehicle) == Plate then
                                                TriggerServerEvent("givecarKey", Custom, Model, Plate, GetPlayerServerId(target), Type)
                                                RageUI.GoBack()
                                            else
                                                ESX.ShowNotification("~r~Vous devez être à côté du véhicule désiré.")
                                            end
                                        else
                                            ESX.ShowNotification("~r~Vous devez être à côté du véhicule désiré.")
                                        end
                                    end
                                end
                            })
                        end
                        if Type == "perso" then
                            RageUI.Button("Prêter un double des clés", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local target = GetNearbyPlayer(2)
                                    if target then
                                        TriggerServerEvent("lendcarKey", Plate, GetPlayerServerId(target))
                                        RageUI.GoBack()
                                    end
                                end
                            })
                            RageUI.Button("Liste des clés prêtés", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ESX.TriggerServerCallback("GetVehiclePret", function(cb)
                                        InteractionMenu.GetVehiclePret = cb
                                    end, Plate)
                                    Wait(150)
                                    RageUI.CloseAll()
                                    RageUI.Visible(InteractionMenu.subKeyPretMenu, true)
                                end
                            })
                        end
                    end)

                    RageUI.IsVisible(InteractionMenu.subKeyPretMenu, function()
                        for k,v in pairs(InteractionMenu.GetVehiclePret) do
                            RageUI.Button(v.label, "Appuyez [~b~ENTRER~s~] pour retirer les clés à la personne.", {RightLabel = v.plate}, true, {
                                onSelected = function()
                                    if v.identifier ~= ESX.PlayerData.identifier then
                                        TriggerServerEvent("retraitKey", v.identifier, Plate)
                                        RageUI.GoBack()
                                    else
                                        ESX.ShowNotification("~r~Vous ne pouvez pas supprimer votre paire de clés.")
                                    end
                                end
                            })
                        end
                    end)

                    RageUI.IsVisible(InteractionMenu.subMenuDivers, function()
                        RageUI.Checkbox("Mode cinématique", false, InteractionMenu.IndexCheckbox, {}, {
                            onChecked = function()
                                TriggerEvent("ShowCine")
                                DisplayRadar(false)
                            end,
                            onUnChecked = function()
                                IsCine = false
                                TriggerServerEvent('getgps')
                            end,

                            onSelected = function(Index)
                                InteractionMenu.IndexCheckbox = Index
                            end
                        })
                        RageUI.Checkbox("Afficher l'hud", false, InteractionMenu.IndexCheckbox3, {}, {
                            onChecked = function()
                                TriggerEvent('esx_status:setDisplay', 10.0)
                            end,
                            onUnChecked = function()
                                TriggerEvent('esx_status:setDisplay', 0.0)
                            end,

                            onSelected = function(Index)
                                InteractionMenu.IndexCheckbox3 = Index
                            end
                        })
                        RageUI.Button("Rockstar Editor", nil, {RightLabel = "→"}, true, {
                        }, InteractionMenu.subMenuConfirm)
                    end)
                    RageUI.IsVisible(InteractionMenu.subMenuConfirm, function()
                        RageUI.Button("~g~Oui", "~r~Attention~s~ cela va vous faire quitter le serveur.", {RightLabel = "→"}, true, {
                            onSelected = function()
                                ExecuteCommand('rockstar')
                            end
                        })
                        RageUI.Button("~r~Non", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                RageUI.GoBack()
                            end
                        })
                    end)
                Wait(1)
            end
        end)
    end
end

Keys.Register("F5", "F5", "Open Interact Menu", openInteractionMenu)

RegisterNetEvent("ShowCine")
AddEventHandler("ShowCine", function()
    IsCine = not IsCine
    if IsCine then
        while IsCine do
            Wait(0)
            DrawRect(1.0, 1.0, 2.0, 0.25, 0, 0, 0, 255)
            DrawRect(1.0, 0.0, 2.0, 0.25, 0, 0, 0, 255)
        end
    end
end)

RegisterKeyMapping("+MenuJob", "Ouvrir le menu Métier", "keyboard", "F7")

RegisterCommand("+MenuJob", function()
    if PlayerData.job and PlayerData.job.name == 'police' or PlayerData.job.name == 'usss' or PlayerData.job.name == 'mayansmotors' or PlayerData.job.name == 'harmonyrepair' or PlayerData.job.name == "bennys" or PlayerData.job.name == "fdmotors" or PlayerData.job.name == "cayom" or PlayerData.job.name == "lscustoms" or PlayerData.job.name == "sandybennys" or PlayerData.job.name == "grimmotors" or PlayerData.job.name == 'ems' or PlayerData.job.name == 'realestateagent' or PlayerData.job.name == 'pharma' then
        if InteractionMenu.CheckboxService then
            if PlayerData.job and PlayerData.job.name == 'police' or PlayerData.job.name == 'usss' then
                TriggerEvent("policeMenu")
            elseif PlayerData.job and PlayerData.job.name == 'mechanic' then

            elseif PlayerData.job and PlayerData.job.name == 'ems' then
                TriggerEvent("EmsMenu")
            elseif PlayerData.job and PlayerData.job.name == 'pharma' then
                TriggerEvent("pharmaMenu")
            elseif PlayerData.job and PlayerData.job.name == 'realestateagent' then
               TriggerEvent("immoMenu")
            elseif PlayerData.job and PlayerData.job.name == 'mayansmotors' or PlayerData.job.name == 'harmonyrepair' or PlayerData.job.name == "bennys" or PlayerData.job.name == "fdmotors" or PlayerData.job.name == "grimmotors" or PlayerData.job.name == "cayom" or PlayerData.job.name == "lscustoms" or PlayerData.job.name == "sandybennys" then
                TriggerEvent("MenuRepaMecano")
            end
        else
            ESX.ShowNotification("~r~Vous n'avez pas activé votre service.")
        end
    end
end)