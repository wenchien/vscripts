IncludeScript("vs_events");
IncludeScript("vs_library");

ITEM_MANAGER <- Entities.FindByName(null, "itemManager");
SETTINGS_MANAGER <- Entities.FindByName(null, "settingsManager");
LEVEL_MANAGER <- Entities.FindByName(null, "levelManager");

RETRY_PLAYER_LIST <- [];


function OnPlayerHurt(event) {
    //local data = getData("player_hurt");
    //printl(data);
	foreach(k,v in event) {
		printl(k + " : " + v);
	}
    printl("event.userid = " + event.userid);//dmg receiver
    printl("event.attacker = " + event.attacker);//attacker
    printl("event.weapon = " + event.weapon);//attacker weapon
    if (event.userid == 0 || event.attacker == 0) {
        return;
    }

    local dmg_receiver = VS.GetPlayerByUserid(event.userid);
    local attacker =  VS.GetPlayerByUserid(event.attacker);


    printl(dmg_receiver);

    // If attacker is CT and dmg_receiver is T
    if (attacker.GetTeam() == 3 && dmg_receiver.GetTeam() == 2) {
        // add to event queue so it can be processed
        ITEM_MANAGER.ValidateScriptScope();
        SETTINGS_MANAGER.ValidateScriptScope();
        local dmgHitSettings = SETTINGS_MANAGER.GetScriptScope().DMG_HIT_BASE;
        local dmgMultiplier =  SETTINGS_MANAGER.GetScriptScope().DMG_MULTIPLIER;
        local dmgToExp = 0;

        if (dmgHitSettings == 0) {
            // dmg base
            dmgToExp = (SETTINGS_MANAGER.GetScriptScope().WEAPON_DMG_TO_EXP[event.weapon] * event.dmg_health * dmgMultiplier).tointeger();
        } else {
            // hit base
            dmgToExp = SETTINGS_MANAGER.GetScriptScope().WEAPON_DMG_TO_EXP[event.weapon];
        }
        if (MAX_EXP_THRESHOLD <= ITEM_MANAGER.GetScriptScope().ACCUMULATED_EXP) {
            ITEM_MANAGER.GetScriptScope().ACCUMULATED_EXP = MAX_EXP_THRESHOLD;
        } else {
            VC.EventQueue.AddEvent(function () {
                ITEM_MANAGER.GetScriptScope().ACCUMULATED_EXP += dmgToExp;
            }, 1.00);
        }

    } else {
        // ignoring all other player_hurt event conditions
        return;
    }

}

function OnRoundEnd(event) {
    // Determine who won the round
    //local data = getData("round_end");
	//printl(data);
	foreach(k,v in event) {
		printl(k + " : " + v);
	}
    if (ITEM_MANAGER != null && ITEM_MANAGER.IsValid()) {
        if (event.winner == 2) {
            // Zombies won!
            ITEM_MANAGER.ValidateScriptScope();
            ITEM_MANAGER.GeScriptScope().OnStageLost();

            LEVEL_MANAGER.ValidateScriptScope();
            LEVEL_MANAGER.GetScriptScope().OnLevelStageLost();
        } else if (event.winner == 3) {
            // Humans won!
            ITEM_MANAGER.ValidateScriptScope();
            ITEM_MANAGER.GetScriptScope().OnStageWon();

            LEVEL_MANAGER.ValidateScriptScope();
            LEVEL_MANAGER.GetScriptScope().OnLevelStageWon();
        } else {
            //Invalid winner
            return;
        }
    }
}

function OnPlayerSay(event) {
    printl(event.userid);
    local msg = event.text;
    if (msg[0] != "!") {
        return;
    }

	local player = VS.GetPlayerByUserid( event.userid );
    if (player.GetTeam() == 3) {
        switch ( msg.tolower() )
	    {

		    case "!upgrade":
                if (player.FirstMoveChild().GetName().find("elite") != null) {
                    if () {

                    }
                    ScriptPrintMessageCenterTeam(3, "");
                }
                
                break;

	    }
    }
	
}

VS.ListenToGameEvent("player_say", OnPlayerSay.bindenv(this), "");
VS.ListenToGameEvent("player_hurt", OnPlayerHurt.bindenv(this), "");
VS.ListenToGameEvent("round_end", OnRoundEnd.bindenv(this), "");


