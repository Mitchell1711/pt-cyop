if (seenTitlecard)
{
    loadCustomLevel(towerList[towerSelected][2], false);
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
            if (sett.titleSong != "")
            {
                title_music = sett.titleSong;
            }
        }
    }
    seenTitlecard = true;
    alarm[0] = 15 + 180;
}