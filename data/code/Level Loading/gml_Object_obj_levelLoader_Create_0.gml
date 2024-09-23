data = global.roomData;
var prop = data.properties;

if (is_undefined(data))
    exit;

roomInsts = [];
respawnOnLap2 = struct_new();

layerForce = [];

//show_message(global.levelMemory);

var insts = struct_get(data, "instances");

var objectStruct = {}

for (var i = 0; i < array_length(data.instances); i ++)
{
    insData = insts[i]
    levelInst = instanceManager_getKey(i);
    if (!insData.deleted)// and !levelMemory_get(levelInst))
    {
        var l = _stGet("insData.layer");
        layerConfirm("Instances", l);

        //write object indexes to a struct
        //levels often use a limited pool of objects so this way we don't need to look through all objects for the right index with asset_get_index
        var objName = _stGet("insData.object")
        var objIndex = undefined
        if(variable_struct_exists(objectStruct, objName)){
            objIndex = variable_struct_get(objectStruct, objName)
        }
        else{
            objIndex = asset_get_index(objName)
            variable_struct_set(objectStruct, objName, objIndex)
        }
        //check if object index is valid
        if(objIndex >= 0){
            var ins = instance_create_layer(_stGet("insData.variables.x") - _stGet("data.properties.roomX"), _stGet("insData.variables.y") - _stGet("data.properties.roomY"), layer_get_id(layerFormat("Instances", l)), objIndex)
            if(instance_exists(ins)){
                ins.flipX = false;
                ins.flipY = false;
                
                ins.targetRoom = "main";
                
                var varNames = variable_struct_get_names(struct_get(insData, "variables"));
                for (var j = 0; j < array_length(varNames); j ++)
                {
                    if (varNames[j] != "x" and varNames[j] != "y")
                        variable_instance_set(ins, varNames[j], varValue_ressolve(struct_get(struct_get(insData, "variables"), varNames[j]), varName_getType(varNames[j])));
                }
                ins.instID = i;
                
                if (!variable_instance_exists(ins, "escape"))
                {
                    ins.escape = false;
                }
                if (variable_instance_exists(ins, "useLayerDepth"))
                {
                    array_push(layerForce, [ins, layer_get_id(layerFormat("Instances", l))]);
                }
                
                array_push(roomInsts, [ins.id, i, ins.object_index, ins.escape]);
                if (ins.escape or array_value_exists(struct_get(global.objectData, "respawnOnLap2"), object_get_name(ins.object_index)))
                {
                    struct_set(respawnOnLap2, [[string(i), "true"]])
                }
                
                if (ins.flipX)
                {
                    var horDifference = sprite_get_width(ins.sprite_index) - sprite_get_xoffset(ins.sprite_index) * 2;
                    ins.x += horDifference * ins.image_xscale;
                    ins.image_xscale *= -1;
                }
                if (ins.flipY)
                {
                    var verDifference = sprite_get_height(ins.sprite_index) - sprite_get_yoffset(ins.sprite_index) * 2;
                    ins.y += verDifference * ins.image_yscale;
                    ins.image_yscale *= -1;
                }

                if(!variable_instance_exists(ins, "respawnOnRoomReload") || !ins.respawnOnRoomReload){
                    instanceManager_checkAndSwitch(levelInst, ins);
                }
            }
        }
    }
}

/*for (var i = 0; i < array_length(roomInsts); i ++)
{
    with roomInsts[i][0]
    {
        event_perform(ev_other, ev_room_start);
    }
}*/

var tileLayers = variable_struct_get_names(_stGet("data.tile_data"));

for (var i = 0; i < array_length(tileLayers); i ++)
{
    initTileLayer(int64(tileLayers[i]), true);
}

var bgLayers = variable_struct_get_names(_stGet("data.backgrounds"));

for (var i = 0; i < array_length(bgLayers); i ++)
{
    initBGLayer(global.roomData, int64(bgLayers[i]))
}

if (prop.song != "")
{
    customSong_switch(prop.song, prop.songTransitionTime)
}

if (global.fromEditor or global.fromMenu)
{
    with obj_player
    {
        if (global.fromEditor) backtohubroom = rmEditor;
        
        targetDoor = "A";
        if (instance_exists(obj_exitgate))
        {
            state = 95
        }
        else
        {
            state = 0;
        }
    }
    global.fromEditor = false;
    global.fromMenu = false;
}

var lv = level_load(global.levelName);
isHubLevel = lv.isWorld;
if (global.levelName == global.hubLevel)
{
    isHubLevel = true;
    with obj_player
    {
        backtohubroom = rmModMenu;
    }
}

if(room == rmCustomLevel && global.dosavestates){
    with(obj_practiceTool){
        if(createRoomStartState){
            alarm[1] = 2
        }
    }
}
//instance_create_layer(obj_player1, layer_get_id("Instances_1"), 100, 100);