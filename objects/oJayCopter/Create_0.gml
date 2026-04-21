SPRITES = {
    DEFEAT: sJayCopter_Defeated,
    FLY: sJayCopter_Flying
};

ATTACK_POWER = 1;
BOMB_DROP_TIME = 45;
FLY_RANGE = 48;
FLY_SPEED = 1;
HP = 1;

facing = 1;
homeX = x;
dropTimer = BOMB_DROP_TIME;
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
};

stateFLY = function() {
    if (sprite_index != SPRITES.FLY) {
        sprite_index = SPRITES.FLY;
        image_index = 0;
    }

    x += FLY_SPEED * facing;
    image_xscale = facing;

    if (abs(x - homeX) >= FLY_RANGE) {
        facing *= -1;
    }

    dropTimer -= 1;
    if (dropTimer <= 0) {
        instance_create_layer(x, y + sprite_height * 0.5, layer, oJayCopterBomb);
        dropTimer = BOMB_DROP_TIME;
    }
};

stateDEFEAT = function() {
    if (sprite_index != SPRITES.DEFEAT) {
        sprite_index = SPRITES.DEFEAT;
        image_index = 0;
    }

    image_xscale = facing;
    y += 2;

    if (y > room_height + sprite_height) {
        instance_destroy();
    }
};

STATE = stateFLY;