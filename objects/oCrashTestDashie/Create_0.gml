event_inherited();

SPRITES = {
    DASH: sCrashTestDashie_Dashing,
    DEFEATED: sCrashTestDashie_Defeated_1
};

DASH_SPEED = 3.5;
CRASH_TIME = 20;
EDGE_CHECK = 10;
ATTACK_POWER = 1;

COLLISIONS = [
    layer_tilemap_get_id("tmSOLID")
];

facing = 1;
stateTimer = 0;
HP = 1;
isDefeated = false;

takeHit = method(id, function(_power, _sourceX) {
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
        stateTimer = CRASH_TIME;
        setSTATE(stateDEFEAT);
    }
});
willCrash = function() {
    var wallAhead = place_meeting(x + (facing * 8), y, COLLISIONS);
    var floorAhead = place_meeting(x + (facing * EDGE_CHECK), y + 12, COLLISIONS);

    return wallAhead || !floorAhead;
};

setSTATE = function(_state) {
    if (STATE != _state) {
        STATE = _state;
        image_index = 0;
    }
};
stateDASH = function() {
    if (sprite_index != SPRITES.DASH) {
        sprite_index = SPRITES.DASH;
        image_index = 0;
    }

    image_xscale = facing;
    HSP = DASH_SPEED * facing;

    if (willCrash()) {
        stateTimer = CRASH_TIME;
        setSTATE(stateDEFEAT);
    }

    move_and_collide(HSP, VSP, COLLISIONS);
};
stateDEFEAT = function() {
    if (!isDefeated) {
        isDefeated = true;
        HSP = -facing * 2.5;
        VSP = -5;
    }

    if (sprite_index != SPRITES.DEFEATED) {
        sprite_index = SPRITES.DEFEATED;
        image_index = 0;
    }

    image_xscale = facing;

    VSP += GRV;
    HSP = lerp(HSP, 0, 0.14);
    move_and_collide(HSP, VSP, COLLISIONS);

    if (VSP >= 0 && place_meeting(x, y + 2, COLLISIONS)) {
        HSP = 0;
        VSP = 0;
        stateTimer -= 1;

        if (stateTimer <= 0) {
            instance_destroy();
        }
    }

    if (y > room_height + sprite_height) {
        instance_destroy();
    }
};

STATE = stateDASH;