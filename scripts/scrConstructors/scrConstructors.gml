function empty() {}

function stateFUNCS(_STEP = empty, _DRAW = draw_self) constructor {
	STEP = method(other, _STEP);
	DRAW = method(other, _DRAW);
	
	static runSTEP = function() { STEP(); }
	static runDRAW = function() { DRAW(); }
}

/// @description Defines the world structure and data for the game.
/// @param {enum.worlds} _ID The id of the world.
/// @param {string} _NAME The name of the world.
/// @param {array<struct.stage>} _STAGES An array of stages within the world.
function world(_ID, _NAME, _STAGES)  constructor {
	ID = _ID;
    NAME = _NAME;
    STAGES = _STAGES;

    /// @description Retrieves the name of the world.
    /// @returns {string} The name of the world.
    static getNAME      = function() { return NAME; }
	
    /// @description Retrieves the list of stages within the world.
    /// @returns {array<room>} The list of stages.
    static getSTAGES    = function() { return STAGES; }
	
    /// @description Retrieves a specific stage by index.
    /// @param {real} _index The index of the stage to retrieve.
    /// @returns {asset.room} The stage struct at the specified index.
    static getSTAGE     = function(_index) { return STAGES[_index]; }
	
	/// @description Whether a specific stage is cleared or not.
    /// @param {real} _index The index of the stage to retrieve.
    /// @returns {bool} The stage struct at the specified index.
    static isSTAGE_CLEARED     = function(_index)
	{ return array_contains(global.SAVE.CLEARED_STAGES[ID], room_get_name(STAGES[_index])); }
	
	/// @description Clear a stage.
    /// @param {real} _index The index of the stage to retrieve.
    static clearSTAGE     = function(_index)
	{ array_push(global.SAVE.CLEARED_STAGES[ID], room_get_name(STAGES[_index])); }
	
    /// @description Checks if the world has been cleared.
    /// @returns {bool} True if the world is cleared, false otherwise.
    static isCLEARED    = function()
	{ return array_contains(global.SAVE.CLEARED_WORLDS, ID); }

    /// @description Marks the world as cleared and all stages within it as cleared.
    static clear = function()
	{ array_push(global.SAVE.CLEARED_WORLDS, ID); }
}