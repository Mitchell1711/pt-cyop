var img_spd = 0;
if (bg_struct != undefined)
{
    sprite_index = _spr(bg_struct.sprite);
    bg_x = bg_struct.x;
    bg_y = bg_struct.y;
    x_scroll = bg_struct.scroll_x;
    y_scroll = bg_struct.scroll_y;
    
    x_tile = bg_struct.tile_x;
    y_tile = bg_struct.tile_y;
    
    img_spd = bg_struct.image_speed;
    
    hsp = bg_struct.hspeed;
    vsp = bg_struct.vspeed;
}

x += hsp;
y += vsp;

img_ind += img_spd / 60;

var cam_x = camera_get_view_x(view_camera[0]);
var cam_y = camera_get_view_y(view_camera[0]);
draw_sprite_tiled_direction(sprite_index, img_ind % sprite_get_number(sprite_index), x + bg_x + cam_x * (1 - x_scroll), y + bg_y + cam_y * (1 - y_scroll), x_tile, y_tile);