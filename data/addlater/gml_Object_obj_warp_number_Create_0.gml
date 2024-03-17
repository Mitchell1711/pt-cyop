trigger = 0;
warpInst = noone;

function warp_to_trigger()
{
    var numWarp = instance_place(x, y, obj_warp_number);
    if (numWarp != noone) targetDoor = numWarp.trigger;
}