///@desc Attacking and being attacked

canTAKE_DAMAGE = function() {
    return state != stateDEAD && invulFrames <= 0;
};

beginDEATH = function() {
    resetACTION_STATE();
    if (haloInstanceId != noone && instance_exists(haloInstanceId)) {
        with (haloInstanceId) {
            instance_destroy();
        }
    }

    haloInstanceId = noone;
    hurtHsp = 0;
    hurtVsp = 0;
    SP.H = 0;
    SP.V = 0;
    image_alpha = 1;
    image_speed = 1;
    state = stateDEAD;
};

recoverFROM_DEATH = function() {
    x = respawnX;
    y = respawnY;
    hurtHsp = 0;
    hurtVsp = 0;
    SP.H = 0;
    SP.V = 0;
    image_alpha = 1;
    image_speed = 1;
    setHEALTH(RESPAWN_HEALTH);

    if (room == rmStage1) {
        audio_stop_all();
		audio_play_sound(SOUNDS.TUTORIAL_ISLAND, 0, true);
    }

    invulFrames = RESPAWN_INVUL_TIME;
    state = stateFREE;
};

takeKNOCKBACK = function(_amount, _sourceX, _knockbackH, _knockbackV) {
    if (!canTAKE_DAMAGE()) {
        return false;
    }

    if (is_undefined(_sourceX)) {
        _sourceX = x;
    }

    if (is_undefined(_knockbackH)) {
        _knockbackH = KNOCKBACK_H;
    }

    if (is_undefined(_knockbackV)) {
        _knockbackV = KNOCKBACK_V;
    }

    var healthBefore = getHEALTH();
    takeDAMAGE(_amount);
    if (getHEALTH() >= healthBefore) {
        return false;
    }

    resetACTION_STATE();

    var knockDirection = sign(x - _sourceX);
    if (knockDirection == 0) {
        knockDirection = image_xscale;
        if (knockDirection == 0) {
            knockDirection = 1;
        }
    }

    image_xscale = knockDirection;

    if (getHEALTH() <= 0) {
        audio_stop_all();
        if (SOUNDS.GAME_OVER != -1) {
            audio_play_sound(SOUNDS.GAME_OVER, 0, false);
        }
        beginDEATH();
        return true;
    }

    if (SOUNDS.LIFE_LOSS != -1) {
        audio_play_sound(SOUNDS.LIFE_LOSS, 0, false);
    }
    invulFrames = INVUL_TIME;
    hitstunFrames = HITSTUN_TIME;
    hurtHsp = knockDirection * _knockbackH;
    hurtVsp = -abs(_knockbackV);
    image_speed = 1;
    state = stateHIT;
    return true;
};

playerATTACK = function() {
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
        instance_place(rightBound, y, oCageTemplate),
        instance_place(rightBound, y, oEnemyTemplate),
        
        collision_rectangle(leftBound, y - ATTACK.HEIGHT, rightBound, y + ATTACK.HEIGHT, oCageTemplate, false, true),
        collision_rectangle(leftBound, y - ATTACK.HEIGHT, rightBound, y + ATTACK.HEIGHT, oEnemyTemplate, false, true)
    ];

    var didHit = false;

    for (var i = 0; i < array_length(targets); i += 1) {
        var target = targets[i];

        if (instance_exists(target)) {
            didHit = true;
            with (target) {
                if (variable_instance_exists(id, "takeHIT")) {
                    takeHIT(other.currentAttackPower, other.x);
                }
            }
        }
    }

    if (didHit) {
        if (SOUNDS.HIT_IMPACT != -1) {
            audio_play_sound(SOUNDS.HIT_IMPACT, 0, false);
        }
    }
};

beginPUNCH = function() {
    currentAttackPower = ATTACK.POWER;
    currentAttackRange = ATTACK.RANGE;

    if (chargeFrames >= ATTACK.CHARGE_TIME) {
        currentAttackPower = ATTACK.CHARGE_POWER;
        currentAttackRange = ATTACK.CHARGE_RANGE;
    }

    attackApplied = false;
    state = statePUNCHING;
};

throwHALO = function() {
    if (haloInstanceId != noone) {
        return;
    }

	if (SOUNDS.HALO_THROW != -1) {
		audio_play_sound(SOUNDS.HALO_THROW, 0, false);
	}

    var dir = image_xscale;

    var halo = instance_create_layer(
        x + (dir * HALO.X_OFFSET),
        y + HALO.Y_OFFSET,
        "Instances",
        oHalo,
		{
			owner: id,
			direction: (dir == 1) ? 0 : 180,
			speed: HALO.SPEED,
			returnSpeed: HALO.RETURN_SPEED,
			maxDistance: HALO.RANGE,
			damage: HALO.POWER
		}
    );

    haloInstanceId = halo;
};

beginHALO_THROW = function() {
    if (haloInstanceId != noone) {
        return;
    }

    haloThrown = false;
    state = stateHALO_THROW;
};