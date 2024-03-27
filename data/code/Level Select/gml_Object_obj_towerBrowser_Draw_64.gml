scr_getinput();
var cpos = cursor_hud_position();

if (bullshitCooldown > 0) bullshitCooldown --;

for (var cind = 0; cind < array_length(w_openCanvas); cind ++)
{
    var c = w_openCanvas[cind];
    
    if (c.name != "screen")
    {
        _wCanvas_surfaceCheck(c)
        surface_set_target(c.surface)
        
        var onX = cpos[0] - c.x + c.scroll_x;
        var onY = cpos[1] - c.y + c.scroll_y;
        var isOn = w_isOnCanvas(c, cpos[0], cpos[1]);
        
        draw_set_font(global.editorfont);
        
        wCanvas_step(c, onX, onY, cpos[0], cpos[1]);
        switch c.name
        {
            case "towerList":
                //var tNames = tbrowser_towerNames();
                var s = 2;
                
                var ySep = 48 * s;
                var xx = 32 * s;
                
                var tPressed = false;
                
                if (isOn)
                {
                    if (cpos[0] != lcpos[0] or cpos[1] != lcpos[1])
                    {
                        tHover = floor((onY * s) / ySep)
                        if (tHover < 0) tHover = -1;
                        if (tHover > array_length(towers) - 1) tHover = -1;
                    }
                    
                    if (mouse_check_button_pressed(mb_left))
                    {
                        tPressed = true;
                    }
                }
                
                if (tPressed == 0)
                {
                    tPressed = key_jump;
                }
                
                if (tPressed and array_length(towers) > 0)
                {
                    var t = towerSelected;
                    if (towerSelected != towers[tHover])
                    {
                        towerSelected = towers[tHover];
                        bullshitCooldown = 2;
                        //show_message(towerSelected)
                    }
                    else if (t.canDownload and t.downloadProgress == -1 and bullshitCooldown = 0)
                    {
                        //show_message(towerSelected)
                        tbrowser_requestDownload(t);
                    }
                        
                }
                
                var tChange = key_down2 - key_up2;
                if (tChange != 0)
                {
                    tHover += tChange;
                    if (tHover < 0) tHover = array_length(towers) - 1;
                    if (tHover > array_length(towers) - 1) tHover = 0;
                }
                
                for (var i = 0; i < array_length(towers); i ++)
                {
                    var t = towers[i];
                    if (tHover == i)
                    {
                        draw_set_color(c_ltgray);
                        draw_rectangle(0, i * ySep, c.width * s, i * ySep + ySep - 2 * s, false);
                        draw_set_color(c_white);
                    }
                    
                    
                    if (t.image != undefined)
                    {
                        if (sprite_exists(t.image))
                        {
                            var scale = (48 * s) / sprite_get_height(t.image);
                            var w = sprite_get_width(t.image) * scale;
                            draw_sprite_ext(t.image, 0, c.width * s - w, i * ySep, scale, scale, 0, c_white, 1);
                        }
                    }
                    
                    if (t.downloadProgress >= 0)
                    {
                        draw_set_color(c_lime);
                        draw_rectangle(0, i * ySep, c.width * s * t.downloadProgress, i * ySep + ySep - 2 * s, false);
                        draw_set_color(c_white);
                    }
                    
                    draw_set_font(global.creditsfont);
                    draw_set_color(c_black)
                    /*draw_text_transformed(xx + 1, i * ySep + 1, string_upper(t.name), 0.5, 0.5, 0)
                    draw_text_transformed(xx - 1, i * ySep + 1, string_upper(t.name), 0.5, 0.5, 0)
                    draw_text_transformed(xx, i * ySep + 1 + 1, string_upper(t.name), 0.5, 0.5, 0)
                    draw_text_transformed(xx, i * ySep + 1 - 1, string_upper(t.name), 0.5, 0.5, 0)*/
                    draw_set_color(c_white)
                    if (!t.canDownload)
                    {
                        draw_set_color(c_gray)
                    }
                    //gpu_set_blendmode(bm_add);
                    draw_text_transformed(xx, i * ySep + 1, string_upper(t.name), s / 2, s / 2, 0)
                    //gpu_set_blendmode(bm_normal);
                    //draw_text_transformed(xx, i * ySep + 1, string_upper(t.name), 0.5, 0.5, 0)
                    
                    draw_set_color(c_gray);
                    if (!t.canDownload)
                    {
                        draw_set_color(c_dkgray)
                    }
                    draw_set_font(global.editorfont);
                    draw_text_transformed(xx, i * ySep + 16 * s, t.tagline, s, s, 0);
                    draw_set_color(c_white);
                    
                    var statsY = i * ySep + 28 * s;
                    draw_text_transformed(xx, statsY, "´" + string(t.downloadCount), s, s, 0)
                    draw_text_transformed(xx + 64 * s, statsY, "¨" + string(t.likeCount), s, s, 0)
                    
                    draw_sprite_ext(_spr("status_icons"), t.status, 4 * s, i * ySep, s, s, 0, c_white, 1);
                    
                    draw_set_color(c_gray);
                    draw_rectangle(0, i * ySep, c.width * s, i * ySep + ySep - 2 * s, true);
                    draw_set_color(c_white);
                }
                
                if (array_length(towers) == 0 and !noResults)
                {
                    draw_set_halign(fa_center);
                    draw_set_font(global.creditsfont);
                    draw_text_transformed(c.width * s / 2, c.height * s / 2, "Loading...", s, s, 0);
                    draw_set_font(global.editorfont);
                    draw_set_halign(fa_left);
                    draw_sprite_ext(_spr("loading"), (current_time / 1000 * 30) % 3, ((current_time / 1000 * 60 * 12) % (c.width + 100) - 100) * s, (c.height / 2 - 80) * s, s, s, 0, c_white, 1)
                }
            break;
            
            case "tower":
                if (towerSelected != noone)
                {
                    var t = towerSelected;
                    var txtY = 400;
                    if (t.image != undefined)
                    {
                        if (sprite_exists(t.image))
                        {
                            var scale = min((c.width * 2) / sprite_get_width(t.image), (txtY - 20) / sprite_get_height(t.image));
                            //var w = sprite_get_width(t.image) * scale;
                            draw_sprite_ext(t.image, 0, (c.width * 2 - sprite_get_width(t.image) * scale) / 2, 0, scale, scale, 0, c_white, 1);
                        }
                    }
                    draw_set_font(global.creditsfont)
                    draw_text_transformed(0, txtY, string_upper(t.name), 1, 1, 0);
                    draw_set_font(global.editorfont);
                    
                    var dlHover = false;
                    var vsHover = false;
                    if (isOn)
                    {
                        if (onY > c.height - 100)
                        {
                            if (onX < c.width / 2)
                            {
                                dlHover = true;
                            }
                            else
                            {
                                vsHover = true;
                            }
                        }
                        
                        if (mouse_check_button_pressed(mb_left))
                        {
                            if (dlHover and t.canDownload and t.downloadProgress == -1)
                            {
                                tbrowser_requestDownload(t);
                            }
                            if (vsHover)
                            {
                                url_open(t.pageLink);
                            }
                        }
                    }
                    
                    var dlImg = dlHover;
                    if (t.status == 2)
                    {
                        dlImg = 5 + dlHover;
                    }
                    if (!t.canDownload or t.downloadProgress >= 0)
                        dlImg = 2;
                    
                    var bY = (c.height - 100) * s;
                    draw_sprite_ext(_spr("download_buttons"), dlImg, 0, bY, s, s, 0, c_white, 1);
                    draw_sprite_ext(_spr("download_buttons"), 3 + vsHover, c.width / 2 * s, bY, s, s, 0, c_white, 1);
                    
                    draw_set_halign(fa_center)
                    var dText = ["download", "re-download", "update", "incompatible"];
                    
                    draw_text_transformed((c.width / 4) * s, bY + 80 * s, dText[t.status], s, s, 0);
                    draw_text_transformed((c.width / 4 * 3) * s, bY + 80 * s, "visit page", s, s, 0);
                }
                else
                {
                    draw_set_font(global.editorfont);
                    draw_text_transformed(2, 2, "Click on a tower for details", 2, 2, 0)
                }
            break;
            
            case "bar":
                draw_set_halign(fa_right);
                draw_set_valign(fa_center);
                draw_text(c.width, c.height / 2, "Page: < " + string(towerPage) + " > ");
                
                draw_set_halign(fa_center);
                
                var modType = "CYOP";
                if (showOldCustom) modType = "(old cat) Custom levels";
                draw_text(c.width / 2, c.height / 2, "Mods: " + modType);
                
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
                
                var filters = ["Recent", "Featured", "Popular"];
                
                draw_text(0, 0, "Filter: " + filters[towerFilter]);
                var searchTxt = towerSearch;
                if (searchTxt == undefined)
                {
                    searchTxt = "";
                }
                searchTxt = "\"" + searchTxt + "\"";
                draw_text(0, 16, "Search: " + searchTxt);
                
                var pgChange = 0;
                if (isOn)
                {
                    if (mouse_check_button_pressed(mb_left))
                    {
                        if (onX > c.width - 9 * 3)
                            pgChange = 1;
                        if (onX > c.width - 9 * 7 and onX < c.width - 9 * 4)
                            pgChange = -1;
                            
                        if (onX < 128)
                        {
                            if (onY < c.height / 2)
                            {
                                towerFilter ++;
                                towerFilter %= 3;
                            }
                            else
                            {
                                var searchTxt = towerSearch;
                                if (searchTxt == undefined)
                                {
                                    searchTxt = "";
                                }
                                towerSearch = get_string("Enter search term (mods that aren't levels may show up)", searchTxt);
                                if (towerSearch == "")
                                {
                                    towerSearch = undefined;
                                }
                            }
                            tbrowser_requestList();
                        }
                        
                        if (onX > c.width / 2 - 100 and onX < c.width / 2 + 100)
                        {
                            showOldCustom = !showOldCustom;
                            tbrowser_requestList();
                        }
                    }
                    
                }
                
                if (pgChange == 0)
                {
                    pgChange = key_right2 + key_left2;
                }
                
                if (pgChange != 0 and array_length(variable_struct_get_names(reqDownload)) == 0)
                {
                    towerPage += pgChange;
                    
                    if (towerPage < 1)
                    {
                        towerPage = 1;
                    }
                    else
                    {
                        tbrowser_requestList();
                    }
                }
            break;
            
            case "close":
                draw_set_halign(fa_right);
                draw_set_valign(fa_center);
                draw_text(c.width - 2, c.height / 2, "CLOSE TOWER BROWSER");
                
                if (isOn and mouse_check_button_pressed(mb_left))
                {
                    instance_destroy();
                }
                draw_set_valign(fa_top)
            break;
            
            case "towerDescription":
                var t = towerSelected;
                if (t != noone)
                {
                    draw_set_halign(fa_left);
                    draw_set_valign(fa_top);
                    draw_text(2, 2, "Mod submitted by:");
                    draw_set_font(global.creditsfont);
                    draw_text_transformed(2, 16, t.creator, 0.75, 0.75, 0);
                    draw_set_font(global.editorfont);
                }
            break;
        }
        
        surface_reset_target();
        wCanvas_draw(c, 0.9)
        
        draw_set_font(global.bigfont);
    }
}

if (key_slap2 or key_escape)
{
    instance_destroy();
}


draw_sprite_ext(_spr("cursor"), 0, cpos[0] * w_scale, cpos[1] * w_scale, 2, 2, 0, c_white, 1)

lcpos = array_duplicate(cpos);