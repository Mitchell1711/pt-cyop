for (var i = 0; i < abs(image_xscale); i++)
{ 
    draw_sprite(spr_water, -1, (x + (32 * i)), y)   
}

if (room == rmCustomLevel)
{
    draw_sprite_ext(_spr("z_oldeditor/water2"), 0, x, y + 32, image_xscale, image_yscale - 1, 0, c_white, 1)
}