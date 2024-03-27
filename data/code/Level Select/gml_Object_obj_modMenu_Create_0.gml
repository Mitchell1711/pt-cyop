with (obj_player)
    state = (18 << 0)

modRoom_init()

global.editingLevel = false;
global.editorLevelName = "";

windows_init();

customSong_destroy_all();
taunt_key = scr_compile_icon_text("[T] TO EDIT TOWER")
//show_message(taunt_key)

windows_add_canvas(200, 200, "towerProperties");
windows_add_canvas(100, 200, "levelList");
windows_add_canvas(100, 150, "levelDropdown");
windows_add_canvas(330, 200, "updateNotice");
windows_add_canvas(330, 100, "browserNotice");

musicID = fmod_event_create_instance("event:/music/pause");
fmod_event_instance_play(musicID)

if (obj_modAssets.currentVersion != obj_modAssets.newestVersion and obj_modAssets.newestVersion != "")
{
    var wc = w_canvas.updateNotice;
    wCanvas_open("updateNotice", (obj_screensizer.actual_width - wc.width) / 2, (obj_screensizer.actual_height - wc.height) / 2);
}

function towerWindowsUpdate(argument0) // if they should open = true
{
    wCanvas_close("towerProperties");
    wCanvas_close("levelList");
    wCanvas_close("levelDropdown");
    if (argument0)
    {
        var wc = w_canvas.levelList;
        var ll = wCanvas_open("levelList", obj_screensizer.actual_width - wc.width - 20, (obj_screensizer.actual_height - wc.height) / 2);
        
        wc = w_canvas.towerProperties;
        wCanvas_open_dropdown("towerProperties", ll.x - wc.width, (obj_screensizer.actual_height - wc.height) / 2, ["name: "], "", "towerProperty");
    }
}
//wCanvas_open("levelList", 0, 0);

function loadTowerList()
{
    towerFileList = find_files_recursive(general_folder(""), ".tower.ini", 1)
    towerList = [];
    towerImages = [];
    for (var i = 0; i < array_length(towerFileList); i ++)
    {
        ini_open(towerFileList[i])
        array_push(towerImages, [-1, -1]);
        array_push(towerList, [
            ini_read_string("properties", "name", "Tower " + string(i)),
            towerFileList[i],
            ini_read_string("properties", "mainlevel", ""),
            ini_read_real("properties", "type", 0),
            string_replace(string_replace(filename_path(towerFileList[i]), general_folder(""), ""), "/", ""),
        ])
        ini_close()
        
        updateTowerImages(i, i == global.towerSelected);
    }
}

function updateTowerImages(argument0, argument1) //towerIndex, load bg too?
{
    if (argument0 >= array_length(towerImages))
        return;
        
    if (towerImages[argument0][1] != -1)
        return;
    
    towerImages[argument0] = [-1, -1]
    var f = filename_path(towerList[argument0][1])
    var iconFile = f + "icon.png";
    var bgFile = f + "bg.png";
    if (file_exists(iconFile))
    {
        towerImages[argument0][0] = sprite_add(iconFile, 1, false, false, 0, 0);
    }
    
    if (argument1 != false)
    {
        if (file_exists(bgFile))
        {
            towerImages[argument0][1] = sprite_add(bgFile, 1, false, false, 0, 0);
        }
        else
        {
            towerImages[argument0][1] = -2; //to prevent trying to reload
        }
    }
}

function towerEdit(argument0, argument1, argument2) //tower index, property name, value
{
    ini_open(towerList[argument0][1]);
    if (is_string(argument2))
    {
        ini_write_string("properties", argument1, argument2)
    }
    else
    {
        ini_write_real("properties", argument1, argument2);
    }
    ini_close()
    loadTowerList()
}

function loadSavefile(argument0)
{
    stats = struct_new();
    if (argument0 >= array_length(towerList))
        return;
    
    global.currentsavefile = "/" + string_replace_all(string_replace_all(towerList[argument0][1], ".tower.ini", ""), "/", "") + "10"
    gamesave_async_load()
    
    //show_message(get_savefile_ini());
    
    var level = towerList[argument0][2];
    ini_open("saves/" + get_savefile_ini())
    stats.highscore = ini_read_real("Highscore", string(level), 0)
    //hats = ini_read_real("Hats", string(level), 0)
    stats.secret_count = ini_read_string("Secret", string(level), 0)
    stats.toppin = [];
    stats.toppin[0] = ini_read_real("Toppin", (string(level) + "1"), 0)
    stats.toppin[1] = ini_read_real("Toppin", (string(level) + "2"), 0)
    stats.toppin[2] = ini_read_real("Toppin", (string(level) + "3"), 0)
    stats.toppin[3] = ini_read_real("Toppin", (string(level) + "4"), 0)
    stats.toppin[4] = ini_read_real("Toppin", (string(level) + "5"), 0)
    stats.rank = ini_read_string("Ranks", string(level), "")
    var s = ini_close()
    //show_message(s);
    //show_message(stats)
}

levelList = [];
function loadLevelList(argument0) //tower name
{
    levelList = [];
    var dir = general_folder(argument0 + "/levels/");
    levelFiles = find_files_recursive(dir, ".ini");
    for (var i = 0; i < array_length(levelFiles); i ++)
    {
        array_push(levelList, [string_replace(string_replace(filename_path(levelFiles[i]), dir, ""), "/", ""), levelFiles[i]])
    }
    return(levelList)
}
towerImages = []; //images[n][0] = icon, images[n][1] = bg
loadTowerList();

listScroll = 0;
menuLock = false;

logoX = 0;
logoY = 0;
logoAccelX = 0;
logoAccelY = 0;
logoSpdX = 0;
logoSpdY = 0;
logoTimer = 3600;

seenTitlecard = false;

towerSelected = global.towerSelected;
towerPage = 0;

toppinSuffix = ["", "", "", "", ""];
alarm[1] = 1;
stats = struct_new();
loadSavefile(towerSelected)

lastFocus = window_has_focus();

//browser notice shits
ini_open("editorSave.ini")
if (!ini_read_real("modMenu", "browserCheck", 0))
{   
    if (global.justUpdated)
    {
        var wc = w_canvas.browserNotice;
        wCanvas_open("browserNotice", (obj_screensizer.actual_width - wc.width) / 2, (obj_screensizer.actual_height - wc.height) / 2);
        towerSelected = array_length(towerList) + 1;
    }
}
ini_write_real("modMenu", "browserCheck", 1)
ini_close();
/*with ins
{
    show_message(object_get_name(ins.object_index));
    tbrowser_requestList(0, 0);
}*/
