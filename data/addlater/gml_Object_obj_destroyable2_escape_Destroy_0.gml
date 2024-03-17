if (ds_list_find_index(global.saveroom, id) == -1 && global.snickchallenge == 0)
{
    repeat (3)
    {
        with (create_debris((x + 16), y, _spr("z_oldeditor/escape_big_debris")))
        {
            hsp = random_range(-5, 5)
            vsp = random_range(-10, 10)
            image_speed = 0;
            image_index = irandom(2)
        }
    }
    /*with (instance_create((x + 16), (y + 16), obj_parryeffect))
        sprite_index = spr_pizzablockdead*/
    scr_sleep(5)
    create_baddiegibsticks((x + 16), (y + 16))
    scr_sound_multiple("event:/sfx/misc/collect", x, y)
    global.heattime += 10
    global.heattime = clamp(global.heattime, 0, 60)
    global.combotime += 10
    global.combotime = clamp(global.combotime, 0, 60)
    var val = heat_calculate(10)
    global.collect += val
    with (instance_create((x + 16), y, obj_smallnumber))
        number = string(val)
    tile_layer_delete_at(1, x, y)
    notification_push((45 << 0), [room])
    scr_sound_multiple("event:/sfx/misc/breakblock", x, y)
    ds_list_add(global.saveroom, id)
}