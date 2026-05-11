event_inherited();

SPRITES = {
    DEFEAT: sBlocko_Defeat_1,
    HIT: sBlocko_Hit_1,
    IDLE: sBlocko_Idle_4,
    WALK: sBlocko_Walking
};

MOVE_SPEED = 0.7;
IDLE_TIME = 20;
HIT_TIME = 12;
WALK_TIME = 56;
EDGE_CHECK = 10;
ATTACK_POWER = 0;
stateTimer = IDLE_TIME;

HP = 4;

stateIDLE = new stateFUNCS(function() {
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
});

stateWALK = new stateFUNCS(function() {
    if (sprite_index != SPRITES.WALK) {
        sprite_index = SPRITES.WALK;
        image_index = 0;
    }

    if (shouldTURN_AROUND()) {
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
});

stateHIT = new stateFUNCS(function() {
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
});

stateDEFEAT = new stateFUNCS(function() {
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.DEFEAT) {
        sprite_index = SPRITES.DEFEAT;
        image_index = 0;
    }

    if (image_index >= sprite_get_number(sprite_index) - 1) {
        instance_destroy();
    }
});

state = stateIDLE;