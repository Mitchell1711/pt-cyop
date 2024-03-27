var _start = 0
with (obj_player)
{
    if (object_index != obj_player2 || global.coop)
    {
        //var customEyeIndex = -1;
        
        if (!variable_instance_exists(other, "instID"))
            other.instID = -1;
           
        var secondCondition = false;
        if (room == rmCustomLevel)
        {
            secondCondition = (other.instID == global.secretRoomFix[1] and global.currentRoom == global.secretRoomFix[0])
        }
            
        if (targetDoor == "S" && (secretportalID == other.id or secondCondition))
        {
            x = other.x
            y = other.y
            roomstartx = x
            roomstarty = y
            with (obj_followcharacter)
            {
                x = other.x
                y = other.y
            }
            with (obj_pizzaface)
            {
                x = other.x
                y = other.y
            }
            _start = 1
            other.sprite_index = spr_secretportal_close
            other.image_index = 0
            instance_destroy(other)
            instance_create(x, y, obj_secretportalstart)
        }
    }
}
if (ds_list_find_index(global.saveroom, id) != -1)
{
    active = 0
    sprite_index = spr_secretportal_close
    image_index = 0
    if (!_start)
        instance_destroy(instance_place(x, y, obj_frontcanongoblin_trigger))
    trace("portal active: false")
}
