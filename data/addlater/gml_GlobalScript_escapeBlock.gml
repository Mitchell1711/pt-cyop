function escapeBlock_init()
{
    saveX = x;
}
function escapeBlock_step()
{
    if (global.panic)
    {
        x = saveX;
        mask_index = spr_bigbreakableescape;
        image_alpha = 1;
        visible = true;
    }
    else
    {
        x = saveX;
        saveX = x;
        with obj_player1
        {
            other.x = x - 3000;
        }
        visible = false;
        image_alpha = 0.5;
    }
}