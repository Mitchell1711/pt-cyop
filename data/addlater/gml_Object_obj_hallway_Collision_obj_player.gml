if (obj_player1.state == (208 << 0))
{
}
if (obj_player1.state == (290 << 0))
    return;
if instance_exists(obj_jumpscare)
{
}
var hall = id
with (other)
{
    if (!other.savedposition)
    {
        other.savedposition = 1
        other.savedx = x
        other.savedy = y
    }
    x = other.savedx
    y = other.savedy
    if (!instance_exists(obj_fadeout))
    {
        obj_player1.lastroom = room
        obj_player2.lastroom = room
        obj_player1.targetDoor = other.targetDoor
        obj_player1.targetRoom = other.targetRoom
            
        obj_player1.hallway = 1
        obj_player1.hallwaydirection = other.image_xscale
        if instance_exists(obj_player2)
        {
            obj_player2.targetDoor = other.targetDoor
            obj_player2.targetRoom = other.targetRoom
            obj_player2.hallway = 1
            obj_player2.hallwaydirection = other.image_xscale
        }
        other.visited = 1
        fmod_event_one_shot("event:/sfx/misc/door")
        with (instance_create(x, y, obj_fadeout))
        {
            offload_arr = hall.offload_arr
            group_arr = hall.group_arr
        }
    }
}
