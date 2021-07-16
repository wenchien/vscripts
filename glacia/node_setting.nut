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
            local randomPathType = RandomInt(0, 2);
            switch(randomPathType) {
                case 0 : NODE_CLASS = TerrainNode(PATH_STATE.STRAIGHT, KESHIKI.STRAIGHT, 1, 1);
                        break;
                case 1 : NODE_CLASS = TerrainNode(PATH_STATE.RIGHT_TURN, KESHIKI.STRAIGHT, 1, 1);
                        break;
                case 2 : NODE_CLASS = TerrainNode(PATH_STATE.LEFT_TURN, KESHIKI.STRAIGHT, 1, 1);
                        break;
            }

        }
        rootTable["LOGGER"].push("Adding the following - Handle: " + handle + " w/ targetname of: " + targetname);
        NODE_CLASS.addEntityList(handle);
    }

    if ("TEMP_NODES" in rootTable) {
        rootTable["LOGGER"].push("TEMP_NODES exists in the rootTable. Pushing this node to TEMP_NODE for persistent purpose");
        rootTable["TEMP_NODES"].push(NODE_CLASS);
    }
}