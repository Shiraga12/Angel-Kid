/// API - 
enum worlds 
{
	tutorial,
	count
}


#macro maxLIVES 3
global.LIVES = maxLIVES;

/// @desc Returns the current number of global.LIVES the player has.
/// @returns {real} The player's current life count.
function getLIVES() {    return global.LIVES;  }

/// @desc Adds a specified amount of global.LIVES to the player's total.
/// @param {real} amount The number of global.LIVES to add.
function gainLIVES(amount) {    global.LIVES += amount; }

/// @desc Subtracts a specified amount of global.LIVES from the player's total.
/// @param {real} amount The number of global.LIVES to subtract.
function loseLIVES(amount) {    global.LIVES -= amount; }

/// @desc Sets the player's life count to a specific amount.
/// @param {real} amount The new total number of global.LIVES for the player.
function setLIVES(amount) {    global.LIVES = amount;  }


global.COINS = 0;

/// @desc Returns the current number of global.COINS the player has.
/// @returns {real} The player's current coin count.
function getCOINS() {    return global.COINS;  }

/// @desc Adds a specified amount of global.COINS to the player's total.
/// @param {real} amount The number of global.COINS to add.
function addCOINS(amount) {    global.COINS += amount; }

/// @desc Sets the player's coin count to a specific amount.
/// @param {real} amount The new total number of global.COINS for the player.
function setCOINS(amount) {    global.COINS = amount;  }


#macro maxHEALTH 8
global.HEALTH = maxHEALTH;

/// @desc Returns the current global.HEALTH of the player.
/// @returns {real} The player's current global.HEALTH.
function getHEALTH() {    return global.HEALTH; }

/// @desc Adds a specified amount of global.HEALTH to the player's total.
/// @param {real} amount The amount of global.HEALTH to add.
function heal(amount) {
	var healthBefore = global.HEALTH;
	global.HEALTH += amount;
	global.HEALTH = clamp(global.HEALTH, 0, maxHEALTH);
	if (global.HEALTH > healthBefore) {
		audio_play_sound(sndOneUp, 0, false);
	}
}

/// @desc Subtracts a specified amount of global.HEALTH from the player's total.
/// @param {real} amount The amount of global.HEALTH to subtract.
function damage(amount) {    global.HEALTH -= clamp(amount, 0, global.HEALTH); }

/// @desc Sets the player's global.HEALTH to a specific amount.
/// @param {real} amount The new total global.HEALTH for the player.
function setHEALTH(amount) {    global.HEALTH = clamp(amount, 0, maxHEALTH); }


global.WORLDS = [
	new world(worlds.tutorial, "Tutorial Island", [ rmStage1 ]),
];

/// @desc Returns the list of global.WORLDS in the game.
/// @returns {array} The list of global.WORLDS.
function getWORLDS() {    return global.WORLDS; }

/// @desc Adds a new world to the game.
/// @param {struct.world} _world The world to add
function addWORLD(_world) {    array_push(global.WORLDS, _world); }

/// @desc Marks a world as cleared. Also marks all stages within that world as cleared.
/// @param {string} name The name of the world to mark as cleared.
function clearWORLD(name) {
    var _world = getWORLD(name);
    if (_world != undefined) {
		var stages = _world.STAGES;
        _world.CLEARED = true;
		for (var i = 0; i < array_length(stages); i++) {
			stages[i].CLEARED = true;
        }
		audio_play_sound(sndWorldComplete, 0, false);
    }
}

/// @desc Retrieves a world by name.
/// @param {string} name The name of the world to retrieve.
/// @returns {struct} The world struct, or undefined if not found.
function getWORLD(name) {
    for (var i = 0; i < array_length(global.WORLDS); i++) {
        if (global.WORLDS[i].NAME == name) {
            return global.WORLDS[i];
        }
    }
    return undefined;
}

/// @desc Adds a stage to a specified world.
/// @param {string} worldNAME The name of the world to add the stage to.
/// @param {asset.room} stage The stage to add.
function addSTAGE(worldName, _stage) {
    var _world = getWORLD(worldName);
    array_push(_world.STAGES, _stage);
}

#macro currentWORLD global.WORLDS[global.SAVE.WORLD]
#macro currentSTAGE currentWORLD.STAGES[global.SAVE.STAGE]

#region GUI Macros
    #macro guiWIDTH display_get_gui_width()
    #macro guiHEIGHT display_get_gui_height()
    #macro centerX (guiWIDTH * 0.5)
    #macro centerY (guiHEIGHT * 0.5)
#endregion