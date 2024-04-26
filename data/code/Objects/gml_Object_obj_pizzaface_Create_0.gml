maxspeed = 8
image_speed = 0.35
depth = -5
savedcx = camera_get_view_x(view_camera[0])
savedcy = camera_get_view_y(view_camera[0])
savedx = x
savedy = y
x = obj_player1.x
y = obj_player1.y
alarm[1] = 10
//this is NOT image_alpha, it's a new variable that keeps track of what alpha value pizzaface should have
//as a workaround for the disappearing tiles bug which I assume is caused by the tiles incorrectly
//reading pizzafaces' create code (for some reason)
img_alpha = 0
treasure = 0
snd = fmod_event_create_instance("event:/sfx/pizzaface/moving")
