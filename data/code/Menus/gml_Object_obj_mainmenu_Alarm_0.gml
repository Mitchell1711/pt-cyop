instance_create(x, y, obj_fadeout)
if (currentselect < 3)
{
    if (!showswap)
    {
        global.swapmode = 0
        with (obj_player1)
        {
            character = "P"
            ispeppino = (other.shownoise ? 0 : 1)
            scr_characterspr()
        }
        scr_start_game((currentselect + 1), (shownoise ? 0 : 1))
    }
    else
    {
        var grouparr = ["characterselectgroup"]
        with (obj_player)
        {
            targetRoom = characterselect
            targetDoor = "A"
            state = states.titlescreen
        }
        global.swapmode = 1
        global.currentsavefile = (currentselect + 1)
        with (instance_create(0, 0, obj_fadeout))
            group_arr = grouparr
    }
}
else
{
    with obj_player
    {
        targetRoom = rmModMenu;
    }
    global.currentsavefile = 10;
}
