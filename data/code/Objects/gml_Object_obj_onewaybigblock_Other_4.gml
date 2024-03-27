if (image_xscale == 1)
{
    with (instance_create(x, y, obj_solid))
    {
        image_yscale = 2
        other.solid_inst = id
    }
}
if (image_xscale == -1)
{
    with (instance_create((x - 32), y, obj_solid))
    {
        image_yscale = 2
        other.solid_inst = id
    }
}

if (ds_list_find_index(global.saveroom, id) != -1)
{
    instance_destroy()
    exit;
}