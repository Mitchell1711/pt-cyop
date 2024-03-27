var cpos = cursor_hud_position();
cursorX = cpos[0] * w_scale;
cursorY = cpos[1] * w_scale;

tilesetStruct = _tileset(tilesetSelected);

if (array_length(tilesetStruct.autotile) <= 0)
{
    tileset_doAutoTile = false;
}

if (display_get_gui_width() != 1920)
{
    display_set_gui_size(1920, 1080);
}

if (surface_get_width(application_surface) != 1920 and window_get_width() >= 1920)
{
    surface_resize(application_surface, 1920, 1080);
}

draw_set_font(global.editorfont);

with (obj_pause)
{
    visible = false;
}