/// @desc: Initializes player variables and constants.
SPRITES = {
    CLIMB: sAK_Climb,
    DEATH: sAK_Death,
    FLY: sAK_Fly,
    GOOBER_POSE_SCARE: sAK_GooberPosescare,
    HALO: sAK_Halo,
    HALO_THROW: sAK_HaloThrow,
    HIT: sAK_Hit,
    IDLE: sAK_Idle,
    JUMP: sAK_Jump,
    LANDING: sAK_Land,
    LOOK: {
        DOWN: sAK_Lookdown,
        UP: sAK_Lookup,
    },
    POWER_GIVEN: sAK_PowerGiven,
    PUNCH_CHARGE: sAK_PunchCharge,
    PUNCH: sAK_Punch,
    RUN: sAK_FullSpeed,
    VICTORY_DANCE: sAK_VictoryDance,
    WALK: sAK_Walk,
};

SP = {
    CLIMB: 2.25,
    FLY: 3.5,
    GRV: 0.45,
    H: 0,
    JUMP: 9.25,
    MAX_FALL: 10,
    RUN: 4.5,
    V: 0,
    WALK: 2.5,
};

ATTACK = {
    CHARGE_POWER: 3,
    CHARGE_RANGE: 40,
    CHARGE_TIME: 20,
    HEIGHT: 18,
    POWER: 1,
    RANGE: 28,
    TRIGGER_FRAME: 2,
};

HALO = {
    POWER: 1,
    RANGE: 132,
    RETURN_SPEED: 7,
    SPEED: 6,
    X_OFFSET: 40,
    Y_OFFSET: 9,
};

attackApplied = false;
chargeFrames = 0;
currentAttackPower = ATTACK.POWER;
currentAttackRange = ATTACK.RANGE;
haloInstanceId = noone;
haloThrown = false;

COLLISIONS = [
    layer_tilemap_get_id("tmSOLID")
]

playerAttack = function() {
    var jayCopterObject = asset_get_index("oJayCopter");
    var pbjObject = asset_get_index("oPunchingBagJoe");
    var shelldonObject = asset_get_index("oShelldon");
    var thrustonObject = asset_get_index("oThruston");
    var offsetX = image_xscale * currentAttackRange;
    var leftBound = x;
    var rightBound = x;

    if (offsetX < 0) {
        leftBound += offsetX;
    }
    else {
        rightBound += offsetX;
    }

    var targets = [
        instance_place(rightBound, y, oBoopoBobblehead),
        instance_place(rightBound, y, oBlocko),
        instance_place(rightBound, y, oBuddyBrawler),
        instance_place(rightBound, y, oCrashTestDashie),
        instance_place(rightBound, y, jayCopterObject),
        instance_place(rightBound, y, oMollyWopWally),
        instance_place(rightBound, y, pbjObject),
        instance_place(rightBound, y, shelldonObject),
        instance_place(rightBound, y, thrustonObject),
        
        collision_rectangle(leftBound, y - ATTACK.HEIGHT, rightBound, y + ATTACK.HEIGHT, oBoopoBobblehead, false, true),
        collision_rectangle(leftBound, y - ATTACK.HEIGHT, rightBound, y + ATTACK.HEIGHT, oBlocko, false, true),
        collision_rectangle(leftBound, y - ATTACK.HEIGHT, rightBound, y + ATTACK.HEIGHT, oBuddyBrawler, false, true),
        collision_rectangle(leftBound, y - ATTACK.HEIGHT, rightBound, y + ATTACK.HEIGHT, oCrashTestDashie, false, true),
        collision_rectangle(leftBound, y - ATTACK.HEIGHT, rightBound, y + ATTACK.HEIGHT, jayCopterObject, false, true),
        collision_rectangle(leftBound, y - ATTACK.HEIGHT, rightBound, y + ATTACK.HEIGHT, oMollyWopWally, false, true),
        collision_rectangle(leftBound, y - ATTACK.HEIGHT, rightBound, y + ATTACK.HEIGHT, pbjObject, false, true),
        collision_rectangle(leftBound, y - ATTACK.HEIGHT, rightBound, y + ATTACK.HEIGHT, shelldonObject, false, true),
        collision_rectangle(leftBound, y - ATTACK.HEIGHT, rightBound, y + ATTACK.HEIGHT, thrustonObject, false, true)
    ];

    for (var i = 0; i < array_length(targets); i += 1) {
        var target = targets[i];

        if (instance_exists(target)) {
            with (target) {
                if (variable_instance_exists(id, "takeHit")) {
                    takeHit(other.currentAttackPower, other.x);
                }
            }
        }
    }
};

beginPunch = function() {
    currentAttackPower = ATTACK.POWER;
    currentAttackRange = ATTACK.RANGE;

    if (chargeFrames >= ATTACK.CHARGE_TIME) {
        currentAttackPower = ATTACK.CHARGE_POWER;
        currentAttackRange = ATTACK.CHARGE_RANGE;
    }

    attackApplied = false;
    STATE = statePUNCHING;
};

throwHalo = function() {
    if (haloInstanceId != noone) {
        return;
    }

    var dir = image_xscale;

    var halo = instance_create_layer(
        x + (dir * HALO.X_OFFSET),
        y + HALO.Y_OFFSET,
        "Instances",
        oHalo
    );

    haloInstanceId = halo;

    // Direct assignment (cleaner + safer)
    halo.owner = id;
    halo.direction = (dir == 1) ? 0 : 180;
    halo.speed = HALO.SPEED;
    halo.returnSpeed = HALO.RETURN_SPEED;
    halo.maxDistance = HALO.RANGE;
    halo.damage = HALO.POWER;
};

beginHaloThrow = function() {
    if (haloInstanceId != noone) {
        return;
    }

    haloThrown = false;
    STATE = stateHALO_THROW;
};

#region State Functions
stateFREE = function() {    
    // Movement logic
    SP.H = keyRIGHT - keyLEFT;
    SP.H *= keyRUN ? SP.RUN : SP.WALK;
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;
        if (keyJUMP) {
            SP.V = -SP.JUMP;
            STATE = stateJUMPING;
        }
    }
    else if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
    move_and_collide(SP.H, SP.V, COLLISIONS);

    var isWALKING = (SP.H != 0);
    var isRUNNING = (isWALKING && keyRUN);
    var isLOOKING_UP = keyUP && !isWALKING;
    var isLOOKING_DOWN = keyDOWN && !isWALKING;

    if (isRUNNING) {
        if (sprite_index != SPRITES.RUN) {
            sprite_index = SPRITES.RUN;
            image_index = 0;
        }
    }
    else if (isWALKING) {
        if (sprite_index != SPRITES.WALK) {
            sprite_index = SPRITES.WALK;
            image_index = 0;
        }
    }
    else if (isLOOKING_UP) {
        if (sprite_index != SPRITES.LOOK.UP) {
            sprite_index = SPRITES.LOOK.UP;
            image_index = 0;
        }
    }
    else if (isLOOKING_DOWN) {
        if (sprite_index != SPRITES.LOOK.DOWN) {
            sprite_index = SPRITES.LOOK.DOWN;
            image_index = 0;
        }
    }
    else {
        if (sprite_index != SPRITES.IDLE) {
            sprite_index = SPRITES.IDLE;
            image_index = 0;
        }
    }
    if (SP.H != 0) {
        image_xscale = sign(SP.H);
    }

    if (keyFLY) {
        STATE = stateFLYING;
    }
    else if (keyHALO_PRESSED && !(haloInstanceId != noone)) {
        beginHaloThrow();
    }
    else if (keyPUNCH_PRESSED) {
        chargeFrames = 0;
        STATE = statePUNCH_CHARGING;
    }
    else if (keyPOSE) {
        STATE = stateGOOBER_POSE_SCARE;
    }

}

stateJUMPING = function() {
    SP.H = keyRIGHT - keyLEFT;
    SP.H *= keyboard_check(vk_shift) ? SP.RUN : SP.WALK;
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;   
        STATE = stateAIR_TO_GROUND;     
    }
    else if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
    move_and_collide(SP.H, SP.V, COLLISIONS);

    // Transition to jumping state
    if sprite_index != SPRITES.JUMP {
        sprite_index = SPRITES.JUMP;
        image_index = 0;
    }
}

stateFLYING = function() {
    SP.H = keyRIGHT - keyLEFT;
    SP.V = keyDOWN - keyUP;
    SP.H *= SP.FLY;
    SP.V *= SP.FLY;

    move_and_collide(SP.H, SP.V, COLLISIONS);

    // Transition to flying state
    if sprite_index != SPRITES.FLY {
        sprite_index = SPRITES.FLY;
        image_index = 0;
    }

    if !keyFLY {
        STATE = stateFREE;
    }
}

statePUNCH_CHARGING = function() {
    SP.H = 0;
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;
    }
    else if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
    move_and_collide(SP.H, SP.V, COLLISIONS);

    if (sprite_index != SPRITES.PUNCH_CHARGE) {
        sprite_index = SPRITES.PUNCH_CHARGE;
        image_index = 0;
    }

    if (keyPUNCH_RELEASED) {
        beginPunch();
    }
}

statePUNCHING = function() {
    // Movement logic
    SP.H = 0;
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;
    }
    else if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
    move_and_collide(SP.H, SP.V, COLLISIONS);

    // Transition to punching state
    if sprite_index != SPRITES.PUNCH {
        sprite_index = SPRITES.PUNCH;
        image_index = 0;
    }

    if (!attackApplied && image_index >= ATTACK.TRIGGER_FRAME) {
        attackApplied = true;
        playerAttack();
    }
    if image_index >= image_number - 1 {
        chargeFrames = 0;
        currentAttackPower = ATTACK.POWER;
        currentAttackRange = ATTACK.RANGE;
        STATE = stateFREE;
    }
}

stateHALO_THROW = function() {
    SP.H = 0;
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;
    }
    else if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
    move_and_collide(SP.H, SP.V, COLLISIONS);

    if (sprite_index != SPRITES.HALO_THROW) {
        sprite_index = SPRITES.HALO_THROW;
        image_index = 0;
        image_speed = 1;
    }
    else if (image_speed == 0) {
        image_speed = 1;
    }

    // Throw at specific frame (feels responsive)
	if (!haloThrown && image_index >= 13) {
	    haloThrown = true;
	    throwHalo();
	}

	// End animation
	if (image_index >= image_number - 1) {
	    STATE = stateFREE;
	}
}

stateAIR_TO_GROUND = function() {
    // Movement logic
    SP.H = 0;
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;
    }
    else if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
    move_and_collide(SP.H, SP.V, COLLISIONS);

    // Transition from air to ground
    if sprite_index != SPRITES.LANDING {
        sprite_index = SPRITES.LANDING;
        image_index = 0;
    }
    if image_index >= image_number - 1 {
        STATE = stateFREE;
    }
}

stateGOOBER_POSE_SCARE = function() {
    SP.H = 0;
    SP.V = 0;
    move_and_collide(SP.H, SP.V, COLLISIONS);

    if sprite_index != SPRITES.GOOBER_POSE_SCARE {
        sprite_index = SPRITES.GOOBER_POSE_SCARE;
        image_index = 0;
    }
    if image_index >= image_number - 1 {
        STATE = stateFREE;
    }
}

stateDEAD = function() {
    SP.H = 0;
    SP.V = 0;
    move_and_collide(SP.H, SP.V, COLLISIONS);

    if sprite_index != SPRITES.DEATH {
        sprite_index = SPRITES.DEATH;
        image_index = 0;
    }

    if image_index >= image_number - 1 {
        // Respawn logic can be added here
    }
}

stateVICTORY_DANCE = function() {
    SP.H = 0;
    SP.V = 0;
    move_and_collide(SP.H, SP.V, COLLISIONS);

    if sprite_index != SPRITES.VICTORY_DANCE {
        sprite_index = SPRITES.VICTORY_DANCE;
        image_index = 0;
    }
}

STATE = stateFREE;

#endregion