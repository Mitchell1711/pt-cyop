if (is_undefined(tilemap))
{
    exit;
}


if (surface_exists(tilemap_surface) and surface_exists(tilemap_prevSurface))
{
    
    
    /*
    if (seamReady)
    {
        // this whole thing basically acts as a tile drawing buffer, where horizontal and vertical strips of tiles get drawn according to a seam off screen.
        surface_set_target(tilemap_surface)
        
        var lSeamX = seamX;
        var lSeamY = seamY;
        var xDiff = floor((camera_get_view_x(view_camera[0]) + room_x) / 32) - seamX / 32;
        var yDiff = floor((camera_get_view_y(view_camera[0]) + room_y) / 32) - seamY / 32;
        seamX += sign(xDiff) * 32;
        seamY += sign(yDiff) * 32;
        
        
        
        if (lSeamX != seamX or lSeamY != seamY) // it draws them only if the screen has moved a grid space
        {
            var xStart = floor(seamX / 32 - 2) * 32;
            var xEnd = xStart + floor(camera_get_view_width(view_camera[0]) / 32 + 4) * 32;
            var yStart = floor(seamY / 32 - 2) * 32;
            var yEnd = yStart + floor(camera_get_view_height(view_camera[0]) / 32 + 4) * 32;
            
            surface_reset_target();
            draw_rectangle(xStart, yStart, xEnd, yEnd, true)
            //draw_line(seamX, 0, seamX, 9000)
            surface_set_target(tilemap_surface);
            
            var verXTarget = xEnd;
            var horYTarget = yEnd;
            
            if (xDiff < 0)
            {
                verXTarget = xStart;
            }
            if (yDiff < 0)
            {
                horYTarget = yStart;
            }
            
            for (var j = 0; j < 2; j ++)
            {
                var zStart = xStart;
                var zEnd = xEnd;
                if (j == 1)
                {
                    zStart = yStart;
                    zEnd = yEnd;
                }
                for (var i = zStart; i <= zEnd; i += 32)
                {
                    var pos = []
                    pos[0] = i - room_x;
                    pos[1] = horYTarget - room_y;
                    
                    if (j == 1)
                    {
                        pos[0] = verXTarget - room_x;
                        pos[1] = i - room_y;
                    }
                    
                    var posString = string(int64(pos[0] + room_x)) + "_" + string(int64(pos[1] + room_y));
                    
                    if (!variable_struct_exists(screenFilled[0], posString))
                    {
                        struct_set(screenFilled[0], [[posString, true]]);
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
            }
        }
        
        surface_reset_target()
        
        
    }
    */
    
    event_user(0);

    draw_set_alpha(tile_alpha * image_alpha);
    //draw_surface(tilemap_surface, x, y)
    tilemapDrawGetVars();
    
    var camScale = camera_get_view_width(view_camera[0]) / 960
    

    draw_surface_ext(tilemap_surface, drawX[0], drawY[0], camera_get_view_width(view_camera[0]) / 960, camera_get_view_height(view_camera[0]) / 540, 0, c_white, draw_get_alpha());
    draw_set_alpha(1);
}
else
{
    draw_set_alpha(1)
    if (instance_exists(obj_rmEditor))
        global.roomData = obj_rmEditor.data;
    initTilemapDrawer(global.roomData, layer_tilemap);
}

draw_set_alpha(1)