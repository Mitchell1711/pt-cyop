function createsavestate(){ //slot to save
    doingstatestuff = true
    var objects = []
    var dontload = []
    //fix for the secret portal crash
    var secretportalID = noone
    //save current mod folder to prevent crashes from loading different levels
    savedmodfolder = global.modFolder
    //save objects and their variables
    with(all){
        //if statement with stuff you dont want to savestate
        if (object_index != obj_practiceTool && object_index != obj_music && object_index != obj_customAudio 
        && object_index != obj_levelLoader && object_index != obj_customBG && object_index != obj_tilemapDrawer
        && object_index != obj_modAssets){
            //save object ID
            var obj_id = id

            var varnames = variable_instance_get_names(id)
            var variables = array_create(array_length(varnames))
            
            for (i = 0; i < array_length(varnames); i++){
                //special handling for secretportalID to prevent a crash
                if(varnames[i] == "secretportalID"){
                    secretportalID = variable_instance_get(id, varnames[i])
                }
                //overwrite object ID if the object contains a cyop id
                else if(varnames[i] == "instID"){
                    obj_id = instanceManager_getKey(variable_instance_get(id, varnames[i]))
                }
                variables[i] = [varnames[i], variable_instance_get(id, varnames[i])]
            }

            //retrieve alarms as well
            var alarms = array_create(12)
            for (i = 0; i < array_length(alarms); i++)
                alarms[i] = alarm[i]
            
            //dont change position when loading state if the object hasnt moved
            var changepos = true
            if(x == xstart && y == ystart){
                changepos = false
            }
            
            //create object struct with all the variables
            var objectinfo = {
                obj_id : obj_id,
                object_index : object_index,
                x : x,
                y : y,
                image_speed : image_speed,
                image_index : image_index,
                sprite_index : sprite_index,
                variables : variables,
                alarms : alarms,
                image_xscale : image_xscale,
                image_yscale : image_yscale,
                image_angle : image_angle,
                direction : direction,
                visible : visible,
                changepos : changepos
            }

            //push struct to array
            array_push(objects, objectinfo)

            //prevent loading in the solids of the oneway block and monster gate
            if(object_index == obj_onewaybigblock){
                array_push(dontload, solid_inst)
            }
            else if(object_index == obj_monstergate){
                array_push(dontload, solidID)
            }
        }
    }

    //get all globals, saveroom, baddieroom and escaperoom need to be tracked seperately as I want to modify them again after load
    varnames = variable_instance_get_names(global)
    
    //get globals and savesystem variables
    var globals = saveGlobals(varnames, array_concat(savesystemnames, blacklistedglobals))
    var savesystem = saveGlobals(savesystemnames)

    savestates[saveslot] = {
        objects : objects,
        globals : globals,
        savesystem : savesystem,
        secretportalID : secretportalID,
        dontload : dontload
    }

    if(saveslot < 10)
        create_transformation_tip("Saved state to slot "+string(saveslot))
    doingstatestuff = false
}

function saveGlobals(argument0, argument1){ //array of varnames, blacklist
    //the array we will return
    var outputarray = []
    //blacklist is empty if none is passed on
    if(argument1 == undefined){
        argument1 = []
    }
    //loop over all the variable names
    for (var i = 0; i < array_length(argument0); i++)
    {
        //check if the variable name isnt in the blacklist
        if (!array_contains(argument1, argument0[i]))
        {
            var value = variable_global_get(argument0[i])
            //global ds lists needs to have their contents dumped into an array
            //check if value is a real to prevent arrays being entered into ds_exists which causes a crash
            if (is_real(value) && ds_exists(value, ds_type_list))
            {
                var ds = []
                for (var j = 0; j < ds_list_size(value); j++)
                    array_push(ds, ds_list_find_value(value, j))

                array_push(outputarray, [argument0[i], value, ds])
            }
            //if the variable is not a list just write it normally
            else
                array_push(outputarray, [argument0[i], value])
        }
    }
    return outputarray
}