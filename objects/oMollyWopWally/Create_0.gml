event_inherited();

SPRITES = {
    DEFEAT: sMollyWopWally_Defeated_2,
    IDLE: sMollyWopWally_Idle_5,
    JUMP: sMollyWopWally_jumping
};

ATTACK_POWER = 0;
COLLISIONS = [
    layer_tilemap_get_id("tmSOLID")
];
EDGE_CHECK = 12;
GRV = 0.45;
HOP_SPEED = 1.3;
HOP_STRENGTH = 7.5;
HOP_WAIT = 18;
STATIC = false;

HSP = 0;
VSP = 0;

HP = 4;
stateTimer = HOP_WAIT;

stateIDLE = new stateFUNCS(function() {
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.IDLE) {
        sprite_index = SPRITES.IDLE;
        image_index = 0;
    }

    if (!place_meeting(x, y + 2, COLLISIONS)) {
        setSTATE(stateJUMP);
        return;
    }

    stateTimer -= 1;
    if (stateTimer <= 0) {
        if (shouldTURN_AROUND()) {
            facing *= -1;
        }

        HSP = HOP_SPEED * facing;
        VSP = -HOP_STRENGTH;
        setSTATE(stateJUMP);
    }
});

stateJUMP = new stateFUNCS(function() {
    HSP = HOP_SPEED * facing;
    image_xscale = facing;

    if (sprite_index != SPRITES.JUMP) {
        sprite_index = SPRITES.JUMP;
        image_index = 0;
    }

    if (place_meeting(x, y + 2, COLLISIONS) && VSP >= 0) {
        HSP = 0;
        stateTimer = HOP_WAIT;
        setSTATE(stateIDLE);
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