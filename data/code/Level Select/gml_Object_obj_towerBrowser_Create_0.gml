towers = [];
towerPage = 1;
towerFilter = 0;
towerSearch = undefined;

noResults = false;

tHover = 0;

wips = false;

imageCleanup = [];
windows_init()

w_scale = 2;

showOldCustom = false;



windows_add_canvas(600, 480, "towerList", [0, 0]);
struct_set(w_canvas.towerList, [["surfaceScale", 0.5]]);
windows_add_canvas(600, 32, "bar", [0, 0]);
windows_add_canvas(328, 32, "close", [0, 0]);
windows_add_canvas(328, 340, "tower", [0, 0]);
struct_set(w_canvas.tower, [["surfaceScale", 0.5]]);
windows_add_canvas(328, 139, "towerDescription", [0, 0]);

reqImage = struct_new();
var tl = wCanvas_open("towerList", 16, 16, [0, 0]);
wCanvas_open("bar", tl.x, tl.y + tl.height, [0, 0]);
var t = wCanvas_open("tower", tl.x + tl.width + 1, tl.y, [0, 0]);
wCanvas_open("towerDescription", t.x, t.y + t.height + 1, [0, 0]);
wCanvas_open("close", t.x, tl.y + tl.height, [0, 0]);

reqDownload = struct_new();

towerSelected = noone;
bullshitCooldown = 0;

incompatible = [];

lcpos = cursor_hud_position();




//show_message("about to send some request...")
tbrowser_requestList();


//reqTowerList = -1;

// NO PONER MAS CODIGO ABAJO DE ESTO NO FUNCTIONA POR ALGUNA PUTA RAZON (ya no 

function tbrowser_addTower() //gamebanana data
{
    var d = argument0;
    var a = d._aSubmitter;
    var p = d._aPreviewMedia;
    
    var downloadLink = "";
    var files = d._aFiles;
    var time = 0;
    var canDownload = false;
    var fileName = "";
    for (var i = 0; i < array_length(files); i ++)
    {
        var f = files[i];
        if (f._tsDateAdded > time)
        {
            time = f._tsDateAdded;
            downloadLink = f._sDownloadUrl;
            fileName = f._sFile;
            canDownload = (string_pos(".zip", fileName) != 0);
        }
    }
    var t = struct_new([
        ["name", d._sName],
        ["modId", array_pop(SplitString(d._sProfileUrl, "/"))],
        ["creator", a._sName],
        ["tagline", d._sDescription],
        ["description", d._sText],
        ["pageLink", d._sProfileUrl],
        ["downloadLink", downloadLink],
        ["dateAdded", time],
        ["imageLink", p[0]._sBaseUrl + "/" + p[0]._sFile],
        ["canDownload", canDownload],
        ["fileName", fileName],
        ["downloadCount", d._nDownloadCount],
        ["likeCount", d._nLikeCount],
        ["image", undefined],
        
        ["locked", false],
        ["status", 0],
        ["downloadProgress", -1]
    ]);
    
    if (array_value_exists(incompatible, t.modId))
    {
        t.canDownload = false;
        t.status = 3;
    }
    
    var statusFile = general_folder(t.modId + "/download");
    if (file_exists(statusFile))
    {
        t.status = 1;
        var stat = buffer_load(statusFile);
        var lastDate = buffer_read(stat, buffer_u64)
        
        if (time > lastDate)
        {
            t.status = 2;
        }
    }
    //show_message(t);
    array_push(towers, t);
    return(t);
}

function tbrowser_removeTower() //index
{
    array_delete(towers, argument0, 1);
}

function tbrowser_towerNames()
{
    var n = [];
    for (var i = 0; i < array_length(towers); i ++)
    {
        array_push(n, towers[i].name);
    }
    return(n);
}

function tbrowser_requestList() //page, filter, searchterm
{
    noResults = false;
    towerSelected = noone;
    while (array_length(towers) > 0)
    {
        tbrowser_removeTower(0);
    }
    tbrowser_cleanup();
    reqTowerList = http_get(levelsUrl(towerPage, wips * 2, towerFilter, 10, showOldCustom, towerSearch))
}

function tbrowser_recieveList() //result array of levels
{
    var l = argument0
    for (var i = 0; i < array_length(l); i ++)
    {
        var t = tbrowser_addTower(l[i]);
        tbrowser_requestImage(t);
    }
}

function tbrowser_requestImage() //tower
{
    var t = argument0;
    var r = http_get_file(t.imageLink, "downloads/images/" + t.modId + ".png")
    struct_set(reqImage, [[string(r), t]]);
    return(r);
}

function tbrowser_recieveImage() //result, request index
{
    var t = struct_get(reqImage, string(argument1))
    variable_struct_remove(reqImage, string(argument1))
    t.image = sprite_add(argument0, 1, false, false, 0, 0);
    array_push(imageCleanup, t.image);
}

function tbrowser_requestDownload() //tower
{
    var t = argument0;
    var dl = t.downloadLink;
    var r = http_get_file(dl, "downloads/towers/" + t.modId + ".zip")
    t.downloadProgress = 0;
    struct_set(reqDownload, [[string(r), t]]);
}

function tbrowser_recieveDownload() //result, request index
{
    var f = argument0;
    var t = struct_get(reqDownload, string(argument1));
    var targetDir = general_folder(t.modId) + "/";
    var tempDir = "downloads/towers/" + t.modId + "TEMP/";
    zip_unzip(f, tempDir)
    
    var ct = current_time;
    var testF = find_files_recursive(tempDir, ".tower.ini", 0);
    
    var success = false;
    
    if (array_length(testF) > 0)
    {
        zip_unzip(f, targetDir)
        success = true;
        var allFiles = find_files_recursive(tempDir, "");
        for (var i = 0; i < array_length(allFiles); i ++)
        {
            var fName = allFiles[i];
            file_delete(fName);
        }
    }
    else
    {
        var testF = find_files_recursive(tempDir, ".tower.ini", 1);
        if (array_length(testF) == 0)
        {
            var lvlF = find_files_recursive(tempDir, ".ptlv", 1);
            if (array_length(lvlF) != 0)
            {
                show_message("The level \"" + t.name + "\" was made using the old level editor, but compatibility is not implemented yet. Compatibility with old levels will be implemented on a future update.");
            }
            else
            {
                show_message("The level mod \"" + t.name + "\" is not compatible with CYOP.\nYou can visit its page to download it as a stand-alone mod.")
            }
            array_push(incompatible, t.modId);
            t.status = 3;
            t.canDownload = false;
        }
        else
        {
            success = true;
            var allFiles = find_files_recursive(tempDir, "");
            var parentDir = filename_dir(testF[0]) + "/";
            //show_message(parentDir)
            for (var i = 0; i < array_length(allFiles); i ++)
            {
                var fName = allFiles[i];
                var destName = string_replace(fName, parentDir, targetDir);
                file_delete(destName);
                file_copy(fName, destName);
                file_delete(fName);
            }
            
        }
    }
    directory_destroy(tempDir);
    file_delete(f);
    
    if (success)
    {
        var b = buffer_create(8, buffer_fixed, 1);
        buffer_write(b, buffer_u64, t.dateAdded);
        buffer_save(b, targetDir + "download");
        buffer_delete(b);
        
        t.status = 1;
    }
    
    t.downloadProgress = -1;
    
    with (obj_modMenu)
    {
        loadTowerList();
    }
    
    //show_message(string(current_time - ct));
    //show_message();
    variable_struct_remove(reqDownload, string(argument1))
}


function tbrowser_cleanup()
{
    while (array_length(imageCleanup) > 0)
    {
        var s = array_pop(imageCleanup);
        if (sprite_exists(s))
            sprite_delete(s);
    }
    var del = find_files_recursive("downloads/", "");
    for (var i = 0; i < array_length(del); i ++)
    {
        file_delete(del[i]);
    }
}