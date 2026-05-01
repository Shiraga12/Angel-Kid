event_inherited();

SPRITES = {
    DEFEAT: sJayCopter_Defeated,
    FLY: sJayCopter_Flying
};

ATTACK_POWER = 1;
BOMB_DROP_TIME = 45;
FLY_RANGE = 48;
FLY_SPEED = 1;

HP = 1;
homeX = x;
dropTimer = BOMB_DROP_TIME;

stateFLY = new stateFUNCS(function() {
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
});

stateDEFEAT = new stateFUNCS(function() {
    if (sprite_index != SPRITES.DEFEAT) {
        sprite_index = SPRITES.DEFEAT;
        image_index = 0;
    }

    image_xscale = facing;
    y += 2;

    if (y > room_height + sprite_height) {
        instance_destroy();
    }
});

state = stateFLY;