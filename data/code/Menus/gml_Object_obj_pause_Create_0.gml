pause = 0
i = 0
color = make_color_rgb(121, 103, 151)
scr_init_input()
player1 = -4
player2 = -4
selected = 0
stickpressed = 0
image_speed = 0
depth = -500
backbuffer = 0
savedmusicmuffle = 0
pause_menu = ["pause_resume", "pause_options", "pause_restart", "pause_exit"]
cursor_index = 0
cursor_sprite_number = sprite_get_number(spr_angelpriest)
cursor_sprite_height = sprite_get_height(spr_angelpriest)
cursor_x = -1000
cursor_y = -1000
cursor_actualx = 0
cursor_actualy = 0
update_cursor = 0
hub = 1
treasurefound = 0
treasurealpha = 0
secretcount = 0
secretalpha = 0
transfotext = -4
transfotext_size = 0
roomtorestart = -4
pausemusicID = fmod_event_create_instance("event:/music/pause")
savedsecretpause = 0
savedmusicpause = 0
savedpillarpause = 0
savedpanicpause = 0
savedkidspartypause = 0
fade = 0
fadein = 0
screensprite = -4
screensize = 0
guisprite = -4
instance_list = ds_list_create()
sound_list = ds_list_create()
priest_list = ds_list_create()
start = 0
pause_icons = array_create(0)
scr_pauseicon_add(spr_pauseicons, 0, -20, -12)
scr_pauseicon_add(spr_pauseicons, 1, 5, -15)
scr_pauseicon_add(spr_pauseicons, 2, -10)
scr_pauseicon_add(spr_pauseicons, 3, -10)
alarm[1] = 1
