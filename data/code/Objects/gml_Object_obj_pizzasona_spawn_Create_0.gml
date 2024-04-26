event_inherited();

var spawnIt = true;
with (obj_secretportal)
{
    if (instance_nearest(x, y, obj_bigcollect) == other.id)
    {
        spawnIt = false;
    }
}

if (!spawnIt)
    exit;
    
visible = false
value = 150
with (instance_create(x, (y - 42), obj_pizzasonacollect))
    collectID = other.id