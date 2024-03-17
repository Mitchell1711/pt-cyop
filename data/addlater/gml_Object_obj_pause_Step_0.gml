if ((!pause) && instance_exists(obj_player1) && obj_player1.key_start && room != Mainmenu && room != Finalintro && room != hub_loadingscreen && room != Endingroom && room != Creditsroom && room != Johnresurrectionroom && room != Longintro && room != Realtitlescreen && room != rank_room)
{
    if (global.editingLevel)
    {
        room_goto(rmEditor);
        exit;
    }
    var _cutscenehandler = 0
    with (obj_cutscene_handler)
    {
        if (!loop)
            _cutscenehandler = 1
    }
    with (obj_player)
    {
        if ((state == (98 << 0) && place_meeting(x, y, obj_startgate)) || (state == (112 << 0) && place_meeting(x, y, obj_exitgate)))
            _cutscenehandler = 1
    }
    with (obj_charswitch_intro)
        _cutscenehandler = 1
    with (obj_bossplayerdeath)
        _cutscenehandler = 1
    with (obj_titlecard)
        _cutscenehandler = 1
    with (obj_taxi)
    {
        if move
            _cutscenehandler = 1
    }
    with (obj_taxidud)
    {
        if (!start)
            _cutscenehandler = 1
    }
    with (obj_pizzafaceboss_p3intro)
        _cutscenehandler = 1
    with (obj_pizzahead_finalecutscene)
        _cutscenehandler = 1
    if (obj_savesystem.state == 0 && (!_cutscenehandler) && room != rank_room && room != Realtitlescreen && room != timesuproom && (!instance_exists(obj_jumpscare)) && (!instance_exists(obj_technicaldifficulty)))
    {
        selected = 0
        fadein = 1
        pause = 1
        
        customSong_handle_pause(true);
        //show_message("paused!");
        fade = 0
        with (obj_music)
        {
            if (music != noone)
            {
                other.savedmusicpause = fmod_event_instance_get_paused(music.event)
                other.savedsecretpause = fmod_event_instance_get_paused(music.event_secret)
                fmod_event_instance_set_paused(music.event, 1)
                fmod_event_instance_set_paused(music.event_secret, 1)
            }
            other.savedpillarpause = fmod_event_instance_get_paused(pillarmusicID)
            other.savedkidspartypause = fmod_event_instance_get_paused(kidspartychaseID)
            other.savedpanicpause = fmod_event_instance_get_paused(panicmusicID)
            fmod_event_instance_set_paused(pillarmusicID, 1)
            fmod_event_instance_set_paused(panicmusicID, 1)
            fmod_event_instance_set_paused(kidspartychaseID, 1)
        }
        if (global.leveltosave != -4)
        {
            ini_open_from_string(obj_savesystem.ini_str)
            treasurefound = ini_read_real("Treasure", global.leveltosave, 0)
            secretcount = ini_read_real("Secret", global.leveltosave, 0)
            ini_close()
            if (!treasurefound)
            {
                treasurefound = global.treasure
                treasurealpha = 0
            }
            else if (!global.treasure)
                treasurealpha = 0.5
            else
                treasurealpha = 0
            if (global.secretfound > secretcount)
            {
                secretcount = global.secretfound
                secretalpha = 0
            }
            else if (global.secretfound < secretcount)
                secretalpha = 0.5
            else
                secretalpha = 0
            if (secretcount > 3)
                secretcount = 3
        }
        else
        {
            treasurefound = 0
            secretcount = 0
        }
        scr_delete_pause_image()
        scr_create_pause_image()
        cursor_x = -60
        cursor_y = -300
        cursor_index = 0
        backbuffer = 2
        var _state = -4
        var _txt = -4
        with (obj_player1)
        {
            _state = state
            if (state == (61 << 0))
                _state = tauntstoredstate
            switch _state
            {
                case (47 << 0):
                case (38 << 0):
                case (49 << 0):
                    _txt = lang_get_value("knighttip")
                    break
                case (10 << 0):
                    _txt = lang_get_value("firemouthtip")
                    break
                case (33 << 0):
                case (35 << 0):
                case (34 << 0):
                    _txt = lang_get_value("boxxedtip")
                    break
                case (11 << 0):
                case (13 << 0):
                case (14 << 0):
                case (12 << 0):
                    _txt = lang_get_value("morttip")
                    break
                case (16 << 0):
                    _txt = lang_get_value("ghosttip")
                    break
                case (184 << 0):
                case (185 << 0):
                    _txt = lang_get_value("rockettip")
                    break
                case (113 << 0):
                case (115 << 0):
                case (114 << 0):
                case (116 << 0):
                    _txt = lang_get_value("barreltip")
                    break
                case (211 << 0):
                    if (sprite_index == spr_player_corpsesurf || sprite_index == spr_player_corpsestart)
                        _txt = lang_get_value("gravesurftip")
                    else
                        _txt = lang_get_value("trashrolltip")
                    break
                case (265 << 0):
                    _txt = lang_get_value("antigravtip")
                    break
                case (24 << 0):
                case (29 << 0):
                case (25 << 0):
                case (26 << 0):
                case (30 << 0):
                    _txt = lang_get_value("cheesedtip")
                    break
                case (148 << 0):
                    _txt = lang_get_value("golftip")
                    break
                case (31 << 0):
                    _txt = lang_get_value("weenietip")
                    break
            }

            if (_txt == -4)
            {
                if shotgunAnim
                    _txt = lang_get_value("shotguntip")
                else if global.noisejetpack
                    _txt = lang_get_value("jetpack2tip")
            }
        }
        if (_txt != -4)
        {
            draw_set_font(lang_get_font("creditsfont"))
            draw_set_halign(fa_left)
            draw_set_valign(fa_top)
            transfotext = scr_compile_icon_text(_txt)
            transfotext_size = scr_text_arr_size(transfotext)
        }
        else
            transfotext = -4
        scr_pause_deactivate_objects()
        fmod_event_instance_play(pausemusicID)
        fmod_event_instance_set_paused(pausemusicID, 0)
    }
}
with (obj_player1)
{
    other.paletteselect = paletteselect
    other.spr_palette = spr_palette
}
border1_xstart = 0
border1_ystart = obj_screensizer.actual_height
border1_xend = -96
border1_yend = (obj_screensizer.actual_height + 100)
border2_xstart = obj_screensizer.actual_width
border2_ystart = obj_screensizer.actual_height
border2_xend = (obj_screensizer.actual_width + 96)
border2_yend = (obj_screensizer.actual_height + 100)
vine_ystart = 0
vine_yend = -117
if (!start)
{
    start = 1
    border2_x = border2_xend
    border2_y = border2_yend
    border1_x = border1_xend
    border1_y = border1_yend
    vine_y = vine_yend
}
var a = 0.1
if (!instance_exists(obj_loadingscreen))
{
    if fadein
    {
        fade = Approach(fade, 1, 0.1)
        border1_x = lerp(border1_x, border1_xstart, a)
        border1_y = lerp(border1_y, border1_ystart, a)
        border2_x = lerp(border2_x, border2_xstart, a)
        border2_y = lerp(border2_y, border2_ystart, a)
        vine_y = lerp(vine_y, vine_ystart, a)
        cursor_x = lerp(cursor_x, 0, 0.05)
        cursor_y = lerp(cursor_y, 0, a)
    }
    else
    {
        fade = Approach(fade, 0, 0.1)
        border1_x = lerp(border1_x, border1_xend, a)
        border1_y = lerp(border1_y, border1_yend, a)
        border2_x = lerp(border2_x, border2_xend, a)
        border2_y = lerp(border2_y, border2_yend, a)
        vine_y = lerp(vine_y, vine_yend, a)
        cursor_x = lerp(cursor_x, 20, 0.05)
        cursor_y = lerp(cursor_y, -100, a)
    }
}
cursor_index += 0.35
pause_update_priests()
var prevpause = pause
if (pause && (!instance_exists(obj_option)) && alarm[3] == -1)
{
    scr_getinput()
    var _dvc = obj_inputAssigner.player_input_device[0]
    if (key_jump && _dvc >= 0 && gamepad_button_check_pressed(_dvc, global.key_jumpC) && global.key_jumpC == 32770)
        key_jump = 0
    key_jump = (key_jump || (global.key_start != 13 && keyboard_check_pressed(vk_return)) || (global.key_start != 32 && keyboard_check_pressed(vk_space)) || gamepad_button_check_pressed(obj_inputAssigner.player_input_device[0], gp_face1))
    key_back = (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_return) || gamepad_button_check_pressed(obj_inputAssigner.player_input_device[0], gp_face2) || gamepad_button_check_pressed(obj_inputAssigner.player_input_device[0], gp_start))
    if (backbuffer > 0)
    {
        backbuffer--
        key_back = 0
    }
    moveselect = ((-key_up2) + key_down2)
    selected += moveselect
    if (moveselect != 0 && selected >= 0 && selected <= 3)
    {
        fmod_event_one_shot("event:/sfx/ui/angelmove")
        update_cursor = 1
    }
    selected = clamp(selected, 0, (array_length(pause_menu) - 1))
    if key_back
    {
        selected = 0
        key_jump = 1
    }
    if key_jump
    {
        switch selected
        {
            case 0:
                scr_pause_activate_objects()
                
                customSong_handle_pause(false);
                //show_message("unpaused!");
                pause_unpause_music()
                instance_destroy(obj_option)
                instance_destroy(obj_keyconfig)
                break
            case 2:
                if (room == Endingroom || room == tower_soundtest || room == Creditsroom || room == Johnresurrectionroom)
                    break
                else
                {
                    if (!global.snickchallenge)
                    {
                        var rm = global.leveltorestart
                        if (rm != -4 && rm != -1)
                        {
                            alarm[5] = 1
                            roomtorestart = rm
                            pause_unpause_music()
                            stop_music()
                            customSong_destroy_all();
                            scr_pause_activate_objects()
                            scr_pause_stop_sounds()
                            instance_destroy(obj_option)
                            instance_destroy(obj_keyconfig)
                            pause = 0
                        }
                        else
                            fmod_event_one_shot("event:/sfx/ui/select")
                    }
                    break
                }
            case 1:
                fmod_event_one_shot("event:/sfx/ui/select")
                with (instance_create(x, y, obj_option))
                    depth = (other.depth - 1)
                break
            case 3:
                if (room == Endingroom || room == Creditsroom || room == Johnresurrectionroom)
                    break
                else
                {
                    pause_unpause_music()
                    stop_music()
                    customSong_destroy_all();
                    scr_pause_stop_sounds()
                    instance_destroy(obj_option)
                    instance_destroy(obj_keyconfig)
                    fmod_event_instance_stop(global.snd_bossbeaten, 1)
                    fmod_event_instance_stop(pausemusicID, 1)
                    obj_music.music = -4
                    var sl = ds_list_create()
                    var il = ds_list_create()
                    var arr = -4
                    ds_list_copy(sl, sound_list)
                    ds_list_copy(il, instance_list)
                    if (room == hub_room1 || room == Finalintro || room == characterselect || room == cowboytask || room == Titlescreen || room == Mainmenu || room == Scootertransition || room == rm_levelselect || (string_copy(room_get_name(room), 1, 5) == "tower" && (!global.panic)))
                    {
                        if global.startgate
                        {
                            hub = 1
                            arr = ["hubgroup"]
                            global.startgate = 0
                        }
                        else
                        {
                            hub = 0
                            arr = ["menugroup"]
                        }
                    }
                    else
                    {
                        global.startgate = 0
                        hub = 1
                        arr = ["hubgroup"]
                    }
                    alarm[3] = 1
                    ds_list_add(il, id)
                    with (textures_offload(arr))
                    {
                        ds_list_clear(sound_list)
                        ds_list_clear(instance_list)
                        ds_list_copy(sound_list, sl)
                        ds_list_copy(instance_list, il)
                    }
                    instance_deactivate_object(id)
                    ds_list_destroy(sl)
                    ds_list_destroy(il)
                    break
                }
        }

    }
}
if pause
    scr_pauseicons_update(selected)
else
    scr_pauseicons_update(-1)
