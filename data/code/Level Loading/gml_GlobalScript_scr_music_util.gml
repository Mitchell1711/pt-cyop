function add_music(argument0, argument1, argument2, argument3, argument4) //gml_Script_add_music
{//
    if (argument4 == undefined)
        argument4 = -4
    var b = struct_new([
        ["continuous", argument3],
        ["on_room_start", -4],
        ["value", 0],
        ["immediate", 0],
        ["event", -4],
        ["event_secret", -4]
    ])

    with (b)
    {
        if (argument4 != -4)
            on_room_start = method(self, argument4)
        if (argument1 != -4)
        {
            event_name = argument1
            event = fmod_event_create_instance(argument1)
        }
        if (argument2 != -4)
        {
            event_secret_name = argument2
            event_secret = fmod_event_create_instance(argument2)
        }
    }
    ds_map_set(music_map, argument0, b)
    return b;
}

function stop_music() //gml_Script_stop_music
{
    with (obj_music)
    {
        if (music != noone)
        {
            if obj_pause.pause
            {
                fmod_event_instance_stop(music.event, 1)
                fmod_event_instance_stop(music.event_secret, 1)
            }
            else
            {
                fmod_event_instance_stop(music.event, 0)
                fmod_event_instance_stop(music.event_secret, 0)
            }
        }
        fmod_event_instance_stop(pillarmusicID, 1)
        fmod_event_instance_stop(panicmusicID, 1)
    }
}

function hub_state(argument0, argument1, argument2) //gml_Script_hub_state
{
    var s = 0
    switch argument0
    {
        case 756:
        case 777:
        case 814:
        case 803:
        case 809:
            s = 0
            break
        case 752:
        case 778:
        case 815:
        case 810:
            s = 1
            break
        case 748:
        case 780:
        case 816:
        case 811:
            s = 2
            break
        case 744:
        case 781:
        case 817:
        case 812:
        case 808:
            s = 3
            break
        case 740:
        case 818:
        case 807:
        case 813:
            s = 4
            break
    }

    fmod_event_instance_set_parameter(argument1, "hub", s, 0)
}

function music_get_pos_wrap(argument0, argument1) //gml_Script_music_get_pos_wrap
{
    while (argument0 > argument1)
        argument0 -= argument1
    if (argument0 < 1)
        argument0 = 1
    return argument0;
}

