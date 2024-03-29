var flipx = sign(image_xscale)
var flipy = sign(image_yscale)
for (var i = 0; i < abs(image_xscale); i++){
    for (var j = 0; j < abs(image_yscale); j++)
        draw_sprite(sprite_index, -1, x + (32 * i * flipx), y + (32 * j * flipy))
}