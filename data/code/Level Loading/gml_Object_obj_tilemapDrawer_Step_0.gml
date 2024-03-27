var targetAlpha = 1;
if (tileLayer_isSecret(layer_tilemap))
{
    with (obj_player)
    {
        var halfX = x;
        var halfY = (bbox_top + bbox_bottom) / 2;
        
        var xx = floor(halfX / 32) * 32;
        var yy = floor(halfY / 32) * 32;
        var posString = string(int64(xx + other.room_x)) + "_" + string(int64(yy + other.room_y));
        
        with (other)
        {
            if (variable_struct_exists(tilemap, posString))
            {
                targetAlpha = 0;
            }
        }
    }
}

tile_alpha += sign(targetAlpha - tile_alpha) * 0.1;
tile_alpha = clamp(tile_alpha, 0, 1);