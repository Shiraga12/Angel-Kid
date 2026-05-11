event_inherited();

SPRITES = {
    FLY: sThruston_Flying,
    IDLE: sThruston_Idle,
    LAUNCH: sThruston_lanch,
    WHEELS: sThruston_Wheels
};

ATTACK_POWER = 1;
AGGRO_HEIGHT = 24;
AGGRO_RANGE = 120;
EDGE_CHECK = 10;
FLY_SPEED = 4.5;
GRAVITY_FLY = 0;
GRAVITY_GROUND = 0.45;
HP = 1;
IDLE_TIME = 18;
LAUNCH_TIME = 12;
MOVE_SPEED = 0.9;

COLLISIONS = [
    layer_tilemap_get_id("tmSOLID")
];

stateTimer = IDLE_TIME;

playerDetected = function() {
    var player = instance_nearest(x, y, oPlayer);
    if (!instance_exists(player)) {
        return false;
    }

    var dx = player.x - x;
    var dy = abs(player.y - y);

    if (abs(dx) > AGGRO_RANGE || dy > AGGRO_HEIGHT) {
        return false;
    }

    facing = sign(dx);
    if (facing == 0) {
        facing = 1;
    }

    return true;
};

stateIDLE = new stateFUNCS(function() {
    GRV = GRAVITY_GROUND;
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.IDLE) {
        sprite_index = SPRITES.IDLE;
        image_index = 0;
    }

    if (playerDetected()) {
        stateTimer = LAUNCH_TIME;
        setSTATE(stateLAUNCH);
        return;
    }

    stateTimer -= 1;
    if (stateTimer <= 0) {
        setSTATE(stateWHEELS);
    }
});

stateWHEELS = new stateFUNCS(function() {
    GRV = GRAVITY_GROUND;

    if (sprite_index != SPRITES.WHEELS) {
        sprite_index = SPRITES.WHEELS;
        image_index = 0;
    }

    if (shouldTURN_AROUND()) {
        facing *= -1;
        stateTimer = IDLE_TIME;
        setSTATE(stateIDLE);
        return;
    }

    if (playerDetected()) {
        HSP = 0;
        stateTimer = LAUNCH_TIME;
        setSTATE(stateLAUNCH);
        return;
    }

    HSP = MOVE_SPEED * facing;
    image_xscale = facing;
});

stateLAUNCH = new stateFUNCS(function() {
    GRV = GRAVITY_GROUND;
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.LAUNCH) {
        sprite_index = SPRITES.LAUNCH;
        image_index = 0;

        var thrustonHiHoSound = sndThrustonHiHo;
        audio_play_sound(thrustonHiHoSound, 0, false);
    }

    stateTimer -= 1;
    if (stateTimer <= 0) {
        VSP = 0;
        setSTATE(stateFLY);
    }
});

stateFLY = new stateFUNCS(function() {
    GRV = GRAVITY_FLY;
    VSP = 0;
    HSP = FLY_SPEED * facing;
    image_xscale = facing;

    if (sprite_index != SPRITES.FLY) {
        sprite_index = SPRITES.FLY;
        image_index = 0;
    }

    if (place_meeting(x + (facing * 10), y, COLLISIONS)) {
        isDefeated = true;
        setSTATE(stateDEFEAT);
    }
});

stateDEFEAT = new stateFUNCS(function() {
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.FLY) {
        sprite_index = SPRITES.FLY;
        image_index = sprite_get_number(SPRITES.FLY) - 1;
    }

    image_speed = 0;
    y += 2;

    if (y > room_height + sprite_height) {
        instance_destroy();
    }
});

state = stateIDLE;