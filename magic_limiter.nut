limited_magic <- "";
limited_magic_chance <- 0;

function onTouchPrint() {
    printl("Limited Magic: " + limited_magic);
}

function OnPostSpawn() {
    limited_magic_chance = RandomInt(0, 100);
    if (limited_magic_chance <= 25) {
        // Fire magic
        limited_magic = "Ignis";
    }
    if (limited_magic_chance >=26 && limited_magic_chance <= 50) {
        // Thunder magic
        limited_magic = "Tonitruum";
    }
    if (limited_magic_chance >=51 && limited_magic_chance <= 75) {
        // Binding magic
        limited_magic = "Alliges";
    }
    if (limited_magic_chance >= 76) {
        limited_magic = "no influence";
    }

    printl(limited_magic);
}