/*draw_set_font(global.editorfont);
draw_set_halign(fa_left)
draw_set_valign(fa_top)*/
//draw_text(64, 64, instance_count);
/*with (obj_music)
{
    draw_text(64, 64, string_upper(music))
}*/
    
/*var totSur = 0;
for (var i = 0; i < 3000; i ++)
{
    if (surface_exists(i))
    {
        totSur ++;
    }
}
draw_set_font(global.editorfont);
draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_text(0, 0, string(totSur) + "\n" + string(global.surfaceRoomEnd));*/
if (saveNotice > 0)
{
    saveNotice --;
    draw_set_font(global.smallfont)
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_alpha(saveNotice / 40);
    var s = display_get_gui_width() / obj_screensizer.actual_width;
    draw_text_transformed(display_get_gui_width() / 2, 10, "LEVEL SAVED", s, s, 0);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
}
/*
var layerList = [];
with (all)
{
    if (!array_value_exists(layerList, layer_get_name(layer)))
    {
        array_push(layerList, layer_get_name(layer))
    }
}*/
/*draw_set_font(global.editorfont)
draw_set_halign(fa_left);
draw_set_valign(fa_top);
for (var i = 0; i < array_length(layerList); i ++)
{
    draw_text(24,  24 + i * 12, layerList[i])
}