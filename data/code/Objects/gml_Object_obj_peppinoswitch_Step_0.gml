if ((global.switchbuffer > 0))
    global.switchbuffer--
if ((sprite_index == switchend) && instance_exists(obj_charswitch_intro) && (obj_charswitch_intro.state != states.fall))
    image_index = 0
if ((sprite_index == switchend) && (floor(image_index) == (image_number - 1)))
{
    with (obj_player1)
    {
        scr_switchpeppino()
        x = obj_peppinoswitch.x
        y = obj_peppinoswitch.y
        global.switchbuffer = 100
    }
    sprite_index = spr_sign
}
if ((sprite_index == spr_sign) && (global.panic != escape))
    visible = false
else
    visible = true
if ((sprite_index == spr_noiseswitch1) && (!collisioned))
{
    mask_index = spr_player_mask
    var xs = sign((obj_gustavoswitch.x - x))
    //maxdistance is used to prevent freezes if theres no wall in between the switch objects
    while ((!(place_meeting((x + (1 * xs)), y, obj_solid))) || maxdistance > 0){
        x += (1 * xs)
        maxdistance--
    }
    collisioned = true
    image_xscale = (-1 * xs)
}
