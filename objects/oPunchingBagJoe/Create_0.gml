event_inherited();

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
DASH_SPEED = 4.25;
JUMP_SPEED = 8.25;
HIT_TIME = 10;
ATTACK_COOLDOWN = 24;
ARENA_RANGE = 220;
AGGRO_RANGE = 260;
JAB_RANGE = 44;
UPPERCUT_RANGE = 34;
DASH_RANGE = 160;
GROUND_POUND_RANGE = 88;
PROJECTILE_RANGE = 128;

ATTACK_POWER = {
    PROJECTILE: 1,
    JAB: 1,
    UPPERCUT: 2,
    DASH: 2,
    GROUND_POUND: 2
};

COLLISIONS = [
    layer_tilemap_get_id("tmSOLID")
];

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
stateTimer = 0;
dashDistance = 0;
jumpCommitted = false;
jumpTargetX = x;
defeatStarted = false;
isDefeated = false;

setSTATE = function(_state) {
    if (STATE != _state) {
        STATE = _state;
        image_index = 0;
        image_speed = 1;
        attackApplied = false;
    }
};

getPlayerTarget = function() {
    if (!instance_exists(oPlayer)) {
        return noone;
    }

    return instance_nearest(x, y, oPlayer);
};

faceTarget = function(_target) {
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

applyFacingHit = function(_range, _top, _bottom, _power) {
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

    if (collision_rectangle(leftBound, y - _top, rightBound, y + _bottom, oPlayer, false, true) != noone) {
        damage(_power);
    }
};

applyRadialHit = function(_range, _top, _bottom, _power) {
    attackApplied = true;

    if (collision_rectangle(x - _range, y - _top, x + _range, y + _bottom, oPlayer, false, true) != noone) {
        damage(_power);
    }
};

spawnProjectile = function() {
    var projectile = instance_create_layer(
        x + (facing * 28),
        y - 12,
        layer,
        oPBJProjectile
    );

    variable_instance_set(projectile, "facing", facing);
    variable_instance_set(projectile, "projectileSpeed", 4.5);
    variable_instance_set(projectile, "attackPower", ATTACK_POWER.PROJECTILE);
};

chooseAttack = function() {
    var player = getPlayerTarget();
    if (!instance_exists(player)) {
        return;
    }

    var distanceX = abs(player.x - x);
    var distanceY = player.y - y;
    var enraged = HP <= ceil(MAX_HP * 0.5);

    if (distanceY < -18 && distanceX <= UPPERCUT_RANGE) {
        stateTimer = 10;
        setSTATE(stateUPPERCUT);
        return;
    }

    if (distanceX <= JAB_RANGE) {
        setSTATE(stateJAB);
        return;
    }

    if (distanceX <= GROUND_POUND_RANGE && abs(distanceY) <= 40) {
        jumpTargetX = clamp(player.x, homeX - ARENA_RANGE, homeX + ARENA_RANGE);
        jumpCommitted = false;
        setSTATE(stateJUMP_ATTACK);
        return;
    }

    if (enraged && distanceX <= DASH_RANGE) {
        dashDistance = 0;
        setSTATE(stateDASH_ATTACK);
        return;
    }

    if (distanceX <= AGGRO_RANGE) {
        setSTATE(statePROJECTILE_ATTACK);
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

    HSP = 0;

    if (HP <= 0) {
        isDefeated = true;
        setSTATE(stateDEFEAT);
    }
    else {
        stateTimer = HIT_TIME;
        attackCooldown = ATTACK_COOLDOWN;
        setSTATE(stateHIT);
    }
});

stateIDLE = function() {
    var player = getPlayerTarget();
    var desiredSpeed = 0;

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
            faceTarget(player);

            if (abs(distanceX) > JAB_RANGE * 0.75) {
                desiredSpeed = clamp(distanceX * 0.05, -MOVE_SPEED, MOVE_SPEED);
            }

            if (attackCooldown <= 0) {
                HSP = 0;
                chooseAttack();
                return;
            }
        }
    }

    if (desiredSpeed == 0) {
        var homeDelta = homeX - x;
        if (abs(homeDelta) > 4) {
            desiredSpeed = clamp(homeDelta * 0.04, -MOVE_SPEED, MOVE_SPEED);
            facing = sign(homeDelta);
        }
    }

    HSP = desiredSpeed;
    image_xscale = facing;
};

statePROJECTILE_ATTACK = function() {
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.PROJECTILE) {
        sprite_index = SPRITES.PROJECTILE;
        image_index = 0;
    }

    if (!attackApplied && image_index >= 1) {
        attackApplied = true;
        spawnProjectile();
    }

    if (image_index >= image_number - 1) {
        attackCooldown = ATTACK_COOLDOWN + 10;
        setSTATE(stateIDLE);
    }
};

stateJAB = function() {
    HSP = 0;
    image_xscale = facing;

    if (sprite_index != SPRITES.JAB) {
        sprite_index = SPRITES.JAB;
        image_index = 0;
    }

    if (!attackApplied && image_index >= 1) {
        applyFacingHit(JAB_RANGE, 26, 20, ATTACK_POWER.JAB);
    }

    if (image_index >= image_number - 1) {
        attackCooldown = ATTACK_COOLDOWN;
        setSTATE(stateIDLE);
    }
};

stateUPPERCUT = function() {
    HSP = 0;
    image_xscale = facing;
    image_speed = 0;

    if (sprite_index != SPRITES.UPPERCUT) {
        sprite_index = SPRITES.UPPERCUT;
        image_index = 0;
    }

    if (!attackApplied) {
        applyFacingHit(UPPERCUT_RANGE, 48, 16, ATTACK_POWER.UPPERCUT);
    }

    stateTimer -= 1;
    if (stateTimer <= 0) {
        attackCooldown = ATTACK_COOLDOWN + 6;
        setSTATE(stateIDLE);
    }
};

stateDASH_ATTACK = function() {
    image_xscale = facing;

    if (sprite_index != SPRITES.DASH) {
        sprite_index = SPRITES.DASH;
        image_index = 0;
    }

    if (image_index < 1) {
        HSP = 0;
        return;
    }

    HSP = DASH_SPEED * facing;
    dashDistance += abs(HSP);

    if (!attackApplied) {
        applyFacingHit(54, 24, 18, ATTACK_POWER.DASH);
    }

    if (dashDistance >= DASH_RANGE || place_meeting(x + (facing * 10), y, COLLISIONS) || image_index >= image_number - 1) {
        stateTimer = 10;
        setSTATE(stateSKID);
    }
};

stateSKID = function() {
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
        attackCooldown = ATTACK_COOLDOWN + 4;
        setSTATE(stateIDLE);
    }
};

stateJUMP_ATTACK = function() {
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
};

stateGROUND_POUND = function() {
    HSP = 0;
    VSP = 0;
    image_speed = 0;

    if (sprite_index != SPRITES.GROUND_POUND) {
        sprite_index = SPRITES.GROUND_POUND;
        image_index = 0;
    }

    if (!attackApplied) {
        applyRadialHit(GROUND_POUND_RANGE, 22, 22, ATTACK_POWER.GROUND_POUND);
    }

    stateTimer -= 1;
    if (stateTimer <= 0) {
        attackCooldown = ATTACK_COOLDOWN + 12;
        setSTATE(stateIDLE);
    }
};

stateHIT = function() {
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
};

stateDEFEAT = function() {
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
};

STATE = stateIDLE;