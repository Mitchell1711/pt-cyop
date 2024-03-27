var result = ds_map_find_value(async_load, "result")
var req = ds_map_find_value(async_load, "id");

if (result != undefined and result != "")
{   
    /*if (result != undefined)
    {
        var temp = json_parse(result)
        if (array_length(temp) == 0)
        {
            //noResults = true;
            exit;
        }
    }*/
    switch req
    {
        case reqTowerList:
            tbrowser_recieveList(json_parse(result));
            if (array_length(towers) == 0)
            {
                if (towerPage > 1)
                {
                    towerPage --;
                    tbrowser_requestList();
                }
                else
                {
                    noResults = true;
                }
            }
        break;
    }
}

var rm = [];
var imgs = variable_struct_get_names(reqImage)
for (var i = 0; i < array_length(imgs); i ++)
{
    if (string(req) == imgs[i])
    {
        if (ds_map_find_value(async_load, "status") == 0)
        {
            tbrowser_recieveImage(result, real(imgs[i]))
        }
    }
}

var dls = variable_struct_get_names(reqDownload)
for (var i = 0; i < array_length(dls); i ++)
{
    if (string(req) == dls[i])
    {
        if (ds_map_find_value(async_load, "status") == 0)
        {
            tbrowser_recieveDownload(result, real(dls[i]))
        }
        else if ds_map_find_value(async_load, "status") == 1
        {
            var t = struct_get(reqDownload, dls[i])
            t.downloadProgress = ds_map_find_value(async_load, "sizeDownloaded") / ds_map_find_value(async_load, "contentLength");
        }
    }
}