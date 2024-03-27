var ev = w_eventCallback;
var c = ev.canvasStruct;
switch ev.name
{
    case "varValueSelected":
        
        
        _stSet("data.instances[" + string(c.instID) + "].variables." + c.varName, ev.data[0]);
        var insData = _stGet("data.instances[" + string(c.instID) + "]");
        wCanvas_close(c);
        instance_update_variables(c.instance, insData);
    break;
    
    case "tilesetModeChanged":
        tileset_doAutoTile = ev.data[1]
        tileset_autotileIndex = 0;
        
        editorWindowUpdate();
        /*wCanvas_close("autotileInd")
        if (tileset_doAutoTile)
        {
            var tmodeDD = w_openCanvas[w_findCanvasIndex("tilesetMode")]
            var nd = wCanvas_open_dropdown("autotileInd", tmodeDD.x + tmodeDD.width, tmodeDD.y, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], tileset_autotileIndex, "autotileIndexChanged");
            struct_set(nd, [["canExit", false]])
        }*/
    break;
    
    case "autotileIndexChanged":
        tileset_autotileIndex = ev.data[1];
    break;
    
    case "bgPresetSelected":
        var q = show_question("By loading this preset, all the background things you've added to this room will get replaced. continue? (you can undo this by pressing ctrl+z)")
        if (q)
        {
            prevBGPreset = ev.data[0];
            struct_set(data, [["backgrounds", _bgpreset(ev.data[0])]])
            wCanvas_close("bgPresetDropdown")
            data = data_compatibility(data);
            initStage(data)
        }
    break;
    
    case "titlecardSprite":
    case "titleSprite":
    case "titleSong":
        _stSet("levelSettings." + ev.name, ev.data[0]);
        wCanvas_close(c);
    break;
    
    case "bgImageSelected":
        var txt = fstring("{bgString}.sprite");
        _stSet(txt, ev.data[0])
        wCanvas_close(c);
    break;
    
    case "songSelected":
        var prop = data.properties;
        var s = ev.data[0];
        
        if (variable_struct_exists(global.defaultSongs, s))
        {
            s = struct_get(global.defaultSongs, s)
        }
        
        prop.song = s;
        wCanvas_close(c);
    break;
}