function scr_destroy_tiles(argument0, argument1, argument2) //gml_Script_scr_destroy_tiles
{
    if (argument2 == undefined)
        argument2 = 0
    var lay_id = layer_get_id(argument1)
    if (lay_id == -1)
    {
        lay_id = layer_get_id("custom_" + argument1);
    }
    if (lay_id != -1 or room == rmCustomLevel)
    {
        var map_id = layer_tilemap_get_id(lay_id)
        var w = (abs(sprite_width) / argument0)
        var h = (abs(sprite_height) / argument0)
        var ix = sign(image_xscale)
        var iy = sign(image_yscale)
        if (ix < 0)
            w++
        for (var yy = (0 - argument2); yy < (h + argument2); yy++)
        {
            for (var xx = (0 - argument2); xx < (w + argument2); xx++)
                scr_destroy_tile((x + ((xx * argument0) * ix)), (y + ((yy * argument0) * iy)), map_id)
        }
    }
}

function scr_destroy_tile_arr(argument0, argument1, argument2) //gml_Script_scr_destroy_tile_arr
{
    if (argument2 == undefined)
        argument2 = 0
    for (var i = 0; i < array_length(argument1); i++)
        scr_destroy_tiles(argument0, argument1[i], argument2)
}

function scr_destroy_tile(argument0, argument1, argument2) //gml_Script_scr_destroy_tile
{
    var data = tilemap_get_at_pixel(argument2, argument0, argument1)
    data = tile_set_empty(data)
    tilemap_set_at_pixel(argument2, data, argument0, argument1)
    
    if (room == rmCustomLevel)
    {
        _temp = global.roomData;
        var xx = int64(argument0)
        var yy = int64(argument1)
        var posString = string(xx + _stGet("_temp.properties.roomX")) + "_" + string(yy + _stGet("_temp.properties.roomY"));
        with obj_tilemapDrawer
        {
            if (!tileLayer_isSecret(layer_tilemap))
            {
                eraseTileFromSurface(xx, yy);
            }
        }
    }
}

function scr_solid_line(argument0) //gml_Script_scr_solid_line
{
    if (collision_line(x, y, argument0.x, argument0.y, obj_solid, false, true) != -4)
        return 1;
    if (collision_line(x, y, argument0.x, argument0.y, obj_slope, false, true) != -4)
        return 1;
    return 0;
}

function scr_destroy_nearby_tiles() //gml_Script_scr_destroy_nearby_tiles
{
    instance_destroy(instance_place((x + 1), y, obj_tiledestroy))
    instance_destroy(instance_place((x - 1), y, obj_tiledestroy))
    instance_destroy(instance_place(x, (y + 1), obj_tiledestroy))
    instance_destroy(instance_place(x, (y - 1), obj_tiledestroy))
}

function scr_cutoff() //gml_Script_scr_cutoff
{
    with (instance_place(x, y, obj_cutoff))
        instance_destroy()
    var dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    var list = ds_list_create()
    for (i = 0; i < array_length(dirs); i++)
    {
        var d = dirs[i]
        if (!(place_meeting((x + d[0]), (y + d[1]), obj_cutoff)))
        {
        }
        else
        {
            var num = instance_place_list((x + d[0]), (y + d[1]), 467, list, 0)
            for (var j = 0; j < ds_list_size(list); j++)
            {
                var b = ds_list_find_value(list, j)
                if ((!is_undefined(b)) && instance_exists(b))
                {
                    with (b)
                    {
                        if (!(place_meeting(x, y, obj_solid)))
                            instance_destroy()
                        else if (other.object_index == obj_tiledestroy || ((object_index != obj_cutoffsmall || other.object_index == obj_secretblock) && (object_index != obj_cutoff || other.object_index == obj_secretbigblock || other.object_index == obj_secretmetalblock)))
                        {
                            var a = scr_cutoff_get_angle(b)
                            var da = a
                            if (d[0] < 0)
                                da = 0
                            else if (d[0] > 0)
                                da = 180
                            else if (d[1] < 0)
                                da = 270
                            else if (d[1] > 0)
                                da = 90
                            if (a == da)
                                visible = true
                        }
                    }
                }
            }
            ds_list_clear(list)
        }
    }
    ds_list_clear(list)
    ds_list_destroy(list)
}

function scr_cutoff_get_angle(argument0) //gml_Script_scr_cutoff_get_angle
{
    a = (argument0.image_angle + 90)
    d = point_direction(0, 0, (lengthdir_x(1, a) * argument0.image_yscale), (lengthdir_y(1, a) * argument0.image_yscale))
    return d;
}

