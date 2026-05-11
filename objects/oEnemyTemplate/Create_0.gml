event_inherited()

timer = 0;
facing = 1;
defeatStarted = false;
HP = 1;
isDefeated = false;
CONTACT_DAMAGE = 1;
CONTACT_KNOCKBACK_H = 3.5;
CONTACT_KNOCKBACK_V = 4.5;

IDLE_TIME = 0;
HIT_TIME = 0;
stateTimer = IDLE_TIME;

state = new stateFUNCS();
stateDEFEAT = new stateFUNCS();
stateHIT = new stateFUNCS();

setSTATE = function(_state) {
    if (state != _state) {
        state = _state;
        image_index = 0;
    }
}

takeHIT = method(id, function(_power, _sourceX) {
    if (isDefeated) {
        return;
    }

    HP -= _power;
    facing = sign(x - _sourceX);
    if (facing == 0) {
        facing = 1;
    }

    var enemyHurtSound = (HP <= 0) ? sndEnemyHurt2 : sndEnemyHurt;
	audio_play_sound(enemyHurtSound, 0, false);

    if (HP <= 0) {
        isDefeated = true;
        setSTATE(stateDEFEAT);
    }
    else {
        stateTimer = HIT_TIME;
        setSTATE(stateHIT);
    }
});

shouldTURN_AROUND = function() {
    var wallAhead = place_meeting(x + (facing * 8), y, COLLISIONS);
    var floorAhead = place_meeting(x + (facing * EDGE_CHECK), y + 12, COLLISIONS);

    return wallAhead || !floorAhead;
};

canSEE_PLAYER = function() {
    var offsetX = facing * ATTACK.RANGE;
    var leftBound = x;
    var rightBound = x;

    if (offsetX < 0) {
        leftBound += offsetX;
    }
    else {
        rightBound += offsetX;
    }

    return collision_rectangle(
        leftBound, y - ATTACK.HEIGHT,
        rightBound, y + ATTACK.HEIGHT,
        oPlayer, false, true
    ) != noone;
};