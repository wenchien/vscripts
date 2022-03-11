STAGE_BGM <- Entities.FindByName(null, "stagebgm");
LEVEL_MANAGER <- Entities.FindByName(null, "levelManager");

function cacheSounds() {
    LEVEL_MANAGER.ValidateScriptScope();
    foreach(sound in LEVEL_MANAGER.GetScriptScope().BGM_SOUNDS) {
        STAGE_BGM.PrecacheScriptSound(sound);
    }
    foreach(sound in LEVEL_MANAGER.GetScriptScope().BOSS_MUSIC) {
        STAGE_BGM.PrecacheScriptSound(sound);
    }
}