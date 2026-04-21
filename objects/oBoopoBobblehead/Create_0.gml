// Inherit the parent event
event_inherited();

SPRITES = {
    IDLE: sBoopoBobblehead_Idle,
    ATTACK: sBoopoBobblehead_Attack,
    DEFEAT: sBoopoBobblehead_Defeat,
    WALK: sBoopoBobblehead_Walk
};

MOVE_SPEED = 3;
GRV = 0.45;
ATTACK = {
    RANGE: 36,
    HEIGHT: 20,
    POWER: 1
};
EDGE_CHECK = 10;

timer = 0;
facing = 1;
defeatStarted = false;
HP = 1;
isDefeated = false;

setSTATE = function(_state) {
    if (STATE != _state) {
        STATE = _state;
        image_index = 0;
    }
};

canSeePlayer = function() {
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

shouldTurnAround = function() {
    var wallAhead = place_meeting(x + (facing * 8), y, COLLISIONS);
    var floorAhead = place_meeting(x + (facing * EDGE_CHECK), y + 12, COLLISIONS);

    return wallAhead || !floorAhead;
};

// Boopo Bobble-head moves back and forth in a small area. If the player gets too close, it attacks. It can be defeated by the player, but it doesn't fight back.
statePATROL = function() {
    if (sprite_index != SPRITES.WALK) {
        sprite_index = SPRITES.WALK;
        image_index = 0;
    }

    if (shouldTurnAround()) {
        facing *= -1;
    }

    HSP = MOVE_SPEED * facing;
    image_xscale = facing;

    if (canSeePlayer()) {
        setSTATE(stateATTACK);
    }
};

stateATTACK = function() {
    HSP = 0;

    if (sprite_index != SPRITES.ATTACK) {
        sprite_index = SPRITES.ATTACK;
        image_index = 0;
    }

    if (image_index >= sprite_get_number(sprite_index) - 1) {
        setSTATE(statePATROL);
    }
};

stateDEFEAT = function() {
    if (!defeatStarted) {
        defeatStarted = true;
        HSP = -facing * 2.5;
        VSP = -5;
    }

    if (sprite_index != SPRITES.DEFEAT) {
        sprite_index = SPRITES.DEFEAT;
        image_index = 0;
    }

    image_xscale = facing;

    if (y > room_height + sprite_height) {
        instance_destroy();
    }

    x += HSP;
    y += VSP;
    VSP += GRV;
};

takeHit = function(_power, _sourceX) {
    if (isDefeated) {
        return;
    }

    HP -= _power;
    facing = sign(x - _sourceX);
    if (facing == 0) {
        facing = 1;
    }

    if (HP <= 0) {
        isDefeated = true;
        setSTATE(stateDEFEAT);
    }
};

STATE = statePATROL;