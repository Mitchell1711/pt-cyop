var xx = x;
var yy = y;
var xscale = image_xscale;
var yscale = image_yscale;

if (flipX)
{
    var horDifference = sprite_get_width(sprite_index) - sprite_get_xoffset(sprite_index) * 2
    xx += horDifference * image_xscale;
    xscale *= -1;
}

if (flipY)
{
    var verDifference = sprite_get_height(sprite_index) - sprite_get_yoffset(sprite_index) * 2
    yy += verDifference * image_yscale;
    yscale *= -1;
}

if (variable_instance_exists(id, "escape"))
{
    if (escape)
        draw_sprite_ext(spr_johnescapeenemy, 6, (bbox_right + bbox_left) / 2, bbox_bottom - sprite_get_height(sprite_index), 1, 1, 0, c_white, 0.5 * image_alpha);
}

draw_sprite_ext(sprite_index, image_index, xx, yy, xscale, yscale, image_angle, image_blend, image_alpha);

if (absorbed != noone)
{
    var objSpr = object_get_sprite(absorbed)
    var targetx = (bbox_right + bbox_left) / 2 + sprite_get_xoffset(objSpr) - (sprite_get_bbox_left(objSpr) + sprite_get_bbox_right(objSpr)) / 2
    var targety = (bbox_bottom + bbox_top) / 2 + sprite_get_yoffset(objSpr) - (sprite_get_bbox_top(objSpr) + sprite_get_bbox_bottom(objSpr)) / 2
    draw_sprite_ext(objSpr, 0, targetx, targety, 1, 1, 0, c_white, abs(dsin(current_time / 10)))
}

if (!instance_exists(obj_rmEditor))
    exit;
    
var inst = obj_rmEditor.data;
inst = inst.instances[instID];

var instVars = inst.variables;
switch inst.object
{
    case obj_warp_number:
        struct_confirm(instVars, "trigger", 0);
        draw_set_alpha(image_alpha);
        draw_text(x, y, instVars.trigger);
        draw_set_alpha(1);
    break;
}