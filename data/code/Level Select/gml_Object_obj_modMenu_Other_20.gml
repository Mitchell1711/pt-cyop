var ev = w_eventCallback
var cpos = cursor_hud_position();
switch ev.name
{
    case "mainLevelSelected":
        towerEdit(towerSelected, "mainlevel", ev.data[0]);
        wCanvas_close(ev.canvasStruct);
    break;
    case "towerProperty":
        switch (ev.data[1])
        {
            case 0:
                var newName = ask_or_not("Input a new name for this tower:", towerList[towerSelected][0])
                towerEdit(towerSelected, "name", newName)
            break;
            case 1:
                var lvlNames = [];
                for (var j = 0; j < array_length(levelList); j ++)
                {
                    array_push(lvlNames, levelList[j][0]);
                }
                wCanvas_open_dropdown("levelDropdown", cpos[0], cpos[1], lvlNames, "test", "mainLevelSelected");
            break;
            case 2:
                towerEdit(towerSelected, "type", (towerList[towerSelected][3] + 1) % 2);
            break;
            case 4:
                get_open_filename_ext("go open this folder on file explorer lol|*.txt", "you can copy the path now", game_save_id + string_replace_all(filename_path(towerList[towerSelected][1]), "/", "\\"), "(there was no way of coding a file explorer window to appear)");
            break;
            case 5:
                var copyIt = show_message("To share a tower, you can zip its folder and then upload it to gamebanana or send it wherever you want. you can find it on AppData/Roaming/PizzaTower_GM2/" + filename_path(towerList[towerSelected][1]) + " (you can also check out this path by opening the assets folder)")
                
                if false//(copyIt)
                {
                    //show_message(string_replace(filename_path(towerList[towerSelected][1]), general_folder(""), ""))
                    show_message(towerList[towerSelected][4])
                    var f = "share_tower"
                    if (f != "")
                    {
                        directory_create(f);
                        ini_open(f + "\\" + "shit.ini")
                        show_message(f + "\\" + "shit.ini")
                        ini_write_real("s", "s", 0);
                        ini_close();
                        show_message(f);
                        var tFolder = filename_path(towerList[towerSelected][1]);
                        var fs = find_files_recursive(tFolder, "");
                        for (var i = 0; i < array_length(fs); i ++)
                        {
                            file_copy(fs[i], string_replace(string_replace(fs[i], tFolder, f + "/"), "/", "\\"))
                            
                        }
                        show_message("done?");
                    }
                }
                
            break;
        }
    break;
}