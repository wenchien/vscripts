function PreSpawnInstance( entityClass, entityName ) {
    local keyvalues = {};
    if ("func_movelinear" == entityClass) {
        local splitted = split(entityName, "_");
        local player = null;
        itemElite = Entities.FindByName(null, splitted[0] + "_magic_elites");

        player = itemElite.GetMoveParent();
        local result =  player.GetAngles() + "";
        keyvalues =
        {

            movedir = "0 " + player.GetAngles().y + " 0",
            movedistance = "500",
            speed = "50",
            spawnflag = "8"
        };
    }

    return keyvalues;
}

function PostSpawn( entities ) {
    foreach (targetname, handle in entities) {
        if ("func_movelinear" == handle.GetClassName()) {
            printl("movelinear moving");
            handle.ValidateScriptScope();
            handle.GetScriptScope().movelinearTick();
            EntFireByHandle(handle, "Open", "", 0.10, null, null);
        }
    }

}