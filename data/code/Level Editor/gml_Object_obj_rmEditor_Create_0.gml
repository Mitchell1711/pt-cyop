scr_playerreset()
modRoom_init()

global.editingLevel = true;
instanceManager_reset()

stopSong()
//audio_play_sound(_sound("bowser-castle"), 1, false);

global.panic = false;
//instance_create_layer(0, 0, layer, obj_customBG);

window_set_cursor(cr_default);
draw_set_font(global.editorfont);

var comment = "";
// instances [object, x, y, variables array[]]"
// variables array [nombre de variable, valor]"
// propiedades array[width, height]"
// tile_data struct{nombre layer : struct{ "x_y" : struct{tileset : "nombre tileset", coord : [xInd, yInd]}}}
level = global.editorLevelName;
lvlRoom = global.editorRoomName;

editorVersion = 6;
//global.currentRoom = global.editorRoomName;
//data = [[], [], [], [obj_screensizer.actual_width, obj_screensizer.actual_height]]
data = roomData_new();/*struct_new();
struct_set(data, [
    ["editorVersion", editorVersion],
    ["properties", struct_new([
        ["levelWidth", obj_screensizer.actual_width],
        ["levelHeight", obj_screensizer.actual_height],
        ["song", ""],
        ["songTransitionTime", 100]
    ])],
    ["instances", []],
    ["tile_data", struct_new()],
    ["backgrounds", struct_new()]
])*/

port_mode = false;

levelSettings = level_load(level);
levelNameList = [];
var dir = mod_folder("levels/");
levelFiles = find_files_recursive(dir, ".ini");
for (var i = 0; i < array_length(levelFiles); i ++)
{
    array_push(levelNameList, string_replace(string_replace(filename_path(levelFiles[i]), dir, ""), "/", ""))
}
spriteList = global.sprite_names;
audioList = global.audio_names;

//undo system
prevData = data;
undo_stack = ds_stack_create();
redo_stack = ds_stack_create();
other_stack = ds_stack_create();
updateUndoMemory = false;

_stSet("data.properties.roomX", 0);
_stSet("data.properties.roomY", 0);

//show_message(dataS)
gridSize = 32
camZoom = 1

layer_instances = 0;
layer_tilemap = 5;
layer_background = 5;

roomNameList = [];
var rm = file_find_first(mod_folder("levels/") + level + "/rooms/*.json", 0);
while rm != ""
{
    array_push(roomNameList, filename_name(filename_change_ext(rm, "")));
    rm = file_find_next();
}

function roomPath() //gml_Script_roomPath
{
    return fstring(mod_folder("levels/{level}/rooms/{lvlRoom}.json"));
}

function saveData() //gml_Script_saveData
{
    data.editorVersion = editorVersion;
    var jText = json_stringify(data, true);
    
    var b = 1;
    var p = "levels/{level}/rooms/";
    var backup = mod_folder(fstring(p + "backups/{lvlRoom}.backup"))
    var oldBackupDir = mod_folder(fstring(p + "backups"));
    var rBackup = "backups/" + backup
    
    if (directory_exists(oldBackupDir))
    {
        var oldB = find_files_recursive(oldBackupDir + "/", "")
        for (var i = 0; i < array_length(oldB); i ++)
        {
            var bNum = SplitString(oldB[i], ".backup");
            file_copy(oldB[i], "backups/" + oldB[i])
            file_delete(oldB[i]);
        }
    }
    directory_destroy(oldBackupDir);
    
    for (var b = 0; b <= 4; b ++)
    {
        if (file_exists(rBackup + string(b)))
        {
            if (b == 0)
                file_delete(rBackup + "0")
            else
                file_rename(rBackup + string(b), rBackup + string(b - 1))
        }
    }
    json_save(jText, roomPath());
    json_save(jText, rBackup + "4")
    
    
    //jText = beautify(jText);
    //var f = file_text_open_write(roomPath());
    //file_text_write_string(f, jText);
    //file_text_close(f);
    
    level_save(level, levelSettings);
    
    obj_modAssets.saveNotice = 120;
}

function loadData() //gml_Script_loadData
{
    if (file_exists(roomPath()))
    {
        //var f = file_text_open_read(roomPath());
        var jText = file_text_read_all(roomPath());
        data = json_parse(jText);
        data = data_compatibility(data);
        //file_text_close(f);
        
        for (var i = 0; i < array_length(data.instances); i ++)
        {
            _temp = i;
            if (_stGet("data.instances[_temp].deleted"))
            {
                ds_stack_push(deletedIndexes, i);
            }
        }
        
        return true;
    }
    return false;
}

function initStage(argument0) //gml_Script_initStage
{
    data = argument0
    
    instance_activate_object(obj_editorInst);
    with (obj_editorInst)
    {
        instance_destroy();
    }
    with (obj_customBG)
    {
        instance_destroy();
    }
    with (obj_tilemapDrawer)
    {
        instance_destroy();
    }
    
    for (i = 0; i < array_length(struct_get(data, "instances")); i++)
    {
        _temp = i;
        if (!_stGet("data.instances[_temp].deleted"))
            initInst(i)
    }
    
    var tileLayers = variable_struct_get_names(_stGet("data.tile_data"));
    
    for (var i = 0; i < array_length(tileLayers); i ++)
    {
        /*with (obj_tilemapDrawer)
        {
            if (layer_tilemap == i)
            {
                instance_destroy();
            }
        }*/
        initTileLayer(int64(tileLayers[i]));
    }
    
    var bgLayers = variable_struct_get_names(_stGet("data.backgrounds"));
    
    for (var i = 0; i < array_length(bgLayers); i ++)
    {
        editor_initBGLayer(int64(bgLayers[i]), "");
    }
    
    //show_message(layer_get_all_names());
}

function initInst(argument0) //gml_Script_initInst
{
    var insts = struct_get(data, "instances");
    var insData = insts[argument0]
    
    var l = struct_get(insData, "layer");
    
    if (l == undefined)
    {
        insData.deleted = true
        return(noone)
    }
    
    layerConfirm("Instances", l);
    
    //show_message("here good?")
    var ins = instance_create_layer(struct_get(struct_get(insData, "variables"), "x"), struct_get(struct_get(insData, "variables"), "y"), layer_get_id(layerFormat("Instances", l)), obj_editorInst)
    var obj = struct_get(insData, "object")
    ins.sprite_index = object_get_sprite(obj)
    ins.instID = argument0
    
    instance_update_variables(ins, insData);
    
    return(ins);
    /*var varNames = variable_struct_get_names(struct_get(insData, "variables"));
    for (var j = 0; j < array_length(varNames); j ++)
    {
        var val = struct_get(struct_get(insData, "variables"), varNames[j]);
        //
        variable_instance_set(ins, varNames[j], varValue_ressolve(val));
    }*/
}

function addInst(argument0, argument1, argument2) //object, x, y
{
    //var newInst = [argument0, argument1, argument2, ds_map_create(), []];
    var newInst = struct_new([
        ["object", argument0],
        ["deleted", false], // weather they are deleted
        ["variables", struct_new([["x", argument1], ["y", argument2]])],
        ["layer", layer_instances]
    ]);
    var instInd = array_length(struct_get(data, "instances"));
    
    if (!ds_stack_empty(deletedIndexes))
        instInd = ds_stack_pop(deletedIndexes);
    
    _temp = instInd;
    data.instances[_temp] = newInst;
    //_stSet("data.instances[_temp]", newInst)
    if (!port_mode)
        return(initInst(instInd))
    return(struct_new([["instID", instInd]]));
}

function initTileLayer(argument0, argument1)
{
    layerConfirm("Tiles", argument0);
    var off = [0, 0];
    if (argument1 == true)
    {
        off = [_stGet("data.properties.roomX"), _stGet("data.properties.roomY")]
    }
    with obj_tilemapDrawer
    {
        if (layer_get_name(layer) == layerFormat("Tiles", argument0))
        {
            initTilemapDrawer(other.data, argument0);
            return;
        }
    }
    // doesn't happen if a tilemap drawer is found for that tile layer
    var tmd = instance_create_layer(0, 0, layer_get_id(layerFormat("Tiles", argument0)), obj_tilemapDrawer);
    with tmd
    {
        //if (surface_exists(tilemap_surface))
        //    surface_free(tilemap_surface)
        initTilemapDrawer(other.data, argument0);
    }
}

pleaseExist = "";

function addTile(argument0, argument1, argument2, argument3, argument4) //tileset name, coords, x, y, does it auto tile
{
    var name = argument0;
    var coord = argument1;
    var xx = int64(argument2);
    var yy = int64(argument3);
    
    if (argument4 == undefined)
        argument4 = false;
    
    tileLayerConfirm(layer_tilemap)
    
    var tLayer = string(layer_tilemap);
    
    _stSet("data.tile_data." + tLayer + "." + string(xx) + "_" + string(yy), struct_new([
        ["tileset", name],
        ["coord", coord],
        ["autotile", argument4],
        ["autotile_index", tileset_autotileIndex]
    ]))
    
    //pleaseExist = "data.tile_data." + tLayer + "." + string(xx) + "_" + string(yy)
    
    if (port_mode)
        return;
    
    var itExists = false
    
    var camScale = camera_get_view_width(view_camera[0]);
    
    with obj_tilemapDrawer
    {
        if (layer_tilemap == other.layer_tilemap)
        {
            drawTileToSurface(name, coord, xx, yy)// - room_x, yy - room_y)
            itExists = true;
        }
    }
    if (!itExists)
    {
        initTileLayer(layer_tilemap);
    }
}

function deleteTile(argument0, argument1)
{
    var xx = int64(argument0);
    var yy = int64(argument1);
    
    var camScale = camera_get_view_width(view_camera[0]);
    
    var tLayer = string(layer_tilemap);
    addTile(tilesetSelected, [0, 0], xx, yy, false);
    variable_struct_remove(_stGet("data.tile_data." + tLayer), string(xx) + "_" + string(yy))
    
    with obj_tilemapDrawer
    {
        if (layer_tilemap == other.layer_tilemap)
        {
            eraseTileFromSurface(xx, yy)// - room_x, yy - room_y);
        }
    }
    //initTileLayer(layer_tilemap);
}

deletedIndexes = ds_stack_create();

cursorMode = 0;
lockCursorMode = false;
cursorImage = 0;
cursorStretch = [0, 0];
prevGridPos = [0, 0];
updateStretch = true;
cursorNotice = ""

editor_state = -1;


tilesetFolder = 0;
tilesetSelected = "tile_entrance1";
tilesetCoord = [0, 0, 1, 1];
tilesetCoord_editing = tilesetCoord;
tilesetCoord_spread = [tilesetCoord];
tileset_doAutoTile = false;
tileset_autotileIndex = 0;
tileset_listScroll = 0;

tile_selection = [0, 0, 0, 0, 0, 0];
tile_selection_made = false;
tile_selection_keys = [];
tile_selection_moving = false;
tile_selection_move_origin = [0, 0, 0, 0];


roomHovering = -1;

bgsHovering = -1;
prevBGPreset = "";

settingsMode = 0;
settingsHovering = -1;

toolbarHovering = -1;


instSelected = noone;
instOn = noone;
selCarry = [];

objIndex = obj_solid;

global.currentRoom = lvlRoom;

var exists = loadData()

var prop = data.properties;
if (prop.levelWidth - prop.roomX) > 16384
{
    prop.levelWidth = floor(16384 / 32) * 32 + prop.roomX
    prop.levelHeight = floor(16384 / 32) * 32 + prop.roomY
}

initStage(data)

if (!exists)
{
    saveData();
    var rn = lvlRoom;
    array_push(roomNameList, rn);
}

cam_x = 0
cam_y = 0
scroll_x = mouse_x
scroll_y = mouse_y
camScroll = [0, 0]

roomResize = [0, 0];
roomPreResize = [0, 0, 100, 100];

objFile = global.objectData;
objFolders = objFile.folders;//struct_new([["solids", [obj_solid, obj_player]], ["enemies", [obj_cheeseslime]], ["warps", [obj_door]]]);
objFolderSelected = 0;
objFolderOrder = objFile.order;

//global.layerIndex = struct_new();

for (var i = 0; i < array_length(objFolderOrder); i ++)
{
    var oF = _stGet("objFolders." + objFolderOrder[i]);
    for (var j = 0; j < array_length(oF); j ++)
    {
        var o = oF[j]
        if (is_string(o))
        {
            _temp = j;
            _stSet("objFolders." + objFolderOrder[i] + "[_temp]", asset_get_index(o));
        }
    }
}

objSelected = obj_solid;
objFlipX = false;
objFlipY = false;


windows_init();//
w_scale = 2;

_stSet("w_canvas.toolbar", _wCanvas(8 * 50, 48, "toolbar"))
_stSet("w_canvas.objFolders", _wCanvas(86, 324, "objFolders"));
_stSet("w_canvas.objFolders.gridSize", [86, 24]);

_stSet("w_canvas.objGrid", _wCanvas(256, 200, "objGrid"));
_stSet("w_canvas.objGrid.gridSize", 36);
_stSet("w_canvas.objGrid.columns", 7);
struct_set(w_canvas.objGrid, [["surfaceScale", 0.5]]);

_stSet("w_canvas.layerDisplay", _wCanvas(250, 48, "layerDisplay"));

_stSet("w_canvas.tilesetList", _wCanvas(100, 296, "tilesetList"));
_stSet("w_canvas.tileset", _wCanvas(256, 256, "tileset"));
windows_add_canvas(110 * array_length(global.tilesetData.order), 14, "tilesetFolders");
windows_add_canvas(100, 32, "tilesetMode");
windows_add_canvas(32, 48, "autotileInd");
windows_add_canvas(48, 16, "autotileEditButton");
windows_add_canvas(320, 160, "autotileEditor");

var r = _wCanvas(90, 256, "rooms")
_stSet("w_canvas.rooms", r);

_stSet("w_canvas.bgs", _wCanvas(256, 180, "bgs"));
windows_add_canvas(200, 200, "bgPresetDropdown");

_stSet("w_canvas.settingTypes", _wCanvas(64, 32, "settingTypes"));
_stSet("w_canvas.settings", _wCanvas(300, 128, "settings"));

_stSet("w_canvas.instanceMenu", _wCanvas(256, 128, "instanceMenu"));

windows_add_canvas(100, 150, "valueDropdown");

wCanvas_open("toolbar", 10, 10);
wCanvas_open("layerDisplay", 10, 460);


windows_add_canvas(200, 200, "bigDropdown");

//wCanvas_open("tileset", 10, 68);
st_instances = 0;
st_tiles = 1;
st_backgrounds = 2;
st_rooms = 3;
st_settings = 4;
st_save = 5;
st_play = 6;
st_edit = 7;
st_resize = 8;

function editorWindowUpdate(argument0)
{
    wCanvas_close("objFolders");
    wCanvas_close("objGrid");
    wCanvas_close("tilesetList");
    wCanvas_close("tileset");
    wCanvas_close("rooms");
    wCanvas_close("bgs");
    wCanvas_close("settingTypes");
    wCanvas_close("settings");
    wCanvas_close("instanceMenu");
    wCanvas_close("tilesetMode");
    wCanvas_close("tilesetFolders");
    wCanvas_close("autotileInd");
    wCanvas_close("autotileEditor")
    wCanvas_close("autotileEditButton")
    wCanvas_close("bgPresetDropdown");
    wCanvas_close("bigDropdown");
    
    if (argument0 == true)
    {
        //wCanvas_close()
    }
    switch editor_state
    {
        case st_instances:
            wCanvas_open("objFolders", 10, 68);
            wCanvas_open("objGrid", 96, 68);
        break;
        
        case st_tiles:
            var sep = 8;
            var tf = wCanvas_open("tilesetFolders", 10, 74 - sep);
            var tl = wCanvas_open("tilesetList", 10, tf.y + tf.height + sep);
            struct_set(tl, [["sep", 24]])
            
            var fs = global.tilesetData.folders
            var sets = struct_get(fs, global.tilesetData.order[tilesetFolder]);
            struct_set(tl, [["scrollBorders", [0, max(array_length(sets) * tl.sep - tl.height, 0)]]])
            
            struct_set(tl, [["scroll_y", tileset_listScroll]])
            var t= wCanvas_open("tileset", 110, tf.y + tf.height + sep);
            struct_set(t, [["zoom", 1]])
            
            
            
            //wCanvas_open("autotileEditor", t.x + t.width, t.y);
            
            var ts = _tileset(tilesetSelected);
            
            if (array_length(ts.autotile) > 0)
            {
                var tOpt = ["Tileset", "Auto Tile"];
                var dd = wCanvas_open_dropdown("tilesetMode", t.x, t.y + t.height, tOpt, tOpt[tileset_doAutoTile], "tilesetModeChanged")
                struct_set(dd, [["canExit", false]])
            }
            
            if (tileset_doAutoTile)
            {
                var opts = [];
                for (var i = 0; i < array_length(ts.autotile); i ++)
                {
                    opts[i] = i;
                }
                if (array_length(opts) > 1)
                {
                    var nd = wCanvas_open_dropdown("autotileInd", dd.x + dd.width, dd.y, opts, tileset_autotileIndex, "autotileIndexChanged");
                    struct_set(nd, [["canExit", false]])
                    
                    if (!array_value_exists(global.defaultTilesets, tilesetSelected))
                    {
                        wCanvas_open("autotileEditButton", nd.x + nd.width, nd.y);
                    }
                }
            }
        break;
        
        case st_backgrounds:
            wCanvas_open("bgs", 10, 68);
        break;
        
        case st_rooms:
            wCanvas_open("rooms", 10, 68);
        break;
        
        case st_settings:
            wCanvas_open("settingTypes", 10, 68);
            wCanvas_open("settings", 74, 68);
        break;
    }
}

if (!variable_struct_exists(global.editorMemory, lvlRoom))
{
    struct_set(global.editorMemory, [
        [lvlRoom, new_memoryVarStruct()]
    ])
}

__mem = global.editorMemory;
varStruct = _stGet("__mem." + lvlRoom)
var varsToSet = variable_struct_get_names(varStruct)
for (var i = 0; i < array_length(varsToSet); i ++)
{
    //show_message(varsToSet[i])
    variable_instance_set(id, varsToSet[i], _stGet("varStruct." + varsToSet[i]));
    //show_message(variable_instance_get(id, varsToSet[i]))
}

tilesetFolder = clamp(tilesetFolder, 0, array_length(global.tilesetData.order) - 1)

editorWindowUpdate()

/*testBuffer = buffer_create(30000, buffer_fast, 1);
buffer_seek(testBuffer, buffer_seek_start, 0);

repeat buffer_get_size(testBuffer)
{
    buffer_write(testBuffer, buffer_u8, irandom(250))
}*/

doubleClickTimer = 0;
selectingMode = false;
//wCanvas_open("objFolders", 10, 68)
//wCanvas_open("objGrid", 74, 68);
