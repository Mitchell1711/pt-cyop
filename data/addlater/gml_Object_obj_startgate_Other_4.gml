if (!variable_instance_exists(id, "targetRoom"))
{
    targetRoom = 0
}
if (levelName != "")
{
    level = levelName;
    if (!is_string(targetRoom))
    {
        targetRoom = "main";
    }
    var sett = level_load(level);
    if (sett.titlecardSprite != "no titlecard")
    {
        titlecard_sprite = _spr(sett.titlecardSprite);
        title_sprite = _spr(sett.titleSprite);
        if (sett.titleSong != "")
        {
            title_music = sett.titleSong;
        }
        //show_message(titlecard_sprite)
    }
    else
    {
        noTitlecard = true;
    }
}
if global.panic
{
    instance_destroy()
    instance_create(x, (y + 144), obj_rubble)
}
switch targetRoom
{
    case 24:
    case 39:
    case 54:
    case 71:
        world = 1
        break
    case 99:
    case 123:
    case 137:
    case 157:
        world = 2
        break
    case 178:
    case 194:
    case 229:
        world = 3
        break
    case 241:
    case 390:
    case 830:
    case 526:
        world = 4
        break
    case 424:
    case 441:
    case 405:
    case 470:
        world = 5
        break
    case 513:
        level = "b_pepperman"
        break
    case 514:
        level = "b_vigilante"
        break
    case 515:
        level = "b_noise"
        break
    case 783:
        level = "b_fakepep"
        break
    case 659:
        level = "b_pizzaface"
        break
}

if (targetRoom == 513 || targetRoom == 514 || targetRoom == 515 || targetRoom == 783)
    boss = 1
if (object_index != obj_bossdoor)
{
    var old_y = y
    if scr_solid(x, y)
    {
        while scr_solid(x, y)
        {
            y--
            if (y < sprite_height)
            {
                y = old_y
                break
            }
            else
                continue
        }
    }
}
ini_open_from_string(obj_savesystem.ini_str)
highscore = ini_read_real("Highscore", string(level), 0)
hats = ini_read_real("Hats", string(level), 0)
secret_count = ini_read_string("Secret", string(level), 0)
toppin[0] = ini_read_real("Toppin", (string(level) + "1"), 0)
toppin[1] = ini_read_real("Toppin", (string(level) + "2"), 0)
toppin[2] = ini_read_real("Toppin", (string(level) + "3"), 0)
toppin[3] = ini_read_real("Toppin", (string(level) + "4"), 0)
toppin[4] = ini_read_real("Toppin", (string(level) + "5"), 0)
rank = ini_read_string("Ranks", string(level), "d")
ini_close()
var _toppinspr = [[1655, 1653, 1698, -75], [1645, 1644, 271, -35], [1649, 1648, 2120, 0], [1638, 1636, 3997, 35], [1630, 1629, 4193, 75]]
for (var i = 0; i < array_length(_toppinspr); i++)
{
    var b = _toppinspr[i]
    if toppin[i]
    {
        with (instance_create((x + b[3]), (y + 100), obj_toppinprop))
        {
            tauntspr = b[2]
            movespr = b[1]
            idlespr = b[0]
            if place_meeting(x, y, obj_platform)
                y -= 2
        }
    }
}
if (object_index == obj_startgate && level != "exit" && level != "tutorial")
{
    for (i = 1; i <= 3; i++)
    {
        b = 1
        if (i > secret_count)
            b = 0
        with (instance_create(x, y, obj_startgate_secreteye))
        {
            last_current_time = (current_time + ((600000 * i) * 2))
            timer = last_current_time
            trace(other.level, " secret eye ", i, timer)
            time_x += (i - 1)
            time_y += ((i - 1) * 2)
            if b
                sprite_index = spr_gatesecreteyeopen
            else
                sprite_index = spr_gatesecreteyeclosed
        }
    }
}
switch level
{
    case "entrance":
        msg = "ENTRANCE"
        break
    case "medieval":
        msg = "PIZZASCAPE"
        break
    case "chateau":
        msg = "PIZZASCARE"
        break
    case "ruin":
        msg = "TEH ANCIENT CHEESE"
        break
    case "dungeon":
        msg = "BLOODSAUCE DUNGEON"
        break
    case "floorroom":
        msg = "OREGANO DESERT"
        break
    case "graveyard":
        msg = "THE WASTEYARD"
        break
    case "farm":
        msg = "FUN FARM"
        break
    case "ufo":
        msg = "SPACE PINBALL"
        break
    case "strongcold":
        msg = "STRONGCOLD"
        break
    case "forest":
        msg = "GNOME FOREST"
        break
    case "beach":
        msg = "PINEAPPLE BEACH"
        break
    case "dragonlair":
        msg = "DRAGON LAIR"
        break
    case "snickchallenge":
        msg = "SNICK CHALLENGE"
        break
}

scr_hub_bg_reinit(x, y)
