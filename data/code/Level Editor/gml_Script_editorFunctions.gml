function playRoom()
{
    saveData();
    levelMemory_reset();
    instanceManager_reset();
    global.fromEditor = true;
    prepareCustomLevel(data, lvlRoom);
}

function initBGLayer(argument0, argument1)
{
    var lName = layerFormat("Background", argument1);
    layerConfirm("Background", argument1);
    
    with (obj_customBG)
    {
        if (layer_background == argument1)
        {
            instance_destroy();
        }
    }
    
    var cbg = instance_create_layer(0, 0, layer_get_id(lName), obj_customBG);
    cbg.layer_background = argument1;
    var d = argument0;
    var l = argument1;
    with (cbg)
    {
        init_customBG(d, l);
    }
}

function editor_initBGLayer(argument0, argument1) //layer, sprite name
{
    if (is_undefined(_stGet("data.backgrounds." + string(argument0))))
    {
        _stSet("data.backgrounds." + string(argument0), struct_new([
            ["sprite", argument1],
            ["x", 0],
            ["y", 0],
            ["scroll_x", 1],
            ["scroll_y", 1],
            ["tile_x", true],
            ["tile_y", true],
            ["hspeed", 0],
            ["vspeed", 0],
            ["image_speed", 15],
            ["panic_sprite", -1]
        ]));
    }
    //_tempbg = _stGet("data.backgrounds." + string(argument0));
    
    initBGLayer(data, argument0);
}

function updateTileSelectionKeys()
{
    if (!variable_struct_exists(_stGet("data.tile_data"), string(layer_tilemap)))
    {
        tileLayerConfirm(layer_tilemap)
        initTileLayer(layer_tilemap);
    }
    tile_selection_keys = [];
    for (var i = 0; i < tile_selection[2] + gridSize; i += gridSize)
    {
        for (var j = 0; j < tile_selection[3] + gridSize; j += gridSize)
        {
            var p = [int64(tile_selection[4] + i), int64(tile_selection[5] + j), int64(tile_selection[0] + i), int64(tile_selection[1] + j)]
            var k = string(p[0]) + "_" + string(p[1]);
            if (variable_struct_exists(_stGet("data.tile_data." + string(layer_tilemap)), string(k)))
            {
                var s = _stGet("data.tile_data." + string(layer_tilemap) + "." + string(k));
                array_push(tile_selection_keys, [array_duplicate(p), array_duplicate(s.coord), s.tileset]);
            }
        }
    }
}

function tileLayerConfirm(argument0)
{
    var tLayer = string(argument0);
    if (!variable_struct_exists(_stGet("data.tile_data"), tLayer))
    {
        _stSet("data.tile_data." + tLayer, struct_new());
    }
}

function stopSong()
{
    customSong_destroy_all();
    stop_music()
    //var m = obj_music.music
    //show_message(m)
    //fmod_event_instance_stop(m.event, 1);
}

function tileArray_get(argument0, argument1, argument2)
{
    _tStruct = argument0;
    var tileNames = variable_struct_get_names(_tStruct);
    //var 
    for (var i = 0; i < array_length(tileNames); i ++)
    {
        var pos = string_split(tileNames[i], "_")
        pos = [int64((real(pos[0]) - argument1) / 32), int64((real(pos[1]) - argument2) / 32)]
        if (pos[0] > 0 and pos[1] > 0)
        {
            
        }
    }
}

function new_memoryVarStruct()
{
    return (struct_new([
        ["cam_x", cam_x],
        ["cam_y", cam_y],
        ["tilesetSelected", tilesetSelected],
        ["objSelected", objSelected],
        ["editor_state", editor_state],
        ["camZoom", camZoom],
        ["layer_instances", layer_instances],
        ["layer_tilemap", layer_tilemap],
        ["layer_background", layer_background],
        ["tileset_doAutoTile", tileset_doAutoTile],
        ["tilesetFolder", tilesetFolder]
    ]))
}

function instance_update_variables(argument0, argument1)
{
    var ins = argument0;
    var insData = argument1;
    var varNames = variable_struct_get_names(struct_get(insData, "variables"));
    var isQBlock = array_value_exists(variable_struct_get_names(global.objectData.questionBlocks), object_get_name(insData.object));
    for (var j = 0; j < array_length(varNames); j ++)
    {
        var val = struct_get(struct_get(insData, "variables"), varNames[j]);
        //
        variable_instance_set(ins, varNames[j], varValue_ressolve(val));
        
        if (isQBlock)
        {
            if (struct_get(global.objectData.questionBlocks, object_get_name(insData.object)) == varNames[j])
            {
                ins.absorbed = varValue_ressolve(val);
            }
        }
    }
}

function instance_getVarList(argument0, argument1, argument2) //object, instance data, return detailed array
{
    var insData = argument1;
    var hide = "x,y,flipX,flipY,"//,image_xscale,image_yscale,"
    var varNames = variable_struct_get_names(struct_get(insData, "variables"));
    
    var output = [];
    var defaultVars = [];
    
    
    var otherVars = []
    var obj = argument0;
    var od = global.objectData;
    var objLists = variable_struct_get_names(od.objectVariables);
    for (var i = 0; i < array_length(objLists) and i != -1; i ++)
    {
        var parent = object_get_parent(obj)
        var parentPresent = false;
        while (parent != -1 and !parentPresent)
        {
            if (string_pos("|" + object_get_name(parent) + "|", objLists[i]) != 0)
                parentPresent = true;
            parent = object_get_parent(parent);
        }
        if (string_pos("|" + object_get_name(obj) + "|", objLists[i]) != 0 or parentPresent or objLists[i] == "all")
        {
            var ov = struct_get(od.objectVariables, objLists[i]);
            for (var j = 0; j < array_length(ov); j ++)
            {
                array_push(defaultVars, ov[j]);
                var varCompare = ov[j]
                if (is_array(varCompare))
                {
                    varCompare = varCompare[0];
                }
                if (!array_value_exists(output, varCompare))
                    array_push(output, varCompare)
            }
        }
    }
    
    for (var i = 0; i < array_length(varNames); i ++)
    {
        if (string_pos(varNames[i] + ",", hide) == 0 and !array_value_exists(output, varNames[i]))
        {
            array_push(output, varNames[i]);
            array_push(defaultVars, -1);
        }
    }
    
    if (argument2 == true)
        return([output, defaultVars]);
    return(output)
}

function level_filename(argument0) //level name
{
    return(mod_folder("levels/" + argument0 + "/level.ini"))
}

function level_load(argument0) //level name (returns a struct)
{
    var l = struct_new();
    ini_open(level_filename(argument0));
    struct_set(l, [
        ["name", ini_read_string("data", "name", "Level Name")],
        ["pscore", ini_read_real("data", "pscore", 10000)],
        ["isWorld", ini_read_real("data", "isWorld", 0)],
        ["escape", ini_read_real("data", "escape", timeString_get_seconds("4:00"))],
        ["titlecardSprite", ini_read_string("data", "titlecardSprite", "no titlecard")],
        ["titleSprite", ini_read_string("data", "titleSprite", "")],
        ["titleSong", ini_read_string("data", "titleSong", "")]
    ])
    ini_close();
    return(l);
}

function level_save(argument0, argument1) //level name, level struct
{
    var l = argument1;
    ini_open(level_filename(argument0));
    ini_write_string("data", "name", l.name);
    ini_write_real("data", "pscore", l.pscore);
    ini_write_real("data", "isWorld", l.isWorld);
    ini_write_real("data", "escape", l.escape);
    ini_write_string("data", "titlecardSprite", l.titlecardSprite);
    ini_write_string("data", "titleSprite", l.titleSprite);
    ini_write_string("data", "titleSong", l.titleSong);
    ini_close();
}

function timeString_get_seconds(argument0)
{
    if (string_count(":", argument0) != 1)
    {
        if (string_digits(argument0) == "")
            argument0 = "0";
        return(real(string_digits(argument0)))
    }
    var time = SplitString(argument0, ":")
    if (string_digits(time[0]) == "") time[0] = "0";
    if (string_digits(time[1]) == "") time[1] = "0";
    return(real(string_digits(time[0])) * 60 + real(string_digits(time[1])))
}

function timeString_get_string(argument0)
{
    return(string(floor(argument0 / 60)) + ":" + string_replace(string(floor(argument0) % 60 + 100), "1", ""));
}

function object_compareToList(argument0, argument1) //object index
{
    var objName = object_get_name(argument0);
    
    if (array_value_exists(argument1, objName))
        return true;
    
    var parent = object_get_parent(argument0);
    var parentPresent = false;
    
    
    while (parent != -1 and !parentPresent)
    {
        if (array_value_exists(argument1, object_get_name(parent)))
        {
            return true;
            parentPresent = true;
        }
        parent = object_get_parent(parent);
    }
    return false;
}


function bgPreset_save(argument0, argument1, argument2) //preset name, bg struct, ask for overwrite
{
    var jt = json_stringify(argument1);
    argument1 = json_parse(jt);
    var path = mod_folder("presets/" + argument0 + ".bgpreset")
    
    if (global.modFolder == "")
    {
        path = editor_folder("presets/" + argument0 + ".bgpreset")
    }
    
    if (file_exists(path) and argument2)
    {
        var q = show_question("the BG Preset \"" + argument0 + "\" already exists. overwrite it?");
        if (!q)
            return;
    }
    
    var f = file_text_open_write(path)
    file_text_write_string(f, json_stringify(argument1))
    file_text_close(f);
}

function editor_drawCanvasNotice(argument0, argument1) //canvas struct, text (this WONT WORK if the surface targetted before isn't the canvas surface)
{
    var c = argument0;
    surface_reset_target();
    draw_set_alpha(0.7);
    draw_set_font(global.smallfont)
    draw_text_transformed(c.x * w_scale, (c.y + c.height + 4) * w_scale, string_upper(argument1), 1, 1, 0)//w_scale, w_scale, 0)
    draw_set_font(global.editorfont)
    draw_set_alpha(1);
    surface_set_target(c.surface)
}

function roomData_new()
{
    return(struct_new([
        ["editorVersion", editorVersion],
        ["properties", struct_new([
            ["levelWidth", obj_screensizer.actual_width],
            ["levelHeight", obj_screensizer.actual_height],
            ["roomX", 0],
            ["roomY", 0],
            ["song", ""],
            ["songTransitionTime", 100]
        ])],
        ["instances", []],
        ["tile_data", struct_new()],
        ["backgrounds", struct_new()]
    ]))
}

function doOverlap(argument0, argument1)
{
    /*var l1 = argument0;
    var r1 = argument1;
    var l2 = argument2;
    var r2 = argument3;*/
    var l1 = struct_new()
    var r1 = struct_new();
    var l2 = struct_new();
    var r2 = struct_new();
    
    l1.x = argument0[0];
    l1.y = argument0[1];
    r1.x = argument0[2];
    r1.y = argument0[3];
    
    l2.x = argument1[0];
    l2.y = argument1[1];
    r2.x = argument1[2];
    r2.y = argument1[3];
    
    //show_message(string(l1) + "\n" + string(r1) + "\n" + string(l2) + "\n" + string(r2))
    // if rectangle has area 0, no overlap
    if (l1.x == r1.x || l1.y == r1.y || r2.x == l2.x || l2.y == r2.y)
    {
        //show_message("area 0")
        return false;
    }
 
    // If one rectangle is on left side of other
    if (l1.x > r2.x || l2.x > r1.x) {
        //show_message("on the left side because either " + string(l1.x) + " > " + string(r2.x) + "  or  " + string(l2.x) + " > " + string(r1.x))
        return false;
    }

    // If one rectangle is above other
    if (r1.y < l2.y || r2.y < l1.y) {
        //show_message("above another because " + string(r1.y) + " > " + string(l2.y) + "  or  " + string(r2.y) + " > " + string(l1.y))
        return false;
    }
    //show_message("this works")
    return true;
}

function loadOldLevel(argument0) //path
{
    //data = roomData_new();
    //initStage(data);
    //var prop = data.properties;
    port_mode = true;
    
    var test1 = [0, 0, 10, 10];
    var test2 = [5, 5, 20, 20];
    //show_message(doOverlap(test1, test2));
    
    var ptlv = json_parse(file_text_read_all(argument0))
    var objs = ptlv.ROOT;
    
    rooms = [roomData_new()];
    roomNames = ["outside"]
    cams = [];
    
    for (var i = 0; i < array_length(objs); i ++)
    {
        var cam = objs[i];
        var ptlvInst = objs[i];
        var o = ptlvInst.obj;
        var og = o;
        
        if (string_pos("obj_camera_", o) == 0)
        {
            continue;
        }
        
        var xscale = ptlvInst.image_xscale;
        var yscale = ptlvInst.image_yscale;
        switch (o)
        {
            case "obj_camera_1x2":
                
                xscale *= 2;
            break;
            case "obj_camera_2x1":
                yscale *= 2;
            break;
            case "obj_camera_2x2":
                xscale *= 2;
                yscale *= 2;
            break;
        }
        
        array_push(cams, [cam.x, cam.y, cam.x + obj_screensizer.actual_width * xscale, cam.y + obj_screensizer.actual_height * yscale, []]);
        array_push(roomNames, "room" + string(array_length(cams)));
    }
    
    if (array_length(cams) == 0)
    {
        roomNames[0] = "main";
    }
    
    
    var dx = 256;
    var dy = 320;
    
    var sgData = rooms[0];
    
    /*for (var i = 0; i < array_length(cams); i ++)
    {
        var cam = cams[i];
        
        var rd = roomData_new();
        var prop = rd.properties;
        prop.levelWidth = cam[2] - cam[0];
        prop.levelHeight = cam[3] - cam[1];
        
        if (clamp(dx, cam[0], cam[2]) == dx and clamp(dy, cam[1], cam[3]) == dy)
        {
            sgData = rd;
            roomNames[i + 1] = "main";
        }
        
        array_push(rooms, rd);
    }*/
    
    data = sgData;
    addInst(obj_doorA, dx - 16, dy + 32 * 3)
    addInst(obj_exitgate, dx, dy);
    
    
    
    var savedTriggers = struct_new();
    for (var i = 0; i < array_length(objs); i ++)
    {
        var ptlvInst = objs[i];
        var o = ptlvInst.obj;
        var og = o;
        
        
        
        var maybeTile = "z_oldeditor/tilesets/" + string_lower(o);
        var maybeSlope = "z_oldeditor/slopes/" + string_lower(o);
        var maybeProp = "z_oldeditor/props/" + string_lower(o);
        
        var isOutside = true;
        
        var bordX = [0, 0];
        var bordY = [0, 0];
        
        if (_spr_exists(maybeTile))
        {
            var img = ptlvInst.image_index;
            var rmTarget = 0;
            for (var c = 0; c < array_length(cams); c ++)
            {
                if (doOverlap(cams[c], [ptlvInst.x + 1, ptlvInst.y + 1, ptlvInst.x + 31, ptlvInst.y + 31]))
                {
                    rmTarget = c + 1;
                    isOutside = false;
                }
            }
            
            data = rooms[rmTarget];
            var offX = 0;
            var offY = 0;
            if (rmTarget > 0)
            {
                offX = cams[rmTarget - 1][0];
                offY = cams[rmTarget - 1][1];
            }
            addTile(maybeTile, [img % 8, floor(img / 8)], ptlvInst.x - offX, ptlvInst.y - offY);
            
            bordX = [floor((ptlvInst.x - 64) / 32) * 32, floor((ptlvInst.x + 32 + 64) / 32) * 32]
            bordY = [floor((ptlvInst.y - 64) / 32) * 32, floor((ptlvInst.y + 32 + 64) / 32) * 32]
        }
        else
        {
            var objSwap = struct_new([
                ["obj_destroyableescape", "obj_destroyable_escape"],
                ["obj_destroyable2escape", "obj_destroyable2_escape"],
                ["obj_destroyable2_bigescape", "obj_destroyable2_big_escape"],
                ["obj_destroyable3escape", "obj_destroyable3_escape"],
                ["obj_onwaybigblock_editor", "obj_onewaybigblock"],
                ["obj_baddiespawner_editor", "obj_baddiespawner"],
                ["obj_camera_1x1", "obj_camera_region"],
                ["obj_camera_2x1", "obj_camera_region"],
                ["obj_camera_1x2", "obj_camera_region"],
                ["obj_camera_2x2", "obj_camera_region"],
                ["obj_slopes", "obj_slopes"],
                ["obj_boxofpizza_editor", "obj_boxofpizza"],
                ["obj_door_editor", "obj_door"],
                ["obj_keydoor_editor", "obj_keydoor"],
                ["obj_water_editor", "obj_water"],
                ["obj_current_editor", "obj_current"],
                ["obj_teleporter_editor", "obj_teleporter"],
                ["obj_pizzabox", "obj_pizzaboxunopen"],
            ])
            
            if (variable_struct_exists(objSwap, ptlvInst.obj))
            {
                ptlvInst.obj = struct_get(objSwap, o);
                o = ptlvInst.obj;
            }
            
            if (!object_exists(asset_get_index(ptlvInst.obj)))
            {
                o = "obj_sprite";
            }
            
            
            var extraInst = noone;
            var extraData = undefined;
            
            // cases before creation
            switch (o)
            {
                case "obj_camera_region":
                    layer_instances = 5;
                break;
                
                case "obj_teleporter":
                    struct_confirm(ptlvInst, "start", true);
                    struct_confirm(ptlvInst, "trigger", 0);
                    if (!ptlvInst.start)
                    {
                        ptlvInst.obj = "obj_teleporter_receptor";
                        o = ptlvInst.obj;
                    }
                break;
                
                case "obj_pizzaboxunopen":
                    var toppins = ["obj_pizzakinshroom", "obj_pizzakincheese", "obj_pizzakintomato", "obj_pizzakinsausage", "obj_pizzakinpineapple"]
                    ptlvInst.content = toppins[ptlvInst.image_index];
                    variable_struct_remove(ptlvInst, "image_index");
                break;
                
                case "obj_ladder":
                    ptlvInst.showLadder = true;
                break;
            }
            
            if (_spr_exists(maybeSlope))
            {
                ptlvInst.obj = "obj_slope";
                o = "obj_slope";
            }
            
            if (_spr_exists(maybeProp))
            {
                ptlvInst.obj = "obj_sprite";
                o = ptlvInst.obj;
                ptlvInst.sprite_index = maybeProp;
            }
            
            struct_confirm(ptlvInst, "image_xscale", 1);
            struct_confirm(ptlvInst, "image_yscale", 1);
            
            var oSpr = object_get_sprite(asset_get_index(o));
            
            if (ptlvInst.image_xscale < 0)
            {
                ptlvInst.image_xscale = abs(ptlvInst.image_xscale)
                var horDifference = sprite_get_width(oSpr) - sprite_get_xoffset(oSpr) * 2
                ptlvInst.x -= horDifference * ptlvInst.image_xscale;
                ptlvInst.flipX = true;
            }
            if (ptlvInst.image_yscale < 0)
            {
                ptlvInst.image_yscale = abs(ptlvInst.image_yscale)
                var verDifference = sprite_get_height(oSpr) - sprite_get_yoffset(oSpr) * 2
                ptlvInst.y -= verDifference * ptlvInst.image_yscale;
                ptlvInst.flipY = true;
            }
            
            //setting which rooms to use
            var xs = ptlvInst.image_xscale;
            var ys = ptlvInst.image_yscale;
            var bord = [
                ptlvInst.x - sprite_get_xoffset(oSpr) * xs,
                ptlvInst.y - sprite_get_yoffset(oSpr) * xs,
                ptlvInst.x + (sprite_get_width(oSpr) - sprite_get_xoffset(oSpr)) * xs,
                ptlvInst.y + (sprite_get_height(oSpr) - sprite_get_yoffset(oSpr)) * ys
            ]
            var inRooms = [rooms[0]];
            var inCamInds = [-1];
            for (var c = 0; c < array_length(cams); c ++)
            {
                var cam = cams[c];
                var lean = 32;
                if (string_pos("obj_camera_", o) != 0)
                {
                    array_push(inRooms, rooms[c + 1])
                    array_push(inCamInds, c)
                }
                else
                {
                    if (bord[0] > cam[0] and bord[1] > cam[1] and bord[2] < cam[2] and bord[3] < cam[3])
                    {
                        isOutside = false;
                        //show_message("");
                    }
                    
                    if (doOverlap(bord, [cam[0] - lean, cam[1] - lean, cam[2] + lean, cam[3] + lean]))
                    {
                        array_push(inRooms, rooms[c + 1])
                        array_push(inCamInds, c)
                    }
                }
            }
            
            //CREATION
            for (var r = 0; r < array_length(inRooms); r ++)
            {
                if (r == 0 and !isOutside)
                {
                    continue;
                }
                data = inRooms[r];
                var prop = data.properties;
                
                var rmX = 0;
                var rmY = 0;
                if (r > 0)
                {
                    rmX = cams[inCamInds[r]][0]
                    rmY = cams[inCamInds[r]][1]
                }
                
                var nInst = addInst(asset_get_index(o), ptlvInst.x - rmX, ptlvInst.y - rmY);
                var instData = data.instances[nInst.instID]
                
                layer_instances = 0;
                
                var instVars = instData.variables;
                var prev_layer = layer_instances;
                
                // cases after creation, before initialization
                switch (o)
                {
                    case "obj_destroyable":
                    case "obj_destroyable2":
                    case "obj_destroyable2_big":
                    case "obj_destroyable3":
                    
                        
                        layer_instances = 2;
                        extraInst = addInst(obj_secretblock, ptlvInst.x - rmX, ptlvInst.y - rmY);
                        extraData = data.instances[extraInst.instID];
                        
                    
                    case "obj_onewaybigblock":
                    case "obj_metalblock":
                        
                        instVars.depth = 100;
                    break;
                    
                    case "obj_boxofpizza":
                        layer_instances = 1;
                        
                        var yy = -64
                        if (ptlvInst.image_yscale < 0) yy = 32;
                        
                        extraInst = addInst(obj_warp_number, ptlvInst.x - rmX, ptlvInst.y + yy - rmY);
                        extraData = data.instances[extraInst.instID];
                        var vars = extraData.variables;
                        vars.trigger = ptlvInst.index + 101
                    break;
                    
                    case "obj_door":
                        layer_instances = 1;
                        extraInst = addInst(obj_warp_number, ptlvInst.x + 32 * ptlvInst.image_xscale - rmX, ptlvInst.y + 64 * ptlvInst.image_yscale - rmY);
                        extraData = data.instances[extraInst.instID];
                        var vars = extraData.variables;
                        vars.trigger = ptlvInst.index
                    break;
                    
                    case "obj_slope":
                        if (_spr_exists(maybeSlope))
                        {
                            instVars.customSprite = maybeSlope
                        }
                    break;
                    
                }
                layer_instances = prev_layer;
                
                
                
                
                var vNames = variable_struct_get_names(ptlvInst);
                for (var j = 0; j < array_length(vNames); j ++)
                {
                    
                    
                    switch (vNames[j])
                    {
                        case "x":
                        case "y":
                            var val = 0;
                        break;
                        
                        default:
                            var val = struct_get(ptlvInst, vNames[j]);
                            
                            struct_set(instData.variables, [[vNames[j], val]])
                            
                            
                    
                            if (extraData != undefined)
                            {
                                if (extraData.object != obj_warp_number)
                                    struct_set(extraData.variables, [[vNames[j], val]])
                            }
                        break;
                    }
                    
                    
                }
                
                switch (og)
                {
                    case "obj_camera_1x2":
                        
                        instVars.image_xscale *= 2;
                    break;
                    case "obj_camera_2x1":
                        instVars.image_yscale *= 2;
                    break;
                    case "obj_camera_2x2":
                        instVars.image_xscale *= 2;
                        instVars.image_yscale *= 2;
                    break;
                    
                    case "obj_baddiespawner_editor":
                        var contents = [
                            obj_pizzagoblin,
                            obj_pizzagoblinbomb,
                            obj_pepgoblin,
                            obj_pizzard,
                            obj_swedishmonkey,
                            obj_weeniesquire,
                            obj_weeniemount,
                            obj_cheeseslime,
                            obj_forknight,
                            obj_kentukykenny,
                            obj_kentukykenny_projectile,
                            obj_junk,
                            obj_pizzaboy,
                            obj_shotgun,
                            obj_rancher,
                            obj_miniufo,
                            obj_barrel,
                            obj_pickle,
                            obj_canongoblin,
                            obj_noisegoblin,
                            obj_coolpineapple
                        ]
                        //struct_confirm(instVars, "image_index", 0);
                        instVars.content = object_get_name(contents[instVars.image_index]);
                    break;
                }
                
                if (extraInst != noone)
                {
                    //cases after initialization
                    switch (o)
                    {
                        case "obj_destroyable":
                        case "obj_destroyable2":
                        case "obj_destroyable2_big":
                        case "obj_destroyable3":
                            var vars = extraData.variables;
                            vars.image_xscale = sprite_get_width(oSpr) * instVars.image_xscale / 32//nInst.sprite_width / 32;
                            vars.image_yscale = sprite_get_height(oSpr) * instVars.image_yscale / 32//nInst.sprite_height / 32;
                        break;
                    }
                    
                    //instance_update_variables(extraInst, extraData);
                }
                
                
                //instance_update_variables(nInst, instData);
                
                
                
            }
            bordX = [floor((bord[0] - 64) / 32) * 32, floor((bord[2] + 64) / 32) * 32]
            bordY = [floor((bord[1] - 64) / 32) * 32, floor((bord[3] + 64) / 32) * 32]
        }
        if (isOutside)
        {
            data = rooms[0];
            var prop = data.properties;
            if (bordX[0] < prop.roomX)
            {
                prop.roomX = bordX[0];
            }
            if (bordX[1] > prop.levelWidth)
            {
                prop.levelWidth = bordX[1];
            }
            if (bordY[0] < prop.roomY)
            {
                prop.roomY = bordY[0];
            }
            if (bordY[1] > prop.levelHeight)
            {
                prop.levelHeight = bordY[1];
            }
        }
    }
    
    for (var i = 0; i < array_length(rooms); i ++)
    {
        data = rooms[i]
        lvlRoom = roomNames[i]
        saveData();
    }
    
    port_mode = false;
    
    global.editorRoomName = "main";
    room_restart();
}