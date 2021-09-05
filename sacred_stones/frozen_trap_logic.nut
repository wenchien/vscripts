relay <- null;
p <- 0.20;

function init() {
    relay = caller;
}

function onTouchFrozenTrap() {
    local chance = RandomFloat(0, 1);
    if (chance < p) {
        EntFireByHandle(relay, "Trigger", "", 0.00, null, null);
        EntFireByHandle(activator, "AddOutput", "basevelocity 0 0 900", 0.00, activator, activator);
        EntFireByHandle(activator, "SetHealth", "5", 1.00, activator, activator);
    }
}