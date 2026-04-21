// Inherit the parent event
event_inherited();

SPRITES = {
	IDLE: sBuddyBrawler_Idle_3,
	WALK: sBuddyBrawler_Walking,
	ATTACK: sBuddyBrawler_Attack_1,
	DEFEAT: sBuddyBrawler_Defeat,
	HIT: sBuddyBrawler_Hit
};

MOVE_SPEED = 3;
IDLE_TIME = 24;
WALK_TIME = 48;
ATTACK = {
	RANGE: 44,
	HEIGHT: 18,
    POWER: 3
};
EDGE_CHECK = 10;

COLLISIONS = [
	layer_tilemap_get_id("tmSOLID")
];

HSP = 0;
VSP = 0;
GRV = 0.45;
STATIC = false;

facing = 1;
stateTimer = IDLE_TIME;
HP = 2;
HIT_TIME = 10;
isDefeated = false;

setSTATE = function(_state) {
	if (STATE != _state) {
		STATE = _state;
		image_index = 0;
	}
};

takeHit = function(_power, _sourceX) {
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
		setSTATE(stateDEFEAT);
	}
	else {
		stateTimer = HIT_TIME;
		setSTATE(stateHIT);
	}
};

playerAhead = function() {
	var offsetX = facing * ATTACK.RANGE;
	var leftBound = x;
	var rightBound = x;

	if (offsetX < 0) {
		leftBound += offsetX;
	}
	else {
		rightBound += offsetX;
	}

	return collision_rectangle(
		leftBound, y - ATTACK.HEIGHT,
		rightBound, y + ATTACK.HEIGHT,
		oPlayer, false, true
	) != noone;
};

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

	if (playerAhead()) {
		setSTATE(stateATTACK);
		return;
	}

	stateTimer -= 1;
	if (stateTimer <= 0) {
		stateTimer = WALK_TIME;
		setSTATE(stateWALK);
	}
};

stateWALK = function() {
	if (sprite_index != SPRITES.WALK) {
		sprite_index = SPRITES.WALK;
		image_index = 0;
	}

	if (shouldTurnAround()) {
		facing *= -1;
		stateTimer = IDLE_TIME;
		setSTATE(stateIDLE);
		return;
	}

	HSP = MOVE_SPEED * facing;
	image_xscale = facing;

	if (playerAhead()) {
		setSTATE(stateATTACK);
		return;
	}

	stateTimer -= 1;
	if (stateTimer <= 0) {
		stateTimer = IDLE_TIME;
		setSTATE(stateIDLE);
	}
};

stateATTACK = function() {
	HSP = 0;
	image_xscale = facing;

	if (sprite_index != SPRITES.ATTACK) {
		sprite_index = SPRITES.ATTACK;
		image_index = 0;
	}

	if (image_index >= sprite_get_number(sprite_index) - 1) {
		stateTimer = IDLE_TIME;
		setSTATE(stateIDLE);
	}
};

stateHIT = function() {
	HSP = 0;
	image_xscale = facing;

	if (sprite_index != SPRITES.HIT) {
		sprite_index = SPRITES.HIT;
		image_index = 0;
	}

	stateTimer -= 1;
	if (stateTimer <= 0) {
		stateTimer = IDLE_TIME;
		setSTATE(stateIDLE);
	}
};

stateDEFEAT = function() {
    if (!isDefeated) {
        isDefeated = true;
        HSP = -facing * 2.5;
        VSP = -5;
    }

    if (sprite_index != SPRITES.DEFEAT) {
        sprite_index = SPRITES.DEFEAT;
        image_index = 0;
    }

    image_xscale = facing;

    if (y > room_height + sprite_height) {
        instance_destroy();
    }

    x += HSP;
    y += VSP;
    VSP += GRV;
};

STATE = stateIDLE;

