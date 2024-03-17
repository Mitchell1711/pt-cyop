if (state == (18 << 0) || (state == (8 << 0) && dark))
{
    draw_sprite(spr_menudark, 0, 0, 0)
    with obj_menutvcustom
    {
        draw_sprite(_spr("tvcustom_dark"), 0, x, y)
    }
    draw_set_color(c_black)
    draw_rectangle(0, 0, 350, 300, false)
    draw_rectangle(300, 0, 700, 180, false)
    draw_rectangle(room_width - 300, 0, room_width, room_height, false)
    draw_set_color(c_white)
}
if (state == (183 << 0))
{
    draw_set_alpha(0.5)
    draw_rectangle_color(0, 0, room_width, room_height, c_black, c_black, c_black, c_black, 0)
    draw_set_alpha(1)
    draw_set_font(lang_get_font("bigfont"))
    draw_set_halign(fa_center)
    draw_set_valign(fa_middle)
    var _str = embed_value_string(lang_get_value("menu_delete"), [string((currentselect + 1))])
    draw_text_color((obj_screensizer.actual_width / 2), ((obj_screensizer.actual_height / 2) - 30), _str, c_red, c_red, c_red, c_red, 1)
    var w = (string_width(_str) / 2)
    draw_sprite(spr_menu_filedelete, index, (((obj_screensizer.actual_width / 2) + w) + 70), (obj_screensizer.actual_height / 2))
    draw_sprite(spr_menu_filedelete, index, (((obj_screensizer.actual_width / 2) - w) - 70), (obj_screensizer.actual_height / 2))
    var c1 = (deleteselect == 0 ? c_white : c_gray)
    var c2 = (deleteselect == 1 ? c_white : c_gray)
    draw_text_color(((obj_screensizer.actual_width / 2) - 100), ((obj_screensizer.actual_height / 2) + 30), lang_get_value("option_yes"), c1, c1, c1, c1, 1)
    draw_text_color(((obj_screensizer.actual_width / 2) + 100), ((obj_screensizer.actual_height / 2) + 30), lang_get_value("option_no"), c2, c2, c2, c2, 1)
}
else if (state == (289 << 0))
{
    draw_set_alpha(0.5)
    draw_rectangle_color(0, 0, room_width, room_height, c_black, c_black, c_black, c_black, 0)
    draw_set_alpha(1)
    draw_set_font(lang_get_font("bigfont"))
    draw_set_halign(fa_center)
    draw_set_valign(fa_middle)
    draw_sprite(spr_menu_byebye, index, ((obj_screensizer.actual_width / 2) + 210), (obj_screensizer.actual_height / 2))
    draw_sprite(spr_menu_byebye, index, ((obj_screensizer.actual_width / 2) - 210), (obj_screensizer.actual_height / 2))
    draw_text_color((obj_screensizer.actual_width / 2), ((obj_screensizer.actual_height / 2) - 30), lang_get_value("menu_exit"), c_white, c_white, c_white, c_white, 1)
    c1 = (exitselect == 0 ? c_white : c_gray)
    c2 = (exitselect == 1 ? c_white : c_gray)
    draw_text_color(((obj_screensizer.actual_width / 2) - 100), ((obj_screensizer.actual_height / 2) + 30), lang_get_value("option_yes"), c1, c1, c1, c1, 1)
    draw_text_color(((obj_screensizer.actual_width / 2) + 100), ((obj_screensizer.actual_height / 2) + 30), lang_get_value("option_no"), c2, c2, c2, c2, 1)
}
