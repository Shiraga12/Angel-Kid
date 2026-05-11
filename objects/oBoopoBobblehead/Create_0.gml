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

HP = 1;

// Boopo Bobble-head moves back and forth in a small area. If the player gets too close, it attacks. It can be defeated by the player, but it doesn't fight back.
statePATROL = new stateFUNCS(function() {
    if (sprite_index != SPRITES.WALK) {
        sprite_index = SPRITES.WALK;
        image_index = 0;
    }

    if (shouldTURN_AROUND()) {
        facing *= -1;
    }

    HSP = MOVE_SPEED * facing;
    image_xscale = facing;

    if (canSEE_PLAYER()) {
        setSTATE(stateATTACK);
    }
});

stateATTACK = new stateFUNCS(function() {
    HSP = 0;

    if (sprite_index != SPRITES.ATTACK) {
        sprite_index = SPRITES.ATTACK;
        image_index = 0;
    }

    if (image_index >= sprite_get_number(sprite_index) - 1) {
        setSTATE(statePATROL);
    }
});

stateDEFEAT = new stateFUNCS(function() {
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
});

state = statePATROL;