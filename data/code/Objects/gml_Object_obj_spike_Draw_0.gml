var horOffset = 0
var vertOffset = 0
if(image_xscale < 0)
    horOffset = 32 * image_xscale
if(image_yscale < 0)
    vertOffset = 32 * image_yscale

for (var i = 0; i < abs(image_xscale); i++){
    for (var j = 0; j < abs(image_yscale); j++)
        draw_sprite(sprite_index, -1, x + horOffset + (32 * i), y + vertOffset + (32 * j))
}