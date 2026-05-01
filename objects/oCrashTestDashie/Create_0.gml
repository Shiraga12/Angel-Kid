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

HP = 1;

stateDASH = new stateFUNCS(function() {
    if (sprite_index != SPRITES.DASH) {
        sprite_index = SPRITES.DASH;
        image_index = 0;
    }

    image_xscale = facing;
    HSP = DASH_SPEED * facing;

    if (shouldTURN_AROUND()) {
        stateTimer = CRASH_TIME;
        setSTATE(stateDEFEAT);
    }

    move_and_collide(HSP, VSP, COLLISIONS);
});
stateDEFEAT = new stateFUNCS(function() {
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
});

state = stateDASH;