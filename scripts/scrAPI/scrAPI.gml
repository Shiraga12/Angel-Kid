/// API - 

globalvar COINS;
COINS = 0;
/// @desc Returns the current number of coins the player has.
/// @returns {real} The player's current coin count.
function getCOINS() {    return COINS;  }
/// @desc Adds a specified amount of coins to the player's total.
/// @param {real} amount The number of coins to add.
function addCOINS(amount) {    COINS += amount; }
/// @desc Sets the player's coin count to a specific amount.
/// @param {real} amount The new total number of coins for the player.
function setCOINS(amount) {    COINS = amount;  }

globalvar HEALTH;
HEALTH = 8;
/// @desc Returns the current health of the player.
/// @returns {real} The player's current health.
function getHEALTH() {    return HEALTH; }
/// @desc Adds a specified amount of health to the player's total.
/// @param {real} amount The amount of health to add.
function heal(amount) {    HEALTH += clamp(amount, 0, 8 - HEALTH); }
/// @desc Subtracts a specified amount of health from the player's total.
/// @param {real} amount The amount of health to subtract.
function damage(amount) {    HEALTH -= clamp(amount, 0, HEALTH); }
/// @desc Sets the player's health to a specific amount.
/// @param {real} amount The new total health for the player.
function setHEALTH(amount) {    HEALTH = clamp(amount, 0, 8); }


globalvar WORLDS;
WORLDS = [
	new world("Tutorial Island", [
        new stage("The Beach", Room1),
    ]),
]
/// @desc Returns the list of worlds in the game.
/// @returns {array} The list of worlds.
function getWORLDS() {    return WORLDS; }
/// @desc Adds a new world to the game.
/// @param {string} name The name of the new world.
function addWORLD(name) {    array_push(WORLDS, { NAME: name, STAGES: [], CLEARED: false }); }
/// @desc Marks a world as cleared. Also marks all stages within that world as cleared.
/// @param {string} name The name of the world to mark as cleared.
function clearWORLD(name) {
    var world = getWORLD(name);
    if (world != undefined) {
		var stages = world[$ "STAGES"];
        world.CLEARED = true;
		for (var i = 0; i < array_length(stages); i++) {
			stages[i].CLEARED = true;
        }
    }
}
/// @desc Retrieves a world by name.
/// @param {string} name The name of the world to retrieve.
/// @returns {struct} The world struct, or undefined if not found.
function getWORLD(name) {
    for (var i = 0; i < array_length(WORLDS); i++) {
        if (WORLDS[i].NAME == name) {
            return WORLDS[i];
        }
    }
    return undefined;
}
/// @desc Adds a stage to a specified world.
/// @param {string} worldNAME The name of the world to add the stage to.
/// @param {string} stageNAME The name of the stage to add.
/// @param {asset.room} stageROOM The room associated with the stage.
function addSTAGE(worldNAME, stageNAME, stageROOM) {
    var world = getWORLD(worldNAME);
    if (world != undefined) {
		array_push(world[$ "STAGES"], { NAME: stageNAME, ROOM: stageROOM, CLEARED: false });
    }
}

#region API
    globalvar API;
    API = {
        WORLD: 0,
        STAGE: 0,
    }

    function getCURRENT_WORLD() {    return WORLDS[API.WORLD]; }
    function getCURRENT_STAGE() {    return getCURRENT_WORLD().STAGES[API.STAGE]; }
#endregion

#region GUI Macros
    #macro guiWIDTH display_get_gui_width()
    #macro guiHEIGHT display_get_gui_height()
    #macro centerX (guiWIDTH * 0.5)
    #macro centerY (guiHEIGHT * 0.5)
#endregion


/// @desc Ensures the persistent transition controller exists.
/// @returns {real} The controller instance id.
function transition_ensure_controller() {
	if (!instance_exists(oTransitionController)) {
		instance_create_depth(0, 0, -100000, oTransitionController);
	}

	return instance_find(oTransitionController, 0);
}

/// @desc Returns whether a room transition is currently active.
/// @returns {bool}
function transition_is_active() {
	var controller = transition_ensure_controller();
	if (!instance_exists(controller)) {
		return false;
	}

	var isActiveMethod = variable_instance_get(controller, "isActive");
	return isActiveMethod();
}

/// @desc Returns the default transition duration in frames.
/// @returns {real}
function transition_default_duration() {
	return max(1, round(room_speed));
}

/// @desc Starts a shader-backed transition to a specific room.
/// @param {asset.room} _room
/// @param {real} _focusX
/// @param {real} _focusY
/// @param {real} _durationFrames
/// @param {real} _pixelAmount
/// @param {asset.shader} _shader
/// @returns {bool}
function transition_goto(_room, _focusX = 0.5, _focusY = 0.5, _durationFrames = undefined, _pixelAmount = 50, _shader = shdSonicFadeToBlackTransition) {
	if (_room == noone || _room == -1) {
		return false;
	}

	if (is_undefined(_durationFrames)) {
		_durationFrames = transition_default_duration();
	}

	if (!shaders_are_supported()) {
		room_goto(_room);
		return false;
	}

	var controller = transition_ensure_controller();
	if (!instance_exists(controller)) {
		room_goto(_room);
		return false;
	}

	var beginTransitionMethod = variable_instance_get(controller, "beginTransition");
	return beginTransitionMethod(_room, _focusX, _focusY, _durationFrames, _pixelAmount, _shader);
}

/// @desc Starts a shader-backed transition to the next room in room order.
/// @param {real} _focusX
/// @param {real} _focusY
/// @param {real} _durationFrames
/// @param {real} _pixelAmount
/// @param {asset.shader} _shader
/// @returns {bool}
function transition_goto_next(_focusX = 0.5, _focusY = 0.5, _durationFrames = undefined, _pixelAmount = 50, _shader = shdSonicFadeToBlackTransition) {
	var nextRoom = room_next(room);
	if (nextRoom == -1) {
		return false;
	}

	return transition_goto(nextRoom, _focusX, _focusY, _durationFrames, _pixelAmount, _shader);
}

