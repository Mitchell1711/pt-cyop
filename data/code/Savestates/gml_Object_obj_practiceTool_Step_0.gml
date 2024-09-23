//savestates are allowed to be used in these rooms
if(room != rmCustomLevel && room != timesuproom){
    return;
}
//prevent savestates from being used based on these conditions
if(!global.dosavestates || doingstatestuff || obj_pause.pause){
    return;
}

scr_getinput_practice()
//wipe savestates if another mod has been opened
if(savedmodfolder != global.modFolder){
    savestates = array_create(12, undefined)
}

//input handling for fancy savestates (multiple slots)
if(global.savestatetype == "fancy"){
    loadorsave = (slot1 || slot2 || slot3 || slot4 || slot5 || slot6 || slot7 || slot8 || slot9 || slot0)

    if loadorsave
    {
        if slot1
            saveslot = 1
        else if slot2
            saveslot = 2
        else if slot3
            saveslot = 3
        else if slot4
            saveslot = 4
        else if slot5
            saveslot = 5
        else if slot6
            saveslot = 6
        else if slot7
            saveslot = 7
        else if slot8
            saveslot = 8
        else if slot9
            saveslot = 9
        else if slot0

        saveslot = 0
        if savestate{
            createsavestate()
        }
        else{
            loadstate()
        }
    }
}
//input handling for fast savestates (single slot)
else if(global.savestatetype == "fast"){
    if(savestatefast){
        saveslot = 1
        createsavestate()
    }
    else if(loadstatefast){
        saveslot = 1
        loadstate()
    }
}

if(reloadroom){
    saveslot = 10
    loadstate()
}

if(last_room){
    saveslot = 11
    loadstate()
}