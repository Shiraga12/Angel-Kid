/// @desc: Initializes player variables and constants.
event_user(0);

attackApplied = false;
chargeFrames = 0;
currentAttackPower = ATTACK.POWER;
currentAttackRange = ATTACK.RANGE;
haloInstanceId = noone;
haloThrown = false;
respawnX = x;
respawnY = y;
invulFrames = 0;
hitstunFrames = 0;
hurtHsp = 0;
hurtVsp = 0;

if (room == rmStage1) {
    audio_stop_all();
	audio_play_sound(SOUNDS.TUTORIAL_ISLAND, 0, true);
}

setRespawnPoint = function(_x, _y) {
    respawnX = _x;
    respawnY = _y;
};

event_user(1)
event_user(2);