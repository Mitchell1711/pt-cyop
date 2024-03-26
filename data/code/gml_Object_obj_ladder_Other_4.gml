if (room == rmCustomLevel and object_index == obj_ladder)
{
    if (!place_meeting(x, y - 1, obj_ladder))
    {
        with instance_create(x, y, obj_platform)
        {
            image_xscale = other.image_xscale;
        }
    }
}