var f = 1
if (group_arr != -4 or room == rmCustomLevel)
    f = 1.2
if (fadealpha > f)
{
    var q = 0
    if (!fadein)
    {
        q = 1
        with (obj_camera)
            lock = 0
        if gamestart
        {
            ini_open_from_string(obj_savesystem.ini_str)
            global.file_minutes = ini_read_real("Game", "minutes", 0)
            global.file_seconds = ini_read_real("Game", "seconds", 0)
            ini_close()
        }
        if restarttimer
        {
            global.level_minutes = 0
            global.level_seconds = 0
        }
    }
    if finalhallway
    {
        with (obj_player)
        {
            state = (0 << 0)
            movespeed = 0
            landAnim = 0
            hallway = 1
            hallwaydirection = 1
            targetDoor = "C"
        }
    }
    fadein = 1
    if (q && group_arr != -4)
    {
        instance_destroy(obj_pigtotal)
        var ga = group_arr
        var oa = offload_arr
        alarm[0] = 1
        with (instance_create(0, 0, obj_loadingscreen))
        {
            dark = 1
            group_arr = ga
            offload_arr = oa
            persistent = 1
        }
    }
    else
    {
        if (q && offload_arr != -4)
        {
            for (var i = 0; i < array_length(offload_arr); i++)
                texture_flush(offload_arr[i])
        }
        event_perform(ev_alarm, 0)
    }
}
if (fadein == 0)
    fadealpha += 0.1
else if (fadein == 1)
    fadealpha -= 0.1
if instance_exists(obj_player)
{
    with (obj_player1)
    {
        if (other.fadein == 1 && (obj_player1.state == (112 << 0) || obj_player1.state == (98 << 0)) && (sprite_index == spr_victory || place_meeting(x, y, obj_door) || place_meeting(x, y, obj_startgate)))
        {
            state = (95 << 0)
            image_index = 0
            if (global.coop == 1)
            {
                obj_player2.state = (95 << 0)
                obj_player2.image_index = 0
            }
        }
        if (other.fadein == 1 && obj_player1.state == (112 << 0) && (obj_player1.sprite_index == spr_downpizzabox || obj_player1.sprite_index == spr_uppizzabox))
        {
            state = (101 << 0)
            uncrouch = 20
            if (global.coop == 1)
                obj_player2.state = (101 << 0)
        }
    }
    if instance_exists(obj_player2)
    {
        with (obj_player2)
        {
            if (other.fadein == 1 && (obj_player2.state == (112 << 0) || obj_player2.state == (98 << 0)) && (place_meeting(x, y, obj_door) || place_meeting(x, y, obj_startgate)))
            {
                state = (95 << 0)
                uncrouch = 20
                image_index = 0
                if (global.coop == 1)
                {
                    obj_player1.state = (95 << 0)
                    obj_player1.image_index = 0
                }
            }
            if (other.fadein == 1 && obj_player2.state == (112 << 0) && (obj_player2.sprite_index == spr_downpizzabox || obj_player2.sprite_index == spr_uppizzabox))
            {
                state = (101 << 0)
                if (global.coop == 1)
                    obj_player1.state = (101 << 0)
            }
        }
    }
    with (obj_player2)
    {
        if instance_exists(obj_coopplayerfollow)
            state = (186 << 0)
    }
}
if (fadein == 1 && fadealpha < 0)
    instance_destroy()
