IncludeScript("terrainNodeClass", null);

function PreSpawnInstance(entityClass, entityName) {
    local keyvalues = {

    };

    return keyvalues;
}

function PostSpawn(entities) {
    local NODE_CLASS = null;
    local rootTable = getroottable();
    foreach(targetname, handle in entities) {
        if (NODE_CLASS == null) {
            rootTable["LOGGER"].push("Creating a new node...");
            NODE_CLASS = TerrainNode(PATH_STATE.STRAIGHT, KESHIKI.STRAIGHT, 1, 1);
        }
        rootTable["LOGGER"].push("Adding the following - Handle: " + handle + " w/ targetname of: " + targetname);
        NODE_CLASS.addEntityList(handle);
    }

    if ("TEMP_NODES" in rootTable) {
        rootTable["LOGGER"].push("TEMP_NODES exists in the rootTable. Pushing this node to TEMP_NODE for persistent purpose");
        rootTable["TEMP_NODES"].push(NODE_CLASS);
    }
}