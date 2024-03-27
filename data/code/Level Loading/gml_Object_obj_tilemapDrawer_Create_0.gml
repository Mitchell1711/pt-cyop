room_x = 0;
room_y = 0;
function initTilemapDrawer(argument0, argument1)
{
    layer_tilemap = argument1
    _temp = argument0;
    tilemap = _stGet("_temp.tile_data." + string(layer_tilemap))
    tiles = variable_struct_get_names(tilemap);
    
    room_x = _stGet("_temp.properties.roomX")
    room_y = _stGet("_temp.properties.roomY")
    
    //tilesDeleted = struct_new();
    
    if (room == rmEditor)
    {
        x = room_x;
        y = room_y;
    }
    
    tilemap_checkSurfaces()
    
    if (alarm[0] > -1)
        return
    if false//(instance_exists(obj_rmEditor))
    {
        surface_set_target(tilemap_surface)
        draw_clear_alpha(c_black, 0);
        
        for (var i = 0; i < array_length(tiles); i ++)
        {
            var posString = tiles[i];
            var pos = SplitString(posString, "_");
            pos[0] = real(pos[0]) - room_x;
            pos[1] = real(pos[1]) - room_y;
            
            if true//(!levelMemory_get(tile_memoryName(pos[0], pos[1])))
            {
                var spr = _stGet("tilemap." + posString + ".tileset");
                var coord = _stGet("tilemap." + posString + ".coord");
                drawTile(spr, coord, pos[0], pos[1]);
            }
        }
        
        surface_reset_target();
    }
    else
    {
        alarm[0] = 2; //will call in 2 frames an alarm that will only draw tiles present on camera (porque 2 frames??) (porque si no la camara no se mueve a donde el peppino jaja)
    }
}

function tilemap_checkSurfaces()
{
    var maxSize = 16384;
    var surW = 960/*camera_get_view_width(view_camera[0])*/ + (seamSize + 1) * 2 * 32;//clamp(_stGet("_temp.properties.levelWidth") - room_x, 0, maxSize);
    var surH = 540/*camera_get_view_height(view_camera[0])*/ + (seamSize + 1) * 2 * 32;//clamp(_stGet("_temp.properties.levelHeight") - room_y, 0, maxSize);
    
    if (seamMode == 1)
    {
        surW = clamp(_stGet("_temp.properties.levelWidth") - room_x, 0, maxSize);
        surH = clamp(_stGet("_temp.properties.levelHeight") - room_y, 0, maxSize);
    }
    
    var newSur = false;
    if !surface_exists(tilemap_surface)
    {
        newSur = true;
    }
    else
    {
        surface_set_target(tilemap_surface);
        draw_clear_alpha(c_black, 0);
        surface_reset_target();
        if (surface_get_width(tilemap_surface) != surW or surface_get_height(tilemap_surface) != surH)
        {
            surface_free(tilemap_surface);
            newSur = true;
        }
    }
    if (!surface_exists(tilemap_prevSurface))
    {
        newSur = true;
    }
    if (newSur)
    {
        if (surface_exists(tilemap_surface)) surface_free(tilemap_surface);
        tilemap_surface = surface_create(surW, surH);
        if (surface_exists(tilemap_prevSurface)) surface_free(tilemap_prevSurface);
        tilemap_prevSurface = surface_create(surW, surH);
        
        array_push(global.surfaceRoomEnd, tilemap_surface);
        array_push(global.surfaceRoomEnd, tilemap_prevSurface);
    }
}

function prevSurface_update()
{
    surface_set_target(tilemap_prevSurface);
    draw_clear_alpha(c_black, 0);
    draw_surface(tilemap_surface, 0, 0);
    surface_reset_target();
}

function drawTileToSurface(argument0, argument1, argument2, argument3)
{
    var camScale = camera_get_view_width(view_camera[0]) / 960
    eraseTileFromSurface(argument2, argument3);
    surface_set_target(tilemap_surface)
    drawTile(argument0, argument1, (argument2  - camSeamX) / camScale, (argument3 - camSeamY) / camScale, 1 / camScale, 1 / camScale)
    surface_reset_target();
}

function eraseTileFromSurface(argument0, argument1)
{
    var camScale = camera_get_view_width(view_camera[0]) / 960
    var xx = argument0;
    var yy = argument1;
    var dx = (xx - camSeamX)
    var dy = (yy - camSeamY)
    surface_set_target(tilemap_surface);
    gpu_set_blendmode(bm_subtract)
    draw_set_color(c_black);
    draw_rectangle(dx  / camScale, dy  / camScale, (dx + 32)  / camScale - 1, (dy + 32)  / camScale - 1, false);
    draw_set_color(c_white);
    gpu_set_blendmode(bm_normal);
    surface_reset_target();
    
    if (!instance_exists(obj_rmEditor))
    {
        var posString = string(xx + room_x) + "_" + string(yy + room_y);
        /*if (!variable_struct_exists(tilesDeleted, posString) and layer_tilemap == 5)
        {
            show_message("deleted " + posString)
        }*/
        struct_set(tilesDeleted, [[posString, "hi"]])
    }
    //    levelMemory_set(tile_memoryName(argument0, argument1));
}

function tile_memoryName(argument0, argument1)
{
    return global.currentRoom + "_" + string(layer_tilemap) + "_" + string(int64(argument0)) + "_" + string(int64(argument1));
}

function tilemapDrawGetVars()
{
    cam_x = camera_get_view_x(view_camera[0]);
    cam_y = camera_get_view_y(view_camera[0]);
    
    camWidth = camera_get_view_width(view_camera[0]);
    camHeight = camera_get_view_height(view_camera[0])
    
    drawX = [(floor(cam_x / 32) - seamSize) * 32, (floor((cam_x + camWidth) / 32) + seamSize) * 32]
    drawY = [(floor(cam_y / 32) - seamSize) * 32, (floor((cam_y + camHeight) / 32) + seamSize) * 32]
    
    if (camWidth < 960)
    {
        drawX[1] += -seamSize * 32 + 32;
        drawY[1] += -seamSize * 32// - 32;
    }
    
    if (room == rmEditor)
    {
        var dat = obj_rmEditor.data;
        var prop = dat.properties;
        var room_w = prop.levelWidth;
        var room_h = prop.levelHeight;
        
        drawX = [max(drawX[0], room_x - 32), min(drawX[1], room_w)]
        drawY = [max(drawY[0], room_y - 32), min(drawY[1], room_h)]
    }
}

tilemap = undefined;
tilemap_surface = -1;
tilemap_prevSurface = -1;
tiles = [];
tile_alpha = 1;

seamMode = 0;

seamX = [0, 0];
seamY = [0, 0];
xDiff = [0, 0];
yDiff = [0, 0];
seamSaveX = [0, 0];
seamSaveY = [0, 0];
camSeamX = 0;
camSeamY = 0;
seamSize = 4;
lastFinishX = [undefined, undefined]
lastFinishY = [undefined, undefined]
saveshit = 0;

horStall = [0, 0];
verStall = [0, 0];

seamReady = false;
screenFilled = [struct_new(), struct_new()];
tilesDeleted = struct_new();

layer_tilemap = 0;

//initTilemapDrawer(0)