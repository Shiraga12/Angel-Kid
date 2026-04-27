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
facing = 1;
isDefeated = false;
stateTimer = HOP_WAIT;

setSTATE = function(_state) {
    if (STATE != _state) {
        STATE = _state;
        image_index = 0;
    }
};

takeHit = method(id, function(_power, _sourceX) {
    if (isDefeated) {
        return;
    }

    HP -= _power;
    facing = sign(x - _sourceX);
    if (facing == 0) {
        facing = 1;
    }

    var enemyHurtSound = asset_get_index((HP <= 0) ? "sndEnemyHurt2" : "sndEnemyHurt");
    if (enemyHurtSound != -1) {
        audio_play_sound(enemyHurtSound, 0, false);
    }

    if (HP <= 0) {
        isDefeated = true;
        setSTATE(stateDEFEAT);
    }
});

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

    if (!place_meeting(x, y + 2, COLLISIONS)) {
        setSTATE(stateJUMP);
        return;
    }

    stateTimer -= 1;
    if (stateTimer <= 0) {
        if (shouldTurnAround()) {
            facing *= -1;
        }

        HSP = HOP_SPEED * facing;
        VSP = -HOP_STRENGTH;
        setSTATE(stateJUMP);
    }
};

stateJUMP = function() {
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