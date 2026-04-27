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
/// @description Defines the cage structure for the game, which may be used for gameplay mechanics or narrative purposes.
function cage() constructor {
    BROKEN = false;

    /// @description Checks if the cage is broken.
    /// @returns {bool} True if the cage is broken, false otherwise.
    static isBROKEN = function() { return BROKEN; }
    /// @description Checks if the cage is not broken.
    /// @returns {bool} True if the cage is not broken, false otherwise.
    static isNOT_BROKEN = function() { return !BROKEN; }

    /// @description Sets the broken state of the cage.
    /// @param {bool} _broken Whether the cage should be marked as broken.
    static setBROKEN = function(_broken) { BROKEN = _broken; }

    /// @description Marks the cage as broken.
    static breakCAGE = function() { setBROKEN(true); }

    /// @description Marks the cage as not broken.
    static repair = function() { setBROKEN(false); }

    /// @description Marks the cage as broken.
    static _break = function() { breakCAGE(); }
}
/// @description Defines the stage structure for the game.
/// @param {asset.gmroom} _ROOM The room associated with the stage.
/// @param {real} _RECORD The record associated with the stage.
/// @param {array<struct.cage>} _CAGES An array of cages within the stage.
function stage(_ROOM, _RECORD = -1, _CAGES = []) constructor {
    ROOM = _ROOM;
    RECORD = _RECORD; // For Time Attack mode, may be used for other things later. -1 means no record.
    CAGES = _CAGES;
    CLEARED = false;

    /// @description Retrieves the room associated with the stage.
    /// @returns {asset.gmroom} The room associated with the stage.
    static getROOM      = function() { return ROOM; }
    /// @description Retrieves the record associated with the stage.
    /// @returns {real} The record associated with the stage.
    static getRECORD    = function() { return RECORD; }
    /// @description Retrieves the list of cages within the stage.
    /// @returns {array<struct.cage>} The list of cages.
    static getCAGES     = function() { return CAGES; }
    /// @description Retrieves a specific cage by index.
    /// @param {real} _index The index of the cage to retrieve.
    /// @returns {struct.cage} The cage struct at the specified index.
    static getCAGE      = function(_index) { return CAGES[_index]; }
    /// @description Checks if the stage has been cleared.
    /// @returns {bool} True if the stage is cleared, false otherwise.
    static isCLEARED    = function() { return CLEARED; }
    /// @description Checks if the stage has not been cleared.
    /// @returns {bool} True if the stage is not cleared, false otherwise.
    static isNOT_CLEARED = function() { return !CLEARED; }
    /// @description Checks if the stage is completed, which may involve specific conditions such as all cages being broken.
    /// @returns {bool} True if the stage is completed, false otherwise.
    static isCOMPLETED = function() { return CLEARED && array_length(CAGES) > 0 && !CAGES[| 0].isNOT_BROKEN(); }

    /// @description Marks the stage as cleared.
    static clear = function() {
        CLEARED = true;
    }
    /// @description Updates the record for the stage if the new record is better than the existing one.
    /// @param {real} _record The new record to compare against the existing record.
    static newRECORD = function(_record) {
        if (RECORD == -1 || _record < RECORD) {
            RECORD = _record;
        }
    }
}