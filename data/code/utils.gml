var str, pos1, pos2, token, varName;
function fstring(argument0) //string with format
{
    str = argument0;
    while (string_count("{", str) > 0)
    {
        pos1 = string_pos("{", str)
        pos2 = string_pos("}", str)
        token = string_copy(str, pos1, (1 + (pos2 - pos1)))
        varName = string_replace(string_replace(token, "{", ""), "}", "")
        str = string_replace(str, token, variable_instance_get(id, varName))
    }
    return str;
}

function parseStructString(argument0, argument1, argument2)
{
    var str = argument0;
    var prevDS = argument1;
    var valToSet = argument2;
    
    var is_set = !is_undefined(valToSet);
    
    if (is_undefined(prevDS))
    {
        prevDS = id;
    }
    if (string_count(str, "[") != string_count(str, "]"))
    {
        show_error("\"" + str + "\" is invalid.", true);
    }
    var pos1 = string_pos(".", str);
    var pos2 = string_pos("[", str);
    
    if (pos1 == 0)
        pos1 = 10000
    if (pos2 == 0)
        pos2 = 10001
    
    var token = "";
    var varValue;
    token = string_copy(str, 1, min(pos1, pos2) - 1)
    
    if (is_struct(prevDS))
    {
        varValue = variable_struct_get(prevDS, token);
    }
    else
    {
        if (is_array(prevDS))
            show_message(prevDS);
        varValue = variable_instance_get(prevDS, token);
    }
    
    if (pos1 < pos2)
    {
        var finalStr = string_delete(str, 1, pos1)
        if (is_set and finalStr == "")
            variable_instance_set(prevDS, token, valToSet);
        
        return([varValue, finalStr]); //shit.ass -> ass
    }
    else
    {
        var ind = 0;
        while (pos2 < pos1)
        {
            str = string_delete(str, 1, pos2) //shit[0].ass -> 0].ass  /  shit[0][1].ass = 0][1].ass
            //show_message(str)
            var pos3 = string_pos("]", str);
            ind = string_copy(str, 1, pos3 - 1)
            if (string_digits(ind) != ind)
            {
                ind = variable_instance_get(id, ind);
            }
            ind = real(ind);
            
            prevDS = varValue;
            varValue = prevDS[ind]
            //show_message()
            str = string_delete(str, 1, pos3); //0].ass -> .ass  /  0][1].ass -> [1].ass
            pos1 = string_pos(".", str);
            pos2 = string_pos("[", str);
            
            if (pos2 == 0)
                pos2 = pos1 + 1;
        }
       
        var prevStr = str;
        if (string_count(".", str) > 0)
            str = string_delete(str, 1, 1) //.ass -> ass
        else
        {
            str = "";
        }
        
        if (is_set and str == "")
        {
            //show_message(string(typeof(prevDS)))
            //show_message("(" + prevStr + ")")
            array_set(prevDS, ind, valToSet);
        }
        
        return([varValue, str]);
    }
}

function _stGet(argument0, argument1)
{
    var _str = argument0;
    var val = undefined;
    var origin = id;
    while (_str != "")
    {
        //show_message(_str)
        var result = parseStructString(_str, origin, argument1)
        val = result[0];
        _str = result[1];
        
        
        
        origin = val;
    }
    return(val);
    //return("hi")
}

function _stSet(argument0, argument1)
{
    return(_stGet(argument0, argument1));
}

function ass_loadSprite(argument0, argument1) //sprite file, folder
{
    var sprName = string_replace(string_replace(argument0, argument1, ""), ".png", "");
    
    var iniFile = string_replace(argument0, ".png", ".ini");
    var atFile = string_replace(argument0, ".png", "");
    
    var offset = [0, 0];
    var centered = false;
    var images = 1;
    var image_width = 0;
    
    var tile_size = 0;
    var tile_scale = 1;
    
    if (file_exists(iniFile))
    {
        ini_open(iniFile);
        offset = [ini_read_real("offset", "x", 0), ini_read_real("offset", "y", 0)];
        centered = ini_read_real("offset", "centered", false);
        images = ini_read_real("properties", "images", 1);//
        image_width = ini_read_real("properties", "image_width", 0);//
        tile_size = abs(int64(ini_read_real("tileset", "size", 0)));
        if (tile_size != 0)
            tile_scale = 32 / tile_size//ini_read_real("tileset", "scale", 1);
        ini_close();
    }
    if (image_width > 0)
    {
        var pseudo = sprite_add(argument0, 1, false, false, 0, 0);
        images = sprite_get_width(pseudo) / image_width;
        sprite_delete(pseudo);
    }
    var sprAdded = sprite_add(argument0, images, false, false, 0, 0);
    sprite_set_speed(sprAdded, 1, spritespeed_framespergameframe)
    if (centered)
    {
        offset[0] += sprite_get_width(sprAdded) / 2;
        offset[1] += sprite_get_height(sprAdded) / 2;
    }
    sprite_set_offset(sprAdded, offset[0], offset[1])
    
    //show_message(argument0 + " , " + sprName + " , " + string(sprAdded));
    if (!ds_map_exists(global.sprites, sprName))
    {
        ds_map_add(global.sprites, sprName, sprAdded);
        array_push(global.sprite_names, sprName);
    }
    else
    {
        ds_map_set(global.sprites, sprName, sprAdded);
    }
    
    if (tile_size != 0)
    {
        ass_addTileset(sprName, tile_size, tile_scale, ass_getAutotileList(atFile));
    }
    
    return(sprName);
}

function ass_getAutotileList(argument0, argument1) //file name with no extension, fill missing spaces
{
    if (argument1 == undefined)
    {
        argument1 = true;
    }
    var at = [];
    var f = argument0 + "_0" + ".autotile"
    
    for (var i = 1; file_exists(f); i ++)
    {
        array_push(at, autotile_load(f))
        f = argument0 + "_" + string(i) + ".autotile";
    }
    if (argument1)
    {
        while (array_length(at) < 9)
        {
            array_push(at, autotile_new());
        }
    }
    //if (array_length(at) == 0)
    return(at);
    
}

function ass_addTileset(argument0, argument1, argument2, argument3) // sprite name, size, scale, auto tile struct array, fill missing autotile array spaces
{
    if (argument3 == undefined)
    {
        argument3 = [autotile_new()];
    }
    ds_map_set(global.tilesets, argument0, struct_new([
        ["size", [argument1, argument1]],
        ["scale", argument2],
        ["autotile", argument3]
    ]));
    if (!array_value_exists(global.tileset_names, argument0))
    {
        array_push(global.tileset_names, argument0);
    }
}

function ass_loadAudio(argument0, argument1)
{
    var audioName = string_replace(string_replace(argument0, argument1, ""), ".ogg", "");
    var iniFile = string_replace(argument0, ".ogg", ".ini");
    
    var loopPoints = [0, -1];
    
    if (file_exists(iniFile))
    {
        ini_open(iniFile);
        loopPoints = [ini_read_real("loopPoints", "start", 0), ini_read_real("loopPoints", "end", -1)];
    }
    
    var newSound = audio_create_stream(argument0)
    //audio_sound_loop_end()
    if (!ds_map_exists(global.audio, audioName))
    {
        array_push(global.audio_names, audioName)
    }
    ds_map_set(global.audio, audioName, struct_new([
        ["sound", newSound],
        ["loopPoints", loopPoints]
    ]));
    
    return(audioName);
}

function ass_loadBGPreset(argument0, argument1) //full file path, base folder
{
    var bgpName = string_replace(string_replace(argument0, argument1, ""), ".bgpreset", "");
    var jText = file_text_read_all(argument0);
    
    ass_addBGPreset(bgpName, json_parse(jText));
    /*
    if (!ds_map_exists(global.bgpresets, bgpName))
    {
        array_push(global.bgpreset_names, bgpName);
    }
    ds_map_set(global.bgpresets, bgpName, json_parse(jText));*/
    
    return(bgpName);
}

function ass_addBGPreset(argument0, argument1) //name, bg struct
{
    if (!ds_map_exists(global.bgpresets, argument0))
    {
        array_push(global.bgpreset_names, argument0);
    }
    ds_map_set(global.bgpresets, argument0, argument1);
}

function ass_unloadAssets()
{
    var s = ds_map_find_first(global.sprites);
    while (s != undefined)
    {
        sprite_delete(ds_map_find_value(global.sprites, s))
        s = ds_map_find_next(global.sprites, s);
    }
    ds_map_destroy(global.sprites);
    global.sprites = ds_map_create();
    global.sprite_names = [];
    global.default_sprites = [];
    
    ds_map_destroy(global.tilesets);
    global.tilesets = ds_map_create();
    global.tileset_names = [];
    global.default_tilesets = [];
    
    ds_map_destroy(global.bgpresets);
    global.pgpresets = ds_map_create();
    global.bgpreset_names = [];
    global.default_bgpresets = [];
    
    var a = ds_map_find_first(global.audio);
    while (a != undefined)
    {
        var aStruct = ds_map_find_value(global.audio, a)
        audio_destroy_stream(aStruct.sound);
        a = ds_map_find_next(global.audio, a);
    }
    ds_map_destroy(global.audio);
    global.audio = ds_map_create();
    global.audio_names = [];
    global.default_audio = [];
}

function ass_loadFolderAssets(argument0, argument1) //folder, count as default
{
    if (argument1 == undefined)
        argument1 = false;
    
    var sprFiles = find_files_recursive(argument0 + "sprites/", ".png")
    for (var i = 0; i < array_length(sprFiles); i ++)
    {
        var s = ass_loadSprite(sprFiles[i], argument0 + ("sprites/"))
        if (argument1)
        {
            array_push(global.default_sprites, s);
            if (variable_struct_exists(global.tilesets, s))
            {
                array_push(global.default_tilesets, s);
            }
        }
        //array_push(global.modAssetsLoaded, "sprite." + ssprFiles[i])
    }
    
    var audioFiles = find_files_recursive(argument0 + ("audio/"), ".ogg")
    for (var j = 0; j < array_length(audioFiles); j ++)
    {
        var a = ass_loadAudio(audioFiles[j], argument0 + ("audio/"))
        if (argument1)
        {
            array_push(global.default_audio, a);
        }
    }
    
    var bgpFiles = find_files_recursive(argument0 + ("presets/"), ".bgpreset")
    for (var j = 0; j < array_length(bgpFiles); j ++)
    {
        var bg = ass_loadBGPreset(bgpFiles[j], argument0 + ("presets/"))
        if (argument1)
        {
            array_push(global.default_bgpresets, bg);
        }
    }
}

function _spr(argument0) // get sprite on global external sprites by name
{
    var maybeSprite = asset_get_index(argument0);
    if (sprite_exists(maybeSprite))
        return(maybeSprite)
        
    if (ds_map_exists(global.sprites, argument0))
        return(ds_map_find_value(global.sprites, argument0));
        
    return(ds_map_find_value(global.sprites, "sprite_preview"));
}

function _spr_exists(argument0)
{
    var maybeSprite = asset_get_index(argument0);
    if (sprite_exists(maybeSprite))
        return(true)
    
    return(ds_map_exists(global.sprites, argument0))
}

function _tileset(argument0)
{
    if (!ds_map_exists(global.tilesets, argument0))
    {
        ass_addTileset(argument0, 32, 1, ass_getAutotileList("", true))
    }
    return(ds_map_find_value(global.tilesets, argument0));
}

function _audio(argument0)
{
    if (!ds_map_exists(global.audio, argument0))
    {
        return -1;
    }
    var a = ds_map_find_value(global.audio, argument0);
    return(a)
}

function _sound(argument0)
{
    var a = _audio(argument0)
    if (a == -1)
        return -1;
    return(a.sound)
}

function _bgpreset(argument0)
{
    var jt = json_stringify(ds_map_find_value(global.bgpresets, argument0));
    return(json_parse(jt));
}

function drawTile(argument0, argument1, argument2, argument3, argument4)
{
    if (argument4 == undefined)
        argument4 = 1;
    var tsetName = argument0;
    var tsetCoord = argument1; // array[xInd, yInd, width, height]
    var xx = argument2;
    var yy = argument3;
    
    if (array_length(tsetCoord) == 2)
        tsetCoord = [tsetCoord[0], tsetCoord[1], 1, 1];
    
    
    var tset = _tileset(argument0);

    if(global.loadedTile != argument0){
        var tsetSprite = _spr(argument0);
        global.loadedTile = argument0
        global.loadedTileSprite = tsetSprite
    }
    else{
        tsetSprite = global.loadedTileSprite
    }
    draw_sprite_part_ext(tsetSprite, 0, tsetCoord[0] * tset.size[0], tsetCoord[1] * tset.size[1], tset.size[0] * tsetCoord[2], tset.size[1] * tsetCoord[3], xx, yy,  tset.scale * argument4, tset.scale * argument4, draw_get_color(), draw_get_alpha());
}

function array_duplicate(argument0)
{
    var newArray = [];
    for (var l = 0; l < array_length(argument0); l ++)
    {
        newArray[l] = argument0[l];
        //if (is_array(argument0)) ihsiodhoahdoih
    }
    return(newArray);
}

function inst_setVar(argument0, argument1, argument2)
{
    var iID = argument0
    var key = argument1;
    var val = argument2;
    with obj_rmEditor
    {
        var insts = _stGet("data.instances");
        struct_set(struct_get(insts[iID], "variables"), [[key, val]]);
    }
}

function struct_new(argument0)
{
    var newStruct = json_parse("{}");
    if (!is_undefined(argument0))
    {
        struct_set(newStruct, argument0);
    }
    return(newStruct);
}

function struct_set(argument0, argument1) // struct, array of arrays of var name and value
{
    for (var v = 0; v < array_length(argument1); v ++)
    {
        variable_struct_set(argument0, argument1[v][0], argument1[v][1])
    }
}

function struct_get(argument0, argument1) // struct, variable name
{
    return(variable_struct_get(argument0, argument1))
}

function struct_confirm(argument0, argument1, argument2) //struct, variable name, default
{
    if (!variable_struct_exists(argument0, argument1))
    {
        struct_set(argument0, [[argument1, argument2]])
    }
}

function file_text_read_all(argument0)
{
    var f = argument0;
    if (is_string(f))
    {
        var buff = buffer_load(f);
        var text = buffer_read(buff, buffer_text);
        buffer_delete(buff)
        return(text);
    }
    else
    {
        var jStr = "";
        while !file_text_eof(f)
        {
            jStr += file_text_readln(f);
        }
        return(jStr);
    }
}

function roomFile_getData(argument0, argument1);
{
    var lTime = current_time;
    var lvl = argument0;
    var rm = argument1;
    var fName = mod_folder("levels/") + lvl + "/rooms/" + rm + ".json";
    show_message(fName);
    if (!file_exists(fName))
    {
        show_error("room " + fName + " doesn't exist.", true);
    }
    var f = file_text_open_read(fName);
    var jText = file_text_read_all(f);
    global.roomData = json_parse(jText);
    global.roomData = data_compatibility(global.roomData);
    file_text_close(f);
    show_message((current_time - lTime) / 1000)
    return global.roomData;
}

function isPosInsideBorder(argument0, argument1)
{
    var o = argument0;
    var b = argument1;
    if (o[0] > b[0] and o[0] < b[2] and o[1] > b[1] and o[1] < b[3])
        return true;
    return false;
}

function preloadCustomLevel(argument0)
{
    global.levelName = argument0;
    levelMemory_reset();
    instanceManager_reset()
}

function loadCustomLevel(argument0, argument1, argument2) // level name, wether it's instant or not, reset level complete
{
    preloadCustomLevel(argument0)
    
    
    var lvlFolder = mod_folder("levels/" + argument0 + "/")
    
    ini_open(lvlFolder + "level.ini")
    var roomToLoad = ini_read_string("data", "mainroom", "main");
    ini_close();
    //show_message(lvlFolder + "rooms/" + roomToLoad + ".json")
    var rm_txt = file_text_read_all(lvlFolder + "rooms/" + roomToLoad + ".json")
    var rm_data = json_parse(rm_txt);
    
    global.leveltosave = argument0
    global.leveltorestart = roomToLoad
    global.levelattempts = 0
    if (argument2 != false)
    {
        global.levelcomplete = false;
    }
    
    prepareCustomLevel(rm_data, roomToLoad, argument1);
}

function get_roomData(argument0) //room name
{
    var lvlFolder = mod_folder("levels/" + global.levelName + "/")
    var rm_txt = file_text_read_all(lvlFolder + "rooms/" + argument0 + ".json")
    return(json_parse(rm_txt));
}

function prepareCustomLevel(argument0, argument1, argument2) //room data struct, room name, instant (true) or fade out (false)
{
    if (is_undefined(argument2))
        argument2 = true;
        
    global.roomData = data_compatibility(argument0)
    //show_message(global.roomData);
    if (argument2)
    {
        global.currentLevel = global.levelName;
        global.currentRoom = argument1;
        room_goto(rmPrepareLevel);
    }
    else
    {
        with obj_player
        {
            targetRoom = argument1;
        }
        instance_create(0, 0, obj_fadeout)
    }
}

function gotoCustomLevel()
{
    _temp = global.roomData;
    room_set_width(rmCustomLevel, _stGet("_temp.properties.levelWidth") - _stGet("_temp.properties.roomX"));
    room_set_height(rmCustomLevel, _stGet("_temp.properties.levelHeight") - _stGet("_temp.properties.roomY"));
    
    room_goto(rmCustomLevel);
}

function layerFormat(argument0, argument1)
{
    var l = "custom_" + argument0 + "_" + string(argument1);//
    switch (argument0)
    {
        case "Tiles":
            if (argument1 < 0)
            {
                l = "custom_Tiles_Top_" + string(-argument1);
                if (tileLayer_isSecret(argument1))
                {
                    l = "custom_Tiles_Secret_" + string(-argument1 - 4);
                }
            }
        break;
        case "Backgrounds":
            if (argument0 > 0)
            {
                l = "custom_Background_" + string(argument1);
            }
            else
            {
                l = "custom_Foreground_" + string(argument1);
            }
        break;
    }
    
    return(l);
}

function tileLayer_isSecret(argument0)
{
    return(argument0 <= -5);
}

function layerConfirm(argument0, argument1)
{
    var lName = layerFormat(argument0, argument1);
    if (!layer_exists(lName))
    {
        var d = 0
        switch argument0
        {
            case "Instances":
                d = -1 - argument1;
            break;
            case "Tiles":
                if (argument1 >= 0)
                {
                    d = 5 * argument1;
                }
                else
                {
                    d = -100 + argument1;
                }
            break;
            case "Tiles_Secret":
                d = -500;
            case "Background":
                d = 500 + 10 * argument1;
                if (argument1 < 0)
                    d *= -1;
            break;
        }
        layer_create(d, lName)
    }
}

function SplitString(argument0, argument1){ 
    
    var str = argument0;
    var divider = argument1;
    var results = []
    
    repeat string_count(divider, str)
    {
        var element = string_copy(str, 1, string_pos(divider, str) - 1)
        array_push(results, element)
        str = string_replace(str, element + divider, "")
    }
    array_push(results, str)
    return results;
}

function buffer_write_slice(argument0, argument1, argument2, argument3)
{
    /// buffer_write_slice(buffer, data_buffer, data_start, data_end)
    var start = argument2;
    var next = argument3 - start;
    if (next <= 0) exit;
    var buf = argument0;
    var data = argument1;
    var size = buffer_get_size(buf);
    var pos = buffer_tell(buf);
    var need = pos + next;
    if (size < need) {
        do size *= 2 until (size >= need);
        buffer_resize(buf, size);
    }
    buffer_copy(data, start, next, buf, pos);
    buffer_seek(buf, buffer_seek_relative, next);
}

function levelMemory_reset()
{
    global.levelMemory = struct_new();
}

function levelMemory_set(argument0, argument1)
{
    if (argument1 == undefined)
        argument1 = false;
        
    struct_set(global.levelMemory, [[argument0, argument1]]);
}

function levelMemory_get(argument0)
{
    return variable_struct_exists(global.levelMemory, argument0);
}

function levelMemory_remove(argument0)
{
    variable_struct_remove(global.levelMemory, argument0);
}

function levelMemory_handleLap2()
{
    var mems = variable_struct_get_names(global.levelMemory)
    for (var i = 0; i < array_length(mems); i ++)
    {
        if (struct_get(global.levelMemory, mems[i]))
        {
            levelMemory_remove(mems[i])
        }
    }
}

function levelMemory_lap2PortalFix(argument0)
{
    if (!variable_instance_exists(argument0, "instID"))
        return;
    show_message(global.currentRoom + "_" + string(argument0.instID))
    levelMemory_set(global.currentRoom + "_" + string(argument0.instID))
}

function instanceManager_reset()
{
    global.instanceManager = struct_new();
    ds_list_clear(global.escaperoom)
    ds_list_clear(global.baddieroom)
    ds_list_clear(global.saveroom)
}

function instanceManager_getKey(argument0) //instid
{
    return global.currentRoom + "_" + string(argument0) 
}

function instanceManager_add(argument0, argument1) //instid, id
{
    struct_set(global.instanceManager, [[instanceManager_getKey(argument0), argument1]])
}

function instanceManager_checkAndSwitch(argument0, argument1) //instid, id
{
    var instKey = instanceManager_getKey(argument0)
    if (variable_struct_exists(global.instanceManager, instKey))
    {
        var ins = struct_get(global.instanceManager, instKey)
        if (ds_list_find_index(global.escaperoom, ins) != -1)
        {
            ds_list_add(global.escaperoom, argument1)
        }
        if (ds_list_find_index(global.baddieroom, ins) != -1)
        {
            //show_message(ds_list_find_value(global.baddieroom, ds_list_find_index(global.baddieroom, ins)))
            ds_list_add(global.baddieroom, argument1)
        }
        if (ds_list_find_index(global.saveroom, ins) != -1)
        {
            //show_message(ds_list_find_value(global.saveroom, ds_list_find_index(global.saveroom, ins)))
            ds_list_add(global.saveroom, argument1)
        }
    }

    instanceManager_add(argument0, argument1);
}

function draw_sprite_tiled_direction(argument0, argument1, argument2, argument3, argument4, argument5) //sprite, image_index, x, y, tile horizontally, tile vertically
{
    var w = sprite_get_width(argument0);
    var h = sprite_get_height(argument0);
    if (argument4 and argument5)
    {
        draw_sprite_tiled(argument0, argument1, argument2, argument3);
    }
    else
    {
        var xx = argument2;
        var yy = argument3;
        var cx = camera_get_view_x(view_camera[0]);
        var cy = camera_get_view_y(view_camera[0]);
        var cw = camera_get_view_width(view_camera[0]);
        var ch = camera_get_view_height(view_camera[0]);
        
        if (argument4)
        {
            while (xx < cx - w)
            {
                xx += w;
            }
            while (xx > cx - w)
            {
                xx -= w;
            }
            for (var i = xx; i < cx + cw + w; i += w)
            {
                draw_sprite(argument0, argument1, i, yy);
            }
        }
        else if (argument5)
        {
            while (yy < cy - h)
            {
                yy += h;
            }
            while (yy > cy - h)
            {
                yy -= h;
            }
            for (var i = yy; i < cy + ch + h; i += h)
            {
                draw_sprite(argument0, argument1, xx, i);
            }
        }
    }
    if (!argument4 and !argument5)
    {
        draw_sprite(argument0, argument1, argument2, argument3);
    }
}

function data_compatibility(argument0)
{
    var d = argument0;
    _temp = d;
    if (is_array(d.backgrounds))
        _stSet("_temp.backgrounds", struct_new());
    var editorVer = 0;
    if (variable_struct_exists(d, "editorVersion"))
    {
        editorVer = _stGet("_temp.editorVersion")
    }
    else
    {
        _stSet("_temp.editorVersion", 0);
    }
    
    switch editorVer
    {
        case 0:
            var bgs = variable_struct_get_names(d.backgrounds)
            for (var i = 0; i < array_length(bgs); i ++)
            {
                if (!variable_struct_exists(_stGet("_temp.backgrounds." + bgs[i]), "hspeed"))
                {
                    _stSet("_temp.backgrounds." + bgs[i] + ".hspeed", 0);
                    _stSet("_temp.backgrounds." + bgs[i] + ".vspeed", 0);
                }
            }
        case 1:
            _stSet("_temp.properties.song", "");
        case 2:
            _stSet("_temp.properties.songTransitionTime", 100);
        case 3:
            var bgs = variable_struct_get_names(d.backgrounds)
            for (var i = 0; i < array_length(bgs); i ++)
            {
                if (!variable_struct_exists(_stGet("_temp.backgrounds." + bgs[i]), "image_speed"))
                {
                    _stSet("_temp.backgrounds." + bgs[i] + ".image_speed", 15);
                    _stSet("_temp.backgrounds." + bgs[i] + ".panic_sprite", -1);
                }
            }
        case 4:
            var ls = variable_struct_get_names(d.tile_data);
            for (var l = 0; l < array_length(ls); l ++)
            {
                var lay = struct_get(d.tile_data, ls[l]);
                var tiles = variable_struct_get_names(lay)
                for (var i = 0; i < array_length(tiles); i ++)
                {
                    var pos = SplitString(tiles[i], "_")
                    if (abs(real(pos[0])) % 32 != 0 or abs(real(pos[1])) % 32 != 0)
                    {
                        variable_struct_remove(lay, tiles[i])
                    }
                }
            }
        }
    if(editorVer < 6){
        var objid = 0
        var prevobjid = 0
        var newobjid = 0
        for(var i = 0; i < array_length(d.instances); i++){
            //get object id from room json
            objid = struct_get(d.instances[i], "object")
            //if statement so we dont need to look for the same updated object id again
            if(objid != prevobjid){
                newobjid = global.objectMap[objid]
                newobjid = asset_get_index(newobjid)
            }
            prevobjid = objid
            //update the loaded roomdata with the new object id
            variable_struct_set(_temp.instances[i], "object", newobjid)
            //fix spawn variables
            //this shit doesnt work and i cant figure out why
            //it keeps grabbing a struct that doesnt exist despite me checking beforehand with variable_struct_exists its infuriating
            //not that it matters since only 2 levels depend on this feature in the first place
            /* switch newobjid{
                case obj_conveyorspawner:
                case obj_conveyordespawner:
                case obj_railh:
                case obj_railv:
                    var objectlist = fix_spawner_variables(d.instances[i].variables, "objectlist")
                    if(objectlist != undefined)
                        variable_struct_set(_temp.instances[i].variables, "objectlist", objectlist)
                break
                case obj_fakesanta:
                    var objectlist = fix_spawner_variables(d.instances[i].variables, "content")
                    if(objectlist != undefined)
                        variable_struct_set(_temp.instances[i].variables, "content", objectlist)
                break
            } */
        }
    }
    //prevent compatibility from running multiple times
    _stSet("_temp.editorVersion", 6)

    return _temp;
}

function fix_spawner_variables(argument0, argument1){
    //check if struct exists before grabbing it
    if(variable_struct_exists(argument0, argument1)){
        var objectlist = struct_get(argument0, argument1)
        //check if its an array or not
        if(is_array(objectlist)){
            for(var j = 0; j < array_length(objectlist); j++){
                var newid = global.objectMap[objectlist[j]]
                objectlist[j] = asset_get_index(newid)
            }
        }
        else{
            var newid = global.objectMap[objectlist[j]]
            objectlist = asset_get_index(newid)
        }
        return objectlist
    }
    else{
        return undefined
    }
}
    
function ask_or_not(argument0, argument1)
{
    var g = get_string(argument0, string(argument1));
    if (g == "")
        return argument1
    else
    {
        return g;
    }
}

function layer_get_all_names()
{
    var allLay = layer_get_all();
    var layStr = "";
    for (var i = 0; i < array_length(allLay); i ++)
    {
        layStr += layer_get_name(allLay[i]) + ",";
    }
    return layStr;
}

function varName_getType(argument0)
{
    var vTypes = global.objectData.variableTypes;
    if (variable_struct_exists(vTypes, argument0))
        return(struct_get(vTypes, argument0))
    
    return("");
}

function varValue_ressolve(argument0, argument1)
{
    var val = argument0;
    
    if (argument1 != undefined and argument1 != "")
    {
        switch (argument1)
        {
            case "lvl":
            case "room":
            case "str":
                return argument0;
            break;
            
            case "num":
                return(real(argument0))
            break;
            
            case "spr":
                return _spr(argument0);
            break;
        }
    }
    
    if (is_string(val))
    {
        if (string_pos("\"", val) != 0)
        {
            return(string_replace_all(val, "\"", ""))
        }
        
        switch val
        {
            case "true":
                return true;
            break;
            case "false":
                return false;
            break;
        }
    }
    
    
    var ind = asset_get_index(string(val));
    if ds_map_exists(global.sprites, argument0)
        return(_spr(argument0))
        
    if (ind != -1)
    {
        if (sprite_get_name(ind) == argument0)
        {
            return ind;
        }
        if (object_get_name(ind) == argument0)
        {
            return ind;
        }
    }
    return val;
}

function beautify(argument0)
{
    var str = argument0;
    var identLevel = 0;
    //str = string_replace_all(str, "{ ", "{\n")
    //str = string_replace_all(str, ", ", ",\n")
    //str = string_replace_all(str, "[ ", "[\n")
    
    var jSize = string_length(str);
    var jBuff = buffer_create(jSize, buffer_fixed, 1)
    var result = buffer_create(jSize, buffer_grow, 1);
    
    buffer_write(jBuff, buffer_text, str);
    buffer_seek(jBuff, buffer_seek_start, 0);
    
    var curl = ord("{")
    var corch = ord("[")
    var comma = ord(",")
    var curlEnd = ord("}");
    var corchEnd = ord("]");
    
    repeat jSize
    {
        var c = buffer_read(jBuff, buffer_u8);
        
        
        //var curl = ord(":")
        var writeIdent = false;
        var writeJump = false;;
        switch c
        {
            case curl:
            case corch:
                identLevel ++;
            case comma:
                
                writeIdent = true;
            break;
            
            case curlEnd:
            case corchEnd:
                identLevel --;
                writeJump = true;
            break;
        }
        if (writeJump)
        {
            buffer_write(result, buffer_u8, 10)
                
            repeat identLevel
            {
                buffer_write(result, buffer_u8, 9)
            }
        }
        
        buffer_write(result, buffer_u8, c);
        
        if (writeIdent)
        {
            buffer_write(result, buffer_u8, 10)
                
            repeat identLevel
            {
                buffer_write(result, buffer_u8, 9)
            }
        }
    }
    /*while (string_pos("{", str) != 0 or string_pos("}", str) != 0)
    {
        if (string_pos("{", str) < string_pos("}", str) and string_pos("{", str) > 0)
        {
            identLevel ++;
            str = string_replace(str, "{", "¨o\n" + string_repeat("    ", identLevel))
        }
        else
        {
            identLevel --;
            str = string_replace(str, "}", "\n" + string_repeat("    ", identLevel) + "¨c");
        }
    }
    str = string_replace_all(str, "¨o", "{");
    str = string_replace_all(str, "¨c", "}");
    */
    buffer_seek(result, buffer_seek_start, 0);
    str = buffer_read(result, buffer_text);
    buffer_delete(jBuff);
    buffer_delete(result);
    
    return(str);
}

function array_value_exists(argument0, argument1)
{
    for (var i = 0; i < array_length(argument0); i ++)
    {
        if (argument0[i] == argument1)
        {
            return true;
        }
    }
    return false;
}

function find_files_recursive(argument0, argument1, argument2) // folder, extension, max depth
{
    var dirQueue = ds_queue_create();
    var fileArray = [];
    ds_queue_enqueue(dirQueue, argument0)
    var startDepth = string_count("/", argument0);
    
    while !ds_queue_empty(dirQueue)
    {
        var currDir = ds_queue_dequeue(dirQueue);
        var fold = file_find_first(currDir + "*", fa_directory);
        while (fold != "")
        {
            var check = fold + "/"
            if (directory_exists(currDir + check))
            {
                if (argument2 == undefined or string_count("/", currDir + check) - startDepth <= argument2)
                    ds_queue_enqueue(dirQueue, currDir + check);
            }
            fold = file_find_next()
        }
        file_find_close();
        
        var file = file_find_first(currDir + "*" + argument1, 0);
        while (file != "")
        {
            if (!directory_exists(currDir + file))
            {
                array_push(fileArray, currDir + file);
            }
            file = file_find_next();
        }
        file_find_close();
    }
    
    return(fileArray);
}

function array_concat(argument1, argument2)
{
    var a = argument0;
    var b = argument1;
    var al = array_length_1d(a);
    var bl = array_length_1d(b);
    var r = array_create(al + bl); // array_create(al + bl, 0) in GMS1
    array_copy(r, 0, a, 0, al);
    array_copy(r, al, b, 0, bl);
    return r;
}

function modRoom_init()
{
    instance_destroy(obj_backtohub_fadeout)
    var wanted = ["obj_fmod", "obj_screensizer", "obj_music", "obj_inputAssigner", "obj_pause", "obj_savesystem", "obj_modAssets", "obj_editorBG", "obj_customAudio"]
    unwanted = [];
    with (all)
    {
        var foundIt = 0
        if (id == other.id)
            foundIt = 1
        for (var i = 0; i < array_length(wanted); i++)
        {
            if (wanted[i] == object_get_name(object_index))
                foundIt = 1
        }
        if (!foundIt)
        {
            array_push(other.unwanted, id);
            instance_deactivate_object(id);
        }
    }
}

function modRoom_end()
{
    for (var i = 0; i < array_length(unwanted); i ++)
    {
        instance_activate_object(unwanted[i]);
        if (!instance_exists(unwanted[i]))
        {
            show_message("someone is missing.. " + string(i));
        }
    }
}

function cursor_hud_position()
{
    var v = view_camera[0];
    return([(mouse_x - camera_get_view_x(v)) / camera_get_view_width(v) * 960, (mouse_y - camera_get_view_y(v)) / camera_get_view_height(v) * 540])
    return([(window_mouse_get_x()/window_get_width()) * display_get_gui_width(), (window_mouse_get_y()/window_get_height()) * display_get_gui_height()]);
}

function json_save(argument0, argument1) // string, path
{
    var b = buffer_create(string_length(argument0), buffer_fixed, 1);
    buffer_write(b, buffer_text, argument0);
    buffer_save(b, argument1)
    buffer_delete(b);
}

function camera_get_limits(argument0, argument1, argument2, argument3)
{
    var limX = [0, room_width];
    var limY = [0, room_height];
    if (room == rmCustomLevel)
    {
        with (obj_player)
        {
            var middleX = (bbox_right + bbox_left) / 2;
            var middleY = (bbox_bottom + bbox_top) / 2;
            var cr = collision_point(middleX, middleY, obj_camera_region, true, true);
            if (cr != noone)
            {
                limX = [cr.x, cr.x + cr.sprite_width];
                limY = [cr.y, cr.y + cr.sprite_height];
            }
        }
    }
    return ([clamp(argument0, limX[0], limX[1] - argument2), clamp(argument1, limY[0], limY[1] - argument3)])
}