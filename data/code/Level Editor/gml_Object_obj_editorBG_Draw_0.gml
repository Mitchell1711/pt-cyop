// draw grid
if (instance_exists(obj_rmEditor))
{
    var e = obj_rmEditor;
    _temp = e.data;
    var lvlPos = [_stGet("_temp.properties.roomX"), _stGet("_temp.properties.roomY")];
    var lvlSize = [struct_get(struct_get(e.data, "properties"), "levelWidth") - lvlPos[0], struct_get(struct_get(e.data, "properties"), "levelHeight") - lvlPos[1]]
    var gridAmmo = [(lvlSize[0] / e.gridSize), (lvlSize[1] / e.gridSize)]
    draw_set_color(c_black)
    draw_set_alpha(0.5)
    if (obj_rmEditor.camZoom < 3)
    {
        draw_sprite_tiled_ext(_spr("grid"), 0, 0, 0, 1, 1, c_black, 0.5)
    }
    else
    {
        for (var i = 0; i < max(gridAmmo[0], gridAmmo[1]); i++)
        {
            for (var j = 0; j < 2; j ++)
            {
                draw_line(lvlPos[0] + (i * e.gridSize) - 1 + j, lvlPos[1], lvlPos[0] + (i * e.gridSize) - 1 + j, lvlPos[1] + (gridAmmo[1] * e.gridSize))
                draw_line(lvlPos[0], lvlPos[1] + (i * e.gridSize) - 1 + j, lvlPos[0] + (gridAmmo[0] * e.gridSize), lvlPos[1] + (i * e.gridSize) - 1 + j)
            }
        }
    }
    
    draw_set_alpha(1)
    draw_set_color(c_dkgray);
    
    var camSize = [camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0])];
    draw_rectangle(e.cam_x, e.cam_y, lvlPos[0], e.cam_y + camSize[1], false);
    draw_rectangle(e.cam_x, e.cam_y, e.cam_x + camSize[0], lvlPos[1], false);
    draw_rectangle(lvlSize[0] + lvlPos[0], e.cam_y, e.cam_x + camSize[0], e.cam_y + camSize[1], false);
    draw_rectangle(e.cam_x, lvlSize[1] + lvlPos[1], e.cam_x + camSize[0], e.cam_y + camSize[1], false);
    
    draw_set_color(c_white)
}