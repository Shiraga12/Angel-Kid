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

HP = 2;

stateWALK = new stateFUNCS(function() {
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
    image_xscale = facing;

    if (sprite_index != SPRITES.ATTACK) {
        sprite_index = SPRITES.ATTACK;
        image_index = 0;
    }

    if (image_index >= sprite_get_number(sprite_index) - 1) {
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

state = stateWALK;