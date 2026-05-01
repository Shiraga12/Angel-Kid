event_inherited();

BOSS_NAME = "Punching Bag Joe";
BOSS_SUBTITLE = "Tutorial Island Boss";

SPRITES = {
    IDLE: PBJ_Idle_7,
    PROJECTILE: PBJ_Attack_move_1,
    JAB: PBJ_Attack_move_2,
    DASH: PBJ_Attack_move_4,
    SKID: PBJ_Skid,
    UPPERCUT: PBJ_uppercut,
    JUMP: PBJ_Jump,
    GROUND_POUND: PBJ_ground_pound,
    HIT: PBJ_Hit_2,
    DEFEAT: PBJ_defated
};

MOVE_SPEED = 1.4;
AIR_SPEED = 3.25;
DASH_SPEED = 4.5;
JUMP_SPEED = 8.25;
HIT_TIME = 10;
ATTACK_COOLDOWN = 24;
INTRO_TIME = 75;
PHASE_CHANGE_TIME = 40;
VICTORY_TIME = 90;
ARENA_RANGE = 220;
ARENA_TRIGGER_RANGE = 150;
AGGRO_RANGE = 260;
JAB_RANGE = 44;
UPPERCUT_RANGE = 34;
DASH_RANGE = 160;
GROUND_POUND_RANGE = 88;
PROJECTILE_RANGE = 128;
ARENA_WALL_MARGIN = 36;
ARENA_WALL_WIDTH = 20;
UI_BAR_WIDTH = 360;
MAX_PHASE = 3;

ATTACK_POWER = {
    PROJECTILE: 1,
    JAB: 1,
    UPPERCUT: 2,
    DASH: 2,
    GROUND_POUND: 2
};

bossWallObject = oBossArenaWall;

COLLISIONS = [
    layer_tilemap_get_id("tmSOLID")
];

array_push(COLLISIONS, bossWallObject);

HSP = 0;
VSP = 0;
GRV = 0.45;
STATIC = false;

MAX_HP = 12;
HP = MAX_HP;
facing = 1;
homeX = x;
attackCooldown = ATTACK_COOLDOWN;
attackApplied = false;
attackPattern = 0;
stateTimer = 0;
dashDistance = 0;
jumpCommitted = false;
jumpTargetX = x;
defeatStarted = false;
isDefeated = false;
encounterStarted = false;
introComplete = false;
encounterCleared = false;
arenaLocked = false;
phase = 1;
bannerText = "";
bannerTimer = 0;
uiAlpha = 0;
uiTargetAlpha = 0;
leftWallId = noone;
rightWallId = noone;

setATTACK_COOLDOWN = function(_base) {
    attackCooldown = max(8, _base - ((phase - 1) * 4));
};

showBANNER = function(_text, _time) {
    bannerText = _text;
    bannerTimer = _time;
};

getPHASE_LABEL = function() {
    switch (phase) {
        case 1:
            return "Warm Up";
        case 2:
            return "Short Fuse";
        default:
            return "Meltdown";
    }
};

faceTARGET = function(_target) {
    if (!instance_exists(_target)) {
        return;
    }

    facing = sign(_target.x - x);
    if (facing == 0) {
        facing = image_xscale;
        if (facing == 0) {
            facing = 1;
        }
    }
};

createARENA_WALL = function(_wallX) {
    if (bossWallObject == -1) {
        return noone;
    }

    var wall = instance_create_layer(_wallX, room_height * 0.5, layer, bossWallObject);
    variable_instance_set(wall, "wallWidth", ARENA_WALL_WIDTH);
    variable_instance_set(wall, "wallHeight", room_height + 64);
    return wall;
};

lockARENA = function() {
    if (arenaLocked) {
        return;
    }

    arenaLocked = true;
    leftWallId = createARENA_WALL(homeX - ARENA_RANGE - ARENA_WALL_MARGIN);
    rightWallId = createARENA_WALL(homeX + ARENA_RANGE + ARENA_WALL_MARGIN);
};

unlockARENA = function() {
    arenaLocked = false;

    if (instance_exists(leftWallId)) {
        with (leftWallId) {
            instance_destroy();
        }
    }

    if (instance_exists(rightWallId)) {
        with (rightWallId) {
            instance_destroy();
        }
    }

    leftWallId = noone;
    rightWallId = noone;
};

releaseFINAL_CAGES = function() {
    with (oFinalCage) {
        if (variable_instance_exists(id, "openCage")) {
            openCage();
        }
    }
};

getTARGET_PHASE = function() {
    var hpRatio = HP / MAX_HP;

    if (hpRatio <= 0.34) {
        return 3;
    }

    if (hpRatio <= 0.67) {
        return 2;
    }

    return 1;
};

beginPHASE_SHIFT = function(_phase) {
    phase = clamp(_phase, 1, MAX_PHASE);
    HSP = 0;
    VSP = 0;
    stateTimer = PHASE_CHANGE_TIME;

    var pbjPhaseSound = sndPBJVoice2;
    audio_play_sound(pbjPhaseSound, 0, false);

    showBANNER(getPHASE_LABEL(), PHASE_CHANGE_TIME);
    setATTACK_COOLDOWN(ATTACK_COOLDOWN + 10);
    setSTATE(statePHASE_CHANGE);
};

startENCOUNTER = function() {
    if (encounterStarted) {
        return;
    }

    encounterStarted = true;

    var pbjIntroSound = sndPBJVoice;
    audio_play_sound(pbjIntroSound, 0, false);

    lockARENA();
    showBANNER(BOSS_NAME, INTRO_TIME);
    stateTimer = INTRO_TIME;
    uiTargetAlpha = 1;
    setSTATE(stateINTRO);
};

triggerDEFEAT_SEQUENCE = function() {
    if (encounterCleared) {
        return;
    }

    encounterCleared = true;
    isDefeated = true;
    unlockARENA();
    releaseFINAL_CAGES();
    uiTargetAlpha = 0;
    showBANNER("Victory", VICTORY_TIME);
};

applyFACING_HIT = function(_range, _top, _bottom, _power) {
    attackApplied = true;

    var leftBound = x;
    var rightBound = x;
    var offsetX = facing * _range;

    if (offsetX < 0) {
        leftBound += offsetX;
    }
    else {
        rightBound += offsetX;
    }

    var player = collision_rectangle(leftBound, y - _top, rightBound, y + _bottom, oPlayer, false, true);
    if (player != noone && variable_instance_exists(player, "takeDamage")) {
        var takeDamageMethod = variable_instance_get(player, "takeDamage");
        takeDamageMethod(_power, x, 4.5 + ((phase - 1) * 0.3), 5 + ((phase - 1) * 0.2));
    }
};

applyRADIAL_HIT = function(_range, _top, _bottom, _power) {
    attackApplied = true;

    var player = collision_rectangle(x - _range, y - _top, x + _range, y + _bottom, oPlayer, false, true);
    if (player != noone && variable_instance_exists(player, "takeDamage")) {
        var takeDamageMethod = variable_instance_get(player, "takeDamage");
        takeDamageMethod(_power, x, 4.75 + ((phase - 1) * 0.35), 5.5 + ((phase - 1) * 0.2));
    }
};

spawnPROJECTILE = function() {
    var projectile = instance_create_layer(
        x + (facing * 28),
        y - 12,
        layer,
        oPBJProjectile
    );

    variable_instance_set(projectile, "facing", facing);
    variable_instance_set(projectile, "projectileSpeed", 4.5 + ((phase - 1) * 0.75));
    variable_instance_set(projectile, "attackPower", ATTACK_POWER.PROJECTILE);
};

chooseATTACK = function() {
    var player = instance_nearest(x, y, oPlayer);
    if (!instance_exists(player)) {
        return;
    }

    attackPattern += 1;

    var distanceX = abs(player.x - x);
    var distanceY = player.y - y;
    var pattern = attackPattern mod 4;

    if (distanceY < -18 && distanceX <= UPPERCUT_RANGE) {
        stateTimer = 10;
        setSTATE(stateUPPERCUT);
        return;
    }

    if (phase == 1) {
        if (distanceX <= JAB_RANGE && pattern != 0) {
            setSTATE(stateJAB);
            return;
        }

        if (distanceX <= AGGRO_RANGE) {
            setSTATE(statePROJECTILE_ATTACK);
        }
        return;
    }

    if (phase == 2) {
        if (distanceX <= GROUND_POUND_RANGE && abs(distanceY) <= 44 && pattern == 0) {
            jumpTargetX = clamp(player.x, homeX - ARENA_RANGE, homeX + ARENA_RANGE);
            jumpCommitted = false;
            setSTATE(stateJUMP_ATTACK);
            return;
        }

        if (distanceX <= JAB_RANGE) {
            setSTATE(stateJAB);
            return;
        }

        if (distanceX <= AGGRO_RANGE) {
            setSTATE(statePROJECTILE_ATTACK);
        }
        return;
    }

    if (distanceX <= DASH_RANGE && pattern != 1) {
        dashDistance = 0;
        setSTATE(stateDASH_ATTACK);
        return;
    }

    if (distanceX <= GROUND_POUND_RANGE && abs(distanceY) <= 48) {
        jumpTargetX = clamp(player.x, homeX - ARENA_RANGE, homeX + ARENA_RANGE);
        jumpCommitted = false;
        setSTATE(stateJUMP_ATTACK);
        return;
    }

    if (distanceX <= JAB_RANGE) {
        setSTATE(stateJAB);
        return;
    }

    if (distanceX <= AGGRO_RANGE) {
        setSTATE(statePROJECTILE_ATTACK);
    }
};

stateDORMANT = new stateFUNCS(function() {
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.IDLE) {
        sprite_index = SPRITES.IDLE;
        image_index = 0;
    }

    var player = instance_nearest(x, y, oPlayer);
    if (instance_exists(player)) {
        faceTARGET(player);
        if (abs(player.x - x) <= ARENA_TRIGGER_RANGE && abs(player.y - y) <= 80) {
            startENCOUNTER();
        }
    }
});

stateINTRO = new stateFUNCS(function() {
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.IDLE) {
        sprite_index = SPRITES.IDLE;
        image_index = 0;
    }

    var player = instance_nearest(x, y, oPlayer);
    if (instance_exists(player)) {
        faceTARGET(player);
    }

    stateTimer -= 1;
    if (stateTimer <= 0) {
        introComplete = true;
        setATTACK_COOLDOWN(ATTACK_COOLDOWN);
        setSTATE(stateIDLE);
    }
});

statePHASE_CHANGE = new stateFUNCS(function() {
    HSP = 0;
    VSP = 0;
    image_xscale = facing;
    image_speed = 0;

    if (sprite_index != SPRITES.HIT) {
        sprite_index = SPRITES.HIT;
        image_index = 0;
    }

    stateTimer -= 1;
    if (stateTimer <= 0) {
        setSTATE(stateIDLE);
    }
});

stateIDLE = new stateFUNCS(function() {
    if (!encounterStarted) {
        setSTATE(stateDORMANT);
        return;
    }

    if (!introComplete) {
        setSTATE(stateINTRO);
        return;
    }

    var player = instance_nearest(x, y, oPlayer);
    var desiredSpeed = 0;
    var maxMoveSpeed = MOVE_SPEED + ((phase - 1) * 0.15);

    if (sprite_index != SPRITES.IDLE) {
        sprite_index = SPRITES.IDLE;
        image_index = 0;
    }

    if (attackCooldown > 0) {
        attackCooldown -= 1;
    }

    if (instance_exists(player)) {
        var distanceX = player.x - x;
        if (abs(distanceX) <= AGGRO_RANGE) {
            faceTARGET(player);

            if (abs(distanceX) > JAB_RANGE * 0.75) {
                desiredSpeed = clamp(distanceX * 0.05, -maxMoveSpeed, maxMoveSpeed);
            }

            if (attackCooldown <= 0) {
                HSP = 0;
                chooseATTACK();
                return;
            }
        }
    }

    if (desiredSpeed == 0) {
        var homeDelta = homeX - x;
        if (abs(homeDelta) > 4) {
            desiredSpeed = clamp(homeDelta * 0.04, -maxMoveSpeed, maxMoveSpeed);
            facing = sign(homeDelta);
        }
    }

    HSP = desiredSpeed;
    image_xscale = facing;
});

statePROJECTILE_ATTACK = new stateFUNCS(function() {
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.PROJECTILE) {
        sprite_index = SPRITES.PROJECTILE;
        image_index = 0;
    }

    if (!attackApplied && image_index >= 1) {
        attackApplied = true;
        spawnPROJECTILE();
    }

    if (image_index >= image_number - 1) {
        setATTACK_COOLDOWN(ATTACK_COOLDOWN + 10);
        setSTATE(stateIDLE);
    }
});

stateJAB = new stateFUNCS(function() {
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.JAB) {
        sprite_index = SPRITES.JAB;
        image_index = 0;
    }

    if (!attackApplied && image_index >= 1) {
        applyFACING_HIT(JAB_RANGE, 26, 20, ATTACK_POWER.JAB);
    }

    if (image_index >= image_number - 1) {
        setATTACK_COOLDOWN(ATTACK_COOLDOWN);
        setSTATE(stateIDLE);
    }
});

stateUPPERCUT = new stateFUNCS(function() {
    HSP = 0;
    image_xscale = facing;
    image_speed = 0;

    if (sprite_index != SPRITES.UPPERCUT) {
        sprite_index = SPRITES.UPPERCUT;
        image_index = 0;
    }

    if (!attackApplied) {
        applyFACING_HIT(UPPERCUT_RANGE, 48, 16, ATTACK_POWER.UPPERCUT);
    }

    stateTimer -= 1;
    if (stateTimer <= 0) {
        setATTACK_COOLDOWN(ATTACK_COOLDOWN + 6);
        setSTATE(stateIDLE);
    }
});

stateDASH_ATTACK = new stateFUNCS(function() {
    image_xscale = facing;

    if (sprite_index != SPRITES.DASH) {
        sprite_index = SPRITES.DASH;
        image_index = 0;
    }

    if (image_index < 1) {
        HSP = 0;
        return;
    }

    HSP = (DASH_SPEED + ((phase - 1) * 0.35)) * facing;
    dashDistance += abs(HSP);

    if (!attackApplied) {
        applyFACING_HIT(54, 24, 18, ATTACK_POWER.DASH);
    }

    if (dashDistance >= DASH_RANGE || place_meeting(x + (facing * 10), y, COLLISIONS) || image_index >= image_number - 1) {
        stateTimer = 10;
        setSTATE(stateSKID);
    }
});

stateSKID = new stateFUNCS(function() {
    HSP *= 0.7;
    image_xscale = facing;
    image_speed = 0;

    if (sprite_index != SPRITES.SKID) {
        sprite_index = SPRITES.SKID;
        image_index = 0;
    }

    stateTimer -= 1;
    if (stateTimer <= 0) {
        HSP = 0;
        setATTACK_COOLDOWN(ATTACK_COOLDOWN + 4);
        setSTATE(stateIDLE);
    }
});

stateJUMP_ATTACK = new stateFUNCS(function() {
    image_xscale = facing;
    image_speed = 0;

    if (sprite_index != SPRITES.JUMP) {
        sprite_index = SPRITES.JUMP;
        image_index = 0;
    }

    if (!jumpCommitted) {
        jumpCommitted = true;
        facing = sign(jumpTargetX - x);
        if (facing == 0) {
            facing = 1;
        }

        HSP = clamp((jumpTargetX - x) / 18, -AIR_SPEED, AIR_SPEED);
        VSP = -JUMP_SPEED;
    }

    if (VSP >= 0 && place_meeting(x, y + max(2, VSP + 2), COLLISIONS)) {
        HSP = 0;
        VSP = 0;
        stateTimer = 12;
        setSTATE(stateGROUND_POUND);
    }
});

stateGROUND_POUND = new stateFUNCS(function() {
    HSP = 0;
    VSP = 0;
    image_speed = 0;

    if (sprite_index != SPRITES.GROUND_POUND) {
        sprite_index = SPRITES.GROUND_POUND;
        image_index = 0;
    }

    if (!attackApplied) {
        applyRADIAL_HIT(GROUND_POUND_RANGE, 22, 22, ATTACK_POWER.GROUND_POUND);
    }

    stateTimer -= 1;
    if (stateTimer <= 0) {
        setATTACK_COOLDOWN(ATTACK_COOLDOWN + 12);
        setSTATE(stateIDLE);
    }
});

stateHIT = new stateFUNCS(function() {
    HSP = 0;
    image_xscale = facing;
    image_speed = 0;

    if (sprite_index != SPRITES.HIT) {
        sprite_index = SPRITES.HIT;
        image_index = 0;
    }

    stateTimer -= 1;
    if (stateTimer <= 0) {
        setSTATE(stateIDLE);
    }
});

stateDEFEAT = new stateFUNCS(function() {
    if (!defeatStarted) {
        defeatStarted = true;
        HSP = -facing * 2.2;
        VSP = -7;
    }

    if (sprite_index != SPRITES.DEFEAT) {
        sprite_index = SPRITES.DEFEAT;
        image_index = 0;
        image_speed = 0;
    }

    image_xscale = facing;
    x += HSP;
    y += VSP;
    VSP += GRV;
    HSP = lerp(HSP, 0, 0.08);

    if (y > room_height + sprite_height) {
        instance_destroy();
    }
});

state = stateDORMANT;