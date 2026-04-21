event_inherited();

SPRITES = {
    DEFEAT: sBlocko_Defeat_1,
    HIT: sBlocko_Hit_1,
    IDLE: sBlocko_Idle_4,
    WALK: sBlocko_Walking
};

MOVE_SPEED = 0.7;
IDLE_TIME = 20;
WALK_TIME = 56;
EDGE_CHECK = 10;
ATTACK_POWER = 0;

COLLISIONS = [
    layer_tilemap_get_id("tmSOLID")
];

HSP = 0;
VSP = 0;
GRV = 0.45;
STATIC = false;

HP = 4;
HIT_TIME = 12;
facing = 1;
isDefeated = false;
stateTimer = IDLE_TIME;

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
    else {
        stateTimer = HIT_TIME;
        setSTATE(stateHIT);
    }
};

shouldTurnAround = function() {
    var wallAhead = place_meeting(x + (facing * 8), y, COLLISIONS);
    var floorAhead = place_meeting(x + (facing * EDGE_CHECK), y + 12, COLLISIONS);

    return wallAhead || !floorAhead;
};

stateIDLE = function() {
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.IDLE) {
        sprite_index = SPRITES.IDLE;
        image_index = 0;
    }

    stateTimer -= 1;
    if (stateTimer <= 0) {
        stateTimer = WALK_TIME;
        setSTATE(stateWALK);
    }
};

stateWALK = function() {
    if (sprite_index != SPRITES.WALK) {
        sprite_index = SPRITES.WALK;
        image_index = 0;
    }

    if (shouldTurnAround()) {
        facing *= -1;
        stateTimer = IDLE_TIME;
        setSTATE(stateIDLE);
        return;
    }

    HSP = MOVE_SPEED * facing;
    image_xscale = facing;

    stateTimer -= 1;
    if (stateTimer <= 0) {
        stateTimer = IDLE_TIME;
        setSTATE(stateIDLE);
    }
};

stateHIT = function() {
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.HIT) {
        sprite_index = SPRITES.HIT;
        image_index = 0;
    }

    stateTimer -= 1;
    if (stateTimer <= 0) {
        stateTimer = WALK_TIME;
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

STATE = stateIDLE;