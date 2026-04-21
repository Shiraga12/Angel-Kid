event_inherited();

SPRITES = {
    ATTACK: sSheldon_attack,
    DEFEAT: sSheldon_defeated,
    IDLE: sSheldon_Idle_6,
    WALK: sSheldon_walk_1
};

ATTACK_POWER = 1;
ATTACK_RANGE = 24;
ATTACK_HEIGHT = 14;
EDGE_CHECK = 10;
MOVE_SPEED = 0.75;

COLLISIONS = [
    layer_tilemap_get_id("tmSOLID")
];

HSP = 0;
VSP = 0;
GRV = 0.45;
STATIC = false;

HP = 2;
facing = 1;
isDefeated = false;

setSTATE = function(_state) {
    if (STATE != _state) {
        STATE = _state;
        image_index = 0;
    }
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

playerAhead = function() {
    var offsetX = facing * ATTACK_RANGE;
    var leftBound = x;
    var rightBound = x;

    if (offsetX < 0) {
        leftBound += offsetX;
    }
    else {
        rightBound += offsetX;
    }

    return collision_rectangle(
        leftBound, y - ATTACK_HEIGHT,
        rightBound, y + ATTACK_HEIGHT,
        oPlayer, false, true
    ) != noone;
};

shouldTurnAround = function() {
    var wallAhead = place_meeting(x + (facing * 8), y, COLLISIONS);
    var floorAhead = place_meeting(x + (facing * EDGE_CHECK), y + 12, COLLISIONS);

    return wallAhead || !floorAhead;
};

stateWALK = function() {
    if (sprite_index != SPRITES.WALK) {
        sprite_index = SPRITES.WALK;
        image_index = 0;
    }

    if (shouldTurnAround()) {
        facing *= -1;
    }

    HSP = MOVE_SPEED * facing;
    image_xscale = facing;

    if (playerAhead()) {
        setSTATE(stateATTACK);
    }
};

stateATTACK = function() {
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.ATTACK) {
        sprite_index = SPRITES.ATTACK;
        image_index = 0;
    }

    if (image_index >= sprite_get_number(sprite_index) - 1) {
        setSTATE(stateWALK);
    }
};

stateDEFEAT = function() {
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.DEFEAT) {
        sprite_index = SPRITES.DEFEAT;
        image_index = 0;
    }

    if (image_index >= sprite_get_number(sprite_index) - 1) {
        instance_destroy();
    }
};

STATE = stateWALK;