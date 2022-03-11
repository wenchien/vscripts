DEBUG_MODE <- false;

ITEM_IDS <- {
    FIRE_MAGIC = 1,
    WIND_MAGIC = 2,
    ICE_MAGIC = 3,
    HOLY_MAGIC = 4
};

ITEM_OWNERS <- {
    FIRE_MAGIC = null,
    WIND_MAGIC = null,
    ICE_MAGIC = null,
    HOLY_MAGIC = null
};

// When humans win, increment the levels here using TEMP_ITEM_LEVEL_LIST
ITEM_LEVEL_LIST <- {
    FIRE_MAGIC = 0,
    WIND_MAGIC = 0,
    ICE_MAGIC = 0,
    HOLY_MAGIC = 0
};

// For during stage, for incremeting usage
TEMP_ITEM_LEVEL_LIST <- {
    FIRE_MAGIC = 0,
    WIND_MAGIC = 0,
    ICE_MAGIC = 0,
    HOLY_MAGIC = 0
};

ITEM_LEVEL_THRESHOLD <- 4;              // items' Upper limit

ITEM_EXP_BASE_MULTIPLIER <- 7500;       // Scaled by a base factor, can be adjusted
ITEM_EXP_HUMAN_MULTIPLIER <- 50;        // Scaled by human count, hard coded for now cause i'm lazy

ACCUMULATED_EXP <- 0;                   // For all humans
PREVIOUS_ACCUMULATED <- 0;              // If zombies win, we need a way to reset / rollback accumulated_exp
MAX_EXP_THRESHOLD <- 1500000;           // Max EXP for accumulated_exp

LEVEL_MANAGER <- Entities.FindByName(null, "levelManager");

// set magic limiter here
limited_magic <- "";
limited_magic_chance <- 0;

function OnSpawn() {
    limited_magic_chance = RandomInt(0, 100);
    if (limited_magic_chance <= 25) {
        // Fire magic - Ignis
        limited_magic = "FIRE_MAGIC";
    }
    if (limited_magic_chance >=26 && limited_magic_chance <= 50) {
        // Wind magic - Tonitruum
        limited_magic = "WIND_MAGIC";
    }
    if (limited_magic_chance >=51 && limited_magic_chance <= 75) {
        // Ice magic - Fimbulvetr
        limited_magic = "ICE_MAGIC";
    }
    if (limited_magic_chance >= 76) {
        // Holy magic -> no influence
        limited_magic = "HOLY_MAGIC";
    }

    if (DEBUG_MODE) {
        printl(limited_magic);
    }

}

function getItemLevelData(key) {
    local tempLevel = ITEM_LEVEL_LIST[key] + TEMP_ITEM_LEVEL_LIST[key];

    // Define upper limit
    if (tempLevel >= ITEM_LEVEL_THRESHOLD) {
        tempLevel = ITEM_LEVEL_THRESHOLD;
    }

    // Anything other than HOLY_MAGIC will be affected
    if (key == limited_magic && "HOLY_MAGIC" != limited_magic) {
        tempLevel = tempLevel - 1;
    }

    return tempLevel;
}

function levelUpItem(key) {
    // check if enough
    // then check if can level up
}

function onRoundStart() {
    if (ScriptIsWarmupPeriod()) {
        return;
    }
    // Set exps
    PREVIOUS_ACCUMULATED = ACCUMULATED_EXP;
    OnSpawn();
}

function OnStageWon() {

    foreach(k,v in ITEM_LEVEL_LIST) {
        v += TEMP_ITEM_LEVEL_LIST[k];
    }

    commonResets();
}

function OnStageLost() {
    checkLevelManagerExistence();
    commonResets();

    // Reset exps
    ACCUMULATED_EXP = PREVIOUS_ACCUMULATED;
}

function commonResets() {
    resetTempLevelList();
    resetMagicLimiter();
}

function resetTempLevelList() {
    if (DEBUG_MODE) {
        printl("Resetting tempLevelList");
    }
    foreach(k,v in TEMP_ITEM_LEVEL_LIST) {
        TEMP_ITEM_LEVEL_LIST[k] = 0;
    }
}

function resetMagicLimiter() {
    if (DEBUG_MODE) {
        printl("Resetting Magic limiter");
    }
    limited_magic = "";
    limited_magic_chance = 0;
}

function resetItemOwners() {
    ITEM_OWNERS <- {
        FIRE_MAGIC = null,
        WIND_MAGIC = null,
        ICE_MAGIC = null,
        HOLY_MAGIC = null
    };
}

function checkLevelManagerExistence() {
    local result = false;

    if (LEVEL_MANAGER != null && LEVEL_MANAGER.IsValid()) {
        result = true;
    }

    return result;
}
