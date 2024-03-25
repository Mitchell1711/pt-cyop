pause = 0
scr_pause_stop_sounds()
var rm = room
if (!hub)
{
    pause = 0
    scr_pause_activate_objects()
    obj_player1.targetRoom = 1
    obj_player2.targetRoom = 1
    room = Realtitlescreen
    with (obj_player1)
    {
        character = "P"
        scr_characterspr()
    }
    global.leveltosave = -4
    global.leveltorestart = -4
    scr_playerreset()
    alarm[0] = 2
    obj_player1.state = (18 << 0)
    obj_player2.state = (18 << 0)
    obj_player1.targetDoor = "A"
    if instance_exists(obj_player2)
        obj_player2.targetDoor = "A"
    global.cowboyhat = 0
    global.coop = 0
}
else
{
    scr_pause_activate_objects()
    with (instance_create(0, 0, obj_backtohub_fadeout))
        fadealpha = 0.9
    scr_playerreset()
    global.levelreset = 1
    obj_player1.targetDoor = "HUB"
    if instance_exists(obj_player2)
        obj_player2.targetDoor = "HUB"

    if (global.hubLevel != "")
    {
        preloadCustomLevel(global.hubLevel);
    }
    global.leveltorestart = -4
    global.leveltosave = -4
}
if (rm == 659 || rm == 515 || rm == 513 || rm == 783 || rm == 514)
    global.bossintro = 1
