global.songsPlaying = struct_new();
global.audioPlayers = [];
global.fullVolume = 1;

wasKidspartyPlaying = false;

wasPaused = false;
carryTime = 0;

audio_falloff_set_model(audio_falloff_linear_distance);