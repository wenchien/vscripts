ITEM_TYPE <- "";
TICK_RATE <- 0.50;

ITEM_MANAGER <- Entities.FindByName(null, "itemManager");

function OnPlayerPickUp(id) {
    ITEM_MANAGER.ValidateScriptScope();
    foreach(k,v in ITEM_MANAGER.GetScriptScope().ITEM_IDS) {
        if (v == id) {
            ITEM_TYPE = k;
        }
    }

    // Set item owner
    if (activator != null && activator.IsValid() && activator.GetHealth() > 0 && activator.GetTeam() == 3) {
        ITEM_MANAGER.GetScriptScope().ITEM_OWNERS[ITEM_TYPE] = activator;
    }

    validateOwner();
}

// Runs on timer loop
function validateOwner() {
    ITEM_MANAGER.ValidateScriptScope();
    // Elites parent
    if (self.GetMoveParent() == null) {
        ITEM_MANAGER.GetScriptScope().ITEM_OWNERS[ITEM_TYPE] = null;
    }

    EntFireByHandle(self, "RunScriptCode", "validateOwner();", TICK_RATE, null, null);
}

// Triggered via fireUser1
function OnUse() {
    ITEM_MANAGER.ValidateScriptScope();
    if (ITEM_MANAGER.GetScriptScope().ITEM_OWNERS[ITEM_TYPE] != null) {
        // Then allow use
        EntFire(ITEM_TYPE + "_relay", "Trigger", null, 0.00, null);
    }
}