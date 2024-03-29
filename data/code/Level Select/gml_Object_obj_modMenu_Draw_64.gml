draw_sprite(_spr("modtitle"), 0, obj_screensizer.actual_width / 2, 64);
//img gonna do everything here fuck you
if (!menuLock and !instance_exists(obj_towerBrowser))
{
    scr_menu_getinput()
}
else
{
    key_down2 = false;
    key_up2 = false;
    key_jump = false;
    key_delete2 = false;
    key_quit2 = false;
}

var vmove = (key_down2 - key_up2)
var xmove = (key_right2 + key_left2);

var tPerPage = 10;
var tOffset = tPerPage * towerPage;
var tMax = tOffset + tPerPage - 1;

tMaxPages = ceil(array_length(towerList) / tPerPage);

towerPage += xmove;
if (towerPage > tMaxPages - 1) towerPage = 0;
if (towerPage < 0) towerPage = tMaxPages - 1;

if (vmove != 0)
{
    towerSelected += vmove;
    var m = min(array_length(towerList) + 1, tMax + 2);
    if (towerSelected < tOffset) towerSelected = m;
    if (towerSelected > m) towerSelected = tOffset;
    towerWindowsUpdate(false);
    loadSavefile(towerSelected);
    updateTowerImages(towerSelected);
    
    global.towerSelected = towerSelected
}

//quick and dirty character swap code because i have no idea how to implement it into the menu
if(keyboard_check_pressed(vk_shift)){
    fmod_event_one_shot("event:/sfx/ui/switchcharup")
    if(global.charSelected < 2){
        global.charSelected++
    }
    else{
        global.charSelected = 0
    }
}

if (key_jump)
{
    var t = towerSelected
    if (towerSelected < min(array_length(towerList), tMax + 1))
    {
        if (towerList[t][2] == "")
        {
            show_message("This tower has no Main Level.")
        }
        else
        {
            fmod_event_one_shot("event:/sfx/misc/collectpizza")
            switchAssetFolder(string_replace(filename_dir(towerList[t][1]), general_folder(""), ""))
            
            instance_activate_object(obj_player);
            global.fromMenu = true;
            //select character
            with obj_player
            {
                backtohubroom = room;
                character = "P"
                if(global.charSelected == 0){
                    global.swapmode = false
                    ispeppino = true
                }
                else if(global.charSelected == 1){
                    global.swapmode = false
                    ispeppino = false
                }
                else if(global.charSelected == 2){
                    global.swapmode = true
                    ispeppino = true
                }
                scr_characterspr()
            }
            if (towerList[t][3] == 0)
            {
                global.hubLevel = towerList[t][2];
            }
            preloadCustomLevel(towerList[t][2]);
            
            towerWindowsUpdate(false);
            menuLock = true;
            fmod_event_instance_stop(musicID, 1)
            if (towerList[t][3] == 0)
            {
                seenTitlecard = true;
                alarm[0] = 50;
            }
            else
            {
                var sett = level_load(towerList[t][2])
                if (sett.titlecardSprite != "no titlecard")
                {
                    alarm[0] = 40;
                }
                else
                {
                    seenTitlecard = true;
                    alarm[0] = 50;
                }
            }
            //show_message(global.leveltosave)
        }
    }
    else
    {
        if (towerSelected == array_length(towerList) or towerSelected == tMax + 1)
        {
            var towerFolder = get_string("Input a folder name for your new Tower (display name can be different)", "tower_" + string(array_length(towerList)))
            if (towerFolder != "")
            {
                if (directory_exists(general_folder(towerFolder)))
                {
                    show_message("a folder with the name \"" + towerFolder + "\" already exists.")
                }
                else
                {
                    var towerName = get_string("Input display name for your Tower (can be changed later)", "Tower " + string(array_length(towerList)))
                    if (towerName != "")
                    {
                        directory_create(general_folder(towerFolder))
                        var tPath = general_folder(towerFolder + "/")
                        directory_create(tPath + "sprites")
                        directory_create(tPath + "audio")
                        directory_create(tPath + "levels")
                        ini_open(tPath + towerFolder + ".tower.ini")
                        ini_write_string("properties", "name", towerName);
                        ini_write_string("properties", "mainlevel", "");
                        ini_close();
                        
                        loadTowerList();
                    }
                }
            }
        }
        else
        {
            instance_create(0, 0, obj_towerBrowser);
        }
    }
}

if (key_delete2)
{
    var t = towerSelected
    if (towerSelected < array_length(towerList))
    {
        loadLevelList(string_replace(filename_dir(towerList[t][1]), general_folder(""), ""));
        towerWindowsUpdate(true);
    }
}

//draw background
var bg = _spr("nighttower")//spr_introasset2;
if (towerSelected < array_length(towerList))
{
    if (towerImages[towerSelected][1] >= 0)
    {
        bg = towerImages[towerSelected][1];
    }
}
/*if (bg == spr_introasset2)
{
    draw_sprite(spr_introasset5, 0, 0, 0);
    draw_sprite(spr_introasset4, 0, 0, 0);
    draw_sprite(spr_introasset3, 0, 0, 0);
}*/
draw_sprite(bg, 0, 0, 0);

//draw tower page
draw_set_font(global.editorfont);
draw_text(2, 2, "Page " + string(towerPage + 1) + "/" + string(tMaxPages));
draw_set_font(global.bigfont);

//single level stats
if (towerSelected < min(array_length(towerList), tMax) and variable_struct_exists(stats, "toppin"))
{
    var t = towerSelected
    if (towerList[t][3] == 1)
    {
        var toppinName = ["shroom", "cheese", "tomato", "sausage", "pineapple"];
        for (var i = 0; i < 5; i ++)
        {
            var col = c_black;
            if (stats.toppin[i])
                col = c_white;
                
            var spr = _spr("spr_toppin" + toppinName[i] + toppinSuffix[i]);
            draw_sprite_ext(spr, (current_time / 1000 * 20) % sprite_get_number(spr), 640 + 64 * i, 440, 1, 1, 0, col, 1)
        }
        
        for (var i = 0; i < 3; i ++)
        {
            var spr = spr_gatesecreteyeclosed;
            if (stats.secret_count > i)
                spr = spr_gatesecreteyeopen;
                
            var rotspd = 0.25;
            draw_sprite(spr, (current_time / 1000 * 20) % sprite_get_number(spr), obj_screensizer.actual_width - 64 - i * 80 + dcos(current_time * rotspd + i * 25) * 20, 400 + dcos(current_time * rotspd / 3.2 + i * 25) * 20)
        }
        if (stats.rank != "")
        {
            var rind = struct_get(struct_new([["d", 0], ["c", 1], ["b", 2], ["a", 3], ["s", 4], ["p", 5]]), stats.rank)
            draw_sprite(spr_ranks_hud, rind, 560, 460)
        }
    }
}


//logo
var logoSpr = _spr("logoscreen");

//logoTimer --
if (logoTimer < 0)
{
    logoAccelX = random_range(-0.05, 0.05);
    logoAccelY = random_range(-0.05, 0.05);
    logoTimer = 50;
}
logoSpdX += logoAccelX
logoSpdY += logoAccelY

//logoSpdX = clamp()

logoX += logoSpdX
logoY += logoSpdY;

var w = obj_screensizer.actual_width;
var h = obj_screensizer.actual_height;
draw_sprite_tiled(logoSpr, 0, logoX, 5 * dsin(current_time / 10) + logoY);
draw_set_font(global.editorfont);
draw_set_halign(fa_right);
draw_text(logoX + 900, 5 * dsin(current_time / 10) + logoY + 170, obj_modAssets.currentVersion)
//draw_sprite(logoSpr, 0, ((obj_screensizer.actual_width - sprite_get_width(logoSpr) - 20 + logoX) - w) % w, 20 + logoY);

draw_set_halign(fa_left);
draw_set_font(global.bigfont)

var editX = 400;
var editY = 500;
draw_text(editX, editY, "PRESS ");
scr_draw_text_arr(editX + 150, editY, taunt_key)


var targety = 110;
var jy = 36;

var yOffset = clamp(-(towerSelected - tOffset - 5), - (min(array_length(towerList) - tOffset, tPerPage) - 4 - 5), 0) * jy; 
targety += yOffset;

listScroll += (targety - listScroll) / 6;

var ly = listScroll;

draw_set_halign(fa_left);
draw_set_valign(fa_top)


var exInd = 0;
for (var i = 0; i < tPerPage + 2; i ++)
{
    var tInd = i + tPerPage * towerPage;
    if (towerSelected != tInd) draw_set_alpha(0.5);
    
    if (i < tPerPage and tInd < array_length(towerList))
    {
        var xoff = 0;
        if (!towerList[tInd][3])
        {
            var icn = towerImages[tInd][0];
            if (icn < 0) icn = _spr("towericon");
            draw_sprite(icn, 0, 6, ly + jy * i)
            xoff = 48;
        }
        draw_text(xoff, ly + jy * i, string_upper(towerList[tInd][0]));
        
    }
    else if (exInd < 2)
    {
        var txt = "CREATE NEW TOWER";
        if (exInd == 1)
        {
            txt = "BROWSE AND DOWNLOAD TOWERS";
        }
        draw_set_font(global.smallfont);
        draw_text(0, ly + jy * i + 10, txt);
        draw_set_font(global.bigfont);
        exInd ++;
    }
    draw_set_alpha(1)
}

var cpos = cursor_hud_position();

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
            case "levelList":
                // actio ns
                var vSep = 12;
                struct_set(c, [["scrollBorders", [0, array_length(levelList) * vSep - c.height]]])
                var hover = -1;
                if (isOn)
                {
                    hover = floor(onY / vSep)
                    if (hover != clamp(hover, 0, array_length(levelList) - 1) or array_length(levelList) == 0)
                    {
                        hover = -1;
                    }
                    if (onX > c.width - 24 and onY < 12)
                    {
                        hover = -2;
                    }
                    if (mouse_check_button_pressed(mb_left))
                    {
                        var goToEditor = false;
                        var lvl = "";
                        switchAssetFolder(string_replace(filename_dir(towerList[towerSelected][1]), general_folder(""), ""));
                        if (hover >= 0)
                        {
                            goToEditor = true;
                            lvl = levelList[hover][0];
                        }
                        if (hover == -2)
                        {
                            var newLevel = get_string("Input a folder name for the new level", "level_" + string(array_length(levelList)))
                            if (newLevel != "")
                            {
                                if (file_exists(mod_folder("levels/" + newLevel + "/level.ini")))
                                {
                                    show_message("a level folder with the name \"" + newLevel + "\" already exists.")
                                }
                                else
                                {
                                    goToEditor = true;
                                    lvl = newLevel;
                                }
                            }
                        }
                        if (goToEditor)
                        {
                            global.levelName = lvl
                            global.editorLevelName = lvl;
                            global.editorRoomName = "main";
                            global.currentRoom = "main";
                            
                            
                            
                            room_goto(rmEditor)
                        }
                    }
                }
                // drawing
                
                draw_sprite(_spr("ui_button"), 0, c.width - 24, 2);
                for (var j = 0; j < array_length(levelList); j ++)
                {
                    draw_set_color(c_ltgray);
                        
                    if (hover == j)
                        draw_set_color(c_white);
                    draw_text(2, j * vSep, levelList[j][0]);
                    draw_set_color(c_white);
                }
                
                surface_reset_target()
                
                draw_set_valign(fa_bottom)
                draw_set_font(global.smallfont);
                draw_text(c.x, c.y - 2, "LEVELS")
                draw_set_valign(fa_top)
                draw_set_font(global.editorfont);
                
                surface_set_target(c.surface);
            break;
            
            case "towerProperties":
                
                var t = towerSelected;
                var tTypes = ["Full tower", "Single level"]
                var opList = [
                    "Name: " + towerList[t][0],
                    "Main level: " + towerList[t][2],
                    "Type: " + tTypes[towerList[t][3]],
                    "",
                    "Open assets folder",
                    "Share this tower"
                ]
                
                if (opList[1] == "Main Level: ") opList[1] += "(not set)";
                struct_set(c, [
                    ["canExit", false],
                    ["optionDefault", ""],
                    ["optionList", opList]
                ])
                if (isOn)
                {
                    /*if (mouse_check_button_pressed(mb_left))
                    {
                        
                    }*/
                }
                
                surface_reset_target()
                
                draw_set_valign(fa_bottom)
                draw_set_font(global.smallfont);
                draw_text(c.x, c.y - 2, "PROPERTIES")
                draw_set_valign(fa_top)
                draw_set_font(global.editorfont);
                
                surface_set_target(c.surface);
            break;
            
            case "updateNotice":
                draw_set_halign(fa_center);
                draw_set_font(global.smallfont);
                var xx = c.width / 2
                draw_text(xx, 2, string_upper("an Update for the level\neditor mod is available!\n\n\n\n\n\nwanna check it out?"))
                draw_text(xx, c.height - 48, "YEAH!!       NAH")
                
                draw_set_font(global.editorfont);
                
                draw_text(xx, 48, "installed: " + obj_modAssets.currentVersion + "\nlatest: " + obj_modAssets.newestVersion);
                
                
                draw_set_halign(fa_left);
                
                if (isOn)
                {
                    if (mouse_check_button_pressed(mb_left) and onY > c.height / 2)
                    {
                        obj_modAssets.newestVersion = "";
                        if (onX < c.width / 2)
                        {
                            url_open(obj_modAssets.downloadLink);
                        }
                        wCanvas_close(c);
                    }
                }
            break;
            
            case "browserNotice":
                draw_set_halign(fa_center);
                draw_set_font(global.smallfont);
                var xx = c.width / 2
                draw_text(xx, 2, string_upper("A browser for\nTowers and Levels\nis now available in-game!"));
                draw_set_font(global.editorfont);
                
                draw_text(xx, c.height - 20, "close window");
                
                
                draw_set_halign(fa_left);
                
                if (isOn)
                {
                    if (mouse_check_button_pressed(mb_left) and onY > c.height / 2)
                    {
                        wCanvas_close(c);
                    }
                }
            break;
        }
        
        surface_reset_target();
        wCanvas_draw(c, 0.5)
        
        draw_set_font(global.bigfont);
    }
}

if key_quit2
{
    if (obj_music.music != noone)
        fmod_event_instance_play(obj_music.music.event);
    room_goto(Mainmenu);
}

draw_sprite(_spr("cursor"), 0, cpos[0], cpos[1])
