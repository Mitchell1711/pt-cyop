if (other.state != (186 << 0))
{
    if (obj_player1.character == "V")
        global.playerhealth = clamp((global.playerhealth + 100), 0, 100)
    global.heattime = 60
    with (obj_camera)
        healthshaketime = 120
    fmod_event_one_shot("event:/sfx/misc/collectgiantpizza")
    var val = heat_calculate(1000)
    if (other.object_index == obj_player1)
        global.collect += val
    else
        global.collectN += val
    if (global.bullet < 3)
        global.bullet += 1
    var _x = (x - 48)
    var _y = (y - 48)
    var _xstart = _x
    for (var yy = 0; yy < 4; yy++)
    {
        for (var xx = 0; xx < 4; xx++)
        {
            create_collect(_x, _y, (obj_player1.ispeppino ? choose(2094, 2089, 3854, 2091) : choose(2750, 2752, 2756, 2757, 2758)))
            _x += 16
        }
        _x = _xstart
        _y += 16
    }
    with (instance_create((x + 16), y, obj_smallnumber))
        number = string(val)
    instance_destroy()
    /*if (secret && (!instance_exists(obj_fadeout)))
    {
        with (obj_player)
        {
            targetRoom = lastroom
            targetDoor = "S"
        }
        instance_create(x, y, obj_fadeout)
    }*/
}
