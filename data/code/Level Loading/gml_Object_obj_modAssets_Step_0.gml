if keyboard_check_pressed(vk_f6) and (global.editingLevel or keyboard_check(vk_control))
{
    if (room != rmEditor)
    {
        //surface_resize(application_surface, obj_screensizer.actual_width * 2, obj_screensizer.actual_height * 2);
        levelMemory_reset();
        room_goto(rmEditor);
    }
}

if keyboard_check_pressed(vk_f3)
{
    convert_to_hexstring();
}

with obj_player1
{
    if (state != other.lpstate)
    {
        //show_message(state);
    }
    other.lpstate = state;
}
