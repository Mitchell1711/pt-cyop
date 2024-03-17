if (!fadein)
{
    fadealpha = Approach(fadealpha, 1, 0.1)
    if (fadealpha >= 1)
    {
        fadein = 1
        start = 1
        music = 0
        alarm[0] = 180
    }
}
else
{
    fadealpha = Approach(fadealpha, 0, 0.1)
    if (fadealpha <= 0 && (!music) && title_music != -4)
    {
        music = 1
        var customSound = _sound(title_music)
        if (customSound == -1)
        {
            fmod_event_one_shot(title_music)
        }
        else
        {
            var ap = new_audioPlayer(title_music);
            audioPlayer_play(ap, false);
        }
    }
}
