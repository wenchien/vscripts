function PreSpawnInstance(entityClass, entityName) {
    local keyvalues = {

    };

    //do nothing
    //test changes
    return keyvalues
}

function PostSpawn(entities) {
    local NODE_CLASS = null;

    foreach(targetname, handle in entities) {
        local random_scale = RandomFloat(0.50, 2.00);
        local rootTable = getroottable();
        if ("TEMP_ENTITY_LIST" in rootTable) {
            rootTable["TEMP_ENTITY_LIST"].push(handle);
        }
        //EntFireByHandle(handle, "AddOutput", "modelscale " + random_scale, 0.00, null, null);
    }

}