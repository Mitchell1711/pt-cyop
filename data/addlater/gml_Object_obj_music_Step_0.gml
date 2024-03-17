prevpillar_on_camera = pillar_on_camera
if (fmod_event_instance_is_playing(kidspartychaseID) && instance_exists(obj_pause) && (!obj_pause.pause) && (!instance_exists(obj_monster)))
{
    trace("Stopping kidsparty music")
    fmod_event_instance_stop(kidspartychaseID, 0)
    instance_destroy(obj_kidspartybg)
    if (music != noone)
    {
        fmod_event_instance_set_paused(music.event, savedmusicpause)
        fmod_event_instance_set_paused(music.event_secret, savedsecretpause)
    }
    fmod_event_instance_set_paused(pillarmusicID, savedpillarpause)
    fmod_event_instance_set_paused(panicmusicID, savedpanicpause)
}
if instance_exists(obj_hungrypillar)
{
    fmod_event_instance_set_paused(pillarmusicID, 0)
    var p = 0
    with (obj_hungrypillar)
    {
        if bbox_in_camera(view_camera[0], 0)
            p = 1
    }
    if (p != pillar_on_camera)
        pillar_on_camera = p
}
else
    pillar_on_camera = 0
if (prevpillar_on_camera != pillar_on_camera)
{
    if pillar_on_camera
        fmod_set_parameter("pillarfade", 1, 0)
    else
        fmod_set_parameter("pillarfade", 0, 0)
}
if global.panic
{
    if (!panicstart)
    {
        trace("Starting panic music: step")
        panicstart = 1
        if (room != tower_finalhallway)
        {
            fmod_event_instance_play(panicmusicID)
            fmod_event_instance_set_paused(panicmusicID, 0)
            fmod_event_instance_set_parameter(panicmusicID, "state", 0, 1)
        }
        if (music != noone)
        {
            fmod_event_instance_stop(music.event, 1)
            fmod_event_instance_stop(music.event_secret, 1)
        }
        if (room == tower_finalhallway)
        {
            exitmusic = 1
            fmod_event_instance_stop(panicmusicID)
            fmod_event_instance_play(music.event)
        }
        fmod_event_instance_stop(pillarmusicID, 1)
        fmod_set_parameter("pillarfade", 0, 1)
        fmod_event_instance_set_parameter(panicmusicID, "state", 0, 1)
    }
    else if fmod_event_instance_is_playing(panicmusicID)
    {
        if (!global.lap)
        {
            if (global.fill <= 672)
                fmod_event_instance_set_parameter(panicmusicID, "state", 1, 1)
        }
        else
            fmod_event_instance_set_parameter(panicmusicID, "state", 2, 1)
    }
}
else
{
    panicstart = 0
    fmod_event_instance_stop(panicmusicID, 1)
}
var _found = 0
with (obj_totem)
{
    if (fmod_event_instance_is_playing(snd) && distance_to_object(obj_player1) <= 400)
        _found = 1
}
with (obj_player)
{
    if (state == (46 << 0))
        _found = 1
}
if _found
    fmod_set_parameter("totem", 1, 0)
else
{
    fmod_set_parameter("totem", 0, 0)
    if instance_exists(obj_bossdark)
        fmod_set_parameter("totem", 1, 0)
    if instance_exists(obj_charswitch_intro)
        fmod_set_parameter("totem", 2, 0)
}
if (exitmusic && fmod_event_instance_is_playing(panicmusicID))//
    fmod_event_instance_stop(panicmusicID, 1)
