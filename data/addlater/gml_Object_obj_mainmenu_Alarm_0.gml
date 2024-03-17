instance_create(x, y, obj_fadeout)
if (currentselect < 3)
{
    with (obj_player)
    {
        targetRoom = 664;
        targetDoor = "A"
    }
    global.currentsavefile = (currentselect + 1)
}
else
{
    with obj_player
    {
        targetRoom = rmModMenu;
    }
    global.currentsavefile = 10;
}

gamesave_async_load()
