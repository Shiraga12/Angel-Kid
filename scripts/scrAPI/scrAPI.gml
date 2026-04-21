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
function addHEALTH(amount) {    HEALTH += clamp(amount, 0, 8 - HEALTH); }
/// @desc Sets the player's health to a specific amount.
/// @param {real} amount The new total health for the player.
function setHEALTH(amount) {    HEALTH = clamp(amount, 0, 8); }

