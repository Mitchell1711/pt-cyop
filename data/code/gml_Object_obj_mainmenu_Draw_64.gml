if instance_exists(obj_noiseunlocked)
    return;
draw_set_font(lang_get_font("bigfont"))
draw_set_halign(fa_center)
draw_set_valign(fa_middle)
draw_set_color(c_white)
draw_set_alpha(1)
if (state == states.titlescreen || (state == states.transitioncutscene && dark))
{
    draw_sprite(spr_menudark, 0, 0, 0)
    with (obj_menutvcustom)
        draw_sprite(_spr("tvcustom_dark"), 0, x, y)
    draw_set_color(c_black)
    draw_rectangle(0, 0, 350, 300, false)
    draw_rectangle(300, 0, 700, 180, false)
    draw_rectangle((room_width - 300), 0, room_width, room_height, false)
    draw_set_color(c_white)
}
if (state == states.bombdelete)
{
    draw_set_alpha(0.5)
    draw_rectangle_color(0, 0, room_width, room_height, c_black, c_black, c_black, c_black, 0)
    draw_set_alpha(1)
    draw_set_font(lang_get_font("bigfont"))
    draw_set_halign(fa_center)
    draw_set_valign(fa_middle)
    var _str = embed_value_string(lang_get_value("menu_delete"), [string((currentselect + 1))])
    tdp_draw_text_color((obj_screensizer.actual_width / 2), ((obj_screensizer.actual_height / 2) - 30), _str, 255, 255, 255, 255, 1)
    var w = (string_width(_str) / 2)
    var spr = spr_menu_filedelete
    var ix = index
    if (deletebuffer > 0)
    {
        spr = spr_menu_filedelete_lit
        ix = (index * 2.5)
    }
    draw_sprite(spr, ix, (((obj_screensizer.actual_width / 2) + w) + 70), (obj_screensizer.actual_height / 2))
    draw_sprite(spr, ix, (((obj_screensizer.actual_width / 2) - w) - 70), (obj_screensizer.actual_height / 2))
    var c1 = (deleteselect == 0 ? 16777215 : 8421504)
    var c2 = (deleteselect == 1 ? 16777215 : 8421504)
    tdp_draw_text_color(((obj_screensizer.actual_width / 2) - 100), ((obj_screensizer.actual_height / 2) + 30), lang_get_value("option_yes"), c1, c1, c1, c1, 1)
    tdp_draw_text_color(((obj_screensizer.actual_width / 2) + 100), ((obj_screensizer.actual_height / 2) + 30), lang_get_value("option_no"), c2, c2, c2, c2, 1)
    tdp_text_commit(0, 0, obj_screensizer.actual_width, obj_screensizer.actual_height)
}
else if (state == states.finale)
{
    draw_set_alpha(0.5)
    draw_rectangle_color(0, 0, room_width, room_height, c_black, c_black, c_black, c_black, 0)
    draw_set_alpha(1)
    draw_set_font(lang_get_font("bigfont"))
    draw_set_halign(fa_center)
    draw_set_valign(fa_middle)
    draw_sprite(spr_menu_byebye, index, ((obj_screensizer.actual_width / 2) + 210), (obj_screensizer.actual_height / 2))
    draw_sprite(spr_menu_byebye, index, ((obj_screensizer.actual_width / 2) - 210), (obj_screensizer.actual_height / 2))
    tdp_draw_text_color((obj_screensizer.actual_width / 2), ((obj_screensizer.actual_height / 2) - 30), lang_get_value("menu_exit"), 16777215, 16777215, 16777215, 16777215, 1)
    c1 = (exitselect == 0 ? 16777215 : 8421504)
    c2 = (exitselect == 1 ? 16777215 : 8421504)
    tdp_draw_text_color(((obj_screensizer.actual_width / 2) - 100), ((obj_screensizer.actual_height / 2) + 30), lang_get_value("option_yes"), c1, c1, c1, c1, 1)
    tdp_draw_text_color(((obj_screensizer.actual_width / 2) + 100), ((obj_screensizer.actual_height / 2) + 30), lang_get_value("option_no"), c2, c2, c2, c2, 1)
    tdp_text_commit(0, 0, obj_screensizer.actual_width, obj_screensizer.actual_height)
}
