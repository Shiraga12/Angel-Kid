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

stateTimer = IDLE_TIME;
HP = 2;

stateIDLE = new stateFUNCS(function() {
	HSP = 0;
	image_xscale = facing;

	if (sprite_index != SPRITES.IDLE) {
		sprite_index = SPRITES.IDLE;
		image_index = 0;
	}

	if (canSEE_PLAYER()) {
		setSTATE(stateATTACK);
		return;
	}

	stateTimer -= 1;
	if (stateTimer <= 0) {
		stateTimer = WALK_TIME;
		setSTATE(stateWALK);
	}
});

stateWALK = new stateFUNCS(function() {
	if (sprite_index != SPRITES.WALK) {
		sprite_index = SPRITES.WALK;
		image_index = 0;
	}

	if (shouldTURN_AROUND()) {
		facing *= -1;
		stateTimer = IDLE_TIME;
		setSTATE(stateIDLE);
		return;
	}

	HSP = MOVE_SPEED * facing;
	image_xscale = facing;

	if (canSEE_PLAYER()) {
		setSTATE(stateATTACK);
		return;
	}

	stateTimer -= 1;
	if (stateTimer <= 0) {
		stateTimer = IDLE_TIME;
		setSTATE(stateIDLE);
	}
});

stateATTACK = new stateFUNCS(function() {
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
});

stateHIT = new stateFUNCS(function() {
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
});

stateDEFEAT = new stateFUNCS(function() {
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
});

state = stateIDLE;