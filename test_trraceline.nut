function testLinearForwardVector() {
    printl("Movelinear vector: " + self.GetForwardVector());

    printl("Movelinear traceline: " + TraceLine(self.GetOrigin(), self.GetOrigin() + self.GetForwardVector(), null));
    if (TraceLine(self.GetOrigin(), self.GetOrigin() + self.GetForwardVector(), null) > 0) {
        printl("Continuing...");
        EntFireByHandle(self, "RunScriptCode", "testLinearForwardVector();", 0.25, null, null);
    } else {
        printl("Stopping because it hit something");
        EntFireByHandle(self, "Kill", "", 0.00, null, null);
        return;
    }
}


