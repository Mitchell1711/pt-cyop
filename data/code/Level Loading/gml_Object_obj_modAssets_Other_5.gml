repeat (array_length(global.surfaceRoomEnd))
{
    var s = array_pop(global.surfaceRoomEnd);
    if (surface_exists(s))
    {
        surface_free(s)
    }
}