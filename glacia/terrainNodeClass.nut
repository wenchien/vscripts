IncludeScript("glacia/keshikiType", null);
class TerrainNode {
    m_pathState = PATH_STATE.STRAIGHT;
    m_keshikiState = KESHIKI.STRAIGHT;
    m_leftHighLowGround = 0;
    m_rightHighLowGround = 0;
    m_left_cliff = "";
    m_right_cliff = "";
    m_entities = null;
    m_extraTreeCount = 1;
    m_extraBoulderCount = 1;
    m_leftFinished = false;
    m_rightFinished = false;
    m_logger = getroottable()["LOGGER"];

    constructor(pathState, keishiState, treeCount, boulderCount) {
        m_pathState = pathState;
        m_keshikiState = keishiState;
        m_entities = [];
        m_extraTreeCount = RandomInt(5, 8);
        m_extraBoulderCount = boulderCount;
        m_leftHighLowGround = RandomInt(0, 1);
        m_rightHighLowGround = RandomInt(0, 1);
        m_logger = getroottable()["LOGGER"];
    }

    //TO-DO
    function defineKeshikiSpawningRule(spawn_parameter, spawner, node_range_x, node_range_y, range_x, range_y, prop_orientation) {
        switch (spawn_parameter) {
            case PATH_STATE.STRAIGHT:
                    generateEntitiesWithinKeshikiRange(spawner, node_range_x, node_range_y, range_x, range_y, prop_orientation);
                break;
            case PATH_STATE.RIGHT_TURN:
                break;
            case PATH_STATE.LEFT_TURN:
                break;
        }
    }

    //Doesn't allow overlapping maybe add a way to allow overlapping
    function generateEntitiesWithinRange(spawner, node_range_x, node_range_y, prop_orientation) {
        local spawnedCount = 0;
        local spawnedList = [];
        local rootTable = getroottable();
        while (spawnedCount != getExtraTree()) {
            if (spawnedList.len() <= 0) {
                //Calculate and generate the first one
                getLogger().push("Spawning initial entity");
                local random_x = RandomInt(node_range_x[0], node_range_x[1]);
                local random_y = RandomInt(node_range_y[0], node_range_y[1]);
                local random_z = RandomInt(150, abs(rootTable["HEIGHT_HIGH"]));
                if (getLeftHighLowGround() == 0 && isLeftFinished() == false) {
                    random_z = RandomInt(rootTable["GROUND_LEVEL"], abs(rootTable["HEIGHT_LOW"]));
                    getLogger().push("Detecting low grounds on the left cliff, setting entities on the LEFT to low ground mode");
                }
                if (getRightHighLowGround() == 0 && isRightFinished() == false) {
                    random_z = RandomInt(rootTable["GROUND_LEVEL"], abs(rootTable["HEIGHT_LOW"]));
                    getLogger().push("Detecting low grounds on the right cliff, setting entities on the RIGHT to low ground mode");
                }
                local result_vector = Vector(random_x, random_y, random_z);
                spawner.SpawnEntityAtLocation(result_vector, prop_orientation);
                local entity = TEMP_ENTITY_LIST.pop();
                spawnedList.push(entity);
                getLogger().push("Pushed: " + entity);
                getEntityList().push(entity);//add it to current node so node has control
                spawnedCount += 1;
                getLogger().push("End of Initial spawning");
            } else {
                foreach(entity in spawnedList) {
                    //Generate random points
                    getLogger().push("Spawning other entity of the same type");
                    local entity_vec_max = GetBoundingMaxsWithOrigin(entity);
                    local entity_vec_min = GetBoundingMinsWithOrigin(entity);
                    local found = false;
                    while (found == false) {
                        local random_x = RandomInt(node_range_x[0], node_range_x[1]);
                        local random_y = RandomInt(node_range_y[0], node_range_y[1]);
                        local random_z = RandomInt(150, abs(rootTable["HEIGHT_HIGH"]));
                        if (getLeftHighLowGround() == 0 && isLeftFinished() == false) {
                            random_z = RandomInt(rootTable["GROUND_LEVEL"], abs(rootTable["HEIGHT_LOW"]));
                            getLogger().push("Detecting low grounds on the left cliff, setting entities on the LEFT to low ground mode");
                        }
                        if (getRightHighLowGround() == 0 && isRightFinished() == false) {
                            random_z = RandomInt(rootTable["GROUND_LEVEL"], abs(rootTable["HEIGHT_LOW"]));
                            getLogger().push("Detecting low grounds on the right cliff, setting entities on the RIGHT to low ground mode");
                        }
                        if (!(random_x > entity_vec_max.x && random_x  < entity_vec_min.x && random_y > entity_vec_max.y && random_y  < entity_vec_min.y)) {
                            found = true;
                            local result_vector = Vector(random_x, random_y, random_z);
                            spawner.SpawnEntityAtLocation(result_vector, prop_orientation);
                            local entity = TEMP_ENTITY_LIST.pop();
                            spawnedList.push(entity);
                            getEntityList().push(entity);
                            getLogger().push("Pushed: " + entity);
                            spawnedCount += 1;
                            getLogger().push("End of other entity of the same type");
                        }
                    }
                    if (found == true) {
                        break;
                    }

                }
            }

        }
    }

    //For straight path, but what about other options?
    function generateEntitiesWithinKeshikiRange(spawner, node_range_x, node_range_y, range_x, range_y, prop_orientation) {
        //Calculating missing points
        local left_range_missing_pt = Vector(node_range_x[0]+range_x, node_range_y[0]-range_y, 65);
        local right_range_missing_pt = Vector(node_range_x[1]-range_x, node_range_y[1]+range_y, 65);

        //Left Ranges
        local left_range_x = [node_range_x[0], left_range_missing_pt.x];
        local left_range_y = [left_range_missing_pt.y, node_range_y[0]];

        //Right Ranges
        local right_range_x = [right_range_missing_pt.x, node_range_x[1]];
        local right_range_y = [node_range_y[1], right_range_missing_pt.y];

        //Generate left and right keshiki
        generateEntitiesWithinRange(spawner, left_range_x, left_range_y, prop_orientation);
        setLeftFinished(true);
        generateEntitiesWithinRange(spawner, right_range_x, right_range_y, prop_orientation)
        setRightFinished(true);
    }

    function checkCliffHeight(number) {
        switch(getPathState()) {
            case PATH_STATE.STRAIGHT : checkCliffHeight01(number, "cliff_straight_left", "cliff_straight_right");
                break;
            case PATH_STATE.RIGHT_TURN : checkCliffHeight01(number, "cliff_rturn_left", "cliff_rturn_right");
                break;
            case PATH_STATE.LEFT_TURN : checkCliffHeight01(number, "cliff_lturn_left", "cliff_lturn_right");
                break;
        }
    }

//need a overload function starter first here so i can just pass in numbers;
    function checkCliffHeight01(number, cliff_left, cliff_right) {
        local entity = null;
        //left
        while (entity = Entities.FindByName(entity, cliff_left)) {
            //Changes its targetname
            entity.__KeyValueFromString("targetname", entity.GetName()+"_"+number);
        }

        entity = null;
        //right
        while (entity = Entities.FindByName(entity, cliff_right)) {
            //Changes its targetname
            entity.__KeyValueFromString("targetname", entity.GetName()+"_"+number);
        }
        //set cliff heights here, need a way to identify cliffs from which node
        if (getLeftHighLowGround() == 0) {
            getLogger().push("Detecting low grounds settings. Setting the LEFT cliff to low");
            setCliffToLowHeight(cliff_left + "_" + number);
        }
        if (getRightHighLowGround() == 0) {
            getLogger().push("Detecting low grounds settings. Setting the RIGHT cliff to low");
            setCliffToLowHeight(cliff_right + "_" + number);
        }
    }

    function setCliffToLowHeight(cliff) {
        local entity = null;
        while (entity = Entities.FindByName(entity, cliff)) {
            //getLogger().push("Can iterate   " + entity);
            local new_z = (entity.GetOrigin().z - abs(getroottable()["HEIGHT_LOW"])).tointeger();
            local new_pos = Vector(entity.GetOrigin().x, entity.GetOrigin().y, new_z);
            getLogger().push(entity.GetName() + " has New Vector: " + new_pos);
            entity.SetOrigin(new_pos);
        }
    }

    function resetPropDynamicModelScaleAll(modelname) {
        foreach(entity in m_entities) {
            if (entity.GetModelName() == modelname) {
                EntFireByHandle(entity, "AddOutput", "modelscale 1", 0.00, null, null);
            }
        }
    }

    function adjustPropDynamicModelScaleAll(modelname, scale_min, scale_max) {
        foreach(entity in m_entities) {
            local random_scale = RandomFloat(scale_min, scale_max);
            if (entity.GetModelName() == modelname) {
                getLogger().push("Executed RandomScaling (" + random_scale + ") on entity: " + entity + " w/ model: " + entity.GetModelName());
                EntFireByHandle(entity, "AddOutput", "modelscale " + random_scale, 0.00, null, null);
            }
        }
    }

    function adjustPropDynamicRandOrientation(modelname) {
        foreach(entity in m_entities) { //z-axis only
            local random_z = RandomFloat(0, 360);
            if (entity.GetModelName() == modelname) {
                getLogger().push("Executed RandomOrientation (0, " + random_z + ", 0) on entity: " + entity + " w/ model: " + entity.GetModelName());
                entity.SetAngles(0, random_z, 0);
            }
        }
    }

//delete cliff need to be redone for different path
    function deleteAll(cliff_number) {
        foreach(entity in getEntityList()) { //z-axis only
            if (entity.IsValid() && entity != null) {
                getLogger().push("Executed deleteAll on the selected Node");
                EntFireByHandle(entity, "Kill", "", 0.00, null, null);
            }

        }
        deleteCliff(cliff_number);
    }

    function deleteCliff(cliff_number) {
        local cliff_left;
        local cliff_right;
        switch(getPathState()) {
            case PATH_STATE.STRAIGHT : cliff_left = "cliff_straight_left"; cliff_right = "cliff_straight_right";
                break;
            case PATH_STATE.RIGHT_TURN : cliff_left = "cliff_rturn_left"; cliff_right = "cliff_rturn_right";
                break;
            case PATH_STATE.LEFT_TURN : cliff_left = "cliff_lturn_left"; cliff_right = "cliff_lturn_right";
                break;
        }
        local entity = null;
        while (entity = Entities.FindByName(entity, cliff_left + "_" + cliff_number)) {
            //Changes its targetname
            entity.Destroy();
        }
        entity = null;
        while (entity = Entities.FindByName(entity, cliff_right + "_" + cliff_number)) {
            //Changes its targetname
            entity.Destroy();
        }
    }

    //Beware boundingMax doesn't exactly return the goodie good
    //the true boundingMax is origin+max
    //and the true boundMin is origin+min
    function GetBoundingMaxsWithOrigin(entity) {
        return (entity.GetBoundingMaxs() + entity.GetOrigin());
    }

    function GetBoundingMinsWithOrigin(entity) {
        return (entity.GetBoundingMins() + entity.GetOrigin());
    }

    //Add random scaling function here

    //Adds entity handle to list
    function addEntityList(entity) {
        m_entities.push(entity);
    }

    function getEntityList() {
        return m_entities;
    }

    function setkeshikiState(value) {
        m_keshikiState = value;
    }

    function getkeshikiState() {
        return m_keshikiState;
    }

    function setPathState(value) {
        m_pathState = value;
    }

    function getPathState() {
        return m_pathState;
    }

    function getLeftCliff() {
        return m_left_cliff;
    }

    function setLeftCliff(value) {
        m_left_cliff = value;
    }

    function getRightCliff() {
        return m_right_cliff;
    }

    function setRightCliff(value) {
        m_right_cliff = value;
    }

    function setExtraTree(value) {
        m_extraTreeCount = value;
    }

    function getExtraTree() {
        return m_extraTreeCount;
    }

    function setExtraBoulder(value) {
        m_extraBoulderCount = value;
    }

    function getExtraBoulder() {
        return m_extraBoulderCount;
    }

    function getLeftHighLowGround() {
        return m_leftHighLowGround;
    }

    function setLeftHighLowGround(value) {
        m_leftHighLowGround = value;
    }

    function getRightHighLowGround() {
        return m_rightHighLowGround;
    }

    function setRightHighLowGround(value) {
        m_rightHighLowGround = value;
    }

    function isLeftFinished() {
        return m_leftFinished;
    }

    function setLeftFinished(value) {
        m_leftFinished = value;
    }

    function isRightFinished() {
        return m_rightFinished;
    }

    function setRightFinished(value) {
        m_rightFinished = true;
    }

    function getLogger() {
        return m_logger;
    }

}