repeat(array_length(global.surfaceDestroyer))
{
    surface_free(array_pop(global.surfaceDestroyer))
}