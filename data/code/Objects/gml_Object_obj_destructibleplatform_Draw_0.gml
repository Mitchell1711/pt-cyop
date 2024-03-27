for (var i = 0; i < abs(image_xscale); i++){
    for (var j = 0; j < abs(image_yscale); j++)
        draw_sprite(sprite_index, image_index, xstart + (32 * i), ystart + (32 * j))
}