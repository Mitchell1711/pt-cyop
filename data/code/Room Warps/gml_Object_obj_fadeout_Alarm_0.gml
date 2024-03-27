if instance_exists(obj_player)
{
    if (custom_level == 0)
    {
        with (obj_player)
        {
            if place_meeting(x, y, obj_goldendoor)
                game_restart()
        }
        var tRoom = obj_player1.targetRoom;
        if (tRoom == rmCustomLevel)
        {
            tRoom = global.secretRoomFix[0];
        }
        if (!is_string(tRoom))
        {
            if (room != obj_player1.targetRoom || roomreset)
            {
                scr_room_goto(obj_player1.targetRoom)
                with (obj_player)
                {
                    if (state == (7 << 0) || state == (152 << 0))
                    {
                        visible = true
                        state = (0 << 0)
                    }
                }
            }
            if (global.coop == 1)
            {
                if (room != obj_player2.targetRoom || roomreset)
                    scr_room_goto(obj_player1.targetRoom)
                with (obj_player)
                {
                    if (state == (7 << 0))
                        state = (0 << 0)
                }
                with (obj_player2)
                {
                    if instance_exists(obj_coopplayerfollow)
                        state = (186 << 0)
                }
            }
        }
        else
        {
            var lvl = global.levelName;
            var rm = tRoom;
            
            if (rm == global.currentRoom and lvl == global.currentLevel)
            {
                with obj_player
                {
                    event_perform(ev_other, ev_room_start);
                }
                exit;
            }
            /*if (rm == "secret" or rm == "room4")
            {
                show_message("sas")
            }*/
            /*var fName = "mod_assets/levels/" + lvl + "/rooms/" + rm + ".json";
            //show_message(fName);
            if (!file_exists(fName))
            {
                show_error("room " + fName + " doesn't exist.", true);
            }
            var f = file_text_open_read(fName);
            var jText = file_text_read_all(f);
            var data = json_parse(jText);*/
            //var data = roomFile_getData(lvl, rm);
            //file_text_close(f);
            
            var lTime = current_time;
            var fName = mod_folder("levels/") + lvl + "/rooms/" + rm + ".json";
            //show_message(fName);
            if (!file_exists(fName))
            {
                show_error("room " + fName + " doesn't exist.", false);
            }
            var jText = file_text_read_all(fName);
            global.roomData = json_parse(jText);
            global.roomData = data_compatibility(global.roomData);
            //show_message((current_time - lTime) / 1000)
            
            //show_message(data)
            prepareCustomLevel(global.roomData, tRoom);
            
            with (obj_player)
            {
                if (state == (7 << 0) || state == (152 << 0))
                {
                    visible = true
                    state = (0 << 0)
                }
            }
        }
    }
}
