global.switchbuffer = 0
image_speed = 0.35
image_xscale = 1
//before the noise update escape was set to 0 by default
if(room == rmCustomLevel)
    escape = 0
else
    escape = 1
depth = -5
sprite_index = spr_gustavoswitch1
switchstart = 626
switchend = 2782
spr_sign = spr_pepsign
if (!obj_player1.ispeppino)
{
    sprite_index = spr_noiseswitch1
    switchstart = 3862
    switchend = 1121
    spr_sign = spr_noisesign
}
collisioned = 0
//like 3 tiles idk
maxdistance = 96
