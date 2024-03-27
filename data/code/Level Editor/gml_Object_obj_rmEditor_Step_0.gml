global.currentsavefile = 10

if (!lockCursorMode)
{
    cursorMode = 0;//
    if (keyboard_check(vk_alt) or keyboard_check(ord("R")) or selectingMode)
    {
        cursorMode = 1;
    }
}
cursorImage = 0;//
//window_set_cursor(cr_none)

if (doubleClickTimer > 0) doubleClickTimer --;

var updateUndo = mouse_check_button_pressed(mb_left) or mouse_check_button_pressed(mb_right) or keyboard_check_pressed(ord("F")) or keyboard_check_pressed(vk_backspace);

if (updateUndo)
{
    prevData = json_stringify(data); // yeah this some bullshit but whatev
    updateUndoMemory = true;
}

var zoomChange = 0;

var onGridPos = [(floor((mouse_x / gridSize)) * gridSize), (floor((mouse_y / gridSize)) * gridSize), (round((mouse_x / gridSize)) * gridSize), (round((mouse_y / gridSize)) * gridSize)]

if (w_isOnCanvas(w_openCanvas[0], cursorX / w_scale, cursorY / w_scale))
{
    switch editor_state
    {
        case st_instances: // instance editor
            switch cursorMode
            {
                case 0:
                    var objSpr = object_get_sprite(objSelected);
                    
                    objFlipX += keyboard_check_pressed(ord("X"));
                    objFlipY += keyboard_check_pressed(ord("Y"));
                    
                    objFlipX %= 2;
                    objFlipY %= 2;
                    
                    var absorber = noone;
                    var candidates = ds_list_create();
                    collision_circle_list(mouse_x, mouse_y, 16, obj_editorInst, true, true, candidates, true)
                    for (var j = 0; j < ds_list_size(candidates); j ++)
                    {
                        if (absorber == noone)
                        {
                            var cand = ds_list_find_value(candidates, j);
                            if (layer_instances == _stGet("data.instances[" + string(cand.instID) + "].layer"))
                            {
                                if (array_value_exists(variable_struct_get_names(global.objectData.questionBlocks), object_get_name(_stGet("data.instances[" + string(cand.instID) + "].object"))))
                                {
                                    absorber = cand;
                                }
                            }
                        }
                    }
                    
                    if (absorber == noone)
                    {
                        x = onGridPos[0];
                        y = onGridPos[1];
                        
                        if (object_compareToList(objSelected, global.objectData.snapToGround))
                        {
                            y += sprite_get_yoffset(objSpr) - sprite_get_bbox_bottom(objSpr) + gridSize;
                            var objSpr = object_get_sprite(objSelected);
                            var objOff = sprite_get_yoffset(objSpr)
                            var objBord = [sprite_get_bbox_top(objSpr), sprite_get_bbox_bottom(objSpr)]
                            var colls = ds_list_create();
                            collision_rectangle_list(x - gridSize / 2, y - objOff + objBord[0], x + gridSize / 2, y - objOff + objBord[1], obj_editorInst, true, true, colls, true)
                            
                            for (var i = 0; i < ds_list_size(colls); i ++)
                            {
                                var cInst = ds_list_find_value(colls, i)
                                repeat 4
                                {
                                    if (collision_rectangle(x - gridSize / 2, y - objOff + objBord[0], x + gridSize / 2, y - objOff + objBord[1], cInst, true, true) != noone)
                                    {
                                        var si = string(cInst.instID);
                                        var o = _stGet("data.instances[" + si + "].object");
                                        if (object_compareToList(o, ["obj_solid", "obj_platform"]))//object_get_parent(o) == obj_solid or o == obj_solid)
                                            y -= 0.5;
                                    }
                                }
                            }
                            //var bboxB = y - sprite_get_yoffset(objSpr) + sprite_get_bbox_bottom(objSpr);
                            //y += (bboxB - floor(bboxB / gridSize) * gridSize);
                        }
                    }
                    else
                    {
                        
                        var targetx = (absorber.bbox_right + absorber.bbox_left) / 2 + sprite_get_xoffset(objSpr) - (sprite_get_bbox_left(objSpr) + sprite_get_bbox_right(objSpr)) / 2
                        var targety = (absorber.bbox_bottom + absorber.bbox_top) / 2 + sprite_get_yoffset(objSpr) - (sprite_get_bbox_top(objSpr) + sprite_get_bbox_bottom(objSpr)) / 2
                        
                        x += (targetx - x) / 6;
                        y += (targety - y) / 6;
                        
                        instOn = absorber
                    }
                    
                    if (keyboard_check(vk_shift))
                    {
                        x = mouse_x;
                        y = mouse_y;
                        if (keyboard_check(vk_control))
                        {
                            var objSpr = object_get_sprite(objSelected);
                            var objOff = sprite_get_yoffset(objSpr)
                            var objBord = [sprite_get_bbox_top(objSpr), sprite_get_bbox_bottom(objSpr)]
                            var cInst = collision_rectangle(x - gridSize / 2, y - objOff + objBord[0], x + gridSize / 2, y - objOff + objBord[1], obj_editorInst, true, true)
                            //show_message("s");
                            if (cInst != noone)
                            {
                                _temp = cInst.instID;
                                var o = _stGet("data.instances[_temp].object");
                                if (object_get_parent(o) == obj_solid or o == obj_solid)
                                {
                                    while (collision_rectangle(x - gridSize / 2, y - objOff + objBord[0], x + gridSize / 2, y - objOff + objBord[1], cInst, true, true) != noone)
                                    {
                                        y --;
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    
                    if (absorber == noone)
                    {
                        if (mouse_check_button(mb_left) and (onGridPos[0] != prevGridPos[0] or onGridPos[1] != prevGridPos[1]))
                        {
                            if (objSelected == obj_exitgate)
                            {
                                addInst(obj_doorA, x - 16, y + 32 * 3)
                            }
                            var o = addInst(objSelected, x, y, [])
                            
                            inst_setVar(o.instID, "flipX", objFlipX);
                            inst_setVar(o.instID, "flipY", objFlipY);
                            
                            instance_update_variables(o, _stGet("data.instances[" + string(o.instID) + "]"));
                        }
                    }
                    else
                    {
                        if (mouse_check_button_pressed(mb_left))
                        {
                            var abName = struct_get(global.objectData.questionBlocks, object_get_name(_stGet("data.instances[" + string(absorber.instID) + "].object")))
                            inst_setVar(absorber.instID, abName, object_get_name(objSelected));
                            instance_update_variables(absorber, _stGet("data.instances[" + string(absorber.instID) + "]"));
                        }
                    }
                    cursorImage = 0;
                    
                    
                    
                    if (mouse_check_button(mb_right))
                    {
                        var delList = ds_list_create();
                        var del = collision_point_list(mouse_x, mouse_y, obj_editorInst, true, true, delList, true);
                        var foundIt = false;
                        //show_message("tf")
                        cursorImage = 6;
                        for (var i = 0; i < ds_list_size(delList); i ++)
                        {
                            if (!foundIt)
                            {
                                var delInst = ds_list_find_value(delList, i);
                                _temp = delInst.instID;
                                if (layer_instances == _stGet("data.instances[_temp].layer"))
                                {
                                    _stSet("data.instances[_temp].deleted", true);
                                    ds_stack_push(deletedIndexes, delInst.instID);
                                    
                                    instance_destroy(delInst);
                                    foundIt = true;
                                }
                            }
                        }
                    }
                    
                    
                    break;
                case 1: // resizing, movin and var editing
                    cursorImage = 5;
                    
                    if (mouse_check_button_released(mb_left))
                    {
                        doubleClickTimer = 20;
                    }
                    
                    
                    
                    if (!instance_exists(instSelected))
                        updateStretch = true;
                    
                    if (!updateStretch)
                    {
                        // do some shit
                        var o = instSelected;
                        var anchor = [0, 0];
                        var growPos = [0, 0];
                        var sprSize = [sprite_get_width(o.sprite_index), sprite_get_height(o.sprite_index)]
                        var sprOff = [sprite_get_xoffset(o.sprite_index), sprite_get_yoffset(o.sprite_index)]
                        
                        var spacePos = gridSize;
                        var spaceX = sprSize[0];
                        var spaceY = sprSize[1];
                        
                        if (keyboard_check(vk_shift))
                        {
                            spacePos = 1;
                            spaceX = 1;
                            spaceY = 1;
                        }
                        
                        if (cursorStretch[0] == -1)
                        {
                            anchor[0] = selCarry[0] + (-sprOff[0] + sprSize[0]) * selCarry[2];
                            var growPos = [round((mouse_x - anchor[0]) / spaceX) * spaceX];
                            
                            var finalXScale = abs(growPos[0]) / sprSize[0];
                            o.image_xscale = finalXScale;
                            o.x = anchor[0] + growPos[0] + (sprOff[0]) * finalXScale;
                        }
                        else if (cursorStretch[0] == 1)
                        {
                            anchor[0] = selCarry[0] + (-sprOff[0]) * selCarry[2];
                            var growPos = [round((mouse_x - anchor[0]) / spaceX) * spaceX];
                            
                            var finalXScale = (growPos[0]) / sprSize[0];
                            o.image_xscale = finalXScale;
                            o.x = anchor[0] + (sprOff[0]) * finalXScale;
                        }
                        
                        if (cursorStretch[1] == -1)
                        {
                            anchor[1] = selCarry[1] + (-sprOff[1] + sprSize[1]) * selCarry[3];
                            var growPos = round((mouse_y - anchor[1]) / spaceY) * spaceY;
                            
                            var finalYScale = abs(growPos) / sprSize[1];
                            o.image_yscale = finalYScale;
                            o.y = anchor[1] + growPos + (sprOff[1]) * finalYScale;
                        }
                        else if (cursorStretch[1] == 1)
                        {
                            anchor[1] = selCarry[1] + (-sprOff[1]) * selCarry[3];
                            var growPos = round((mouse_y - anchor[1]) / spaceY) * spaceY;
                            
                            var finalYScale = (growPos) / sprSize[1];
                            o.image_yscale = finalYScale;
                            o.y = anchor[1] + (sprOff[1]) * finalYScale;
                        }
                        
                        if (cursorStretch[0] == 0 and cursorStretch[1] == 0)
                        {
                            o.x = selCarry[0] + floor((mouse_x - selCarry[4]) / spacePos) * spacePos
                            o.y = selCarry[1] + floor((mouse_y - selCarry[5]) / spacePos) * spacePos 
                        }
                                                
                        inst_setVar(o.instID, "image_xscale", abs(o.image_xscale));
                        inst_setVar(o.instID, "image_yscale", abs(o.image_yscale));
                        inst_setVar(o.instID, "x", o.x);
                        inst_setVar(o.instID, "y", o.y);
                        
                        
                        
                        instance_update_variables(o, _stGet("data.instances[" + string(o.instID) + "]"));
                        
                        if (!mouse_check_button(mb_left))
                        {
                            updateStretch = true;
                            instSelected = noone;
                            lockCursorMode = false;
                        }
                    }
                    var stretchDir = array_duplicate(cursorStretch);
                    
                    var insList = ds_list_create();
                    var insNum = collision_circle_list(mouse_x, mouse_y, 600, obj_editorInst, true, true, insList, true);
                    var onIns = noone;
                    var isOn = false;
                    for (var i = 0; i < insNum; i ++)
                    {
                        var ins = ds_list_find_value(insList, i);
                        _temp = ins.instID;
                        if (onIns == noone and _stGet("data.instances[_temp].layer") == layer_instances)
                        {
                            with ins
                            {
                                var bbLeft = x - sprite_get_xoffset(sprite_index) * image_xscale;
                                var bbRight = x + (-sprite_get_xoffset(sprite_index) + sprite_get_width(sprite_index)) * image_xscale;
                                var bbTop = y - sprite_get_yoffset(sprite_index) * image_yscale;
                                var bbBottom = y + (-sprite_get_yoffset(sprite_index) + sprite_get_height(sprite_index)) * image_yscale;
                                
                                var off = 10;
                                if (mouse_x > bbLeft - off and mouse_x < bbRight + off and mouse_y > bbTop - off and mouse_y < bbBottom + off)
                                {
                                    isOn = true;
                                }
                            }
                            if (isOn)
                            {
                                onIns = ds_list_find_value(insList, i);
                            }
                        }
                    }
                    instOn = onIns;
                    
                    if (onIns != noone)
                    {
                        cursorNotice = "Double click to edit variables\nPress X/Y to flip"
                        if (keyboard_check_pressed(ord("V")) or (mouse_check_button_pressed(mb_left) and doubleClickTimer > 0))
                        {
                            var c = wCanvas_open("instanceMenu", clamp(cursorX / w_scale, 100, obj_screensizer.actual_width - 300), clamp(cursorY / w_scale - 64, 100, obj_screensizer.actual_height - 200));
                            struct_set(c, [["instance", onIns]]);
                            struct_set(c, [["hovering", -1]]);
                        }
                        
                        if (keyboard_check_pressed(ord("X")))
                        {
                            _stSet("data.instances[" + string(onIns.instID) + "].variables.flipX", !onIns.flipX);
                            onIns.flipX = !onIns.flipX;
                        }
                        if (keyboard_check_pressed(ord("Y")))
                        {
                            _stSet("data.instances[" + string(onIns.instID) + "].variables.flipY", !onIns.flipY);
                            onIns.flipY = !onIns.flipY;
                        }
                        
                        instance_update_variables(onIns, _stGet("data.instances[" + string(onIns.instID) + "]"));
                        
                        if (updateStretch)
                        {
                            stretchDir = [0, 0];
                            var off = 8;
                            var insSpr = onIns.sprite_index;
                            var bbLeft = onIns.x - sprite_get_xoffset(insSpr) * onIns.image_xscale;
                            var bbRight = onIns.x + (-sprite_get_xoffset(insSpr) + sprite_get_width(insSpr)) * onIns.image_xscale;
                            var bbTop = onIns.y - sprite_get_yoffset(insSpr) * onIns.image_yscale;
                            var bbBottom = onIns.y + (-sprite_get_yoffset(insSpr) + sprite_get_height(insSpr)) * onIns.image_yscale;
                            
                            if (mouse_x < bbLeft + off)
                                stretchDir[0] = -1;
                            else if (mouse_x > bbRight - off)
                                stretchDir[0] = 1;
                            
                            if (mouse_y < bbTop + off)
                                stretchDir[1] = -1;
                            else if (mouse_y > bbBottom - off)
                                stretchDir[1] = 1;
                            
                            cursorStretch = array_duplicate(stretchDir);
                        }
                        
                        if (mouse_check_button_pressed(mb_left))
                        {
                            updateStretch = false;
                            instSelected = onIns;
                            selCarry = [onIns.x, onIns.y, onIns.image_xscale, onIns.image_yscale, mouse_x, mouse_y];
                            lockCursorMode = true;
                        }
                    }
                    
                    // cursor sprite
                    if (onIns != noone or !updateStretch)
                    {
                        if (abs(stretchDir[0]) == 1)
                            cursorImage = 3;
                        if (abs(stretchDir[1]) == 1)
                            cursorImage = 1;
                        if (abs(stretchDir[0]) == abs(stretchDir[1]))
                        {
                            if (stretchDir[0] == stretchDir[1])
                                cursorImage = 4;
                            else
                                cursorImage = 2;
                        }
                        if (stretchDir[0] == 0 and stretchDir[1] == 0)
                            cursorImage = 5;
                    }
                break;//
                
                case 2:
                    //nada lol
                break;
            }
        break;
        
        case st_tiles: // tile editing
            x = onGridPos[0];
            y = onGridPos[1];
            
            var xPlace = x - 2 * _stGet("data.properties.roomX");
            var yPlace = y - 2 * _stGet("data.properties.roomY");
            
            switch cursorMode
            {
                case 0:
                    var act = 0;
                    if (mouse_check_button(mb_left) and (onGridPos[0] != prevGridPos[0] or onGridPos[1] != prevGridPos[1]))
                    {
                        act = 1;
                        if (tileset_doAutoTile)
                        {
                            act = 3;
                        }
                    }
                    if (mouse_check_button(mb_right))
                    {
                        
                        cursorImage = 6;
                        if (onGridPos[0] != prevGridPos[0] or onGridPos[1] != prevGridPos[1])
                        {
                            act = 2;
                            if (tileset_doAutoTile)
                            {
                                act = 4
                            }
                        }
                    }
                    if (act != 0 and act < 3)
                    {
                        for (var tX = 0; tX < tilesetCoord[2]; tX ++)
                        {
                            for (var tY = 0; tY < tilesetCoord[3]; tY ++)
                            {
                                if (act == 1)
                                {
                                    var coords = [tilesetCoord[0] + tX, tilesetCoord[1] + tY]
                                    
                                    addTile(tilesetSelected, coords, x + tilesetStruct.size[0] * tX, y + tilesetStruct.size[1] * tY)
                                }
                                else
                                {
                                    deleteTile(x + tilesetStruct.size[0] * tX, y + tilesetStruct.size[1] * tY);
                                }
                            }
                        }
                    }
                    else if (act >= 3)
                    {
                        x -= gridSize;
                        y -= gridSize;
                        editor_autotile(act == 3, 2, 2);
                        x += gridSize;
                        y += gridSize;
                    }
                    
                    // reset mode 1 bullshits
                    tile_selection_made = false;
                    tile_selection = [0, 0, 0, 0, 0, 0];
                break;
                case 1:
                    if (!tile_selection_made)
                    {
                        if (mouse_check_button_pressed(mb_left))
                        {
                            lockCursorMode = true;
                            
                            tile_selection = [xPlace, yPlace, 0, 0, x, y];
                        }
                        if (mouse_check_button(mb_left))
                        {
                            tile_selection[2] = xPlace - tile_selection[0];
                            tile_selection[3] = yPlace - tile_selection[1];
                        }
                        if (mouse_check_button_released(mb_left))
                        {
                            if (tile_selection[2] < 0)
                            {
                                tile_selection[2] *= -1;
                                tile_selection[0] -= tile_selection[2];
                                tile_selection[4] -= tile_selection[2];
                            }
                            if (tile_selection[3] < 0)
                            {
                                tile_selection[3] *= -1;
                                tile_selection[1] -= tile_selection[3];
                                tile_selection[5] -= tile_selection[3];
                            }
                            
                            updateTileSelectionKeys();
                            
                            tile_selection_made = true;
                        }
                    }
                    else
                    {
                        var isInArea = (xPlace >= tile_selection[0] and xPlace <= tile_selection[0] + tile_selection[2]) and (yPlace >= tile_selection[1] and yPlace <= tile_selection[1] + tile_selection[3]);
                        if (mouse_check_button_pressed(mb_left))
                        {
                            if isInArea
                            {
                                tile_selection_move_origin = [xPlace, yPlace, x, y];
                                tile_selection_moving = true;
                            }
                        }
                        if (mouse_check_button_released(mb_left))
                        {
                            if (tile_selection_moving)
                            {
                                var xMove = xPlace - tile_selection_move_origin[0];
                                var yMove = yPlace - tile_selection_move_origin[1];
                                
                                for (var i = 0; i < array_length(tile_selection_keys); i ++)
                                {
                                    deleteTile(tile_selection_keys[i][0][0], tile_selection_keys[i][0][1]);
                                }
                                for (var i = 0; i < array_length(tile_selection_keys); i ++)
                                {
                                    var ogPos = [tile_selection_keys[i][0][0], tile_selection_keys[i][0][1]];
                                    
                                    addTile(tile_selection_keys[i][2], tile_selection_keys[i][1], ogPos[0] + xMove, ogPos[1] + yMove);
                                }
                                tile_selection[0] += xMove;
                                tile_selection[4] += xMove;
                                
                                tile_selection[1] += yMove;
                                tile_selection[5] += yMove;
                                
                                updateTileSelectionKeys();
                                
                                
                            }
                            else
                            {
                                tile_selection_made = false;
                                tile_selection = [0, 0, 0, 0, 0, 0];
                            }
                            tile_selection_moving = false;
                            lockCursorMode = false;
                        }
                        
                        if (keyboard_check_pressed(vk_backspace))
                        {
                            for (var i = 0; i <= tile_selection[2]; i += gridSize)
                            {
                                //addTile(tilesetCoord[)
                                for (var j = 0; j <= tile_selection[3]; j += gridSize)
                                {
                                    deleteTile(tile_selection[4] + i, tile_selection[5] + j);
                                }
                            }
                            tile_selection_moving = false;
                            lockCursorMode = false;
                        }
                        
                        if (keyboard_check_pressed(ord("F")))
                        {
                            var spreadIndices = []//
                            var selW = tile_selection[2] / gridSize;
                            var selH = tile_selection[3] / gridSize;
                            
                            for (var i = 0; i <= selW; i ++)
                            {
                                spreadIndices[i] = []
                                for (var j = 0; j <= selH; j ++)
                                {
                                    spreadIndices[i][j] = -1;
                                }
                            }
                            for (var i = 0; i <= tile_selection[2]; i += gridSize)
                            {
                                //addTile(tilesetCoord[)
                                for (var j = 0; j <= tile_selection[3]; j += gridSize)
                                {
                                    if (!tileset_doAutoTile)
                                    {
                                        var indX = i / gridSize;
                                        var indY = j / gridSize;
                                        var sInd = spreadIndices[indX][indY];
                                        if (sInd == -1)
                                        {
                                            sInd = irandom(array_length(tilesetCoord_spread) - 1)
                                            for (var p = 0; p < tilesetCoord_spread[sInd][2]; p ++)
                                            {
                                                for (var q = 0; q < tilesetCoord_spread[sInd][3]; q ++)
                                                {
                                                    spreadIndices[indX + p][indY + q] = sInd;
                                                }
                                            }
                                        }
                                        var sInd
                                        var tx = tilesetCoord_spread[sInd][0];
                                        var ty = tilesetCoord_spread[sInd][1];
                                        var tw = tilesetCoord_spread[sInd][2];
                                        var th = tilesetCoord_spread[sInd][3];
                                        //deleteTile(tile_selection[0] + i, tile_selection[1] + j);
                                        addTile(tilesetSelected, [tx + ((i / gridSize) % tw), ty + ((j / gridSize) % th)], tile_selection[4] + i, tile_selection[5] + j)
                                        //addTile(tilesetSelected, [tilesetCoord_spread[0][0] + i % tilesetCoord_spread[0][2], tilesetCoord_spread[0][1] + j % tilesetCoord_spread[0][3]], ogPos[0] + i, ogPos[1] + j);
                                    }
                                    else
                                    {
                                        //addTile(tilesetSelected, [0, 0], tile_selection[4] + i, tile_selection[5] + j, true)
                                    }
                                }
                            }
                            
                            if (tileset_doAutoTile)
                            {
                                var ogPos = [x, y];
                                x = tile_selection[4];
                                y = tile_selection[5];
                                
                                editor_autotile(true, floor(tile_selection[2] / gridSize) + 1, floor(tile_selection[3] / gridSize) + 1);
                                
                                x = ogPos[0];
                                y = ogPos[1];
                            }
                            
                            tile_selection_moving = false;
                            lockCursorMode = false;
                        }
                    }
                break;
            }
        break;
        
        case st_backgrounds:
            if (variable_struct_exists(data.backgrounds, string(layer_background)))
            {
                cursorNotice = "Click and drag to move the background"
            }
            if (variable_instance_exists(id, "prevMousePos"))
            {
                if (mouse_check_button(mb_left))
                {
                    var bgs = "data.backgrounds." + string(layer_background);
                    _stSet(bgs + ".x", _stGet(bgs + ".x") + mouse_x - prevMousePos[0]);
                    _stSet(bgs + ".y", _stGet(bgs + ".y") + mouse_y - prevMousePos[1]);
                }
            }
        break;
        
        case st_resize:
            cursorNotice = "Click and drag the room borders to resize it"
            // resizing room
            if (!mouse_check_button(mb_left))
            {
                roomResize = [0, 0];
                if (onGridPos[2] <= _stGet("data.properties.roomX"))
                    roomResize[0] = -1;
                else if (onGridPos[2] >= _stGet("data.properties.levelWidth"))
                    roomResize[0] = 1;
                
                if (onGridPos[3] <= _stGet("data.properties.roomY"))
                    roomResize[1] = -1;
                else if (onGridPos[3] >= _stGet("data.properties.levelHeight"))
                    roomResize[1] = 1;
                    
                roomResize[2] = onGridPos[2];
                roomResize[3] = onGridPos[3];
                
                roomPreResize = [_stGet("data.properties.roomX"), _stGet("data.properties.roomY"), _stGet("data.properties.levelWidth"), _stGet("data.properties.levelHeight")];
            }
            else
            {
                var xDiff = onGridPos[2] - roomResize[2];
                var yDiff = onGridPos[3] - roomResize[3];
                
                var maxSize = floor((16384) / 32) * 32
                var prop = data.properties;
                if (roomResize[0] == -1)
                {
                    _stSet("data.properties.roomX", clamp(roomPreResize[0] + xDiff, -maxSize + prop.levelWidth, _stGet("data.properties.levelWidth") - obj_screensizer.actual_width))
                }
                else if (roomResize[0] == 1)
                {
                    _stSet("data.properties.levelWidth", clamp(roomPreResize[2] + xDiff, _stGet("data.properties.roomX") + obj_screensizer.actual_width, maxSize + prop.roomX))
                }
                
                if (roomResize[1] == -1)
                {
                    _stSet("data.properties.roomY", clamp(roomPreResize[1] + yDiff, -maxSize + prop.levelHeight, _stGet("data.properties.levelHeight") - obj_screensizer.actual_height))
                }
                else if (roomResize[1] == 1)
                {
                    _stSet("data.properties.levelHeight", clamp(roomPreResize[3] + yDiff, _stGet("data.properties.roomY") + obj_screensizer.actual_height, maxSize + prop.roomY))
                }
            }
            
            cursorImage = 5;
            if (roomResize[0] != 0)
            {
                cursorImage = 3;
            }
            if (roomResize[1] != 0)
            {
                cursorImage = 1;
            }
            
            if (roomResize[0] != 0 and roomResize[1] != 0 and abs(roomResize[0]) == abs(roomResize[1]))
            {
                cursorImage = 4;
                if (roomResize[0] != roomResize[1])
                    cursorImage = 2;
            }
        break;
    }
    
    // zooming in out
    var zoomChange = (mouse_wheel_down() - mouse_wheel_up())
    if (zoomChange == 0)
    {
        zoomChange = keyboard_check_pressed(ord("E")) - keyboard_check_pressed(ord("Q"))
    }
    if (zoomChange != 0)
    {
        if (zoomChange > 0)
            camZoom *= 2
        else
            camZoom *= 0.5
        
        var l = camZoom
        camZoom = clamp(camZoom, power(2, -1), power(2, 3))
        if (l != camZoom)
        {
            zoomChange = 0;
        }
        var ogCamSize = [camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0])]
        
        
    }
    
    
    
    // scrolling screen
    if mouse_check_button(mb_middle)
    {
        cam_x -= (mouse_x - scroll_x)
        cam_y -= (mouse_y - scroll_y)
    }
    else
    {
        camScroll = [cam_x, cam_y]
    }
    
    
}
if mouse_check_button(mb_left) or mouse_check_button(mb_right)
{
    prevGridPos = array_duplicate(onGridPos);
}
else
{
    prevGridPos = [-1, -1];
}

camera_set_view_size(view_camera[0], (obj_screensizer.actual_width * camZoom), (obj_screensizer.actual_height * camZoom))
if (zoomChange > 0)
{
    cam_x -= (camera_get_view_width(view_camera[0]) / 2 - ogCamSize[0] / 2)
    cam_y -= (camera_get_view_height(view_camera[0]) / 2 - ogCamSize[1] / 2)
}
else if (zoomChange < 0)
{
    cam_x += ogCamSize[0] / 2 - camera_get_view_width(view_camera[0]) / 2
    cam_y += ogCamSize[1] / 2 - camera_get_view_height(view_camera[0]) / 2
}

if (zoomChange != 0)
{
    with obj_tilemapDrawer
    {
        initTilemapDrawer(other.data, layer_tilemap);
    }
}

prevMousePos = [mouse_x, mouse_y];

var t = w_findCanvasIndex("tileset");

var canMoveCam = true
if (t >= 0)
{
    if (w_isOnCanvas(w_openCanvas[t], cursorX / w_scale, cursorY / w_scale))
    {
        canMoveCam = false
    }
}
if (canMoveCam)
{
    var scrollSpd = 8 + (8 * keyboard_check(vk_shift));
    cam_x += (keyboard_check(ord("D")) - keyboard_check(ord("A"))) * scrollSpd * camZoom;
    cam_y += (keyboard_check(ord("S")) - keyboard_check(ord("W"))) * scrollSpd * camZoom;
}


// menus menus men
toolbarHovering = -1;
bgsHovering = -1;
for (var i = 0; i < array_length(w_openCanvas); i ++)
{
    var c = w_openCanvas[i];
    
    var onX = (cursorX / w_scale - c.x + c.scroll_x);
    var onY = (cursorY / w_scale - c.y + c.scroll_y);
    
    wCanvas_step(c, onX, onY, cursorX / w_scale, cursorY / w_scale);
    if (w_isOnCanvas(c, cursorX / w_scale, cursorY / w_scale))
    {
        switch c.name
        {
            case "toolbar":
                var mInd = floor(onX / 50);
                if (mInd > -1)
                {
                    toolbarHovering = mInd;
                }
                if (mouse_check_button_pressed(mb_left))
                {
                    if (mInd == editor_state)
                    {
                        editor_state = -1;
                    }
                    else
                    {
                        if (mInd > -1)
                        {
                            toolbarHovering = mInd;
                            switch (mInd)
                            {
                                case st_instances:
                                case st_tiles:
                                case st_backgrounds:
                                case st_rooms:
                                case st_settings:
                                    editor_state = mInd
                                break;
                                
                                case st_save:
                                    saveData();
                                    //show_message("Room saved to \"" + roomPath() + "\"");
                                break;
                                
                                case st_play:
                                    playRoom();
                                break;
                                
                                case st_edit:
                                    if (editor_state == 0 or editor_state == 1)
                                        selectingMode = !selectingMode
                                break;
                            }
                        }
                    }
                    editorWindowUpdate();
                }
            break;
            
            case "objFolders":
                var onFolder = clamp(floor(onY / _stGet("w_canvas.objFolders.gridSize[1]")), 0, array_length(variable_struct_get_names(objFolders)) - 1);
                struct_set(c, [["scrollBorders", [0, ((array_length(variable_struct_get_names(objFolders)) * _stGet("w_canvas.objFolders.gridSize[1]"))) - c.height]]])
                if (mouse_check_button_pressed(mb_left))
                    objFolderSelected = onFolder;
            break;
            
            case "objGrid":
                var og = _stGet("w_canvas.objGrid");
                var folderNames = objFolderOrder;//variable_struct_get_names(objFolders)
                var objs = _stGet("objFolders." + folderNames[objFolderSelected]);
                struct_set(c, [["scrollBorders", [0, ((array_length(objs) / og.columns) + 1) * og.gridSize - c.height]]])
                
                
                var objCoord = [floor(onX / og.gridSize), floor(onY / og.gridSize)];
                if (objCoord[0] == clamp(objCoord[0], 0, og.columns) and objCoord[1] == clamp(objCoord[1], 0, array_length(objs) / og.columns))
                {
                    var objInd = (objCoord[0] % og.columns) + objCoord[1] * og.columns;
                    if (objInd < array_length(objs))
                    {
                        cursorNotice = object_get_name(objs[objInd]);
                        if (mouse_check_button_pressed(mb_left))
                        {
                            objSelected = objs[objInd];
                        }
                    }
                }
                
                
            break;
            
            case "tilesetFolders":
                var mInd = floor(onX / 110);
                
                if (mInd == clamp(mInd, 0, array_length(global.tilesetData.order) - 1))
                {
                    if (mouse_check_button_pressed(mb_left))
                    {
                        tilesetFolder = mInd;
                        editorWindowUpdate();
                    }
                }
            break;
            
            case "tilesetList":
                var mInd = floor(onY / c.sep)
                
                
                tileset_listScroll = c.scroll_y;
                
                var order = global.tilesetData.order;
                var sets = struct_get(global.tilesetData.folders, order[tilesetFolder])
                
                //struct_set(c, [["scrollBorders", [0, max(array_length(sets) * c.sep - c.height, 0)]]])
                
                if (mInd == clamp(mInd, 0, array_length(sets) - 1))
                {
                    if (mouse_check_button_pressed(mb_left))
                    {
                        tilesetSelected = sets[mInd]
                        tileset_autotileIndex = 0;
                        editorWindowUpdate();
                        var tsSprite = _spr(tilesetSelected);
                        var tCanvas = w_openCanvas[w_findCanvasIndex("tileset")];
                        struct_set(tCanvas, [["scrollBorders", [sprite_get_width(tsSprite) - tCanvas.width, 2 * sprite_get_height(tsSprite) - tCanvas.height]]])
                    }
                }
            break;
            
            case "tileset":
                var tScale = tilesetStruct.scale;
                var w = tilesetStruct.size[0] * tScale;
                var h = tilesetStruct.size[1] * tScale;
                
                var sc = keyboard_check_pressed(ord("Q")) - keyboard_check_pressed(ord("E"))
                if (sc != 0)
                {
                    //struct_set(c, [["scroll_x", c.scroll_x + c.width / 2 * c.zoom], ["scroll_y", c.scroll_y + c.height / 2 * c.zoom]])
                    c.zoom *= power(1.25, sc)
                    struct_set(c, [["scroll_x", c.scroll_x * power(1.25, sc)], ["scroll_y", c.scroll_y * power(1.25, sc)]])
                }
                onX /= c.zoom
                onY /= c.zoom
                
                var tsSprite = _spr(tilesetSelected);
                var tex = sprite_get_texture(tsSprite, 0);
                
                if (!tileset_doAutoTile or w_findCanvasIndex("autotileEditor") != -1)
                {
                    struct_set(c, [["scrollBorders", [sprite_get_width(tsSprite) * tScale - c.width, (texture_get_height(tex) / texture_get_texel_height(tex)) * tScale - c.height]]])
                    cursorNotice = "Press Q/E to zoom in/out"
                }
                else
                {
                    struct_set(c, [["scrollBorders", [10 * gridSize - c.width, 0]]])
                }
                
                var mInd = [floor(onX / gridSize), floor(onY / gridSize)];
                if (mouse_check_button_pressed(mb_left))
                {
                    if (!keyboard_check(vk_control))
                    {
                        tilesetCoord_editing = tilesetCoord;
                        tilesetCoord_spread = [tilesetCoord]
                    }
                    else
                    {
                        var newArray = [0, 0, 1, 1];
                        array_push(tilesetCoord_spread, newArray);
                        tilesetCoord_editing = newArray;
                    }
                    tilesetCoord_editing[0] = mInd[0];
                    tilesetCoord_editing[1] = mInd[1];
                    
                    tilesetCoord_editing[2] = 1;
                    tilesetCoord_editing[3] = 1;
                }
                if (mouse_check_button(mb_left))
                {
                    tilesetCoord_editing[2] = clamp(mInd[0] - tilesetCoord_editing[0] + 1, 1, 200);
                    tilesetCoord_editing[3] = clamp(mInd[1] - tilesetCoord_editing[1] + 1, 1, 200);
                }
            break;
            
            case "bgs":
                if (_stGet("data.backgrounds." + string(layer_background)) == undefined)
                {
                    bgsHovering = floor(onY / 14);
                    if (mouse_check_button_pressed(mb_left))
                    {
                        switch (bgsHovering)
                        {
                            case 0:
                                editor_initBGLayer(layer_background, "burger");
                            break;
                            
                            case 1:
                                //wCanvas_close("bgPresetDropdown");
                                var nd = wCanvas_open_dropdown("bgPresetDropdown", cursorX / w_scale, cursorY / w_scale, global.bgpreset_names, "", "bgPresetSelected");
                            break;
                        }
                    }
                }
                else
                {
                    bgsHovering = floor(onY / 14);
                    
                    if (mouse_check_button_pressed(mb_left))
                    {
                        saveData();
                        bgString = "data.backgrounds." + string(layer_background);
                        switch bgsHovering
                        {
                            case 0:
                                var txt = fstring("{bgString}.sprite");
                                var nd = wCanvas_open_dropdown("bigDropdown", cursorX / w_scale, cursorY / w_scale, spriteList, _stGet(txt), "bgImageSelected", "Input sprite name");
                                //_stSet(txt, ask_or_not("Background sprite name:", _stGet(txt)))
                            break;
                            
                            case 1:
                            case 2:
                                var txt = bgString;
                                if (bgsHovering == 2)
                                    txt += ".y"
                                else
                                    txt += ".x"
                                _stSet(txt, real(ask_or_not("Input value:", _stGet(txt))));
                            break;
                            
                            case 3:
                            case 4:
                                var txt = bgString;
                                if (bgsHovering == 4)
                                    txt += ".scroll_y"
                                else
                                    txt += ".scroll_x"
                                _stSet(txt, real(ask_or_not("Input value:", _stGet(txt))));
                            break;
                            
                            case 5:
                            case 6:
                                var txt = bgString;
                                if (bgsHovering == 6)
                                    txt += ".tile_y"
                                else
                                    txt += ".tile_x"
                                _stSet(txt, !_stGet(txt));
                            break;
                            
                            case 7:
                            case 8:
                                var txt = bgString;
                                if (bgsHovering == 8)
                                    txt += ".vspeed"
                                else
                                    txt += ".hspeed"
                                _stSet(txt, real(ask_or_not("Input value:", _stGet(txt))));
                            break;
                            
                            case 9:
                                var txt = fstring("{bgString}.image_speed");
                                _stSet(txt, ask_or_not("Animation speed (in frames): ", _stGet(txt)))
                            break;
                            
                            case 10:
                                //var txt = fstring("{bgString}.image_speed");
                                var bgpName = get_string("Set a name for the new Background Preset:", prevBGPreset)
                                if (bgpName != "")
                                {
                                    bgPreset_save(bgpName, data.backgrounds, true);
                                    ass_addBGPreset(bgpName, data.backgrounds);
                                }
                                //_stSet(txt, ask_or_not("Save BG Preset...", _stGet(txt)))
                            break;
                            
                            case 11:
                                variable_struct_remove(_stGet("data.backgrounds"), string(layer_background))
                                with (obj_customBG)
                                {
                                    if (layer_background == other.layer_background)
                                    {
                                        instance_destroy();
                                    }
                                }
                            break;
                        }
                    }
                }
            break;
            
            case "rooms":
                roomHovering = floor(onY / 12)
                var onAdd = onX > _stGet("w_canvas.rooms.width") - 12 and onY < 12;
                if (roomHovering >= array_length(roomNameList) or onAdd)
                    roomHovering = -1;
                    
                struct_set(c, [["scrollBorders", [0, array_length(roomNameList) * 12 - c.height]]])
                    
                if (mouse_check_button_pressed(mb_left))
                {
                    if (roomHovering != -1)
                    {
                        saveData();
                        global.editorRoomName = roomNameList[roomHovering];
                        room_restart();
                    }
                    else if (onAdd)
                    {
                        var rName = get_string("New room name", "room" + string(array_length(roomNameList)));
                        if (rName != "")
                        {
                            saveData();
                            global.editorRoomName = rName;
                            room_restart();
                        }
                    }
                }
            break;
            
            case "settingTypes":
                if (mouse_check_button_pressed(mb_left))
                {
                    settingsMode = clamp(floor(onY / 16), 0, 1)
                }
            break;
            
            case "settings":
                settingsHovering = -1;
                if (settingsMode == 0) // room
                {
                    var mInd = floor(onY / 16);
                    if (mInd == clamp(mInd, 0, 2))
                    {
                        settingsHovering = mInd;
                    }
                    
                    if (mouse_check_button_pressed(mb_left))
                    {
                        var txt;
                        switch settingsHovering
                        {
                            case 0:
                                txt = "data.properties.song";
                                //_stSet(txt, ask_or_not("Audio asset name:", _stGet(txt)))
                                var opts = array_duplicate(audioList);
                                opts = array_concat(opts, global.defaultSong_names);
                                var def = _stGet(txt);
                                if (variable_struct_exists(global.defaultSong_display, def))
                                {   
                                    def = struct_get(global.defaultSong_display, def)
                                }
                                var nd = wCanvas_open_dropdown("bgPresetDropdown", cursorX / w_scale, cursorY / w_scale, opts, def, "songSelected");
                            break;
                            case 1:
                                txt = "data.properties.songTransitionTime";
                                _stSet(txt, ask_or_not("Transition time in milliseconds (has an effect ONLY on custom songs):", _stGet(txt)))
                            break;
                            case 2:
                                editor_state = st_resize;
                                editorWindowUpdate();
                            break;
                        }
                    }
                }
                else // level
                {
                    var mInd = floor(onY / 16);
                    if (mInd == clamp(mInd, 0, 6))
                    {
                        settingsHovering = mInd;
                    }
                    var opts = [];
                    if (mouse_check_button_pressed(mb_left))
                    {
                        var txt;
                        switch settingsHovering
                        {
                            case 0:
                                txt = "levelSettings.name";
                                _stSet(txt, ask_or_not("Level name:", _stGet(txt)))
                            break;
                            
                            case 1:
                                txt = "levelSettings.pscore";
                                _stSet(txt, ask_or_not("Score for an S rank:", _stGet(txt)))
                            break;
                            
                            case 2:
                                txt = "levelSettings.isWorld";
                                _stSet(txt, !_stGet(txt));
                            break;
                            
                            case 3:
                                txt = "levelSettings.escape";
                                _stSet(txt, timeString_get_seconds(ask_or_not("Pizza Time limit:", timeString_get_string(_stGet(txt)))));
                            break;
                            
                            case 4:
                            case 5:
                            case 6:
                                opts = array_duplicate(spriteList)
                                var cb = "cardSprite";
                                var prompt = "sprite"
                                var txt = "levelSettings.titlecardSprite";
                                if (settingsHovering == 4)
                                {
                                    opts = [];
                                    array_push(opts, "no titlecard")
                                    opts = array_concat(opts, spriteList)
                                }
                                if (settingsHovering == 5)
                                {
                                    cb = "Sprite"
                                    txt = "levelSettings.titleSprite";
                                }
                                else if (settingsHovering == 6)
                                {
                                    opts = audioList;
                                    prompt = "audio"
                                    cb = "Song"
                                    txt = "levelSettings.titleSong"
                                }
                                
                                
                                
                                var nd = wCanvas_open_dropdown("bigDropdown", cursorX / w_scale, cursorY / w_scale, opts, _stGet(txt), "title" + cb, "Input " + prompt + " name");
                            break;
                        }
                    }
                }
            break;
            
            case "instanceMenu":
                var ins = c.instance;
                if (!instance_exists(ins))
                {
                    wCanvas_close(c);
                    break;
                }
                var insData = _stGet("data.instances[" + string(ins.instID) + "]");
                var varInfo = instance_getVarList(insData.object, insData, true);
                var varList = varInfo[0];
                //show_message(varInfo[1]);
                variable_struct_set(c, "scrollBorders", [0, (array_length(varList) + 2) * 12 + 16 - c.height])
                struct_set(c, [["hovering", floor((onY - 16) / 12)]]);
                if (c.hovering != clamp(c.hovering, 0, array_length(varList) - 1))
                {
                    c.hovering = -1;
                }
                if (mouse_check_button_pressed(mb_left))
                {
                    if (onX < 12 and onY - c.scroll_y < 12)
                    {
                        wCanvas_close(c);
                    }
                    else if (onX < 12 and onY > 16 + array_length(varList) * 12)
                    {
                        var varName = get_string("variable name:", "");
                        if (varName != "")
                        {
                            var varValue = get_string(varName + " value:", "");
                            if (varValue != "")
                            {
                                var noDot = string_replace(varValue, ".", "");
                                if (string_digits(noDot) == noDot)
                                {
                                    varValue = real(varValue);
                                }
                                _stSet("data.instances[" + string(ins.instID) + "].variables." + varName, varValue);
                            }
                        }
                    }
                    else if (c.hovering != -1 and onX < c.width - 12 /*for scrolling*/) 
                    {
                        if (onX > c.width - 24)
                        {
                            variable_struct_remove(insData.variables, varList[c.hovering])
                        }
                        else
                        {
                            var varName = varList[c.hovering];
                            if (is_array(varInfo[1][c.hovering]))
                            {
                                var info = varInfo[1][c.hovering];
                                var opList = [];
                                if (is_string(info[1]))
                                {
                                    if (variable_instance_exists(id, info[1]))
                                    {
                                        opList = variable_instance_get(id, info[1]);
                                    }
                                }
                                
                                if (is_array(info[1]))
                                {
                                    opList = info[1];
                                }
                                
                                var cust = true;
                                if (array_length(info) > 2)
                                {
                                    if (variable_struct_exists(info[2], "noCustom"))
                                    {
                                        var cock = info[2]
                                        cust = !cock.noCustom;
                                    }
                                }
                                var d = wCanvas_open_dropdown("valueDropdown", clamp(cursorX / w_scale, 0, obj_screensizer.actual_width - c.width), clamp(cursorY / w_scale, 0, obj_screensizer.actual_height - c.height), opList, _stGet("data.instances[" + string(ins.instID) + "].variables." + varName), "varValueSelected", "input custom value:");//
                                struct_set(d, [
                                    ["instance", ins],
                                    ["instID", ins.instID],
                                    ["varName", varName],
                                    ["dropdownCustom", cust]
                                ])
                                
                            }
                            else
                            {
                                var varValue = get_string(varName + " value:", "");
                                if (varValue != "")
                                {
                                    var noDot = string_replace(varValue, ".", "");
                                    if (string_digits(noDot) == noDot)
                                    {
                                        varValue = real(varValue);
                                    }
                                    _stSet("data.instances[" + string(ins.instID) + "].variables." + varName, varValue);
                                }
                            }
                        }
                    }
                    
                    instance_update_variables(ins, insData);
                }
            break;
            
            case "autotileInd":
                var opts = [];
                var ts = _tileset(tilesetSelected);
                for (var j = 0; j < array_length(ts.autotile); j ++)
                {
                    opts[j] = j;
                    
                }
                if (array_length(opts) > 1)
                {
                    struct_set(c, [["optionList", opts]]);
                }
                else
                {
                    wCanvas_close(c);
                }
                
            break;
            
            case "autotileEditor":
                var atd = tilesetStruct.autotile[tileset_autotileIndex];
                if (mouse_check_button(mb_left))
                {
                    
                    var xInd = floor(onX / gridSize);
                    var yInd = floor(onY / gridSize);
                    if (xInd == clamp(xInd, 0, 10) and yInd == clamp(yInd, 0, 5))
                    {
                        for (var xx = 0; xx < tilesetCoord[2]; xx ++)
                        {
                            for (var yy = 0; yy < tilesetCoord[3]; yy ++)
                            {
                                atd[xInd + xx][yInd + yy] = [tilesetCoord[0] + xx, tilesetCoord[1] + yy];
                            }
                        }
                        array_set(tilesetStruct.autotile, tileset_autotileIndex, atd);
                    }
                }
                if (mouse_check_button_released(mb_left))
                {
                    var atFile = "sprites/" + tilesetSelected + "_" + string(tileset_autotileIndex) + ".autotile";
                    if (array_value_exists(global.defaultTilesets, tilesetSelected))
                    {
                        autotile_save(atd, editor_folder(atFile));
                    }
                    else
                    {
                        autotile_save(atd, mod_folder(atFile));
                    }
                }
            break;
            
            case "autotileEditButton":
                if (mouse_check_button_pressed(mb_left))
                {
                    var ind = w_findCanvasIndex("tileset");
                    if (ind != -1)
                    {
                        if (w_findCanvasIndex("autotileEditor") == -1)
                        {
                            var t = w_openCanvas[ind];
                            wCanvas_open("autotileEditor", t.x + t.width, t.y);
                        }
                        else
                        {
                            wCanvas_close("autotileEditor");
                        }
                    }
                }
            break;
        }
    }
}

instance_deactivate_object(obj_editorInst);
var v = view_camera[0];
instance_activate_region(camera_get_view_x(v), camera_get_view_y(v), camera_get_view_width(v), camera_get_view_height(v), true);
for (var i = 0; i < array_length(unwanted); i ++)
{
    instance_deactivate_object(unwanted[i]);
}

// shits alphas layersxsx
with obj_editorInst
{
    image_speed = 0;
    image_alpha = 1;
    if (other.editor_state != other.st_instances and other.editor_state != -1)
    {
        image_alpha = 0.5;
    }
    if (layer_get_name(layer) != layerFormat("Instances", other.layer_instances))
    {
        image_alpha = 0.5;
    }
}

with obj_tilemapDrawer
{
    image_alpha = 1;
    if (other.editor_state != other.st_tiles and other.editor_state != -1)
    {
        image_alpha = 0.5;
    }
    if (layer_tilemap != other.layer_tilemap)
    {
        image_alpha = 0.5;
    }
}

var edChange = keyboard_check_pressed(vk_tab)
editor_state += edChange;
if (editor_state > st_resize)
{
    editor_state = -1;
}

if (edChange != 0)
{
    editorWindowUpdate();
}

switch (editor_state)
{
    case st_instances:
        layer_instances += (keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left))
    break;
    
    case st_tiles:
        layer_tilemap -= (keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left))
    break;
    
    case st_backgrounds:
        layer_background -= (keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left))
    break;
}
layer_instances = clamp(layer_instances, 0, 100);
layer_tilemap = clamp(layer_tilemap, -8, 10);


var lvlW = struct_get(struct_get(data, "properties"), "levelWidth");
var lvlH = struct_get(struct_get(data, "properties"), "levelHeight");

var camW = camera_get_view_width(view_camera[0]);
var camH = camera_get_view_height(view_camera[0]);

cam_x = clamp(cam_x, -camW + (camW / 10) + _stGet("data.properties.roomX"), lvlW - camW / 10);
cam_y = clamp(cam_y, -camH + (camH / 10) + _stGet("data.properties.roomY"), lvlH - camH / 10);

camera_set_view_pos(view_camera[0], cam_x, cam_y)
scroll_x = mouse_x
scroll_y = mouse_y

//DEBUG
/*
if keyboard_check_pressed(ord("L"))
{
    var lvl = get_open_filename("old level editor level|*.ptlv", "level");
    if (lvl != "")
    {
        loadOldLevel(lvl);
    }
}
*/

// playing
if keyboard_check_pressed(vk_f5)
{
    playRoom();
}

// saving

if keyboard_check_pressed(vk_return)
{
    rp = roomPath()
    saveData()
}

if keyboard_check_pressed(vk_escape)
{
    saveData()
    room_goto(rmModMenu);
}


if (updateUndoMemory)
{
    ds_stack_clear(redo_stack)
    ds_stack_push(undo_stack, prevData);
    updateUndoMemory = false;
    //show_message("memory'd stack.");
}

if (keyboard_check(vk_control))
{
    if (keyboard_check_pressed(ord("Z")))
    {
        if (!ds_stack_empty(undo_stack))
        {
            var memString = ds_stack_pop(undo_stack);
            ds_stack_push(redo_stack, json_stringify(data));
            initStage(json_parse(memString))
        }
    }
    
    if (keyboard_check_pressed(ord("Y")))
    {
        if (!ds_stack_empty(redo_stack))
        {
            var memString = ds_stack_pop(redo_stack);
            ds_stack_push(undo_stack, json_stringify(data));
            initStage(json_parse(memString))
        }
    }
}

variable_struct_set(global.editorMemory, lvlRoom, new_memoryVarStruct())//, new_memoryStruct())
