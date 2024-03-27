var result = ds_map_find_value(async_load, "result");
if (result == undefined or result == "")
{
    exit;
}

switch ds_map_find_value(async_load, "id")
{
    case getVersion:
        result = json_parse(result)
        result = result[0]
        if (variable_struct_exists(result, "message"))
        {
            if (result.message == "Not Found")
            {
                show_message("Repo isn't public yet")
                exit;
            }
        }
        //downloadLink = result.html_url;
        if (!array_value_exists(prevVersions, result.tag_name))
            newestVersion = result.tag_name;
    break;
    
    /*case getLevelList:
        result = json_parse(result)
        show_message(result)
        var m = result[0]
        var fileData = m._aFiles[0];
        //getLevelDownload = http_get_file(fileData._sDownloadUrl, game_save_id + "downloads/" + fileData._sFile);
    break;*/
    
    case getLevelDownload:
        if (ds_map_find_value(async_load, "status") == 0)
            show_message("finished!!");
        else if (ds_map_find_value(async_load, "status") < 0)
            show_message("error...")
    break;
}