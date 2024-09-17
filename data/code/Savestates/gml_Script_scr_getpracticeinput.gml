//set values for pressed buttons on object
function scr_init_input_practice() //gml_Script_scr_init_input_practice
{
    slot1 = 0
    slot2 = 0
    slot3 = 0
    slot4 = 0
    slot5 = 0
    slot6 = 0
    slot7 = 0
    slot8 = 0
    slot9 = 0
    slot0 = 0
    savestate = 0
    savestatebasic = 0
    loadstatebasic = 0
}

//check for pressed input
function scr_getinput_practice() //gml_Script_scr_getinput_practice
{
    if ((!instance_exists(obj_debugcontroller)) || (!obj_debugcontroller.active))
    {
        slot1 = keyboard_check_pressed(global.slot1)
        slot2 = keyboard_check_pressed(global.slot2)
        slot3 = keyboard_check_pressed(global.slot3)
        slot4 = keyboard_check_pressed(global.slot4)
        slot5 = keyboard_check_pressed(global.slot5)
        slot6 = keyboard_check_pressed(global.slot6)
        slot7 = keyboard_check_pressed(global.slot7)
        slot8 = keyboard_check_pressed(global.slot8)
        slot9 = keyboard_check_pressed(global.slot9)
        slot0 = keyboard_check_pressed(global.slot0)
        savestate = keyboard_check(global.savestate)
        savestatebasic = keyboard_check_pressed(global.savestatebasic)
        loadstatebasic = keyboard_check_pressed(global.loadstatebasic)
    }
}

//Set globals to key values from ini
function scr_initpracticeinput(argument0) //gml_Script_scr_initpracticeinput
{
    ini_open("practicemod.ini")
    global.slot1 = ini_read_string("DebugKeys", "slot1", 49)
    global.slot2 = ini_read_string("DebugKeys", "slot2", 50)
    global.slot3 = ini_read_string("DebugKeys", "slot3", 51)
    global.slot4 = ini_read_string("DebugKeys", "slot4", 52)
    global.slot5 = ini_read_string("DebugKeys", "slot5", 53)
    global.slot6 = ini_read_string("DebugKeys", "slot6", 54)
    global.slot7 = ini_read_string("DebugKeys", "slot7", 55)
    global.slot8 = ini_read_string("DebugKeys", "slot8", 56)
    global.slot9 = ini_read_string("DebugKeys", "slot9", 57)
    global.slot0 = ini_read_string("DebugKeys", "slot0", 48)
    global.savestate = ini_read_string("DebugKeys", "savestate", 16)
    global.savestatebasic = ini_read_string("DebugKeys", "savestatebasic", 49)
    global.loadstatebasic = ini_read_string("DebugKeys", "loadstatebasic", 50)
    ini_close()
}

