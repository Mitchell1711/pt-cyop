tilemapDrawGetVars();

seamX[0] = drawX[0]
seamX[1] = drawX[0];
seamY[0] = drawY[0]
seamY[1] = drawY[1]; //idc
camSeamX = drawX[0];
camSeamY = drawY[0];

for (var i = 0; i < 1080 / 32; i ++)
{
    event_user(0);
}

seamReady = true;
/*
surface_set_target(tilemap_surface)
draw_clear_alpha(c_black, 0);

screenFilled = [struct_new(), struct_new()];

var xStart = floor((camera_get_view_x(view_camera[0]) + room_x) / 32 - 2) * 32;
var xEnd = xStart + floor(camera_get_view_width(view_camera[0]) / 32 + 4) * 32;
var yStart = floor((camera_get_view_y(view_camera[0]) + room_y) / 32 - 2) * 32;
var yEnd = yStart + floor(camera_get_view_height(view_camera[0]) / 32 + 4) * 32;

for (var i = xStart; i <= xEnd; i += 32)
{
    for (var j = yStart; j <= yEnd; j += 32)
    {
        var pos = [i - room_x, j - room_y];
        var posString = string(int64(pos[0] + room_x)) + "_" + string(int64(pos[1] + room_y));
        //draw_sprite(spr_plug, 0, pos[0] + room_x, pos[1] + room_y)
        //struct_set(screenFilled[0], [[posString, true]]);
        
        if (variable_struct_exists(tilemap, posString))
        {
            if (!levelMemory_get(tile_memoryName(pos[0], pos[1])))
            {
                var spr = _stGet("tilemap." + posString + ".tileset");
                var coord = _stGet("tilemap." + posString + ".coord");
                drawTile(spr, coord, pos[0], pos[1]);
            }
        }
    }
}

surface_reset_target();*/

//seamX = floor((camera_get_view_x(view_camera[0]) + room_x) / 32) * 32;
//seamY = floor((camera_get_view_y(view_camera[0]) + room_y) / 32) * 32;
