if global.swapmode
    instance_create_unique(obj_player1.x, obj_player1.y, obj_swapmodefollow)
if(global.fromMenu){
    loadCustomLevel(global.levelName, false)
}
else{
    scr_start_game(global.currentsavefile, selected == 0)
}