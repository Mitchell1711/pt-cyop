if (is_undefined(tilemap))
{
    exit;
}


if (surface_exists(tilemap_surface) and surface_exists(tilemap_prevSurface))
{
    draw_set_alpha(1)
    event_user(0);

    draw_set_alpha(tile_alpha * image_alpha);
    //draw_surface(tilemap_surface, x, y)
    tilemapDrawGetVars();
    
    var camScale = camera_get_view_width(view_camera[0]) / 960
    

    draw_surface_ext(tilemap_surface, drawX[0], drawY[0], camera_get_view_width(view_camera[0]) / 960, camera_get_view_height(view_camera[0]) / 540, 0, c_white, draw_get_alpha());
    draw_set_alpha(1);
}
else
{
    draw_set_alpha(1)
    if (instance_exists(obj_rmEditor))
        global.roomData = obj_rmEditor.data;
    initTilemapDrawer(global.roomData, layer_tilemap);
}

draw_set_alpha(1)