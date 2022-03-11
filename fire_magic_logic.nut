ITEM_MANAGER <- Entities.FindByName(null, "itemManager");
ITEM_ELITE <- Entities.FindByName(null, "fire_magic_elites");
FIRE_MAGIC_MAKER <- Entities.FindByName(null, "fire_magic_maker");
PLAYER_COUNT <- 20;
AUGMENTED <- false;

FIRE_MAGIC_COOLDOWNS <- [5.00, 20.00, 60.00, 120.00];
DMG <- [200, 400, 800, 1500];

TEMP_ITEM_LEVEL <- ITEM_MANAGER.GetScriptScope().getItemLevelData(ITEM_ELITE.GetScriptScope().ITEM_TYPE);

function fireMagicRelay() {
    ITEM_MANAGER.ValidateScriptScope();
    ITEM_ELITE.ValidateScriptScope();
    local itemLevel = TEMP_ITEM_LEVEL;

    local hooman = null;
    local candidates = [];
    while (null != (hooman = Entities.FindInSphere(hooman, ITEM_ELITE.GetOrigin(), 512))) {
        if (hooman.GetClassname() == "player" && hooman.GetTeam() == 3) {
            candidates.push(hooman); //if everything required is OK, add the target to the list of candidates
        }
    }

    local hoomanCount = candidates.len();
    if (hoomanCount < PLAYER_COUNT) {
        EntFire("fire_magic_btn", "Lock", null, 0.00, null);
        EntFire("fire_magic_btn", "Unlock", null, 10.00, null);
    } else {
        EntFire("fire_magic_btn", "Lock", null, 0.00, null);
        switch (itemLevel) {
            case 0:
                EntFireByHandle(FIRE_MAGIC_MAKER, "AddOutput", "EntityTemplate fire_magic_level_0", 0.00, null, null);
                break;
            case 1:
                EntFireByHandle(FIRE_MAGIC_MAKER, "AddOutput", "EntityTemplate fire_magic_level_1", 0.00, null, null);
                break;
                //Increase dmg
            case 2:
                EntFireByHandle(FIRE_MAGIC_MAKER, "AddOutput", "EntityTemplate fire_magic_level_1", 0.00, null, null);
                break;
            case 3:
                EntFireByHandle(FIRE_MAGIC_MAKER, "AddOutput", "EntityTemplate fire_magic_level_3", 0.00, null, null);
                break;
        }

        local fire_dmg_hurt = Entities.FindByName("fire_dmg_hurt");
        EntFireByHandle(fire_dmg_hurt, "AddOutput", "Damage " + DMG[itemLevel], 0.00, null, null);
        EntFire("fire_magic_maker", "ForceSpawn", null, 1.00, null);
        EntFireByHandle(self, "RunScriptCode", "setMovelinearLevel(" + itemLevel + ");", 1.20, null, null);
        EntFire("fire_magic_btn", "Unlock", null, FIRE_MAGIC_COOLDOWNS[itemLevel], null);
    }
}

function setMovelinearLevel(lvl) {
    local fireMovelinear = Entities.FindByName("fire_magic_movelinear*");
    fireMovelinear.ValidateScriptScope();
    fireMovelinear.GetScriptScope().setLevel(TEMP_ITEM_LEVEL);
}