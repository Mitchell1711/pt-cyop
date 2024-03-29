//load asset folder
currentVersion = "noise-port";
newestVersion = "";
downloadLink = "https://gamebanana.com/mods/443629";

prevVersions = ["beta-1", "beta-2", "beta-2.1", "beta-3", "beta-3.5", "halloween-port", "final-port"]

global.justUpdated = false;
var noob = !file_exists("version");

ini_open("version")
var v = ini_read_string("data", "version", "");

if (v != currentVersion or !directory_exists(game_save_id + "editor_assets") or !file_exists(game_save_id + "editor_assets/objects.json"))
{
    //show_message_async("Extracting mod assets, this may take a while...")
    var q = show_question("Hey! \"Create Your Own Pizza\" mod assets might need to be extracted, which may take a while. This will only happen the first time you open the mod/after an update.\n\nPress Yes to continue")
    if(q){
        if (!noob)
        {
            global.justUpdated = true;
        }
        if (!q)
        {
            //game_end();
        }
        if (directory_exists("editor_assets"))
        {
            var prevEditorFiles = find_files_recursive("editor_assets/", "");
            repeat array_length(prevEditorFiles)
            {
                file_delete(array_pop(prevEditorFiles));
            }
            directory_destroy("editor_assets")
        }

        var wins = find_files_recursive(program_directory, ".win", 2);
        
        
        var hFound = false;
        for (var i = 0; i < array_length(wins) and !hFound; i ++)
        {
            //show_message("aw")
            var b = buffer_load(wins[i])
            buffer_seek(b, buffer_seek_start, 0);
            buffer_seek(b, buffer_seek_start, 0x0537AA8E)//87446308)
            //show_message("hell")
            
            var head = 0;
            var hFail = false;
            
            if (buffer_get_size(b) < 87446308)
            {
                hFail = true;
            }
            while (!hFound and !hFail)
            {
                if (buffer_tell(b) >= buffer_get_size(b) - 7000000)
                {
                    hFail = true;
                }
                else
                {
                    var num = buffer_read(b, buffer_u8)
                    var check = 10000 * head + num
                    switch check
                    {
                        case 00122: //z
                        case 10105: //i
                        case 20112: //p
                        case 30104: //h
                        case 40101: //e
                        case 50097: //a
                        case 60100: //d
                        case 70101: //e
                        case 80114: //r
                            head ++;
                        break;
                        case 90053: //5
                            hFound = true;
                        break;
                        default:
                            head = 0
                        break;
                    }
                }
            }
            if (hFound)
            {
                var newB = buffer_create(900000, buffer_grow, 1)
                repeat(buffer_get_size(b) - buffer_tell(b))
                {
                    buffer_write(newB, buffer_u8, buffer_read(b, buffer_u8))
                }
                buffer_save(newB, "editor_assets.ccc");
                buffer_delete(newB);
            }
            buffer_delete(b);
            //show_message("na")
        }
        //buffer_write(newB, buffer_text, buffer_read(b, buffer_text))
        /*
        repeat buffer_get_size(b)
        {
            var retPos = buffer_tell(b);
            var k = [];
            repeat 10
                array_push(k, buffer_read(b, buffer_u8));
            if (k[0] == 122 and k[1] == 105 and k[2] == 112 and k[3] == 104)
                show_message("found it bitch")
                
            buffer_seek(b, buffer_seek_start, retPos + 1);
        }*/
        if (hFound)
        {
            zip_unzip("editor_assets.ccc", game_save_id);
            file_delete("editor_assets.ccc");
            
            directory_create("towers");
            var defTowerFiles = find_files_recursive("editor_assets/defaultTowers/", "")
            
            for (var i = 0; i < array_length(defTowerFiles); i ++)
            {
                file_copy(defTowerFiles[i], string_replace(defTowerFiles[i], "editor_assets/defaultTowers", "towers"));
            }
        }
        
        
    }
    else{
        show_message("Stopped extracting mod assets, in case of any issues the mod assets can be manually updated in \"AppData/Roaming/PizzaTower_GM2\"")
    }
    ini_write_string("data", "version", currentVersion)
}
ini_close();
if (!directory_exists("editor_assets") or !file_exists("editor_assets/objects.json"))
{
    show_message("editor_assets folder is missing from appdata, or data was not extracted successfully. Try re-installing the mod and opening the game again.")
    game_end();
    exit;
}
//////


global.sprites = ds_map_create();
global.tilesets = ds_map_create();
global.audio = ds_map_create();
global.bgpresets = ds_map_create();

global.sprite_names = [];
global.tileset_names = [];
global.audio_names = [];
global.bgpreset_names = [];

global.default_sprites = [];
global.default_tilesets = [];
global.default_audio = [];
global.default_bgpresets = [];

global.modFolder = "newTower"
//this shouldnt be here but i dont care
global.charSelected = 0

function general_folder(argument0)
{
    return("towers/" + argument0)
}

function mod_folder(argument0)
{
    return(general_folder(global.modFolder + "/" + argument0))
}

function editor_folder(argument0)
{
    return("editor_assets/" + argument0)
}

global.roomData = undefined;
global.levelName = "test";
global.editorRoomName = "main";
global.hubLevel = "";
global.currentRoom = "main";
global.currentLevel = global.levelName;
global.fromEditor = false;
global.fromMenu = false;
global.editorMemory = struct_new();
global.towerSelected = 0;

global.editingLevel = false;
global.editorLevelName = "";

global.surfaceDestroyer = [];
global.surfaceRoomEnd = [];

global.secretRoomFix = ["main", 0] // yeah

global.objectData = json_parse(file_text_read_all(editor_folder("objects.json")));
//object ids got shuffled around with the new update
global.objectMap = json_parse(file_text_read_all(editor_folder("objectCompatibility.json")))

if (!variable_struct_exists(global.objectData, "variableTypes"))
{
    struct_set(global.objectData, [["variableTypes", struct_new(
        ["levelName", "lvl"],
        ["level", "lvl"],
        ["targetRoom", "room"]
    )]])
    //show_message("ERROR: The modified objects.json file in your editor_assets folder does not contain the \"variableTypes\" definition. Either use the default one or add the default variableTypes category to your objects.json.")
    //game_end();
}

levelMemory_reset();

global.editorfont = -1;

function modAssets_extractTowers()
{
    var zips = find_files_recursive(general_folder(""), ".zip", 1)
    //show_message(zips)
    
    for (var i = 0; i < array_length(zips); i ++)
    {
        zip_unzip(zips[i], general_folder(""));
        file_delete(zips[i]);
    }
}

modAssets_extractTowers();

getVersion = http_get("https://api.github.com/repos/GithubSPerez/pt-new-level-editor/releases");

getLevelDownload = -1;

/*
var folder = editor_folder("sprites/");

var sprFiles = find_files_recursive(folder, ".png");

for (var i = 0; i < array_length(sprFiles); i ++)
{
    ass_loadSprite(sprFiles[i], folder)
}

folder = editor_folder("audio/");

var audioFiles = find_files_recursive(folder, ".ogg");
for (var i = 0; i < array_length(audioFiles); i ++)
{
    ass_loadAudio(audioFiles[i], folder);
}
*/
depth = -1000

global.defaultTilesets = [];
global.defaultSongs = struct_new();
global.defaultSong_names = [];
global.defaultSong_display = struct_new();

global.tilesetData = struct_new();
global.loadedTileSprite = undefined
global.loadedTile = undefined

function switchAssetFolder(argument0)
{
    global.modFolder = argument0;
    ass_unloadAssets();
    if (font_exists(global.editorfont))
    {
        font_delete(global.editorfont)
    }
    
    if (argument0 != "")
    {
        ass_loadFolderAssets(mod_folder(""));
    }
    
    global.tilesetData = json_parse(file_text_read_all(editor_folder("tilesets.json")));
    var defaultTiles = [];
    var defFolderNames = variable_struct_get_names(global.tilesetData.folders)
    for (var i = 0; i < array_length(defFolderNames); i ++)
    {
        var f = struct_get(global.tilesetData.folders, defFolderNames[i])
        for (var j = 0; j < array_length(f); j ++)
        {
            array_push(defaultTiles, f[j])
        }
    }
    if (array_length(global.tileset_names) > 0)
    {
        global.tilesetData.order = array_concat(["custom"], global.tilesetData.order)
        struct_set(global.tilesetData.folders, [["custom", array_duplicate(global.tileset_names)]])
    }
    
    ass_loadFolderAssets(editor_folder(""), true);
    //var defaultTiles = SplitString(string_replace_all(file_text_read_all(editor_folder("tilesets.txt")), "\r", ""), "\n");
    global.defaultTilesets = defaultTiles;
    
    
    for (var i = 0; i < array_length(defaultTiles); i ++)
    {
        ass_addTileset(defaultTiles[i], 32, 1, ass_getAutotileList(editor_folder("autotile/" + defaultTiles[i]), false));
    }
    
    global.defaultSongs = struct_new();
    global.defaultSong_names = [];
    global.defaultSong_display = struct_new();
    
    var jt = file_text_read_all(editor_folder("songs.json"))
    var songData = json_parse(jt);
    
    for (var i = 0; i < array_length(songData); i ++)
    {
        if (songData[i][0] != "")
        {
            struct_set(global.defaultSongs, [[songData[i][0], songData[i][1]]])
            struct_set(global.defaultSong_display, [[songData[i][1], songData[i][0]]])
        }
        array_push(global.defaultSong_names, songData[i][0]);
    }
    
    //show_message(global.defaultSong_names)
    
    //defautls
    global.editorfont = font_add_sprite_ext(_spr("smallfont"), "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789?!.:-<>()_{},[]/\"´¨", false, -1)
    /* object_set_sprite(obj_sprite, _spr("sprite_preview"))
    object_set_sprite(obj_camera_region, _spr("z_oldeditor/spr_camera"))
    object_set_sprite(obj_warp_number, _spr("warp_number"))
    object_set_sprite(obj_destroyable3_escape, _spr("z_oldeditor/escape_destroyable3")) */
}
switchAssetFolder("");

instance_create(x, y, obj_customAudio);

lpstate = 0;
saveNotice = 0;

