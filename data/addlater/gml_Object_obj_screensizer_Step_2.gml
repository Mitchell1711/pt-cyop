/*
WARNING: Recursive script decompilation (for member variable name resolution) failed for gml_Script_gameframe_get_fullscreen

System.InvalidOperationException: Stack empty.
   at System.Collections.Generic.Stack`1.ThrowForEmptyStack()
   at System.Collections.Generic.Stack`1.Pop()
   at UndertaleModLib.Decompiler.Decompiler.DecompileFromBlock(DecompileContext context, Dictionary`2 blocks, Block block, List`1 tempvars, Stack`1 workQueue) in C:\Users\sebap\Documents\GitHub\UndertaleModTool\UndertaleModLib\Decompiler\Decompiler.cs:line 2149
   at UndertaleModLib.Decompiler.Decompiler.DecompileFromBlock(DecompileContext context, Dictionary`2 blocks, Block block) in C:\Users\sebap\Documents\GitHub\UndertaleModTool\UndertaleModLib\Decompiler\Decompiler.cs:line 2654
   at UndertaleModLib.Decompiler.Decompiler.<DecompileFromBlock>g__FindActualNameForAnonymousCodeObject|30_2(DecompileContext context, UndertaleCode anonymousCodeObject) in C:\Users\sebap\Documents\GitHub\UndertaleModTool\UndertaleModLib\Decompiler\Decompiler.cs:line 2430
*/
var ww = window_get_width()
var wh = window_get_height()
var cr = cr_beam
if ((device_mouse_x_to_gui(0) != mouse_xprevious || device_mouse_y_to_gui(0) != mouse_yprevious) && gml_Script_gameframe_mouse_in_window())
{
    if (window_get_cursor() == -1)
        cr = cr_default
    disappearbuffer = 100
    mouse_xprevious = device_mouse_x_to_gui(0)
    mouse_yprevious = device_mouse_y_to_gui(0)
}
if (disappearbuffer > 0)
{
    captionalpha = Approach(captionalpha, 1, 0.2)
    disappearbuffer--
}
else
{
    captionalpha = Approach(captionalpha, 0, 0.1)
    if (window_get_cursor() != -1 && window_has_focus() && room != Mainmenu)
        cr = cr_none
}
if (room != Mainmenu && gameframe_get_fullscreen() > 0)
    cr = cr_none
if (room == Mainmenu && window_get_cursor() == -1)
    cr = cr_default
if (instance_exists(obj_inputAssigner) && obj_inputAssigner.player_input_device[0] >= 0)
    cr = cr_none
switch room
{
    case rmEditor:
    case rmModMenu:
        cr = cr_none
    break;
}
if (cr != cr_beam)
{
    window_set_cursor(cr)
    global.gameframe_current_cursor = cr
    if (cr == cr_none)
        global.gameframe_set_cursor = 0
    else
        global.gameframe_set_cursor = 1
}
global.gameframe_alpha = captionalpha
if window_has_focus()
{
    savedwidth = window_get_width()
    savedheight = window_get_height()
    saved_guiwidth = display_get_gui_width()
    saved_guiheight = display_get_gui_height()
}
else
{
    dirty = 1
    if (global.option_fullscreen > 0)
        alarm[2] = 5
}
if (startbuffer > 0)
    startbuffer--
if (window_has_focus() && (dirty || window_width_current != ww || window_height_current != wh || global.option_scale_mode != last_scale_mode || global.option_fullscreen != gameframe_get_fullscreen()))
{
    if dirty
        dirty = 0
    if (global.option_scale_mode == 0)
    {
        camera_set_view_size(view_camera[0], (obj_screensizer.ideal_width * camzoom), (obj_screensizer.ideal_height * camzoom))
        app_scale = min((ww / obj_screensizer.ideal_width), (wh / obj_screensizer.ideal_height))
        trace(app_scale)
        obj_screensizer.actual_width = obj_screensizer.ideal_width
        obj_screensizer.actual_height = obj_screensizer.ideal_height
        if (app_scale > 0)
        {
            surface_resize(application_surface, obj_screensizer.ideal_width, obj_screensizer.ideal_height)
            __display_set_gui_size_hook(obj_screensizer.ideal_width, obj_screensizer.ideal_height)
        }
    }
    else if (global.option_scale_mode == 1)
    {
        camera_set_view_size(view_camera[0], (obj_screensizer.ideal_width * camzoom), (obj_screensizer.ideal_height * camzoom))
        app_scale = min((ww div obj_screensizer.ideal_width), (wh div obj_screensizer.ideal_height))
        obj_screensizer.actual_width = obj_screensizer.ideal_width
        obj_screensizer.actual_height = obj_screensizer.ideal_height
        if (app_scale > 0)
        {
            surface_resize(application_surface, obj_screensizer.ideal_width, obj_screensizer.ideal_height)
            __display_set_gui_size_hook(obj_screensizer.ideal_width, obj_screensizer.ideal_height)
        }
    }
    else if (global.option_scale_mode == 2)
    {
        app_scale = 1
        camera_set_view_size(view_camera[0], (ww * camzoom), (wh * camzoom))
        obj_screensizer.actual_width = ww
        obj_screensizer.actual_height = wh
        if (ww > 0 && wh > 0)
        {
            surface_resize(application_surface, obj_screensizer.actual_width, obj_screensizer.actual_height)
            __display_set_gui_size_hook(obj_screensizer.actual_width, obj_screensizer.actual_height)
        }
    }
    last_scale_mode = global.option_scale_mode
    last_fullscreen = gameframe_get_fullscreen()
    window_width_current = window_get_width()
    window_height_current = window_get_height()
    normal_size_fix_x = ((obj_screensizer.actual_width - 960) / 2)
    normal_size_fix_y = ((obj_screensizer.actual_height - 540) / 2)
}
