function scr_is_p_rank() //gml_Script_scr_is_p_rank
{
    if (global.leveltosave != "exit")
        return (global.lap && global.secretfound >= 3 && global.treasure && (!global.combodropped) && global.prank_enemykilled);
    else
        return (!global.combodropped);
}

function scr_do_rank(argument0, argument1) //gml_Script_scr_do_rank
{
    fmod_event_instance_stop(global.snd_escaperumble, 1)
    
    if (global.editingLevel)
    {
        audio_stop_all();
        room_goto(rmEditor);
        return(-1);
    }
    
    if (argument0 == undefined)
        argument0 = 1
    if (argument1 == undefined)
        argument1 = 0
    
    var ex = x
    var ey = y
    var cx = (camera_get_view_x(view_camera[0]) + obj_screensizer.normal_size_fix_x)
    var cy = (camera_get_view_y(view_camera[0]) + obj_screensizer.normal_size_fix_y)
    rankpos_x = (ex - cx)
    rankpos_y = (ey - cy)
    if (global.timeattack == 1)
        obj_timeattack.stop = 1
    with (obj_wartimer)
        notification_push((47 << 0), [minutes, (seconds + addseconds)])
    targetDoor = "none"
    obj_camera.alarm[2] = -1
    var roomname = room_get_name(room)
    var namestring = string_letters(roomname)
    if (!global.tutorial_room)
    {
        if (!argument1)
            scr_savescore(global.leveltosave)
        else
        {
            ini_open_from_string(obj_savesystem.ini_str)
            var _hats = global.hats
            if (ini_read_real("Hats", global.leveltosave, 0) < _hats)
                ini_write_real("Hats", global.leveltosave, _hats)
            var _extrahats = global.extrahats
            if (ini_read_real("Extrahats", global.leveltosave, 0) < _extrahats)
                ini_write_real("Extrahats", global.leveltosave, _extrahats)
            var _rank = "d"
            var maxhats = (6 + global.srank)
            var currhats = (_extrahats + _hats)
            if (currhats >= maxhats && (!global.bossplayerhurt))
                _rank = "p"
            else if (currhats >= (maxhats - 2))
                _rank = "s"
            else if (currhats >= (maxhats - 4))
                _rank = "a"
            else if (currhats >= (maxhats - 6))
                _rank = "b"
            else if (currhats >= (maxhats - 8))
                _rank = "c"
            global.rank = _rank
            scr_write_rank(global.leveltosave)
            scr_play_rank_music()
            obj_savesystem.ini_str = ini_close()
            gamesave_async_save()
        }
        notification_push((5 << 0), [global.leveltosave, global.secretfound, global.level_minutes, global.level_seconds])
        with (obj_achievementtracker)
            event_perform(ev_step, ev_step_normal)
    }
    else
    {
        var _lap = 0
        ini_open_from_string(obj_savesystem.ini_str)
        ini_write_real("Tutorial", "finished", 1)
        if ((global.level_minutes < 2 || global.level_minutes < 1 || (global.level_minutes == 1 && global.level_seconds <= 40)) && ini_read_real("Tutorial", "lapunlocked", 0) == 0)
        {
            ini_write_real("Tutorial", "lapunlocked", 1)
            _lap = 1
        }
        obj_savesystem.ini_str = ini_close()
        if _lap
            create_transformation_tip(lang_get_value("tutorial_lapunlock"))
    }
    if (global.combo > 0)
    {
        global.combotime = 0
        global.combo = 0
        obj_camera.alarm[4] = -1
        for (var i = 0; i < global.comboscore; i += 10)
            create_collect((obj_player1.x + irandom_range(-60, 60)), ((obj_player1.y - 100) + irandom_range(-60, 60)), choose(2089, 2091, 2092, 2094, 2090), 10)
        global.comboscore = 0
    }
    if (!instance_exists(obj_endlevelfade))
    {
        with (instance_create(x, y, obj_endlevelfade))
        {
            do_rank = 1
            toppinvisible = argument0
            if (room == tower_tutorial1)
            {
                do_rank = 0
                targetRoom = 757
                targetDoor = "HUB"
            }
            else if (room == tower_entrancehall)
            {
                with (obj_followcharacter)
                    persistent = 0
                if (!global.exitrank)
                {
                    do_rank = 0
                    targetRoom = 799
                    targetDoor = "A"
                    instance_destroy(obj_pigtotal)
                    audio_stop_all()
                    stop_music()
                    fmod_event_instance_stop(global.snd_rank)
                    fmod_event_one_shot("event:/sfx/ending/towercollapsetrack")
                }
                else
                    toppinvisible = 0
            }
        }
    }
    obj_player1.state = (112 << 0)
    obj_player1.sprite_index = obj_player1.spr_lookdoor
    if instance_exists(obj_player2)
    {
        obj_player2.state = (112 << 0)
        obj_player2.sprite_index = obj_player2.spr_lookdoor
        if global.coop
            obj_player2.visible = true
    }
    obj_endlevelfade.alarm[0] = 235
    image_index = 0
    global.panic = 0
    global.snickchallenge = 0
    global.leveltorestart = -4
    gamesave_async_save()
    
    
}

