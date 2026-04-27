/// API - 

#region LIVES
    global.LIVES = 3;
    /// @desc Returns the current number of lives the player has.
    /// @returns {real} The player's current life count.
    function getLIVES() {    return global.LIVES;  }
    /// @desc Adds a specified amount of lives to the player's total.
    /// @param {real} amount The number of lives to add.
    function gainLIVES(amount) {    global.LIVES += amount; }
    /// @desc Subtracts a specified amount of lives from the player's total.
    /// @param {real} amount The number of lives to subtract.
    function loseLIVES(amount) {    global.LIVES -= amount; }
    /// @desc Sets the player's life count to a specific amount.
    /// @param {real} amount The new total number of lives for the player.
    function setLIVES(amount) {    global.LIVES = amount;  }
#endregion

#region SCORE
    global.SCORE = 0;
    /// @desc Returns the player's current score.
    /// @returns {real} The player's current score.
    function getSCORE() {    return global.SCORE;  }
    /// @desc Adds a specified amount of points to the player's score.
    /// @param {real} amount The number of points to add.
    function addSCORE(amount) {    global.SCORE += amount; }
    /// @desc Sets the player's score to a specific amount.
    /// @param {real} amount The new total score for the player.
    function setSCORE(amount) {    global.SCORE = amount;  }
#endregion

#region TIME
    global.TIME = 0;
    /// @desc Returns the current time in seconds.
    /// @returns {real} The current time in seconds.
    function getTIME() {    return global.TIME;  }
    /// @desc Increments the current time by 1/60th of a second. This should be called once per frame to keep track of time.
    function timeCOUNT_UP() {    global.TIME =+ 1 / 60; }
    /// @desc Resets the current time to 0.
    function resetTIME() {    global.TIME = 0;  }
    /// @desc Decrements the current time by 1/60th of a second. This can be used for countdown timers.
    /// @param {real} amount The amount of time in seconds to subtract.
    function timeCOUNT_DOWN() {    global.TIME -= 1 / 60; }
    /// @desc Sets the current time to a specific amount.
    /// @param {real} amount The new time in seconds.
    function setTIME(amount) {    global.TIME = amount;  }
    /// @desc Adds a specified amount of time in seconds to the current time.
    /// @param {real} amount The amount of time in seconds to add.
    function addTIME(amount) {    global.TIME += amount; }
    /// @desc Subtracts a specified amount of time in seconds from the current time.
    /// @param {real} amount The amount of time in seconds to subtract.
    function subtractTIME(amount) {    global.TIME -= amount; }

    /// @desc Converts a number to a string and pads it with leading zeroes until it reaches a specified length.
    /// @param {real} number The number to convert and pad.
    /// @param {real} length The desired length of the resulting string, including leading zeroes.
    /// @returns {string} The resulting string with leading zeroes.
    function string_zeroes(number, length) {
        var str = string(number);
        while (string_length(str) < length) {
            str = "0" + str;
        }
        return str;
    }

    /// @desc Formats a time value in seconds into a string in the format "M:SS:MS".
    /// @param {real} seconds The time in seconds to format.
    /// @returns {string} The formatted time string.
    function formatTIME(seconds) {
        var minutes = floor(seconds / 60);
        var remainingSeconds = floor(seconds mod 60);
        var milliseconds = floor((seconds - floor(seconds)) * 1000);
        return $"{minutes}:{string_zeroes(remainingSeconds, 2)}:{string_zeroes(milliseconds, 3)}";
    }
#endregion

#region COINS
    global.COINS = 0;
    /// @desc Returns the current number of coins the player has.
    /// @returns {real} The player's current coin count.
    function getCOINS() {    return global.COINS;  }
    /// @desc Adds a specified amount of coins to the player's total.
    /// @param {real} amount The number of coins to add.
    function addCOINS(amount) {    global.COINS += amount; }
    /// @desc Sets the player's coin count to a specific amount.
    /// @param {real} amount The new total number of coins for the player.
    function setCOINS(amount) {    global.COINS = amount;  }
#endregion

#region HEALTH
    global.HEALTH = 8;
    /// @desc Returns the current health of the player.
    /// @returns {real} The player's current health.
    function getHEALTH() {    return global.HEALTH; }
    /// @desc Adds a specified amount of health to the player's total.
    /// @param {real} amount The amount of health to add.
    function heal(amount) {
        var healthBefore = global.HEALTH;
        global.HEALTH += clamp(amount, 0, 8 - global.HEALTH);
        if (global.HEALTH > healthBefore) {
            var oneUpSound = asset_get_index("snd1Up");
            if (oneUpSound != -1) {
                audio_play_sound(oneUpSound, 0, false);
            }
        }
    }
    /// @desc Subtracts a specified amount of health from the player's total.
    /// @param {real} amount The amount of health to subtract.
    function damage(amount) {    global.HEALTH -= clamp(amount, 0, global.HEALTH); }
    /// @desc Sets the player's health to a specific amount.
    /// @param {real} amount The new total health for the player.
    function setHEALTH(amount) {    global.HEALTH = clamp(amount, 0, 8); }
#endregion

#region WORLDS
    global.WORLDS = [
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
    function getWORLDS() {    return global.WORLDS; }
    /// @desc Retrieves a world by name.
    /// @param {string} name The name of the world to retrieve.
    /// @returns {struct} The world struct, or undefined if not found.
    function getWORLD(name) {
        for (var i = 0; i < array_length(global.WORLDS); i++) {
            if (global.WORLDS[i].getNAME() == name) {
                return global.WORLDS[i];
            }
        }
        return undefined;
    }
    /// @desc Adds a new world to the game.
    /// @param {string} name The name of the new world.
    function addWORLD(name) {    array_push(global.WORLDS, new world(name, [])); }
    /// @desc Marks a world as cleared. Also marks all stages within that world as cleared.
    /// @param {string} name The name of the world to mark as cleared.
    function clearWORLD(name) {
        var _world = getWORLD(name);
        if (_world != undefined) {
            var stages = _world[$ "STAGES"];
            _world.CLEARED = true;
            for (var i = 0; i < array_length(stages); i++) {
                stages[i].CLEARED = true;
            }
            var worldCompleteSound = asset_get_index("sndWorldComplete");
            if (worldCompleteSound != -1) {
                audio_play_sound(worldCompleteSound, 0, false);
            }
        }
    }
    /// @desc Adds a stage to a specified world.
    /// @param {string} worldNAME The name of the world to add the stage to.
    /// @param {string} stageNAME The name of the stage to add.
    /// @param {asset.room} stageROOM The room associated with the stage.
    function addSTAGE(worldNAME, stageNAME, stageROOM) {
        var _world = getWORLD(worldNAME);
        if (_world != undefined) {
            array_push(_world[$ "STAGES"], new stage(stageROOM));
        }
    }
#endregion

#region API
    globalvar API;
    API = {
        WORLD: 0, // The world index the player is currently in
        STAGE: 0, // The stage index within the current world
    }

    function getCURRENT_WORLD() {    return global.WORLDS[API.WORLD]; }
    function getCURRENT_STAGE() {    return getCURRENT_WORLD().STAGES[API.STAGE]; }
#endregion

#region GUI Macros
    #macro guiWIDTH display_get_gui_width()
    #macro guiHEIGHT display_get_gui_height()
    #macro centerX (guiWIDTH * 0.5)
    #macro centerY (guiHEIGHT * 0.5)
#endregion