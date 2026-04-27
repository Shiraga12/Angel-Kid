/// @description Defines the world structure and data for the game.
/// @param {string} _NAME The name of the world.
/// @param {array<struct.stage>} _STAGES An array of stages within the world.
function world(_NAME,_STAGES)  constructor {
    NAME = _NAME;
    STAGES = _STAGES;
    CLEARED = false;

    /// @description Retrieves the name of the world.
    /// @returns {string} The name of the world.
    static getNAME      = function() { return NAME; }
    /// @description Retrieves the list of stages within the world.
    /// @returns {array<struct.stage>} The list of stages.
    static getSTAGES    = function() { return STAGES; }
    /// @description Retrieves a specific stage by index.
    /// @param {real} _index The index of the stage to retrieve.
    /// @returns {struct.stage} The stage struct at the specified index.
    static getSTAGE     = function(_index) { return STAGES[_index]; }
    /// @description Checks if the world has been cleared.
    /// @returns {bool} True if the world is cleared, false otherwise.
    static isCLEARED    = function() { return CLEARED; }
    /// @description Checks if the world has not been cleared.
    /// @returns {bool} True if the world is not cleared, false otherwise.
    static isNOT_CLEARED = function() { return !CLEARED; }

    /// @description Marks the world as cleared and all stages within it as cleared.
    static clear = function() {
        CLEARED = true;
    }

}
/// @description Defines the stage structure for the game.
/// @param {asset.room} _ROOM The room associated with the stage.
function stage(_ROOM) constructor {
    ROOM = _ROOM;
    CLEARED = false;

    /// @description Retrieves the room associated with the stage.
    /// @returns {asset.room} The room associated with the stage.
    static getROOM      = function() { return ROOM; }
    /// @description Checks if the stage has been cleared.
    /// @returns {bool} True if the stage is cleared, false otherwise.
    static isCLEARED    = function() { return CLEARED; }
    /// @description Checks if the stage has not been cleared.
    /// @returns {bool} True if the stage is not cleared, false otherwise.
    static isNOT_CLEARED = function() { return !CLEARED; }

    /// @description Marks the stage as cleared.
    static clear = function() {
        CLEARED = true;
    }
}