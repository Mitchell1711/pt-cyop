//only one is allowed to exist
if (instance_number(object_index) > 1)
{
    instance_destroy()
    return;
}
//initialize practiceinput
scr_init_input_practice()
scr_initpracticeinput()
savestates = array_create(12, [])
saveslot = 0
doingstatestuff = false
spaceblockstate = 0
savedmodfolder = global.modFolder
savesystemnames = ["baddieroom", "escaperoom", "saveroom"]