function windows_init()
{
    w_canvas = struct_new([["screen", _wCanvas(1000, 1000, "screen")]]);
    w_openCanvas = [];
    w_eventCallback = struct_new();
    w_scale = 1;
    wCanvas_open("screen", 0, 0);
    w_canvasLock = noone;
    
}

function wCanvas_draw(argument0, argument1, argument2)
{
    var al = argument1;
    _canv = argument0;
    var c = argument0;
    
    if (_canv.seeThrough)
        al *= 0.1;
    
    var col = argument2;
    if (is_undefined(col))
        col = c_black;
    
    var bord = [_stGet("_canv.x") * w_scale, _stGet("_canv.y") * w_scale, (_stGet("_canv.x") + _stGet("_canv.width")) * w_scale, (_stGet("_canv.y") + _stGet("_canv.height")) * w_scale]
    
    draw_set_alpha(al);
    
    // backdrop
    draw_set_color(col);
    draw_rectangle(bord[0], bord[1], bord[2], bord[3], false);
    
    // contents
    draw_set_alpha(1);
    draw_set_color(c_white);
    _wCanvas_surfaceCheck(_canv);
    
    var passSur = _canv.passSurface
    var sur = _stGet("_canv.surface");
    
    //special elements
    surface_set_target(sur);
    if (c.isDropdown)
    {
        for (var j = 0; j < array_length(c.optionList); j ++)
        {
            draw_set_color(c_ltgray);
            if (c.optionList[j] == c.optionDefault)
                draw_set_color(c_lime);
                
            if (c.hovering == j)
                draw_set_color(c_white);
                
            draw_text(2, j * 12, string(c.optionList[j]));
            draw_set_color(c_white);
        }
        
        if (c.dropdownCustom)
        {
            draw_sprite(_spr("ui_button"), 0, c.width - 24, c.scroll_y);
        }
        if (c.canExit)
        {
            draw_sprite(_spr("ui_button"), 2, c.width - 24, c.scroll_y + c.height - 12);
        }
    }
    surface_reset_target();
    //
    
    surface_set_target(passSur);
    draw_surface_ext(sur, -_canv.scroll_x * w_scale, -_canv.scroll_y * w_scale, w_scale * c.surfaceScale, w_scale * c.surfaceScale, 0, c_white, 1)
    surface_reset_target()
    
    if (_canv.seeThrough)
        draw_set_alpha(0.1)
    
    draw_surface(passSur, bord[0], bord[1])
    
    draw_set_alpha(1);
    
    surface_set_target(sur);
    draw_clear_alpha(c_black, 0);
    surface_reset_target();
    surface_set_target(passSur);
    draw_clear_alpha(c_black, 0);
    surface_reset_target();
    
    // borders and scrollbars
    draw_set_alpha(al);

    draw_set_color(merge_color(col, c_black, 0.5));
    draw_rectangle(bord[0], bord[1], bord[2], bord[3], true);
    draw_rectangle(bord[0] + 1, bord[1] + 1, bord[2] - 1, bord[3] - 1, true);
    
    draw_set_color(c_white);
    
    var barSize = 5;
    if (_canv.scrollBorders[0] > 0)
    {
        var xScroll = -_canv.scroll_x / _canv.scrollBorders[0];
        var xLength = (bord[0] - bord[2]);
        var xDivision = 2;
        
        var barPos = (xLength - (xLength / xDivision)) * xScroll;
        draw_rectangle(bord[0], bord[3] - barSize, bord[2] - 1, bord[3] - 1, true)
        draw_rectangle(bord[0] - xLength / xDivision + barPos, bord[3] - barSize, bord[0] - xLength / xDivision + barPos + (xLength / xDivision), bord[3] - 1, false);
    }
    
    if (_canv.scrollBorders[1] > 0)
    {
        var yScroll = -_canv.scroll_y / _canv.scrollBorders[1];
        var yLength = (bord[1] - bord[3]);
        var yDivision = 2;
        
        var barPos = (yLength - (yLength / yDivision)) * yScroll;
        draw_rectangle(bord[2] - barSize, bord[1], bord[2] - 1, bord[3] - 1, true)
        draw_rectangle(bord[2] - barSize, bord[1] + barPos, bord[2] - 1, bord[3] + barPos + (yLength / yDivision), false);
    }
    
    draw_set_alpha(1);
}

function wCanvas_step(argument0, argument1, argument2, argument3, argument4) // open canvas struct, cursor x relative, cursor y relative, cursor x absolute, cursor y absolute
{
    _canv = argument0;
    var c = argument0;
    
    struct_set(c, [["eventCallback", noone]])
    
    argument1 -= _canv.scroll_x;
    argument2 -= _canv.scroll_y;
    var scrollChange = mouse_wheel_down() - mouse_wheel_up()
    
    var mX = argument3 - _canv.x;
    var mY = argument4 - _canv.y;
    
    var bord = [_stGet("_canv.x"), _stGet("_canv.y"), _stGet("_canv.x") + _stGet("_canv.width"), _stGet("_canv.y") + _stGet("_canv.height")]
    
    
    var ext = 0;
    var xMove = argument1 - _canv.prev_cursorX;
    var yMove = argument2 - _canv.prev_cursorY;
    if (w_isOnCanvas(argument0, argument3, argument4, true))
    {
        if (scrollChange != 0)
        {
            _stSet("_canv.scroll_y", _canv.scroll_y + scrollChange * 16);
        }
        if (mouse_check_button(mb_middle))
        {
            _stSet("_canv.scroll_x", _canv.scroll_x - xMove);
            _stSet("_canv.scroll_y", _canv.scroll_y - yMove);
            ext = 4;
        }
        
        var barSize = 8;
        var onScrollBar = [mX > _canv.width - barSize, mY > _canv.height - barSize];
        if (mouse_check_button(mb_left))
        {
            if (onScrollBar[0])
            {
                _stSet("_canv.scroll_y", _canv.scroll_y + (yMove / _canv.height * 2) * (_canv.scrollBorders[1]))
            }
            if (onScrollBar[1])
            {
                _stSet("_canv.scroll_x", _canv.scroll_x + (xMove / _canv.width * 2) * (_canv.scrollBorders[0]))
            }
        }
        
        _stSet("_canv.scroll_x", _canv.scroll_x + (keyboard_check(ord("D")) - keyboard_check(ord("A"))) * 4);
        _stSet("_canv.scroll_y", _canv.scroll_y + (keyboard_check(ord("S")) - keyboard_check(ord("W"))) * 4);
        
        
        //special shits
        if (c.isDropdown)
        {
            struct_set(c, [["scrollBorders", [0, array_length(c.optionList) * 12 - c.height]]])
            var hover = floor((argument2 + c.scroll_y) / 12);
            if (hover != clamp(hover, 0, array_length(c.optionList) - 1))
                hover = -1;
            
            if (onScrollBar[0])
            {
                hover = -1;
            }
            
            if (argument2 < 12)
            {
                if (argument1 > c.width - 24 and argument1 < c.width - 12)
                {
                    if (c.dropdownCustom)
                        hover = -2;
                }
            }
            if (c.canExit and argument2 > c.height - 12 and argument1 > c.width - 24 and argument1 < c.width - 12)
            {
                hover = -3;
            }
            
            struct_set(c, [["hovering", hover]])
            
            if (mouse_check_button_pressed(mb_left) and !onScrollBar[0])
            {
                if (hover >= 0)
                {
                    w_eventCallback = struct_new([
                        ["name", c.dropdownEvent],
                        ["data", [c.optionList[hover], hover]],
                        ["canvasStruct", c],
                        ["isCustom", false]
                    ])
                    struct_set(c, [
                        /*["eventCallback", struct_new([
                            ["name", "dropdownSelected"],
                            ["data", ]
                        ])],*/
                        ["optionDefault", c.optionList[hover]]
                    ])
                    event_user(10);
                }
                else if (hover == -2)
                {
                    var val = get_string(c.dropdownCustomPrompt, c.optionDefault);
                    if (val != "")
                    {
                        w_eventCallback = struct_new([
                            ["name", c.dropdownEvent],
                            ["data", [val, hover]],
                            ["canvasStruct", c],
                            ["isCustom", true]
                        ]);
                        struct_set(c, [
                            ["optionDefault", val]
                        ]);
                        event_user(10);
                    }
                }
                else if (hover == -3)
                {
                    wCanvas_close(c);
                }
            }
        }
    }
    
    _stSet("_canv.scroll_x", clamp(_canv.scroll_x, -ext, max(0, _canv.scrollBorders[0] + ext)))
    _stSet("_canv.scroll_y", clamp(_canv.scroll_y, -ext, max(0, _canv.scrollBorders[1] + ext)))
    
    _stSet("_canv.prev_cursorX", argument1);
    _stSet("_canv.prev_cursorY", argument2);
}

function wCanvas_get_event(argument0) //open canvas struct or canvas name
{
    var ind = w_findCanvasIndex(argument0)
    if (ind == -1)
    {
        return struct_new([["name", "nothing"], ["data", []]]);
    }
    var c = w_openCanvas[ind];
    if (c.eventCallback == noone)
    {
        return struct_new([["name", "nothing"], ["data", []]]);
    }
    return(c.eventCallback);
}

function wCanvas_open(argument0, argument1, argument2)
{
    var w = _stGet("w_canvas." + argument0 + ".width");
    var h = _stGet("w_canvas." + argument0 + ".height");
    var c = struct_new([
        ["name", argument0],
        ["x", argument1],
        ["y", argument2],
        ["width", w],
        ["height", h],
        ["scroll_x", 0],
        ["scroll_y", 0],
        ["scrollBorders", _stGet("w_canvas." + argument0 + ".scrollBorders")],
        ["surface", -1],
        ["passSurface", -1],
        ["surfaceScale", _stGet("w_canvas." + argument0 + ".surfaceScale")],
        
        //dropdown shits
        ["isDropdown", false],
        ["canExit", true],
        ["optionList", []],
        ["optionDefault", 0],
        ["dropdownCustom", false],
        ["dropdownCustomPromt", "set to custom value:"],
        ["dropdownEvent", "dropdownSelected"],
        //these will be constantly updated
        ["prev_cursorX", 0],
        ["prev_cursorY", 0],
        ["seeThrough", false],
        ["hovering", -1],
        ["eventCallback", noone]
    ])
    _wCanvas_surfaceCheck(c)
    array_push(w_openCanvas, c);
    return(c);
}

function wCanvas_open_dropdown(argument0, argument1, argument2, argument3, argument4, argument5, argument6) //canvas name, x, y, option list, default, event name, custom value prompt (blank for no custom values)
{
    var c = wCanvas_open(argument0, argument1, argument2);
    struct_set(c, [
        ["isDropdown", true],
        ["optionList", argument3],
        ["optionDefault", argument4],
        ["dropdownEvent", argument5]
    ]);
    
    if (argument6 != undefined)
    {
        struct_set(c, [
            ["dropdownCustom", true],
            ["dropdownCustomPrompt", argument6]
        ])
    }
    return(c);
}

function wCanvas_close(argument0)
{
    var ind = w_findCanvasIndex(argument0);
    if (ind == -1)
        return;
        
    wCanvas_surfaceCleanup(w_openCanvas[ind]);
        
    array_delete(w_openCanvas, ind, 1);
}

function wCanvas_close_all()
{
    for (var i = 0; i < array_length(w_openCanvas); i ++)
    {
        wCanvas_close(w_openCanvas[0]);
    }
}

function windows_add_canvas(argument0, argument1, argument2, argument3) // width, height, name, scrollborders
{
    struct_set(w_canvas, [[string(argument2), _wCanvas(argument0, argument1, argument2, argument3)]])
}

function _wCanvas(argument0, argument1, argument2, argument3)
{
    var scrollBorders = argument3;
    if (is_undefined(argument3))
        scrollBorders = [0, 0];
    return struct_new([
    ["name", string(argument2)],
    ["width", argument0],
    ["height", argument1],
    ["children", []],
    ["scrollBorders", scrollBorders],
    ["surfaceScale", 1],
    ["parent", undefined]
    ]);
}

function _wCanvas_surfaceCheck(argument0)
{
    _c = argument0
    if (!surface_exists(_stGet("_c.surface")) or !surface_exists(_stGet("_c.passSurface")))
    {
        _stSet("_c.passSurface", surface_create(_stGet("_c.width") * w_scale, _stGet("_c.height") * w_scale));
        _stSet("_c.surface", surface_create(2000, 2000));
        array_push(global.surfaceRoomEnd, _c.passSurface);
        array_push(global.surfaceRoomEnd, _c.surface);
    }
}

function wCanvas_surfaceCleanup(argument0)
{
    var c = argument0
    if (surface_exists(c.surface))
        array_push(global.surfaceDestroyer, c.surface);
    if (surface_exists(c.passSurface))
        array_push(global.surfaceDestroyer, c.passSurface);
}

function w_isOnCanvas(argument0 /*canvas instance*/, argument1 /*cursor x*/, argument2 /*cursor y*/, argument3 /* include scrollbar borders */)
{
    if (argument3 == undefined)
        argument3 = false;
        
    var canvasInd = w_findCanvasIndex(argument0);
    
    if (keyboard_check(vk_space))
    {
        w_canvasLock = noone;
        if (canvasInd != 0)
        {
            struct_set(argument0, [["seeThrough", true]])
            return false;
        }
        return true
    }
    
    var barSize = 8;
    if (argument3)
        barSize = -2;
    
    var bord = [argument0.x, argument0.y, argument0.x + argument0.width + 2, argument0.y + argument0.height + 2];
    var mPos = [argument1, argument2]
    
    if (w_canvasLock != noone)
    {
        if (w_canvasLock == canvasInd)
            return true

        if !mouse_check_button(mb_any)
            w_canvasLock = noone;
            
        if (isPosInsideBorder(mPos, bord))
            struct_set(argument0, [["seeThrough", true]])
        else
            struct_set(argument0, [["seeThrough", false]])
            
        return false
    }
    struct_set(argument0, [["seeThrough", false]])
    
    if (!isPosInsideBorder(mPos, bord))
    { 
        return false;
    }
    
    for (var i = array_length(w_openCanvas) - 1; i > canvasInd; i --)
    {
        var oC = w_openCanvas[i];
        if (isPosInsideBorder(mPos, [oC.x, oC.y, oC.x + oC.width, oC.y + oC.height]))
            return false;
    }
    
    if (mouse_check_button(mb_any))
        w_canvasLock = canvasInd
        
    return true;
}

function w_findCanvasIndex(argument0)//
{
    var nm = "";
    
    for (var j = 0; j < array_length(w_openCanvas); j ++)
    {
        if (is_string(argument0))
        {
            _temp = j;
            if (_stGet("w_openCanvas[_temp].name") == argument0)
                return(j)
        }
        else if (w_openCanvas[j] == argument0)
            return(j)
    }
    if (is_string(argument0))
    {
        nm = argument0;
    }
    else
    {
        nm = argument0.name
    }
    //show_error("no canvas with name " + nm + " is open.", true);
    return(-1);
}