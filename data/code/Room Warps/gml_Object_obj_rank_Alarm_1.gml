global.levelcomplete = 1
global.noisejetpack = 0
global.pistol = 0
scr_playerreset()
with (obj_player)
{
    swap_player()
    global.pistol = 0
    global.noisejetpack = 0
    noisepizzapepper = 0
    targetDoor = "HUB"
    targetRoom = backtohubroom
    if (!is_string(backtohubroom))
    {
        room = backtohubroom//
    }
    else
    {
        if (global.hubLevel != "")
        {
            preloadCustomLevel(global.hubLevel);
        }
        prepareCustomLevel(get_roomData(backtohubroom), backtohubroom)
    }
    x = backtohubstartx
    y = backtohubstarty
    state = states.comingoutdoor
    sprite_index = spr_walkfront
    image_index = 0
    image_blend = c_white
}
global.exitrank = 0
global.leveltorestart = -4
global.leveltosave = -4
global.level_minutes = 0
global.level_seconds = 0
