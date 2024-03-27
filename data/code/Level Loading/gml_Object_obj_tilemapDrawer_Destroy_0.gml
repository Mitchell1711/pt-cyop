//show_message("out")
if (surface_exists(tilemap_surface))
{
    surface_free(tilemap_surface);
}
if (surface_exists(tilemap_prevSurface))
{
    surface_free(tilemap_prevSurface);
}