var playerid = obj_player1
if (obj_player1.spotlight == 0)
    playerid = obj_player2
fmod_event_instance_set_3d_attributes(snd, x, y)
if (!fmod_event_instance_is_playing(snd))
    fmod_event_instance_play(snd)
if (!instance_exists(playerid))
    return;
var _move = 1
with (obj_player)
{
    if (state == states.taxi || state == states.victory || state == states.keyget || state == states.gottreasure || state == states.door || state == (292 << 0))
        _move = 0
}
if (!treasure)
{
    if (img_alpha >= 1)
    {
        if ((!instance_exists(obj_fadeout)) && (!obj_player1.cutscene))
        {
            if _move
            {
                var dir = point_direction(x, y, playerid.x, playerid.y)
                x += lengthdir_x(maxspeed, dir)
                y += lengthdir_y(maxspeed, dir)
            }
        }
    }
    else
        img_alpha += 0.01
}
else
{
    x = -200
    y = -200
}
if (!_move)
    img_alpha = Approach(img_alpha, 0, 0.1)
if (_move && place_meeting(x, y, playerid) && (!playerid.cutscene) && playerid.state != states.actor && (!instance_exists(obj_fadeout)) && (!instance_exists(obj_endlevelfade)) && img_alpha >= 1)
{
    fmod_event_instance_stop(snd, 1)
    with (playerid)
    {
        instance_destroy(obj_fadeout)
        targetDoor = "A"
        room = timesuproom
        state = states.timesup
        sprite_index = spr_Timesup
        image_index = 0
        if isgustavo
            sprite_index = spr_player_ratmounttimesup
        visible = true
        image_blend = c_white
        stop_music()
        fmod_event_one_shot("event:/music/timesup")
    }
    instance_destroy()
}
if (maxspeed < 3 && img_alpha >= 1)
    maxspeed += 0.01
//finally set image_alpha at the end of the script
image_alpha = img_alpha
