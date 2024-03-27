

function autotile_new()
{
    var atData = []
    for (var i = 0; i < 10; i ++)
    {
        atData[i] = [];
        for (var j = 0; j < 5; j ++)
        {
            atData[i][j] = [i, j];
        }
    }
    return(atData)
}
function autotile_save(argument0, argument1) //autotile data, save file
{
    var atData = argument0;
    var buff = buffer_create(100, buffer_fast, 1)
    for (var i = 0; i < 10; i ++)
    {
        for (var j = 0; j < 5; j ++)
        {
            var atdCoord = atData[i][j];
            buffer_write(buff, buffer_u8, atdCoord[0]);
            buffer_write(buff, buffer_u8, atdCoord[1]);
        }
    }
    buffer_save(buff, argument1)
}

function autotile_load(argument0) //file
{
    var aData = [];
    if (!file_exists(argument0))
    {
        return autotile_new();
    }
    var buff = buffer_load(argument0)
    for (var i = 0; i < 10; i ++)
    {
        aData[i] = [];
        for (var j = 0; j < 5; j ++)
        {
            var xCoord = buffer_read(buff, buffer_u8);
            var yCoord = buffer_read(buff, buffer_u8);
            aData[i][j] = [xCoord, yCoord];
        }
    }
    return(aData);
}

function at_collCheck(argument0, argument1, argument2) //coord array, x relative, y relative
{
    return(argument0[argument1 + 2][argument2 + 2])
}

function autotile_vars()
{
    at_outRules = [
        [ //0
            [2, 0, 2],
            [0, 1, 1],
            [2, 1, 2]
        ],
        [ //1
            [2, 0, 2],
            [1, 1, 1],
            [2, 1, 2]
        ],
        [ //2
            [2, 0, 2],
            [1, 1, 0],
            [2, 1, 2]
        ],
        [ //3
            [2, 1, 2],
            [0, 1, 1],
            [2, 1, 2]
        ],
        [ //4
            [1, 1, 1],
            [1, 1, 1],
            [1, 1, 1]
        ],
        [ //5
            [2, 1, 2],
            [1, 1, 0],
            [2, 1, 2]
        ],
        [ //6
            [2, 1, 2],
            [0, 1, 1],
            [2, 0, 2]
        ],
        [ //7
            [2, 1, 2],
            [1, 1, 1],
            [2, 0, 2]
        ],
        [ //8
            [2, 1, 2],
            [1, 1, 0],
            [2, 0, 2]
        ],
        
        //inside corners
        [ //9
            [2, 1, 2],
            [1, 1, 1],
            [2, 1, 0]
        ],
        [ //10
            [2, 1, 2],
            [1, 1, 1],
            [0, 1, 2]
        ],
        [ //11
            [2, 1, 0],
            [1, 1, 1],
            [2, 1, 2]
        ],
        [ //12
            [0, 1, 2],
            [1, 1, 1],
            [2, 1, 2]
        ],
    ]
    
    at_inRules = [
        [ // 0
            [2, 2, 2, 2, 2],
            [2, 1, 1, 1, 1],
            [2, 1, 1, 1, 1],
            [2, 1, 1, 1, 1],
            [2, 1, 1, 1, 1],
        ],
        [ // 1
            [0, 0, 0, 0, 0],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
        ],
        [ // 2
            [2, 2, 2, 2, 2],
            [1, 1, 1, 1, 2],
            [1, 1, 1, 1, 2],
            [1, 1, 1, 1, 2],
            [1, 1, 1, 1, 2],
        ],
        [ // 3
            [0, 1, 1, 1, 1],
            [0, 1, 1, 1, 1],
            [0, 1, 1, 1, 1],
            [0, 1, 1, 1, 1],
            [0, 1, 1, 1, 1],
        ],
        [ // 4
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
        ],
        [ // 5
            [1, 1, 1, 1, 0],
            [1, 1, 1, 1, 0],
            [1, 1, 1, 1, 0],
            [1, 1, 1, 1, 0],
            [1, 1, 1, 1, 0],
        ],
        [ // 6
            [2, 1, 1, 1, 1],
            [2, 1, 1, 1, 1],
            [2, 1, 1, 1, 1],
            [2, 1, 1, 1, 1],
            [2, 2, 2, 2, 2],
        ],
        [ // 7
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [0, 0, 0, 0, 0],
        ],
        [ // 8
            [1, 1, 1, 1, 2],
            [1, 1, 1, 1, 2],
            [1, 1, 1, 1, 2],
            [1, 1, 1, 1, 2],
            [2, 2, 2, 2, 2],
        ],
    ]
}

function autotile_getCollArray(argument0, argument1, argument2, argument3) //tilemap, tile x, tile y, square side length
{
    var halfSide = floor(argument3 / 2);
    var coll = [];
    for (var i = 0; i < argument3; i ++)
    {
        coll[i] = []
        for (var j = 0; j < argument3; j ++)
        {
            coll[i][j] = false;
            var xCheck = int64(argument1 + (i - halfSide) * 32);
            var yCheck = int64(argument2 + (j - halfSide) * 32);
            var tString = string(xCheck) + "_" + string(yCheck);
            if (variable_struct_exists(argument0, tString))
            {
                var tile = struct_get(argument0, tString);
                if (tile.tileset == tilesetSelected)
                {
                    var sameInd = true;
                    if (variable_struct_exists(tile, "autotile_index") and variable_struct_exists(tile, "autotile"))
                    {
                        if (tile.autotile and tile.autotile_index != tileset_autotileIndex)
                        {
                            sameInd = false
                        }
                    }
                    coll[i][j] = sameInd;
                }
            }
            var dat = obj_rmEditor.data;
            var prop = dat.properties;
            if (xCheck < prop.roomX or xCheck >= prop.levelWidth or yCheck < prop.roomY or yCheck >= prop.levelHeight)
            {
                coll[i][j] = true;
            }
        }
    }
    return coll
}

function autotile_isInside(argument0) //collision  array 5x5
{
    autotile_vars();
    
    var coll = argument0
    
    for (var i = 0; i < array_length(at_inRules); i ++)
    {
        var success = true;
        for (var tx = 0; tx < 5 and success; tx ++)
        {
            for (var ty = 0; ty < 5 and success; ty ++)
            {
                var arr = at_inRules[i][ty];
                if (coll[tx][ty] != arr[tx] and arr[tx] != 2) //theyre flipped yeah
                {
                    success = false;
                }
            }
        }
        if (success)
        {
            return(true);
        }
    }
    return(false);
}

function autotile_getCoords(argument0, argument1, argument2, argument3, argument4) //tilemap, tile x, tile y, autotile struct, isInside array
{
    autotile_vars();

    var result = [0, 0]
    var coll = autotile_getCollArray(argument0, argument1, argument2, 5);
    var bigColl = autotile_getCollArray(argument0, argument1, argument2, 7);
    var xx = argument1;
    var yy = argument2;
    
    if (argument3 == undefined)
        argument3 = autotile_new();
    
    
    var foundInd = -1;
    var onInside = false;
    
    for (var i = 0; i < array_length(at_outRules) and foundInd == -1; i ++)
    {
        var success = true;
        for (var tx = 0; tx < 3 and success; tx ++)
        {
            for (var ty = 0; ty < 3 and success; ty ++)
            {
                var arr = at_outRules[i][ty];
                if (coll[tx + 1][ty + 1] != arr[tx] and arr[tx] != 2) //theyre flipped yeah
                {
                    success = false;
                }
            }
        }
        if (success)
        {
            foundInd = i;
        }
    }
    
    if (foundInd == -1)
    {
        return(argument3[7][2])
    }
    
    if (foundInd == 4)
    {
        onInside = autotile_isInside(coll);
        
        if (onInside)
        {
            
            var inColl = [
                [0, 0, 0],
                [0, 1, 0],
                [0, 0, 0],
            ]
            inColl = argument4
            //show_message(inColl);
            /*
            
            for (var z = 0; z < 3; z ++)
            {
                for (var f = 0; f < 3; f ++)
                {
                    for (var i = 0; i < array_length(at_inRules) and !inColl[z][f]; i ++)
                    {
                        var success = true;
                        for (var tx = 0; tx < 5 and success; tx ++)
                        {
                            for (var ty = 0; ty < 5 and success; ty ++)
                            {
                                var arr = at_inRules[i][ty];
                                if (bigColl[tx + z][ty + f] != arr[tx] and arr[tx] != 2) //theyre flipped yeah
                                {
                                    success = false;
                                }
                            }
                        }
                        if (success)
                        {
                            inColl[z][f] = 1;
                        }
                    }
                }
            }
            */
            
            var foundit = false;
            for (var i = 0; i < array_length(at_outRules) and !foundit; i ++)
            {
                var success = true;
                for (var tx = 0; tx < 3 and success; tx ++)
                {
                    for (var ty = 0; ty < 3 and success; ty ++)
                    {
                        var arr = at_outRules[i][ty];
                        if (inColl[tx][ty] != arr[tx] and arr[tx] != 2) //theyre flipped yeah
                        {
                            success = false;
                        }
                    }
                }
                if (success)
                {
                    foundInd = i;
                    foundit = true;
                }
            }
        }
    }
    
    if (onInside and foundInd == -1)
    {
        onInside = false;
        foundInd = 4; //lol
    }
    
    var r = irandom_range(1, 3);
    var resultList = []
    if (!onInside)
    {
        resultList = [
            [0, 0],
            [r, 0],
            [4, 0],
            [0, r],
            [7, 2],
            [4, r],
            [0, 4],
            [r, 4],
            [4, 4],
            
            [6, 1],
            [8, 1],
            [6, 3],
            [8, 3],
        ]
    }
    else
    {
        resultList = [
            [1, 1],
            [2, 1],
            [3, 1],
            [1, 2],
            [2, 2],
            [3, 2],
            [1, 3],
            [2, 3],
            [3, 3],
            
            [5, 0],
            [9, 0],
            [5, 4],
            [9, 4],
        ]
        /*
        resultList = [
            [2, 2],
            [1, 1],
            [1, 1],
            [1, 1],
            
            [2, 1],
            [2, 1],
            [2, 1],
            
            [3, 1],
            
            [1, 2],
            [1, 2],
            [1, 2],
            
            [2, 2],
            [3, 2],
            [1, 3],
            [2, 3],
            [3, 3],
            
            
            [5, 0],
            [9, 0],
            [5, 4],
            [9, 4],
            
            [2, 2],
        ]*/
    }
    /*
    var collString = ""
    for (var j = 0; j < 5; j ++)
    {
        for (var i = 0; i < 5; i ++)
        {
            collString += string(coll[i][j])
        }
        collString += "\n"
    }
    var resultStr = ""
    for (var i = 0; i < 3; i ++)
    {
        for (var j = 0; j < 3; j ++)
        {
            var arr = at_outRules[foundInd]
            resultStr += string(coll[i][j])
        }
        resultStr += "\n"
    }
    show_message(collString + "\n\n" + resultStr)
    */
    //show_message(result)
    
    result = resultList[foundInd]
    //show_message(argument3[result[0]][result[1]])
    /*
    if (at_collCheck(coll, 1, 0) and at_collCheck(coll, -1, 0))
    {
        result = [1, 0];
        if (at_collCheck(coll, 0, -1))
        {
            result = [1, 4];
            if (at_collCheck(coll, 0, 1))
            {
                result = [7, 2];
            }
        }
    }
    else if (at_collCheck(coll, 1, 0))
    {
        result = [0, 0];
        if (at_collCheck(coll, 0, -1))
        {
            result = [0, 4];
            if (at_collCheck(coll, 0, 1))
            {
                result = [0, 1];
            }
        }
    }
    else
    {
        result = [4, 0];
        if (at_collCheck(coll, 0, -1))
        {
            result = [4, 4];
            if (at_collCheck(coll, 0, 1))
            {
                result = [4, 1];
            }
        }
    }
    */
    
    return(argument3[result[0]][result[1]])
}

function editor_autotile(argument0, argument1, argument2) //place = 1 delete = 0 dont alter = 2, width, height
{
    if (argument0 < 2)
    {
        for (var xx = 0; xx < argument1; xx ++)
        {
            for (var yy = 0; yy < argument2; yy ++)
            {
                if (argument0)
                {
                    addTile(tilesetSelected, [0, 0], x + xx * gridSize, y + yy * gridSize, true)
                }
                else
                {
                    deleteTile(x + xx * gridSize, y + yy * gridSize);
                }
            }
        }
    }

    var tm = _stGet("data.tile_data." + string(layer_tilemap));
    var tString = string(x) + "_" + string(y);
    //show_message(tString)
    
    var autoData = [];
    var collArrays = [];
    var positions = [];
    var isInside = [];
    var isAuto = []
    
    for (var xx = 0; xx < 6 + argument1; xx ++)
    {
        collArrays[xx] = []
        isInside[xx] = [];
        pos[xx] = [];
        isAuto[xx] = [];
        for (var yy = 0; yy < 6 + argument2; yy ++)
        {
            collArrays[xx][yy] = undefined;
            positions[xx][yy] = [0, 0];
            isInside[xx][yy] = false;
            isAuto[xx][yy] = false;
            
            var checkX = int64(x + (xx - 3) * gridSize)
            var checkY = int64(y + (yy - 3) * gridSize)
            var tString = string(checkX) + "_" + string(checkY);
            
            if (variable_struct_exists(tm, tString))
            {
                
                var currTile = struct_get(tm, tString);
                //show_message(currTile)
                
                if (currTile.tileset == tilesetSelected)// and currTile.autotile)
                {
                    collArrays[xx][yy] = autotile_getCollArray(tm, checkX, checkY, 5);
                    positions[xx][yy] = [checkX, checkY];
                    isInside[xx][yy] = autotile_isInside(collArrays[xx][yy])
                    if (variable_struct_exists(currTile, "autotile"))
                    {
                        var sameInd = true;
                        if (variable_struct_exists(currTile, "autotile_index"))
                        {
                            if (currTile.autotile_index != tileset_autotileIndex)
                            {
                                sameInd = false
                            }
                        }
                        isAuto[xx][yy] = currTile.autotile and sameInd;
                    }
                }
            }
            var dat = obj_rmEditor.data;
            var prop = dat.properties;
            if (checkX < prop.roomX or checkX >= prop.levelWidth or checkY < prop.roomY or checkY >= prop.levelHeight)
            {
                collArrays[xx][yy] = autotile_getCollArray(tm, checkX, checkY, 5);
                positions[xx][yy] = [checkX, checkY];
                isInside[xx][yy] = autotile_isInside(collArrays[xx][yy])
                isAuto[xx][yy] = false;
            }
        }
    }
    
    //now again for tiling
    for (var xx = 0; xx < 4 + argument1; xx ++)
    {
        for (var yy = 0; yy < 4 + argument2; yy ++)
        {
            if (collArrays[xx + 1][yy + 1] != undefined)
            {
                if (isAuto[xx + 1][yy + 1])
                {
                    var pos = positions[xx + 1][yy + 1];

                    var inColl = [
                        [0, 0, 0],
                        [0, 0, 0],
                        [0, 0, 0]
                    ]
                    
                    if (isInside[xx + 1][yy + 1])
                    {
                        for (var i = 0; i < 3; i ++)
                        {
                            for (var j = 0; j < 3; j ++)
                            {
                                inColl[i][j] = isInside[xx + i][yy + j]
                            }
                        }
                    }
                    var coords = autotile_getCoords(tm, pos[0], pos[1], tilesetStruct.autotile[tileset_autotileIndex], inColl)
                    //show_message(coords);
                    addTile(tilesetSelected, coords, pos[0], pos[1], true)
                    
                }
            }
        }
    }
}