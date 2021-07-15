//Logging utilities
::LOGGER <- ["Started Logging...."];
IncludeScript("node_setting", null);
IncludeScript("terrainNodeClass", null);
IncludeScript("keshikiType", null);
IncludeScript("EntityOnSpawn", null)
//Reponsible for distributing logic to nodes
//as well as manage main logic of random path generation

//Node related variables
//Temp variables
::TEMP_NODES <- []; //all newly created nodes are stored heres
::TEMP_ENTITY_LIST <- []; //for extra tree and boulder

// All currently running nodes related
::TERRAIN_NODES <- [];
::CURRENT_NODE_PTR <- 0;
::PREV_NODE_PTR <- 0;


//Entities in game
entities_spawner <- Entities.FindByName(null, "entities_spawner");
node_spawner_1 <- Entities.FindByName(null, "node_spawner_1");
node_spawner_2 <- Entities.FindByName(null, "node_spawner_2");
node_spawner_3 <- Entities.FindByName(null, "node_spawner_3");
gimmick_spawner <- Entities.FindByName(null, "gimmick_spawner");
merit_spawner <- Entities.FindByName(null, "merit_spawner");

//Area range/threshold variables (min_x, max_x), (top left, to bottom right)
node_area_1_range_x <- [-11712, -10112];
node_area_1_range_y <- [9856, 6912];

node_area_2_range_x <- [-9952, -8352];
node_area_2_range_y <- [9856, 6912];

node_area_3_range_x <- [-8192, -6592];
node_area_3_range_y <- [9856, 6912];

//Other const vars
::DEFAULT_ORIENTATION <- Vector(0, 0, 0);
::KESHIKI_RANGE_X <- 512;
::KESHIKI_RANGE_Y <- 2688;
::GROUND_LEVEL <- 65;
::HEIGHT_LOW <- -250;
::HEIGHT_HIGH <- 400;




//ModelName list
SNOW_TREE_1 <- "models/snow_tree/snow_tree_1.mdl";
SNOW_BUSH_1 <- "models/snow_tree/snow_tree_1.mdl";
SNOW_ROCK_1 <- "models/snow_tree/snow_tree_1.mdl";
SNOW_CLIFF_1 <- "models/cliff/cliff_side_1.mdl";


//Const Strings for cliffs
CLIFF_STRAIGHT_LEFT <- "cliff_straight_left";
CLIFF_STRAIGHT_RIGHT <- "cliff_straight_right";
CLIFF_RTURN_LEFT <- "cliff_rturn_left";
CLIFF_RTURN_RIGHT <- "cliff_rturn_right";
CLIFF_LTURN_LEFT <- "cliff_lturn_left";
CLIFF_LTURN_RIGHT <- "cliff_lturn_right";

//Called this first
function onInit() {
    startLogger();
    LOGGER.push("Called onInit....initializing");
    setTemplateByHandle(entities_spawner, "tree_template");
    setTemplateByHandle(node_spawner_1, "flat_ground_template");
    EntFireByHandle(node_spawner_1, "ForceSpawn", "", 0.00, null, null);
}

function onFinishedInit() {
    local node_1 = TEMP_NODES[0];
    node_1.setExtraTree(8);
    CURRENT_NODE_PTR = 1;
    //Call defineKeshikiSpawningRule() instead
    node_1.generateEntitiesWithinKeshikiRange(entities_spawner, node_area_1_range_x, node_area_1_range_y, KESHIKI_RANGE_X, KESHIKI_RANGE_Y, DEFAULT_ORIENTATION);
    node_1.adjustPropDynamicModelScaleAll(SNOW_TREE_1, 1.00, 3.00);
    node_1.adjustPropDynamicRandOrientation(SNOW_TREE_1);
    node_1.checkCliffHeight(CURRENT_NODE_PTR);
    printl(node_1.getEntityList());
    TERRAIN_NODES.push(node_1);
    TEMP_NODES.clear();
    LOGGER.push("End OnInit....Current Node: " + CURRENT_NODE_PTR);
}

//For next N nodes, call this first instead
function prepareNextNode() {
    //Node number clampings
    LOGGER.push("Current Node: " + CURRENT_NODE_PTR);
    CURRENT_NODE_PTR += 1;
    if (CURRENT_NODE_PTR > 3) {
        CURRENT_NODE_PTR = 1;
    }
    LOGGER.push("Next Node: " + CURRENT_NODE_PTR);
    spawnNextNode(CURRENT_NODE_PTR);
}


function spawnNextNode(number) {
    LOGGER.push("Called spawnNextNode....initializing");
    switch(number) {
        case 1 :  setTemplateByHandle(entities_spawner, "tree_template");
                setTemplateByHandle(node_spawner_1, "flat_ground_template");
                EntFireByHandle(node_spawner_1, "ForceSpawn", "", 0.00, null, null);
                break;
        case 2 :  setTemplateByHandle(entities_spawner, "tree_template");
                setTemplateByHandle(node_spawner_2, "flat_ground_template");
                EntFireByHandle(node_spawner_2, "ForceSpawn", "", 0.00, null, null);
                break;
        case 3 :  setTemplateByHandle(entities_spawner, "tree_template");
                setTemplateByHandle(node_spawner_3, "flat_ground_template");
                EntFireByHandle(node_spawner_3, "ForceSpawn", "", 0.00, null, null);
                break;
    }
}

//For next N nodes, call this second
function setUpNextNode() {
    //Call defineKeshikiSpawningRule() instead, set up all the landscape related stuff
    LOGGER.push("Called setUpNextNode...Setting up the scenery");
    local node = TEMP_NODES[0];
    //node.setExtraTree(RandomInt(4, 8));
    switch (CURRENT_NODE_PTR) {
        case 1 : node.generateEntitiesWithinKeshikiRange(entities_spawner, node_area_1_range_x, node_area_1_range_y, KESHIKI_RANGE_X, KESHIKI_RANGE_Y, DEFAULT_ORIENTATION);
                break;
        case 2 : node.generateEntitiesWithinKeshikiRange(entities_spawner, node_area_2_range_x, node_area_2_range_y, KESHIKI_RANGE_X, KESHIKI_RANGE_Y, DEFAULT_ORIENTATION);
                break;
        case 3 : node.generateEntitiesWithinKeshikiRange(entities_spawner, node_area_3_range_x, node_area_3_range_y, KESHIKI_RANGE_X, KESHIKI_RANGE_Y, DEFAULT_ORIENTATION);
                break;
    }

    node.adjustPropDynamicModelScaleAll(SNOW_TREE_1, 1.00, 3.00);
    node.adjustPropDynamicRandOrientation(SNOW_TREE_1);
    node.checkCliffHeight(CURRENT_NODE_PTR);
    printl(node.getEntityList());
    debugArray(node.getEntityList());
    TERRAIN_NODES.push(node);
    TEMP_NODES.clear();
}

function deleteEntitiesFromNode(node) {
    //Clamping
    local number = CURRENT_NODE_PTR-1;
    if ((number) == 0) {
        number = 3;
    }
    node.deleteAll(number);
}

//For next N nodes, call this last
function deletePrevNodeFromList() {
    deleteEntitiesFromNode(TERRAIN_NODES.remove(0));
}

function setTemplateByHandle(spawner, template) {
    EntFireByHandle(spawner, "AddOutput", "EntityTemplate " + template, 0.00, null, null);
}

//------Util------
function startLogger() {
    if (LOGGER.len() != 0) {
        foreach(log in LOGGER) {
            printl("Customer Logger: " + Time().tointeger() + " :: " + log);
        }
        LOGGER.clear();
    }
    EntFireByHandle(self, "RunScriptCode", "startLogger();", 0.10, null, null);
}


function debugArray(array) {
    printl("----------Entities Handle in Array----------");
    foreach(handle in array) {
        local formattedStr = format("%s\t", handle.GetName());
        printl(formattedStr);
    }
    printl("----------------End of Array----------------");
}
