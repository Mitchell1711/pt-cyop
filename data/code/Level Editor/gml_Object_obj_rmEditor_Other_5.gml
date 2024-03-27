modRoom_end()
display_set_gui_size(obj_screensizer.actual_width, obj_screensizer.actual_height);
surface_resize(application_surface, obj_screensizer.actual_width, obj_screensizer.actual_height);

wCanvas_close_all();

with (obj_pause)
{
    visible = true;
}