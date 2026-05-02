///@desc States

resetACTION_STATE = function() {
    attackApplied = false;
    chargeFrames = 0;
    currentAttackPower = ATTACK.POWER;
    currentAttackRange = ATTACK.RANGE;
    haloThrown = false;
};

stateFREE = function() {    
    // Movement logic
    SP.H = keyRIGHT - keyLEFT;
    SP.H *= keyRUN ? SP.RUN : SP.WALK;
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;
        if (keyJUMP) {
            SP.V = -SP.JUMP;
            state = stateJUMPING;
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
        state = stateFLYING;
    }
    else if (keyHALO_PRESSED && !(haloInstanceId != noone)) {
        beginHALO_THROW();
    }
    else if (keyPUNCH_PRESSED) {
        chargeFrames = 0;
        state = statePUNCH_CHARGING;
    }
    else if (keyPOSE) {
        state = stateGOOBER_POSE_SCARE;
    }

}

stateJUMPING = function() {
    SP.H = keyRIGHT - keyLEFT;
    SP.H *= keyboard_check(vk_shift) ? SP.RUN : SP.WALK;
	
    if (place_meeting(x, y + 2, COLLISIONS)) {
        SP.V = 0;   
		audio_play_sound(SOUNDS.HIT_LANDED, 0, false);
		state = stateFREE;
		return;
    }
	
    if (SP.V < SP.MAX_FALL) {
        SP.V += SP.GRV;
    }
	
    move_and_collide(SP.H, SP.V, COLLISIONS);

    if sprite_index != SPRITES.JUMP {
        sprite_index = SPRITES.JUMP;
        image_index = 0;
		audio_play_sound(SOUNDS.JUMP, 0, false);
    }
	if (SP.H != 0) {
        image_xscale = sign(SP.H);
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
		audio_play_sound(SOUNDS.FLY, 0, false);
    }

    if !keyFLY {
        state = stateFREE;
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
		audio_play_sound(SOUNDS.PUNCH_HOLD, 0, false);
    }

    if (keyPUNCH_RELEASED) {
        beginPUNCH();
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
        playerATTACK();
    }
    if image_index >= image_number - 1 {
        chargeFrames = 0;
        currentAttackPower = ATTACK.POWER;
        currentAttackRange = ATTACK.RANGE;
        state = stateFREE;
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
	    throwHALO();
	}

	// End animation
	if (image_index >= image_number - 1) {
	    state = stateFREE;
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
		audio_play_sound(SOUNDS.HIT_LANDED, 0, false);
    }
    if image_index >= image_number - 1 {
        state = stateFREE;
    }
}

stateGOOBER_POSE_SCARE = function() {
    SP.H = 0;
    SP.V = 0;
    move_and_collide(SP.H, SP.V, COLLISIONS);

    if sprite_index != SPRITES.GOOBER_POSE_SCARE {
        sprite_index = SPRITES.GOOBER_POSE_SCARE;
        image_index = 0;
		audio_play_sound(SOUNDS.GOOBER_SCARE, 0, false);
    }
    if image_index >= image_number - 1 {
        state = stateFREE;
    }
}

stateHIT = function() {
    if (sprite_index != SPRITES.HIT) {
        sprite_index = SPRITES.HIT;
        image_index = 0;
    }

    if (place_meeting(x, y + 2, COLLISIONS) && hurtVsp >= 0) {
        hurtVsp = 0;
    }
    else if (hurtVsp < SP.MAX_FALL) {
        hurtVsp += SP.GRV;
    }

    move_and_collide(hurtHsp, hurtVsp, COLLISIONS);

    hurtHsp = lerp(hurtHsp, 0, 0.2);
    if (abs(hurtHsp) < 0.05) {
        hurtHsp = 0;
    }

    hitstunFrames -= 1;
    if (hitstunFrames <= 0 && place_meeting(x, y + 2, COLLISIONS)) {
        hurtHsp = 0;
        hurtVsp = 0;
        state = stateFREE;
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
        recoverFROM_DEATH();
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

state = stateFREE;