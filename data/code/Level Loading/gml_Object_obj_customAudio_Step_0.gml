if (variable_global_exists("panic"))
{
    if (global.panic)
    {
        customSong_destroy_all();
    }
}

for (var i = 0; i < array_length(global.audioPlayers); i ++)
{
    var aStruct = global.audioPlayers[i];
    
    // volume fade
    if (aStruct.gain_transition)
    {
        var gainDir = sign(aStruct.gain_target - aStruct.gain);
        struct_set(aStruct, [["gain", aStruct.gain + gainDir * aStruct.gain_speed]])
        //if (gainDir < 0)
        if (gainDir == 1 and aStruct.gain >= aStruct.gain_target) or (gainDir == -1 and aStruct.gain <= aStruct.gain_target) or aStruct.gain == aStruct.gain_target
        {
            struct_set(aStruct, [["gain", aStruct.gain_target]])
            aStruct.gain_tansition = false;
        }
    }
    
    var gainMult = 1;
    with obj_music
    {
        if (kidspartychaseID != noone)
        {
            if (fmod_event_instance_is_playing(kidspartychaseID))
            {
                gainMult = 0;
            }
        }
    }
    
    audio_sound_gain(aStruct.audioPlayback, aStruct.gain * global.option_master_volume * global.option_music_volume * gainMult, 0);
    
    // loop points
    if (aStruct.audio_doesLoop)
    {
        var audioAss = aStruct.audioAsset;
        var loopPoints = audioAss.loopPoints
        if (!audioAsset_isLoopNormal(audioAss))
        {
            var endPoint = loopPoints[1];
            var checkForEnding = false;
            if (endPoint < 0)
            {
                endPoint = audio_sound_length(aStruct.audioPlayback) - 0.001;
                checkForEnding = true;
            }
            var trackPos = audio_sound_get_track_position(aStruct.audioPlayback);
            if (trackPos >= endPoint or (checkForEnding and !audio_is_playing(aStruct.audioPlayback)))
            {
                if (!audio_is_playing(aStruct.audioPlayback))
                {
                    audioPlayer_play(aStruct, false);
                }
                audio_sound_set_track_position(aStruct.audioPlayback, loopPoints[0])
            }
        }
    }
    
    if (aStruct.audioPlayback != -1)
    {
        carryTime = audio_sound_get_track_position(aStruct.audioPlayback) * 1000;
    }
    
    if (aStruct.fmodPlayback != noone)
    {
        if (fmod_event_instance_is_playing(aStruct.fmodPlayback))
        {
            aStruct.fmodTime = fmod_event_instance_get_timeline_pos(aStruct.fmodPlayback);
            carryTime = aStruct.fmodTime;
            
            
        }
        
        with obj_music
        {
            if (kidspartychaseID != noone)
            {
                if (fmod_event_instance_is_playing(kidspartychaseID))
                {
                    audioPlayer_fade(aStruct, 0, 0);
                    //show_message("start")
                    //fmod_event_instance_set_timeline_pos(aStruct.fmodPlayback, other.carryTime);
                }
                else if other.wasKidspartyplaying
                {
                    audioPlayer_fade(aStruct, 1, 0);
                }
            }
        }
    }
}

with obj_music
{
    if (kidspartychaseID != noone)
    {
        other.wasKidspartyplaying = (fmod_event_instance_is_playing(kidspartychaseID))
    }
}

if (global.levelName != global.hubLevel and room == rmCustomLevel)
{
    carryTime = 0;
}

var songs = variable_struct_get_names(global.songsPlaying)

for (var i = 0; i < array_length(songs); i ++)
{
    var aStruct = struct_get(global.songsPlaying, songs[i]);
    
    var isClose = false;
    var fadeSpeed = 1.75;
    
    if (instance_exists(obj_hungrypillar) and instance_exists(obj_player))
    {
        with (obj_hungrypillar)
        {
            if bbox_in_camera(view_camera[0], 0)
            {
                isClose = true;
                audio_emitter_position(aStruct.emitter, 0, 0, audio_emitter_get_z(aStruct.emitter) + fadeSpeed * sign(310 - audio_emitter_get_z(aStruct.emitter)));
            }
        }
    }
    
    if (!isClose)
    {
        audio_emitter_position(aStruct.emitter, 0, 0, audio_emitter_get_z(aStruct.emitter) + fadeSpeed * sign(0 - audio_emitter_get_z(aStruct.emitter)));
    }
    
    if (!audio_is_playing(aStruct.audioPlayback) and aStruct.fmodPlayback == noone)
    {
        customSong_destroy(songs[i])
    }
}