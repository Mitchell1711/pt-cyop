if (w_isOnCanvas(w_openCanvas[0], cursorX / 2, cursorY / 2))
{
    switch editor_state
    {
        case st_instances:
            switch cursorMode
            {
                case 0:
                    var xx = x;
                    var yy = y;
                    var xs = 1 - 2 * objFlipX;
                    var ys = 1 - 2 * objFlipY;
                    var objSpr = object_get_sprite(objSelected);
                    
                    if (objFlipX)
                    {
                        var horDifference = sprite_get_width(objSpr) - sprite_get_xoffset(objSpr) * 2
                        xx += horDifference;
                    }
                    
                    if (objFlipY)
                    {
                        var verDifference = sprite_get_height(objSpr) - sprite_get_yoffset(objSpr) * 2
                        yy += verDifference;
                    }

                    draw_sprite_ext(objSpr, 0, xx, yy, xs, ys, 0, c_white, 0.5);
                    break;
                case 1:
                    //draw_circle(round(mouse_x / gridSize) * gridSize, round(mouse_y / gridSize) * gridSize, 4, true);
                    
                    var onIns = instOn;
                    draw_set_alpha(0.5);
                    if (instance_exists(instSelected))
                    {
                        onIns = instSelected;
                        draw_set_alpha(1);
                    }
                    if (instance_exists(onIns))
                    {
                        var insSpr = onIns.sprite_index;
                        var bbLeft = onIns.x - sprite_get_xoffset(insSpr) * onIns.image_xscale;
                        var bbRight = onIns.x + (-sprite_get_xoffset(insSpr) + sprite_get_width(insSpr)) * onIns.image_xscale;
                        var bbTop = onIns.y - sprite_get_yoffset(insSpr) * onIns.image_yscale;
                        var bbBottom = onIns.y + (-sprite_get_yoffset(insSpr) + sprite_get_height(insSpr)) * onIns.image_yscale;
                        
                        draw_rectangle(bbLeft, bbTop, bbRight, bbBottom, true);
                        draw_rectangle(bbLeft + 1, bbTop + 1, bbRight - 1, bbBottom - 1, true);
                        
                        /*var instVars = _stGet("data.instances[" + string(onIns.instID) + "].variables");
                        var varNames = variable_struct_get_names(instVars);
                        for (var i = 0; i < array_length(varNames); i ++)
                        {
                            draw_text(mouse_x, mouse_y + i * 12, varNames[i] + ": " + string(struct_get(instVars, varNames[i])))
                        }*/
                        //draw_text_transformed(mouse_x, mouse_y + 12 * camZoom, "Press V to edit variables\n\nPress X/Y to flip", camZoom, camZoom, 0);
                    }
                    draw_set_alpha(1);
                    
                    break;//
            }
        break;
        
        case st_tiles:
            switch cursorMode
            {
                case 0:
                    draw_set_alpha(0.5);
                    if (!tileset_doAutoTile)
                    {
                        drawTile(tilesetSelected, tilesetCoord, x, y);
                    }
                    else
                    {
                        var xx = x - gridSize;
                        var yy = y - gridSize;
                        var ww = gridSize;
                        var hh = gridSize;
                        draw_rectangle(xx, yy, xx + ww + gridSize - 1, yy + hh + gridSize - 1, true);
                        draw_rectangle(xx - 1, yy - 1, xx + ww + gridSize, yy + hh + gridSize, true);
                    }
                    draw_set_alpha(1);
                break;
                case 1:
                    var xx = tile_selection[4];
                    var yy = tile_selection[5];
                    var ww = tile_selection[2];
                    var hh = tile_selection[3];
                    if (ww < 0)
                    {
                        ww *= -1;
                        xx -= ww;
                    }
                    if (hh < 0)
                    {
                        hh *= -1;
                        yy -= hh;
                    }
                    draw_rectangle(xx, yy, xx + ww + gridSize - 1, yy + hh + gridSize - 1, true);
                    draw_rectangle(xx - 1, yy - 1, xx + ww + gridSize, yy + hh + gridSize, true);
                    
                    if (tile_selection_moving)
                    {
                        var xMove = x - tile_selection_move_origin[2];
                        var yMove = y - tile_selection_move_origin[3];
                        draw_set_color(c_lime);
                        draw_rectangle(xx + xMove, yy + yMove, xx + ww + gridSize - 1 + xMove, yy + hh + gridSize - 1 + yMove, true);
                        draw_set_color(c_white)
                    }
                break;
            }
            //draw_sprite(object_get_sprite(objIndex), 0, x, y)
        break;
    }
}