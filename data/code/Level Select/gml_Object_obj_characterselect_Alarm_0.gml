if global.swapmode
    instance_create_unique(obj_player1.x, obj_player1.y, obj_swapmodefollow)
if(global.fromMenu){
    loadCustomLevel(global.levelName, false)
}
//ported over old char select room transition code since some people put this object in their towers and it would load the base game
else if (room == rmCustomLevel){
    with (instance_create(x, y, obj_fadeout))
    {
        obj_player1.targetRoom = hub_loadingscreen
        obj_player1.targetDoor = "A"
        obj_player1.state = states.normal
        if (global.coop == 1)
        {
            obj_player2.state = states.normal
            obj_player2.targetDoor = "A"
        }
    }
}
else{
    scr_start_game(global.currentsavefile, selected == 0)
}