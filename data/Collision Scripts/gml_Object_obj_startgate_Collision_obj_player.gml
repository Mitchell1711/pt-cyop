var gate = id
with (other)
{
    if (place_meeting(x, y, other) && key_up && grounded && (state == states.normal || state == states.mach1 
    || state == states.mach2 || state == states.mach3) && (!instance_exists(obj_noisesatellite)) 
    && (!instance_exists(obj_fadeout)) && state != states.victory && state != states.comingoutdoor && spotlight == 1)
    {
        //audio_stop_all()
        stop_music()
        customSong_fadeout_all()//destroy_all();
        global.collect = 0
        global.startgate = 1
        global.leveltosave = other.level
        global.leveltorestart = other.targetRoom
        global.levelattempts = 0
        global.hub_bgsprite = other.bgsprite
        backtohubstartx = x
        backtohubstarty = y
        backtohubroom = room
        mach2 = 0
        obj_camera.chargecamera = 0
        image_index = 0
        state = states.victory
        obj_player2.backtohubstartx = x
        obj_player2.backtohubstarty = y
        obj_player2.backtohubroom = room

        if (room == rmCustomLevel)
        {
            with obj_player
            {
                backtohubroom = global.currentRoom
            }
        }
        
        if (other.levelName != "")
        {
            preloadCustomLevel(other.levelName);
        }

        if (global.coop == 1)
        {
            with (obj_player2)
            {
                x = obj_player1.x
                y = obj_player1.y
                mach2 = 0
                obj_camera.chargecamera = 0
                image_index = 0
                state = states.victory
            }
        }
        return;
    }
}
if ((floor(obj_player1.image_index) == (obj_player1.image_number - 1) && obj_player1.state == states.victory) 
|| (floor(obj_player2.image_index) == (obj_player2.image_number - 1) && obj_player2.state == states.victory))
{
    with (obj_player)
    {
        if (other.level == "snickchallenge")
        {
            global.wave = 0
            global.maxwave = (((global.minutes * 60) + global.seconds) * 60)
            if global.panicbg
                scr_panicbg_init()
            global.snickchallenge = 1
            global.collect = 10000
            with (obj_camera)
            {
                alarm[1] = 60
                global.seconds = 59
                global.minutes = 9
            }
        }
        obj_music.fadeoff = 0
        customSong_destroy_all()
        targetDoor = other.targetDoor
        targetRoom = other.targetRoom
        if (targetRoom == tower_finalhallway)
            global.exitrank = 1
        if (gate.level != "tutorial" && !gate.noTitlecard)
        {
            if (gate.object_index != obj_bossdoor)
            {
                if (!instance_exists(obj_titlecard))
                {
                    with (instance_create(x, y, obj_titlecard))
                    {
                        group_arr = gate.group_arr
                        titlecard_sprite = gate.titlecard_sprite
                        titlecard_index = gate.titlecard_index
                        title_sprite = gate.title_sprite
                        title_index = gate.title_index
                        title_music = gate.title_music
                        noisespots = gate.noisespots
                    }
                }
            }
            else
            {
                with (instance_create_unique(0, 0, obj_fadeout))
                {
                    restarttimer = 1
                    group_arr = gate.group_arr
                }
            }
        }
        else
        {
            with (instance_create_unique(0, 0, obj_fadeout))
                restarttimer = 1
        }
    }
}
