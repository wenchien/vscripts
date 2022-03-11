TIME_REQUIREMENT <- 20;                         // in minutes
SPECIAL_TIME_REQUIREMENT <- 25;                 // in minutes
CURRENT_LEVEL <- "";                            //
LEVEL_SELECTION <- ["UNDERGROUND","SHIP"];      //
SECRET_LEVEL_SELECTION <- ["CASTLE","SECRET"];  //
WARMUP <- false;

LEVELS_COMPLETED <- {
    UNDERGROUND = false,
    SHIP = false,
    CASTLE = false
};


SOUND_PRECACHED <- false;
BGM_SOUNDS <- [
    "ixi/Main_Theme.mp3",
    "ixi/Stage1_BGM.mp3",
    "ixi/Stage2_BGM.mp3",
    "ixi/Stage3_BGM.mp3",
    "ixi/Stage4_BGM.mp3"
];
BOSS_MUSIC  <- [
    "ixi/Stage1_BOSS.mp3",
    "ixi/Stage2_BOSS.mp3",
    "ixi/Stage3_BOSS.mp3",
    "ixi/Stage4_BOSS.mp3"
];


function checkLevel() {
    printl("check Level STart");
    EntFire("main_fog_sky_relay", "Trigger", "", 0.00, null);

    if (ScriptIsWarmupPeriod()) {
        printl("Ending warmup");
        EntFire("Server", "Command", "mp_warmup_end", 0.00, null);
        WARMUP = true;
        return;
    }

    if (WARMUP && SOUND_PRECACHED) {
        // retry clients
        // set bgm to main theme
        printl("WARM UP !!!!");
        EntFire("stagebgm", "Volume", "0", 0.00, null);
        EntFire("stagebgm", "AddOutput", "message " + BGM_SOUNDS[0], 0.50, null);
        EntFire("stagebgm", "PlaySound", "", 1.00, null);
        EntFire("stagebgm", "FadeOut", "4", 75.00, null);
        EntFire("stagebgm", "Volume", "0", 79.00, null);
        printl("Done Warm up bgm");
        setWarmUpOver();
        EntFire("game_round_end", "FireUser1", "", 80.00, null);

        return;
    }
    if (LEVELS_COMPLETED["UNDERGROUND"] && LEVELS_COMPLETED["SHIP"]) {
        // Upon completing all random stages, proceed to castle stage if time requirement is met
        CURRENT_LEVEL = "CASTLE";
    } else {
        // Select one of the two stages randomly each round
        local randomSelection = LEVEL_SELECTION[RandomInt(0, 1)];
        CURRENT_LEVEL = randomSelection;
        if (LEVELS_COMPLETED["UNDERGROUND"]) {
            CURRENT_LEVEL = "SHIP";
        } else if (LEVELS_COMPLETED["SHIP"]) {
            CURRENT_LEVEL = "UNDERGROUND";
        }

        if ("UNDERGROUND" == CURRENT_LEVEL) {
            ScriptPrintMessageCenterAll("Chapter Underground : Optional Time to beat - " + SPECIAL_TIME_REQUIREMENT);
            EntFire("stagebgm", "Volume", "0", 0.00, null);
            EntFire("stagebgm", "AddOutput", "message " + BGM_SOUNDS[1], 0.50, null);
            EntFire("stagebgm", "PlaySound", "", 1.00, null);
        } else {
            ScriptPrintMessageCenterAll("Chapter Sea : Optional Time to beat - " + TIME_REQUIREMENT);
            EntFire("stagebgm", "Volume", "0", 0.00, null);
            EntFire("stagebgm", "AddOutput", "message " + BGM_SOUNDS[2], 0.50, null);
            EntFire("stagebgm", "PlaySound", "", 1.00, null);
        }
    }
}

function getCurrentLevel() {
    return CURRENT_LEVEL;
}

function OnLevelStageWon() {
    markLevelCompleted();
}

function OnLevelStageLost() {
    CURRENT_LEVEL = "";
}

// Test precaching
function OnLevelRoundStart() {
    printl("RoundStart for level manager!");

    if (ScriptIsWarmupPeriod() && !SOUND_PRECACHED) {
        EntFire("bgm_caching_relay", "Trigger", "", 0.00, self);
        SOUND_PRECACHED = true;
        printl("Done  precaching...");
        return;
    } else {
        printl("Checking levels");
        checkLevel();
    }


}

function markLevelCompleted() {
    LEVELS_COMPLETED[getCurrentLevel()] = true;
}

function setWarmUpOver() {
    WARMUP = false;
}

function resetAllLevels() {
    // Returns to warmup
}