if (room == custom_lvl_room)
    tile_layer_delete_at(1, x, y)
if (ds_list_find_index(global.saveroom, id) == -1)
{
    repeat (4)
    {
        with (create_debris((x + random_range(0, sprite_width)), (y + random_range(0, sprite_height)), _spr("z_oldeditor/escape_big_debris"), 1))
        {
            hsp = random_range(-5, 5)
            vsp = random_range(-10, 10)
            image_speed = 0;
            image_index = irandom(2)
        }
    }
    /*with (instance_create((x + random_range(0, sprite_width)), (y + random_range(0, sprite_height)), obj_parryeffect))
    {
        sprite_index = spr_deadjohnsmoke
        image_speed = 0.35
    }*/
    global.heattime += 10
    global.heattime = clamp(global.heattime, 0, 60)
    global.combotime += 50
    global.combotime = clamp(global.combotime, 0, 60)
    var val = heat_calculate(100)
    global.collect += val
    scr_sound_multiple("event:/sfx/misc/collect", x, y)
    with (instance_create((x + 16), y, obj_smallnumber))
        number = string(val)
        
    scr_sleep(5)
    tile_layer_delete_at(1, x, y)
    scr_sound_multiple("event:/sfx/misc/breakblock", x, y)
    ds_list_add(global.saveroom, id)
    notification_push((45 << 0), [room])
}