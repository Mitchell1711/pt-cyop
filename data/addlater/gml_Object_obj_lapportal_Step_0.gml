if (global.panic || instance_exists(obj_wartimer))
{
    image_alpha = 1
    if (sprite_index == spr_pizzaportal)
    {
        playerid = noone
        with (obj_player)
        {
            if (other.playerid == noone && place_meeting(x, y, other))
            {
                fmod_event_one_shot_3d("event:/sfx/misc/secretenter", x, y)
                with (obj_camera)
                    lock = 1
                state = (146 << 0)
                visible = false
                other.sprite_index = spr_pizzaportalend
                other.image_index = 0
                other.playerid = id
                fmod_event_one_shot_3d("event:/sfx/misc/lapenter", x, y)
                if (ds_list_find_index(global.saveroom, other.id) == -1)
                {
                    ds_list_add(global.saveroom, other.id)
                    global.collect += 3000
                    global.combotime = 60
                    with (instance_create(x, y, obj_smallnumber))
                        number = string(3000)
                }
            }
        }
    }
    else if (sprite_index == spr_pizzaportalend)
    {
        with (playerid)
        {
            hsp = 0
            vsp = 0
            visible = false
        }
        if (floor(image_index) == (image_number - 1))
        {
            image_index = (image_number - 1)
            image_speed = 0
            if (!instance_exists(obj_fadeout))
            {
                with (obj_player)
                {
                    targetDoor = "LAP"
                    targetRoom = other.targetRoom
                }
                for (var i = 0; i < ds_list_size(global.escaperoom); i++)
                {
                    var b = ds_list_find_value(global.escaperoom, i)
                    var q = ds_list_find_index(global.baddieroom, b)
                    var t = 0
                    if (q == -1)
                    {
                        q = ds_list_find_index(global.saveroom, b)
                        t = 1
                    }
                    if (q != -1)
                    {
                        if (!t)
                            ds_list_delete(global.baddieroom, q)
                        else
                            ds_list_delete(global.saveroom, q)
                    }
                }
                global.laps++
                global.lap = 1
                levelMemory_handleLap2();
                instance_create(0, 0, obj_fadeout)
            }
        }
    }
}
else
    image_alpha = 0.5
