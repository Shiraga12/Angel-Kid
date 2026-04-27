/// API - 

#region LIVES
    globalvar LIVES;
    LIVES = 3;
    /// @desc Returns the current number of lives the player has.
    /// @returns {real} The player's current life count.
    function getLIVES() {    return LIVES;  }
    /// @desc Adds a specified amount of lives to the player's total.
    /// @param {real} amount The number of lives to add.
    function gainLIVES(amount) {    LIVES += amount; }
    /// @desc Subtracts a specified amount of lives from the player's total.
    /// @param {real} amount The number of lives to subtract.
    function loseLIVES(amount) {    LIVES -= amount; }
    /// @desc Sets the player's life count to a specific amount.
    /// @param {real} amount The new total number of lives for the player.
    function setLIVES(amount) {    LIVES = amount;  }
#endregion

#region SCORE
    globalvar SCORE;
    SCORE = 0;
    /// @desc Returns the player's current score.
    /// @returns {real} The player's current score.
    function getSCORE() {    return SCORE;  }
    /// @desc Adds a specified amount of points to the player's score.
    /// @param {real} amount The number of points to add.
    function addSCORE(amount) {    SCORE += amount; }
    /// @desc Sets the player's score to a specific amount.
    /// @param {real} amount The new total score for the player.
    function setSCORE(amount) {    SCORE = amount;  }
#endregion

#region TIME
    globalvar TIME;
    TIME = 0;
    /// @desc Returns the current time in seconds.
    /// @returns {real} The current time in seconds.
    function getTIME() {    return TIME;  }
    function addTIME(amount) {    TIME += amount; }
    /// @desc Sets the current time to a specific amount.
    /// @param {real} amount The new time in seconds.
    function setTIME(amount) {    TIME = amount;  }
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
function heal(amount) {
	var healthBefore = HEALTH;
	HEALTH += clamp(amount, 0, 8 - HEALTH);
	if (HEALTH > healthBefore) {
		var oneUpSound = asset_get_index("snd1Up");
		if (oneUpSound != -1) {
			audio_play_sound(oneUpSound, 0, false);
		}
	}
}
/// @desc Subtracts a specified amount of health from the player's total.
/// @param {real} amount The amount of health to subtract.
function damage(amount) {    HEALTH -= clamp(amount, 0, HEALTH); }
/// @desc Sets the player's health to a specific amount.
/// @param {real} amount The new total health for the player.
function setHEALTH(amount) {    HEALTH = clamp(amount, 0, 8); }

globalvar WORLDS;
WORLDS = [
	new world("Tutorial Island", [
        new stage(rmStage1, -1, [
            new cage(),
            new cage(),
            new cage(),
            new cage(),
        ]),
    ]),
    new world("Palm Bay", []),
    new world("Ziph Desert", []),
    new world("Gelida", []),
]
/// @desc Returns the list of worlds in the game.
/// @returns {array} The list of worlds.
function getWORLDS() {    return WORLDS; }
/// @desc Adds a new world to the game.
/// @param {string} name The name of the new world.
function addWORLD(name) {    array_push(WORLDS, new world(name, [])); }
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
		var worldCompleteSound = asset_get_index("sndWorldComplete");
		if (worldCompleteSound != -1) {
			audio_play_sound(worldCompleteSound, 0, false);
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
		array_push(world[$ "STAGES"], new stage(stageROOM));
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


