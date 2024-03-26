if (active && sprite_index != spr_secretportal_open && (!instance_exists(obj_jumpscare)) && ds_list_find_index(global.saveroom, id) == -1)
{
    if (sprite_index != spr_secretportal_close)
    {
        sprite_index = spr_secretportal_close
        image_index = 0
        fmod_event_one_shot_3d("event:/sfx/misc/secretenter", x, y)
    }
    if (!touched)
    {
        with (obj_camera)
            lock = 1
        if secret
        {
            notification_push((27 << 0), [room])
        }
        else
        {
            global.secretRoomFix = [global.currentRoom, instID]
            notification_push((26 << 0), [room, targetRoom])
        }
        if (room != rmCustomLevel)
        {
            if (!secret)
            {
                obj_music.secret = 1
                obj_music.secretend = 0
            }
            else
            {
                obj_music.secretend = 1
                obj_music.secret = 0
            }
        }
    }
    playerid = other.id
    other.ghostpepper = 0
    other.ghostdash = 0
    other.x = x
    other.y = (y - 30)
    other.vsp = 0
    other.hsp = 0
    other.cutscene = 1
    other.brick = 1
    with (obj_brickcomeback)
    {
        create_particle(x, y, (9 << 0))
        instance_destroy()
    }
    if (!touched)
    {
        other.superchargedeffectid = -4
        if (other.state != (47 << 0) && other.state != (38 << 0) && other.state != (49 << 0) && other.state != (10 << 0))
        {
            if (!other.isgustavo)
                other.sprite_index = other.spr_hurt
            else
                other.sprite_index = spr_player_ratmounthurt
            other.image_speed = 0.35
        }
        if (other.state == (38 << 0))
        {
            other.sprite_index = other.spr_knightpepfall
            other.state = (47 << 0)
            other.hsp = 0
            other.vsp = 0
        }
        other.tauntstoredstate = other.state
        other.tauntstoredmovespeed = other.movespeed
        other.tauntstoredhsp = other.hsp
        other.tauntstoredvsp = other.vsp
        other.tauntstoredsprite = other.sprite_index
        other.state = (296 << 0)
    }
    touched = 1
    with (obj_heatafterimage)
        visible = false
    instance_destroy(obj_superchargeeffect)
}
