function new_audioPlayer(argument0)
{
    var fst = 0;
    if (audioName_isFmod(argument0))
    {
        if (string_pos(".", argument0) != 0)
        {
            var sep = SplitString(argument0, ".");
            argument0 = sep[0];
            fst = real(sep[1])
        }
    }
    
    var aStruct = struct_new([
        ["audioName", argument0],
        ["audioAsset", _audio(argument0)],
        ["audio_isPlaying", false],
        ["audio_doesLoop", false],
        ["audioPlayback", -1],
        ["gain", 1],
        ["gain_target", 1],
        ["gain_speed", 1],
        ["gain_transition", false],
        ["emitter", audio_emitter_create()],
        ["isFmod", false],
        ["fmodState", fst],
        ["fmodPlayback", noone],
        ["fmodTime", 0],
    ])
    array_push(global.audioPlayers, aStruct);
    return aStruct;
}

function audioAsset_isLoopNormal(argument0) //audio asset struct
{
    var audioAss = argument0;
    if (audioAss.loopPoints[0] == 0 and audioAss.loopPoints[1] == -1)
    {
        return(true);
    }
    return(false);
}

function audioName_isFmod(argument0)
{
    return(string_pos("event:", argument0) != 0);
}

function audioPlayer_play(argument0, argument1, argument2) //audio player struct, if it loops, start gain
{
    
    var audioStruct = argument0;
    
    if (audioName_isFmod(argument0))
    {
        audioPlayer_playFmod(argument0, argument1);
        return;
    }
    
    var audioAss = audioStruct.audioAsset;
    var normalLoop = audioAsset_isLoopNormal(audioAss);
    
    if (is_undefined(argument2))
    {
        argument2 = 1;
    }
    audio_emitter_falloff(audioStruct.emitter, 10, 300, 1);
    
    //show_message(normalLoop);
    var gain = global.option_master_volume * global.option_music_volume * argument2;
    struct_set(audioStruct, [["audioPlayback", audio_play_sound_on(audioStruct.emitter, _sound(audioStruct.audioName), normalLoop and argument1, 1, gain)], ["audio_doesLoop", argument1], ["audio_isPlaying", true], ["gain", gain]]);
    //
}

function audioPlayer_playFmod(argument0, argument1) //audiostruct, does it loop...?
{
    //fmod_play_oneshot()
    var aStruct = argument0;
    struct_set(aStruct, [["isFmod", true], ["fmodPlayback", fmod_event_create_instance(aStruct.audioName)], ["audio_isPlaying", true]])
    fmod_event_instance_set_parameter(aStruct.fmodPlayback, "state", aStruct.fmodState, 0)
    fmod_event_instance_set_parameter(aStruct.fmodPlayback, "hub", aStruct.fmodState, 0)
    fmod_event_instance_play(aStruct.fmodPlayback);
    
    //show_message(aStruct.fmodPlayback)
}

function audioPlayer_stop(argument0) //audio player struct
{
    var audioStruct = argument0;
    
    if (audioStruct.audioPlayback != -1)
    {
        audio_stop_sound(audioStruct.audioPlayback);
        audioStruct.audioPlayback = -1;
    }
    
    struct_set(audioStruct, [["audio_isPlaying", false]]);
    
    if (audioStruct.fmodPlayback != noone)
    {
        fmod_event_instance_stop(audioStruct.fmodPlayback, 1)
        audioStruct.fmodPlayback = noone;
    }
}

function audioPlayer_pause(argument0, argument1) //audio player struct, resume instead
{
    var audioStruct = argument0;
    
    if (audioStruct.audioPlayback != -1)
    {
        struct_set(audioStruct, [["audio_isPlaying", !argument1]]);
        if (!argument1)
            audio_pause_sound(audioStruct.audioPlayback);
        else
            audio_resume_sound(audioStruct.audioPlayback);
    }
    
    if (audioStruct.fmodPlayback != -1)
    {
        struct_set(audioStruct, [["audio_isPlaying", !argument1]]);

        fmod_event_instance_set_paused(audioStruct.audioPlayback, !argument1);
    }
}

function audioPlayer_destroy(argument0) //audio struct
{
    var audioStruct = argument0;
    audioPlayer_stop(argument0);
    //show_message("");
    for (var i = 0; i < array_length(global.audioPlayers); i ++)
    {
        if (global.audioPlayers[i] == argument0)
        {
            array_delete(global.audioPlayers, i, 1);
        }
    }
}

function audioPlayer_fade(argument0, argument1, argument2) //struct, gain from 0-1 (automatically adjusted by game settings), time in milliseconds
{
    var audioStruct = argument0;
    
    if (audioStruct.audioPlayback != -1)
    {
        struct_set(audioStruct, [
            ["gain_target", argument1],
            ["gain_speed", (abs(audioStruct.gain - argument1) / (argument2 / 1000)) / 60 ], //1000 for milliseconds, 60 for frames
            ["gain_transition", true]
        ])
        //audio_sound_gain(audioStruct.audioPlayback, argument1 * global.fullVolume, argument2)
    }
    
    if (audioStruct.fmodPlayback != noone)
    {
        if (argument1 <= 0)
        {
            //fmod_event_instance_set_parameter(audioStruct.fmodPlayback, "state", -1, 1)
            fmod_event_instance_stop(audioStruct.fmodPlayback, 0)
            
            //show_message("sup")
        }
        else
        {
            if (!fmod_event_instance_is_playing(audioStruct.fmodPlayback))
            {
                fmod_event_instance_play(audioStruct.fmodPlayback);
                fmod_event_instance_set_timeline_pos(audioStruct.fmodPlayback, audioStruct.fmodTime);
            }
        }
    }
}



/// song specific shits

function customSong_add(argument0, argument1) //audio name, starting volume
{
    var ap = new_audioPlayer(argument0);
    struct_set(global.songsPlaying, [[argument0, ap]]);
    audioPlayer_play(ap, true, argument1);
    //show_message(argument0)
}

function customSong_switch(argument0, argument1)
{
    with (obj_customAudio)
    {
        var sp = global.songsPlaying;
        var songName = argument0;
        if (is_undefined(argument1))
        {
            argument1 = 100;
        }
        var songs = variable_struct_get_names(global.songsPlaying);
        if (array_length(songs) == 0) //if there are no songs playing then it's assumed it's the start of the level so song plays at full volume
        {
            customSong_add(songName);
        }
        else
        {
            if (!variable_struct_exists(sp, argument0)) //add song if it doesn't exist, start with volume 0
            {
                customSong_add(argument0, 0);
            }
            array_push(songs, argument0);
            for (var i = 0; i < array_length(songs); i ++) //fade out all other songs and fade in this one
            {
                if (variable_struct_exists(sp, songName))
                {
                    var vol = 0;
                    if (songs[i] == argument0)
                    {
                        vol = 1;
                    }
                    var as = struct_get(sp, songs[i]);
                    audioPlayer_fade(as, vol, argument1)
                    
                    if (global.levelName == global.hubLevel)
                    {
                        if (as.isFmod)
                        {
                            fmod_event_instance_set_timeline_pos(as.fmodPlayback, carryTime);
                        }
                        else
                        {
                            audio_sound_set_track_position(as.audioPlayback, carryTime / 1000);
                        }
                    }
                }
            }
        }
    }
}

function customSong_destroy(argument0) // song name
{
    var s = struct_get(global.songsPlaying, argument0);
    audioPlayer_destroy(s);
    variable_struct_remove(global.songsPlaying, argument0);
}

function customSong_destroy_all()
{
    var songs = variable_struct_get_names(global.songsPlaying);
    for (var i = 0; i < array_length(songs); i ++) //destroy them all
    {
        customSong_destroy(songs[i])
    }
}

function customSong_fadeout_all()
{
    var songs = variable_struct_get_names(global.songsPlaying);
    for (var i = 0; i < array_length(songs); i ++) //destroy them all
    {
        var as = struct_get(global.songsPlaying, songs[i])
        audioPlayer_fade(as, 0, 1500);
    }
}

function customSong_handle_pause(argument0) //true is pause, false is resume
{
    var songs = variable_struct_get_names(global.songsPlaying);
    for (var i = 0; i < array_length(songs); i ++)
    {
        var s = struct_get(global.songsPlaying, songs[i])
        audioPlayer_pause(s, !argument0);
    }
}