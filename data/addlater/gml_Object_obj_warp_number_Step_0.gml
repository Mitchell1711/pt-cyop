var objs = [obj_door, obj_keydoor, obj_geromedoor]
for (var i = 0; i < array_length(objs); i ++)
{
    with (objs[i])
    {
        warp_to_trigger();
    }
}