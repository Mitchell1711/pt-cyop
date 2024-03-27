function init_customBG(argument0, argument1) // data, layer
{
    data = argument0
    bg_struct = _stGet("data.backgrounds." + string(argument1));
    
    sprite_index = _spr(_stGet("bg_struct.sprite"));
    bg_x = _stGet("bg_struct.x");
    bg_y = _stGet("bg_struct.y");
    x_scroll = _stGet("bg_struct.scroll_x");
    y_scroll = _stGet("bg_struct.scroll_y");
    x_tile = _stGet("bg_struct.tile_x");
    y_tile = _stGet("bg_struct.tile_y");
    hsp = _stGet("bg_struct.hspeed");
    vsp = _stGet("bg_struct.vspeed");
    
    layer_background = argument1;
}


layer_background = undefined;
bg_struct = undefined;

x_scroll = 1;
y_scroll = 1;

x_tile = true;
y_tile = true;

room_x = 0;
room_y = 0;

hsp = 0;
vsp = 0;

bg_x = 0;
bg_y = 0;

img_ind = 0;