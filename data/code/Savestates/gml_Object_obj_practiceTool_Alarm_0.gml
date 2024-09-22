var save = savestates[saveslot]

//update the savesystem lists inside of the savestate with the updated ids (these are updated on room load)
variable_struct_set(save, "savesystem", saveGlobals(savesystemnames))

//load objects
loadstatevariables()

//update spaceblock state after objects are loaded back in
global.spaceblockswitch = spaceblockstate

doingstatestuff = false