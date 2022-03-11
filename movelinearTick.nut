TICKRATE <- 0.25;
DMG_RADIUS <- 32;
LEVEL <- 0;

function movelinearTick() {
    printl("Movelinear vector: " + self.GetForwardVector());

    printl("Movelinear traceline: " + TraceLine(self.GetOrigin(), self.GetOrigin() + self.GetForwardVector(), null));
    local magicType = split(self.GetName(), "_")[0];

    local zombie_uwu = null;
    local candidates = [];
    while (null != (zombie_uwu = Entities.FindInSphere(zombie_uwu, self.GetOrigin(), DMG_RADIUS))) {
        if (zombie_uwu.GetClassname() == "player" && zombie_uwu.GetTeam() == 2) {
            candidates.push(zombie_uwu); //if everything required is OK, add the target to the list of candidates
        }
    }

    // Replacement for parenting trigger_hurt
    // needs testing
    local zombieCount = candidates.len();
    if (candidates.length != 0) {
        printl("Stopping because of zombies uwu...");
        foreach(zombie in candidates) {
            EntFire(magicType + "_dmg_hurt", "Hurt", "", 0.00, null, null);
            // EntFireByHandle(zombie, "SetHealth", "0", 0.00, null, null);
        }
        if (LEVEL > 0) {
            // Execute additional relays
            EntFire(magicType + "_magic_additional_relays", "Trigger", "", 0.00, self, self);
        }
        EntFireByHandle(self, "Kill", "", 0.00, null, null);

    } else {
        if (TraceLine(self.GetOrigin(), self.GetOrigin() + self.GetForwardVector(), null) > 0) {
            printl("Continuing...");
            EntFireByHandle(self, "RunScriptCode", "movelinearTick();", TICKRATE, null, null);
        } else {
            printl("Stopping because it hit something");
            EntFireByHandle(self, "Kill", "", 0.00, null, null);
            return;
        }
    }
}

function setLevel(lvl) {
    LEVEL = lvl;
}