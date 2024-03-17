if (variable_instance_exists(id, "customSprite"))
{
    if (customSprite != spr_slope)
    {
        mask_index = spr_slope;
        sprite_index = customSprite;
        visible = true;
    }
}