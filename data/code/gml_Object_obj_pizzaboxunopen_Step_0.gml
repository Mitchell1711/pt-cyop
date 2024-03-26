var roomname = string_letters(room_get_name(room))
if (place_meeting(x, y, obj_player) && sprite_index == spr_pizzaboxunopen)
{
    global.combotime = 60
    fmod_event_one_shot("event:/sfx/misc/collecttoppin")
    switch content{
        case obj_pizzakinshroom:
            handlePizzakin()
            global.shroomfollow = 1
            break
        case obj_pizzakincheese:
            handlePizzakin()
            global.cheesefollow = 1
            break
        case obj_pizzakintomato:
            handlePizzakin()
            global.tomatofollow = 1
            break
        case obj_pizzakinsausage:
            handlePizzakin()
            global.sausagefollow = 1
            break
        case obj_pizzakinpineapple:
            handlePizzakin()
            global.pineapplefollow = 1
            break
        case obj_noisey:
            fmod_event_one_shot_3d("event:/sfx/enemies/projectile", x, y)
            with (instance_create(x, (y - 25), content))
            {
                image_xscale = other.image_xscale
                state = states.stun
                stunned = 20
                vsp = -5
            }
            break
        case obj_noisebomb:
            with (obj_player)
            {
                state = states.backbreaker
                sprite_index = spr_player_bossintro
                image_index = 0
            }
            with (instance_create(x, (y - 25), content))
                sprite_index = spr_noisebomb_intro
            instance_create(x, y, obj_taunteffect)
            instance_create(x, (y + 600), obj_itspizzatime)
            global.panic = 1
            switch room
            {
                case floor2_roomtreasure:
                    global.minutes = 2
                    global.seconds = 40
                    break
                case floor3_roomtreasure:
                    global.minutes = 2
                    global.seconds = 30
                    break
                case floor4_roomtreasure:
                    global.minutes = 2
                    global.seconds = 0
                    break
                case floor5_roomtreasure:
                    global.minutes = 2
                    global.seconds = 0
                    break
            }

            global.wave = 0
            global.maxwave = (((global.minutes * 60) + global.seconds) * 60)
            if global.panicbg
                scr_panicbg_init()
            break
        default:
            instance_create(x, (y - 25), content)
            break

    }
    instance_destroy()
}
subimg += 0.35
if (subimg > (sprite_get_number(spr_toppinhelp) - 1))
{
    subimg = frac(subimg)
    scr_fmod_soundeffect(snd, x, y)
}

function handlePizzakin(){
    with (instance_create(x, y, obj_smallnumber))
        number = "1000"
    if place_meeting(x, y, obj_player1)
        global.collect += 1000
    else
        global.collectN += 1000
    instance_create(x, y, obj_taunteffect)
    instance_create(x, (y - 25), content)
    if (global.toppintotal < 5)
        obj_tv.message = (("YOU NEED " + string((5 - global.toppintotal))) + " MORE TOPPINS!")
    if (global.toppintotal == 5)
        obj_tv.message = "YOU HAVE ALL TOPPINS!"
    obj_tv.showtext = 1
    obj_tv.alarm[0] = 150
    global.toppintotal += 1
}