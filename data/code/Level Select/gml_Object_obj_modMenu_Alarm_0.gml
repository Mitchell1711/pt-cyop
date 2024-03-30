if (seenTitlecard)
{
    //if swap mode was chosen go to the character select menu instead of immediately loading a level
    if(global.charSelected == 2){
        obj_player1.targetRoom = characterselect
        instance_create(0, 0, obj_fadeout)
    }
    else{
        loadCustomLevel(towerList[towerSelected][2], false);
    }
}
else
{
    var sett = level_load(towerList[towerSelected][2])
    if (!instance_exists(obj_titlecard))
    {
        with (instance_create(x, y, obj_titlecard))
        {
            //group_arr = gate.group_arr
            titlecard_sprite = _spr(sett.titlecardSprite);
            titlecard_index = 0
            title_sprite = _spr(sett.titleSprite);
            title_index = 0
            noisespots = sett.noiseHeads
            //if youre playing as noise/swapmode and the noise titlesong exists load that in
            if(sett.titleSongN != "" && (!obj_player1.ispeppino || global.swapmode)){
                title_music = sett.titleSongN
            }
            //otherwise load the standard titlemusic
            else if (sett.titleSong != "")
            {
                title_music = sett.titleSong;
            }
        }
    }
    seenTitlecard = true;
    alarm[0] = 15 + 180;
}