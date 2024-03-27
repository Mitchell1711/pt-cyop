tilemapDrawGetVars();

var camScale = camera_get_view_width(view_camera[0]) / 960

var lCamSeamX = camSeamX;
var lCamSeamY = camSeamY;

var camXDiff = drawX[0] - camSeamX;
var camYDiff = drawY[0] - camSeamY;

if (room != rmEditor)
{
    if (abs(camXDiff) > 960 / 2 or abs(camYDiff) > 540 / 2)
    {
        initTilemapDrawer(global.roomData, layer_tilemap);
        exit;
    }
}

camSeamX += camXDiff;
camSeamY += camYDiff;

var lSeamX = array_duplicate(seamX);
var lSeamY = array_duplicate(seamY);

//xDiff = [drawX[0] - seamX[0], drawX[1] - seamX[1]];
//yDiff = [drawY[0] - seamY[0], drawY[1] - seamY[1]];

if verStall[0] == 0//(xDiff[0] < 0 and verStall[0] == 0)
{
    seamX[0] += sign(xDiff[0]) * 32;
    seamSaveY[0] = drawY[0]
    seamX[0] = clamp(seamX[0], drawX[0], drawX[1])
    xDiff[0] = drawX[0] - seamX[0];
}
if verStall[1] == 0//(xDiff[1] > 0 and verStall[1] == 0)
{
    seamX[1] += sign(xDiff[1]) * 32;
    seamSaveY[1] = drawY[1]
    seamX[1] = clamp(seamX[1], drawX[0], drawX[1])
    xDiff[1] = drawX[1] - seamX[1];
}

if horStall[0] == 0//(yDiff[0] < 0 and horStall[0] == 0)
{
    seamY[0] += sign(yDiff[0]) * 32;
    seamSaveX[0] = drawX[0]
    seamY[0] = clamp(seamY[0], drawY[0], drawY[1])
    yDiff[0] = drawY[0] - seamY[0];
}
if horStall[1] == 0//(yDiff[1] > 0 and horStall[1] == 0)
{
    seamY[1] += sign(yDiff[1]) * 32;
    seamSaveX[1] = drawX[1]
    seamY[1] = clamp(seamY[1], drawY[0], drawY[1])
    yDiff[1] = drawY[1] - seamY[1];
}








/*for (var i = 0; i < 2; i ++)
{
    if (lSeamX[i] != seamX[i])
    {
        verStall[i] = 0;
        xDiff[i] = 0;
    }
    if (lSeamY[i] != seamY[i])
    {
        horStall[i] = 0;
        yDiff[i] = 0;
    }
}*/
/*
if (xDiff[0] > 0)
{
    verStall[0] = 0;
    seamX[0] += xDiff[0];
    xDiff[0] = 0;
}

if (seamX[0] > drawX[1])
{
    verStall[0] = 0;
    seamX[0] = drawX[1];
    xDiff[0] = 0;
}

if (xDiff[1] < 0)
{
    verStall[1] = 0;
    seamX[1] += xDiff[1];
    xDiff[1] = 0;
}

if (seamX[1] < drawX[0])
{
    verStall[1] = 0;
    seamX[1] = drawX[0];
    xDiff[1] = 0;
}

if (yDiff[0] > 0)
{
    horStall[0] = 0;
    seamY[0] += yDiff[0];
    yDiff[0] = 0;
}

if (seamY[0] > drawY[1])
{
    verStall[0] = 0;
    seamX[0] = drawX[1];
    xDiff[0] = 0;
}

if (yDiff[1] < 0)
{
    horStall[1] = 0;
    seamY[1] += yDiff[1];
    yDiff[1] = 0;
}
/*
if (horStall[0] == 0 and verStall == 0)
{
    seamX += sign(xDiff) * 32;
    seamY += sign(yDiff) * 32;
}*/



if (lCamSeamX != camSeamX or lCamSeamY != camSeamY)
{
    prevSurface_update();
    
    surface_set_target(tilemap_surface)
    draw_clear_alpha(c_black, 0);
    draw_surface(tilemap_prevSurface, -camXDiff / camScale, -camYDiff / camScale)//-sign(xDiff) * 32, -sign(yDiff) * 32);
    surface_reset_target();
}

if (instance_exists(obj_rmEditor))
{
    global.roomData = obj_rmEditor.data;
}

var layerAmmo = array_length(variable_struct_get_names(global.roomData.tile_data))

var maxTime = 1000 / 40 / layerAmmo;
if true//(lSeamX != seamX or lSeamY != seamY or horStall != 0 or verStall != 0)
{
    
    
    
    /*
    draw_rectangle(seamX[0], seamY[0], seamX[1] + 31, seamY[1] + 31, true)
    draw_set_color(c_red);
    draw_rectangle(seamSaveX[0], seamSaveY[0], seamSaveX[1] + 31, seamSaveY[1] + 31, true)
    draw_set_color(c_white);
    //draw_line(seamX, 0, seamX, 9000)
     */
    surface_set_target(tilemap_surface);
   
    /*
    var xStart = (floor(seamX / 32) + 1) * 32;
    var xEnd = (xStart) + (floor(camera_get_view_width(view_camera[0]) / 32 + seamSize * 2) - 1) * 32;
    var yStart = (floor(seamY / 32) + 1) * 32;
    var yEnd = yStart + (floor(camera_get_view_height(view_camera[0]) / 32 + seamSize * 2) - 1) * 32;
    
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
    */
    var horStallReset = [true, true];
    var verStallReset = [true, true];
    
    /*for (var j = 0; j < 2; j ++)
    {
        for (var i = seamY[0] + verStall[j]; i < seamY[1]; i += 32)
        {
            if (i - verStall[j] < 32)
            {
                var pos = [seamX[j], i]
                draw_text((pos[0] - camSeamX) / camScale, (pos[1] - camSeamY) / camScale, "a")
            }
            else
            {
                verStall[j] = i;
                verStallReset[j] = false;
            }
        }
    }*/
    
    
    
    
    for (var j = 0; j < 2; j ++)
    {
        var prevTime = current_time;
        if (xDiff[j] * (1 - j * 2) < 0)
        {
            var off = verStall[j];
            var stallMax = 1024 + seamSize * 128;
            var stop = false;
            var adv = 0;
            
            var pos = [seamX[j], seamSaveY[0] + off]
            if (verStall[j] != 0 and pos[1] != lastFinishY[j])
            {
                off -= pos[1] - lastFinishY[j];
            }
            
            for (var i = seamSaveY[0] + off; i < seamSaveY[1] + 32 and !stop; i += 32)
            {
                if (adv > stallMax)// or (adv > 0 and current_time - prevTime > maxTime)
                {
                    verStall[j] += adv;
                    verStallReset[j] = false;
                    stop = true;
                    //var pos = [seamX[j], i]
                    //draw_text_transformed((pos[0] - camSeamX) / camScale, (pos[1] - camSeamY) / camScale, "[", 1 / camScale, 1 / camScale, 0)
                    lastFinishY[j] = seamSaveY[0] + verStall[j]
                }
                else
                {
                    adv += 32;
                    var pos = [seamX[j], i]
                    
                    var posString = string(int64(pos[0] + room_x - x)) + "_" + string(int64(pos[1] + room_y - y));
                    
                    if true//(!variable_struct_exists(screenFilled[0], posString))
                    {
                        //struct_set(screenFilled[0], [[posString, true]]);
                        if (variable_struct_exists(tilemap, posString))
                        {
                            if (!variable_struct_exists(tilesDeleted, posString))//levelMemory_get(tile_memoryName(pos[0], pos[1])))
                            {
                                var spr = _stGet("tilemap." + posString + ".tileset");
                                var coord = _stGet("tilemap." + posString + ".coord");
                                drawTile(spr, coord, (pos[0] - camSeamX) / camScale, (pos[1] - camSeamY) / camScale, 1 / camScale);
                            }
                            /*else
                            {
                                //show_message("not: " + posString);
                                //draw_text((pos[0] - camSeamX) / camScale, (pos[1] - camSeamY) / camScale, "d")
                            }*/
                        }
                        /*else if layer_tilemap == 5
                        {
                            //draw_text((pos[0] - camSeamX) / camScale, (pos[1] - camSeamY) / camScale, "e")
                            //drawTile(_tileset("tile_secret"), [1, 1], (pos[0] - camSeamX) / camScale, (pos[1] - camSeamY) / camScale, 1 / camScale);
                        }*/
                    }
                }
            }
        }
    }
    
    for (var j = 0; j < 2; j ++)
    {
        var prevTime = current_time;
        if (yDiff[j] * (1 - j * 2) < 0)
        {
            var off = horStall[j];
            var stallMax = 1024 + seamSize * 128;
            var stop = false;
            var adv = 0;
            
            var pos = [seamSaveX[0] + off, seamY[j]]
            if (horStall[j] != 0 and pos[0] != lastFinishX[j])
            {
                off -= pos[0] - lastFinishX[j];
            }
            //draw_set_color(c_lime)
            //draw_text_transformed((pos[0] - camSeamX) / camScale, (pos[1] - camSeamY) / camScale, "[", 1 / camScale, 1 / camScale, 0)
            //draw_set_color(c_white)
            for (var i = seamSaveX[0] + off; i < seamSaveX[1] + 32 and !stop; i += 32)
            {
                if (adv > stallMax)// or (adv > 0 and current_time - prevTime > maxTime)
                {
                    horStall[j] += adv;
                    horStallReset[j] = false;
                    stop = true;;
                    var pos = [i, seamY[j]]
                    //draw_set_color(c_lime)
                    //draw_text_transformed((pos[0] - camSeamX) / camScale, (pos[1] - camSeamY) / camScale, " ]", 1 / camScale, 1 / camScale, 0)
                    //draw_set_color(c_white)
                    
                    lastFinishX[j] = seamSaveX[0] + horStall[j]
                }
                else
                {
                    adv += 32;
                    var pos = [i, seamY[j]]
                    
                    var posString = string(int64(pos[0] + room_x - x)) + "_" + string(int64(pos[1] + room_y - y));
                    
                    if true//(!variable_struct_exists(screenFilled[0], posString))
                    {
                        //struct_set(screenFilled[0], [[posString, true]]);
                        if (variable_struct_exists(tilemap, posString))
                        {
                            if (!variable_struct_exists(tilesDeleted, posString))//levelMemory_get(tile_memoryName(pos[0], pos[1])))
                            {
                                var spr = _stGet("tilemap." + posString + ".tileset");
                                var coord = _stGet("tilemap." + posString + ".coord");
                                drawTile(spr, coord, (pos[0] - camSeamX) / camScale, (pos[1] - camSeamY) / camScale, 1 / camScale);
                            }
                            /*else
                            {
                                //show_message("not: " + posString);
                                //draw_text((pos[0] - camSeamX) / camScale, (pos[1] - camSeamY) / camScale, "d")
                            }*/
                        }
                        /*else if layer_tilemap == 5
                        {
                            //draw_text((pos[0] - camSeamX) / camScale, (pos[1] - camSeamY) / camScale, "e")
                            //drawTile(_tileset("tile_secret"), [1, 1], (pos[0] - camSeamX) / camScale, (pos[1] - camSeamY) / camScale, 1 / camScale);
                        }*/
                    }
                }
                
            }
        }
    }
    
    
    if (horStallReset[0]) horStall[0] = 0;
    if (horStallReset[1]) horStall[1] = 0;
    if (verStallReset[0]) verStall[0] = 0;
    if (verStallReset[1]) verStall[1] = 0;
    /*
    for (var j = 0; j < 2; j ++)
    {
        var zStart = xStart;
        var zEnd = xEnd;
        if (j == 1)
        {
            zStart = yStart;
            zEnd = yEnd;
        }
        
        var off = horStall;
        if (j == 1) off = verStall;
        
        var stallMax = 960 + seamSize * 64;
        if (j == 1)
        {
            var stallMax = 540 + seamSize * 64;
        }
        
        for (var i = zStart + off; i <= zEnd; i += 32)
        {
            if (i - off > stallMax)
            {
                if (j == 0)
                {
                    horStall += i;
                    horStallReset = false
                }
                else
                {
                    verStall += i;
                    verStallReset = false;
                }
                i = zEnd + 1;
            }
            else
            {
            
                var pos = []
                pos[0] = i;
                pos[1] = horYTarget;
                
                if (j == 1)
                {
                    pos[0] = verXTarget ;
                    pos[1] = i;
                }
                
                var posString = string(int64(pos[0] + room_x)) + "_" + string(int64(pos[1] + room_y));
                
                if true//(!variable_struct_exists(screenFilled[0], posString))
                {
                    //struct_set(screenFilled[0], [[posString, true]]);
                    if (variable_struct_exists(tilemap, posString))
                    {
                        if (!variable_struct_exists(tilesDeleted, posString))//levelMemory_get(tile_memoryName(pos[0], pos[1])))
                        {
                            var spr = _stGet("tilemap." + posString + ".tileset");
                            var coord = _stGet("tilemap." + posString + ".coord");
                            drawTile(spr, coord, (pos[0] - camSeamX) / camScale, (pos[1] - camSeamY) / camScale, 1 / camScale);
                        }
                    }
                }
            }
        }
    }
    
    if (horStallReset and verStallReset)
    {
        horStall = 0;
        verStall = 0;
    }
    */
    surface_reset_target();
}
var cond


