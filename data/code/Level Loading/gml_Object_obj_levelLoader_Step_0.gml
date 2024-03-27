var rem = [];
for (var i = 0; i < array_length(roomInsts); i ++)
{
    var escapeException = (roomInsts[i][3] and !global.panic)
    if ( (!instance_exists(roomInsts[i][0]) ) and !escapeException)
    {
        if (!array_value_exists(struct_get(global.objectData, "overrideDestructionMemory"), object_get_name(roomInsts[i][2])))
        {
            levelMemory_set(global.currentRoom + "_" + string(roomInsts[i][1]), variable_struct_exists(respawnOnLap2, string(roomInsts[i][1])));
        }
        array_push(rem, i);
    }
}
for (var j = 0; j < array_length(rem); j ++)
{
    array_delete(roomInsts, rem[j] - j, 1);
}

for (var j = 0; j < array_length(layerForce); j ++)
{
    var l = layerForce[j][1]
    with (layerForce[j][0])
    {
        layer = l;
    }
}