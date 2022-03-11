ClientCMD <- Entities.FindByName(null, "Client");
ServerCMD <- Entities.FindByName(null, "Server");

// Restricting M249, Negev, Bizon. Can always be adjusted
DMG_MULTIPLIER <- 0.1;
DMG_HIT_BASE <- 1;
PROHIBITED_WEAPONS <- [14, 28, 26]
WEAPON_DMG_TO_EXP <- {
    // Rifles
    m4a1 = 10,
    m4a1_silencer = 9,
    sg556 = 10,
    ak47 = 12,
    aug = 10,
    awp = 4,
    famas = 12,
    g3sg1 = 4,
    scar20 = 4,
    galilar = 12,
    ssg08 = 20,

    // Smgs
    bizon = 3,
    mac10 = 6,
    mp7 = 6,
    mp9 = 6,
    p90 = 3,
    ump45 = 10,
    mp5sd = 6,

    // Heavies
    m249 = 3,
    negev = 2,
    sawedoff = 1,
    mag7 = 1,
    nova = 1,
    xm1014 = 1,

    // Pistols
    usp_silencer = 20,
    deagle = 15,
    elite = 12,
    fiveseven = 15,
    glock = 17,
    hkp2000 = 17,
    p250 = 23,
    tec9 = 9,
    cz75a = 18,
    revolver = 15
}

function onMapSpawnDoSettings() {
    limitWeaponChoices();
    EntFireByHandle(ServerCMD, "Command", "mp_roundtime 30", 0.00, null, null);
}

function limitWeaponChoices() {
    // Limiting weapon choices
    local limitedChoices = "";
    foreach (index, weaponId in PROHIBITED_WEAPONS) {
        // appending logic
        if (index == PROHIBITED_WEAPONS.len() - 1) {
            limitedChoices += weaponId;
        } else {
            limitedChoices += weaponId + ",";
        }

    }

    EntFireByHandle(ServerCMD, "Command", "mp_items_prohibited " + limitedChoices, 0.00, null, null);
}