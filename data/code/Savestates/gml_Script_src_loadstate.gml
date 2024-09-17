function loadstate(){
    var save = savestates[saveslot]
    if(array_length(variable_struct_get_names(save)) == 0){
        if(saveslot < 10)
            create_transformation_tip("Failed to load slot "+string(saveslot))
        else
            create_transformation_tip("Failed to load room state")
        break
    }
    doingstatestuff = true
    //restore globals before room reload
    //important since I want to update the roomdata and currentroom to what it was during saving so I can load the right one
    restoreGlobals(struct_get(save, "globals"))
    //savesystem is reloaded the same way as well
    restoreGlobals(struct_get(save, "savesystem"))

    //save spaceblock state since the spaceblock resets the global variable in its create code
    spaceblockstate = global.spaceblockswitch
    //load in secret portal id
    var portalID = struct_get(save, "secretportalID")
    if(portalID != undefined){
        with(obj_player1){
            secretportalID = portalID
        }
    }

    //(re)load the room
    prepareCustomLevel(get_roomData(global.currentRoom), global.currentRoom)
    //3 frame delay for loading objects because cyop is slow
    //needs 2 frames to instantiate the objects and 1 frame to instantiate hitboxes
    alarm[0] = 3
}

//called in alarm[0]
function loadstatevariables()
{
    var save = savestates[saveslot]
    //go over all saved objects
    var objects = struct_get(save, "objects")
    for (var i = 0; i < array_length(objects); i++)
    {
        var obj = objects[i]
        var obj_id = struct_get(obj, "obj_id")
         //if object id is a string it means its an object spawned from the json
         //I need to convert this string back to an object id by looking it up in the instancemanager
        if is_string(obj_id)
            obj_id = struct_get(global.instanceManager, obj_id)

        //spawn in object if its missing
        if(!instance_exists(obj_id)){
            obj_id = instance_create(struct_get(obj, "x"), struct_get(obj, "y"), struct_get(obj, "object_index"))
        }

        //assign all saved variables to the object
        with(obj_id){
            //only change pos if it moved from its spawn position during the savestate
            if(struct_get(obj, "changepos"))
            {
                x = struct_get(obj, "x")
                y = struct_get(obj, "y")
            }
            image_speed = struct_get(obj, "image_speed")
            image_index = struct_get(obj, "image_index")
            //cyop objects can have their sprites changed to a custom one from the mod folder
            //this causes issues specifically when trying to load another level from the same tower
            var spr = struct_get(obj, "sprite_index")
            if sprite_exists(spr)
                sprite_index = spr
            image_xscale = struct_get(obj, "image_xscale")
            image_yscale = struct_get(obj, "image_yscale")
            image_angle = struct_get(obj, "image_angle")
            direction = struct_get(obj, "direction")
            visible = struct_get(obj, "visible")

            //load object variables
            var vars = struct_get(obj, "variables")
            for (var j = 0; j < array_length(vars); j++){
                variable_instance_set(id, vars[j][0], vars[j][1])
            }
            //load alarms
            var alarms = struct_get(obj, "alarms")
            for (j = 0; j < array_length(alarms); j++)
                alarm[j] = alarms[j]
        }
    }
}

function restoreGlobals(argument0){ //savestate array
    for (var i = 0; i < array_length(argument0); i++)
    {
        var glob = argument0[i]
        variable_global_set(glob[0], glob[1])

        //if the global saved was a list then the array length will be 3
        if (array_length(glob) > 2)
        {
            //empty out list
            ds_list_clear(glob[1])

            //add values from array back to ds list
            for (var j = 0; j < array_length(glob[2]); j++)
                ds_list_add(glob[1], glob[2][j])
        }
    }
}