scr_getinput()
index += 0.1
key_jump = (key_jump || (scr_check_menu_key(13) && keyboard_check_pressed(vk_return)) || (scr_check_menu_key(32) && keyboard_check_pressed(vk_space)))
key_jump2 = (key_jump2 || (scr_check_menu_key(13) && keyboard_check(vk_return)) || (scr_check_menu_key(32) && keyboard_check(vk_space)))

switch state
{
    case (18 << 0):
        jumpscarecount++
        currentselect = -1
        if ((keyboard_check_pressed(vk_anykey) || scr_checkanygamepad(obj_inputAssigner.player_input_device[0]) != -4 || scr_checkanystick(obj_inputAssigner.player_input_device[0])) && (!instance_exists(obj_mainmenu_jumpscare)))
        {
            state = (8 << 0)
            currentselect = -1
            visualselect = -1
            darkcount = 7
            dark = 0
            darkbuffer = 5
            jumpscarecount = 0
            fmod_event_one_shot("event:/sfx/ui/lightswitch")
            with (obj_music)
                fmod_event_instance_set_parameter(music.event, "state", 1, 1)
        }
        if (jumpscarecount > 2400 && (!instance_exists(obj_mainmenu_jumpscare)))
        {
            instance_create(480, 270, obj_mainmenu_jumpscare)
            fmod_event_one_shot("event:/sfx/enemies/jumpscare")
        }
        break
    case (8 << 0):
        if (darkbuffer > 0)
            darkbuffer--
        else
        {
            dark = (!dark)
            if (darkcount > 0)
            {
                darkcount--
                if dark
                    darkbuffer = (2 + irandom(3))
                else
                    darkbuffer = (6 + irandom(5))
                if (darkcount <= 0)
                {
                    dark = 0
                    darkbuffer = 40
                }
            }
            else
            {
                currentselect = 3
                visualselect = 3
                dark = 0
                state = (0 << 0)
                sprite_index = _spr("pepmaker")
                image_index = 0
            }
        }
        break
    case (0 << 0):
        if (key_start && (!instance_exists(obj_option)))
        {
            with (instance_create(0, 0, obj_option))
                backbuffer = 2
            break
        }
        else if instance_exists(obj_option)
            break
        else
        {
            move = 0//(key_left2 + key_right2)
            vmove = 0//(key_down2 - key_up2)
            if ((sprite_index != spr_titlepep_punch && sprite_index != spr_titlepep_angry) || move != 0 || vmove != 0)
            {
                if (move != 0 or vmove != 0)
                    angrybuffer = 0
                
                if (currentselect < 3)
                {
                    currentselect += move
                    currentselect = clamp(currentselect, 0, 2)
                }
                else if (move != 0)
                {
                    currentselect = 1 + move;
                }
                if (vmove == -1)
                {
                    currentselect = 1;
                }
                if (vmove == 1)
                {
                    currentselect = 3;
                }
                if (currentselect != visualselect && (sprite_index == spr_titlepep_left || sprite_index == spr_titlepep_middle || sprite_index == spr_titlepep_right || sprite_index == _spr("pepmaker_idle")))
                {
                    visualselect = Approach(visualselect, currentselect, 1)
                    image_index = 0
                    if (visualselect == 0 && sprite_index == spr_titlepep_middle)
                        sprite_index = spr_titlepep_middletoleft
                    if (visualselect == 1 && sprite_index == spr_titlepep_left)
                        sprite_index = spr_titlepep_lefttomiddle
                    if (visualselect == 2 && (sprite_index == spr_titlepep_middle or sprite_index == _spr("pepmaker_idle")))
                        sprite_index = spr_titlepep_middletoright
                    if (visualselect == 1 && sprite_index == spr_titlepep_right)
                        sprite_index = spr_titlepep_righttomiddle
                    if (visualselect == 3 and sprite_index == spr_titlepep_right)
                        sprite_index = _spr("pepmaker")
                }
                if (floor(image_index) == (image_number - 1))
                {
                    var edSpr = _spr("pepmaker");
                    switch sprite_index
                    {
                        case spr_titlepep_forwardtoleft:
                        case 1635:
                            sprite_index = spr_titlepep_left
                            break
                        case 2946:
                        case 2995:
                            sprite_index = spr_titlepep_middle
                            break
                        case 3525:
                            sprite_index = spr_titlepep_right
                            break
                        case edSpr:
                            sprite_index = _spr("pepmaker_idle")
                            break
                    }

                }
            }
            else if (sprite_index == spr_titlepep_angry)
            {
                y = ystart
                if (angrybuffer > 0)
                    angrybuffer--
                else
                {
                    sprite_index = savedsprite
                    switch sprite_index
                    {
                        case spr_titlepep_forwardtoleft:
                        case 1635:
                            sprite_index = spr_titlepep_left
                            break
                        case 2946:
                        case 2995:
                            sprite_index = spr_titlepep_middle
                            break
                        case 3525:
                            sprite_index = spr_titlepep_right
                            break
                    }

                    image_index = savedindex
                    image_speed = 0.35
                }
            }
            else
            {
                if (vsp < 20)
                    vsp += 0.5
                y += vsp
                if (y >= ystart && vsp > 0)
                {
                    y = ystart
                    vsp = 0
                }
            }
            if key_jump
            {
                if currentselect != 3
                {
                    fmod_event_one_shot_3d("event:/sfx/voice/pig", 480, 270)
                }
                else
                {
                    state = (98 << 0)
                    with (obj_menutv)
                    {
                        if (trigger == other.currentselect)
                        {
                            fmod_event_instance_stop(obj_music.music.event, 0)
                            if (trigger != 3)
                                fmod_event_one_shot("event:/sfx/ui/fileselect")
                            state = (98 << 0)
                            sprite_index = confirmspr
                        }
                    }
                    alarm[0] = 250
                    fmod_event_one_shot("event:/sfx/misc/collectpizza")
                    switch currentselect
                    {
                        case 0:
                            sprite_index = spr_titlepep_left
                            break
                        case 1:
                            sprite_index = spr_titlepep_middle
                            break
                        case 2:
                            sprite_index = spr_titlepep_right
                            break
                        case 3:
                            sprite_index = _spr("pepmaker_idle");
                            alarm[0] = 60
                            break
                    }
                }

            }
            else if key_slap2
            {
                state = (289 << 0)
                exitselect = 1
                switch currentselect
                {
                    case 0:
                        sprite_index = spr_titlepep_left
                        break
                    case 1:
                        sprite_index = spr_titlepep_middle
                        break
                    case 2:
                        sprite_index = spr_titlepep_right
                        break
                    case 3:
                        sprite_index = _spr("pepmaker_idle");
                        break
                }

            }
            else if (key_taunt2 && global.game_started[currentselect] && currentselect != 3)
            {
                deletebuffer = 0
                state = (183 << 0)
                deleteselect = 1
                fmod_event_one_shot_3d("event:/sfx/voice/pig", 480, 270)
                switch currentselect
                {
                    case 0:
                        sprite_index = spr_titlepep_left
                        break
                    case 1:
                        sprite_index = spr_titlepep_middle
                        break
                    case 2:
                        sprite_index = spr_titlepep_right
                        break
                }

            }
            break
        }
    case (183 << 0):
        deleteselect += (key_left2 + key_right2)
        deleteselect = clamp(deleteselect, 0, 1)
        if key_jump2
            deletebuffer++
        else
            deletebuffer = 0
        if ((deleteselect == 1 && key_jump) || (deleteselect == 0 && deletebuffer >= 120))
        {
            if (deleteselect == 0)
            {
                var f = concat("saves/saveData", (currentselect + 1), ".ini")
                if file_exists(f)
                    file_delete(f)
                if (currentselect == 0)
                    global.percentage_1 = 0
                else if (currentselect == 1)
                    global.percentage_2 = 0
                else if (currentselect == 2)
                    global.percentage_3 = 0
                global.game_started[currentselect] = 0
                global.game_snotty[currentselect] = 0
                global.game_john[currentselect] = 0
                global.game_judgement[currentselect] = "none"
                global.game_palette[currentselect] = 1
                global.game_palettetexture[currentselect] = -4
                fmod_event_one_shot_3d("event:/sfx/misc/explosion", 480, 270)
                fmod_event_one_shot_3d("event:/sfx/mort/mortdead", 480, 270)
                with (obj_menutv)
                {
                    if (trigger == other.currentselect && sprite_index == selectedspr)
                        sprite_index = transspr
                }
                with (obj_camera)
                {
                    shake_mag = 4
                    shake_mag_acc = (5 / room_speed)
                }
            }
            state = (0 << 0)
        }
        break
    case (289 << 0):
        exitselect += (key_left2 + key_right2)
        exitselect = clamp(exitselect, 0, 1)
        if key_jump
        {
            if (exitselect == 0)
                game_end()
            else
                state = (0 << 0)
        }
        break
}

if (state != (18 << 0) && state != (8 << 0))// && currentselect != 3)
    extrauialpha = Approach(extrauialpha, 1, 0.1)

//if (currentselect == 3)
//    extrauialpha = Approach(extrauialpha, 0, 0.1)

if (currentselect == 0)
    percentage = global.percentage_1
else if (currentselect == 1)
    percentage = global.percentage_2
else if (currentselect == 2)
    percentage = global.percentage_3
if (currentselect != -1 and currentselect != 3)
{
    snotty = global.game_snotty[currentselect]
    john = global.game_john[currentselect]
    judgement = global.game_judgement[currentselect]
}
perstatus_icon = floor((percentage / 14.285714285714286))
if (state != (18 << 0) && state != (8 << 0))
{
    var a = (floor((abs((percvisual - percentage)) / 10)) + 1)
    percvisual = Approach(percvisual, percentage, a)
}
if (perstatus_icon > (sprite_get_number(spr_percentstatemenu) - 1))
    perstatus_icon = (sprite_get_number(spr_percentstatemenu) - 1)
if (percentage >= 101)
    perstatus_icon = 8
with (obj_menutv)
{
    if (trigger == other.currentselect)
        selected = 1
    else
        selected = 0
}
if gamepad_button_check_pressed(obj_inputAssigner.player_input_device[0], gp_shoulderrb)
{
    punch_x = (x + irandom_range(-40, 40))
    punch_y = (y + irandom_range(-30, 30))
    event_user(0)
}
