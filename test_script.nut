//Squirrel Utilities
//Constants
Pi <- 3.14159265
TwoPi <- 6.2831853
HalfPi <- 1.5707963

Rad <- 0.01745329251994329576923690768489
Deg <- 57.295779513082320876798154814105

eyeDirection <- Vector(0,0,0);
btn <- Entities.FindByName(null, "akbtn");
itemOwner <- Entities.FindByName(null, "akkk")
bgm <- Entities.FindByName(null, "testBgm");

function printInfo() {
    printl(bgm);
    if (bgm != null && bgm.IsValid()) {
        printl("entity bgm is ok");
    }
}

function PreSpawnInstance( entityClass, entityName )
{
    //bug here for forwardvector
    local player = itemOwner.GetMoveParent();
    printl("Player angles :  " + player.GetAngles());
    local keyvalues = {};
    if (entityClass == "func_movelinear") {
        local result = Vector(0,0,0);
        local resultStr = "";
        if (player != null && player.IsValid()) {

            result = player.GetForwardVector();
        // either i don't normalize the result or the movedir x and y value is reversed....
        }
        // problem here
        result =  player.GetAngles() + "";
        keyvalues =
        {
            // pitch y yall z roll x
            movedir = "0 " + player.GetAngles().y + " 0",
            movedistance = "500",
            speed = "50",
            spawnflag = "8"
        };
    }
    foreach(k,v in keyvalues) {
        printl(k + " : " + v);
    }
	return keyvalues
}

function PostSpawn( entities )
{

	foreach( targetname, handle in entities )
	{
         if ("test_move" == targetname) {
            printl("movelinear moving");
            handle.ValidateScriptScope();
            handle.GetScriptScope().testLinearForwardVector();
            EntFireByHandle(handle, "Open", "", 0.00, null, null);
        }
		printl( targetname + ": " + handle )
	}
}

function spawnAsActivator() {
    EntFire("move_maker", "ForceSpawn", "", 0.00, activator);
}

//Normalizes a vector
function Normalize(v)
{
	local len = v.Length();
	return Vector(v.x/len,v.y/len,v.z/len);
}

function AngleBetween(v1,v2)
{
		local aZ = atan2((v1.y - v2.y),(v1.x - v2.x))+Pi;
		local aY = atan2((v1.z - v2.z),Distance2D(v1,v2))+Pi;

		return Vector(aY,aZ,0.0);
}

function AngleBetween2(v1,v2)
{
		local aZ = atan2((v1.z - v2.z),(v1.x - v2.x))+Pi;
		local aY = atan2((v1.z - v2.z),(v1.y - v2.y))+Pi;

		return Vector(aY,aZ,0.0);
}

function Distance2D(v1,v2)
{
	local a = (v2.x-v1.x);
	local b = (v2.y-v1.y);

	return sqrt((a*a)+(b*b));
}
