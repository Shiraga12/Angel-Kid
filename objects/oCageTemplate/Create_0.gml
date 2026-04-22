SPRITES = {
    IDLE: noone,
    OPENING: noone,
    OPENED: noone
};

HP = 1;
isOpened = false;

setSTATE = function(_state) {
    if (STATE != _state) {
        STATE = _state;
        image_index = 0;
    }
};

onOpen = function() {};

openCage = function() {
    if (isOpened) {
        return;
    }

    isOpened = true;
    onOpen();

    if (SPRITES.OPENING != noone) {
        setSTATE(stateOPENING);
    }
    else {
        setSTATE(stateOPENED);
    }
};

takeHit = method(id, function(_power, _sourceX) {
    if (isOpened) {
        return;
    }

    HP -= _power;
    if (HP <= 0) {
        openCage();
    }
});

stateIDLE = function() {
    if (SPRITES.IDLE != noone && sprite_index != SPRITES.IDLE) {
        sprite_index = SPRITES.IDLE;
        image_index = 0;
    }

    image_speed = 1;
};

stateOPENING = function() {
    if (SPRITES.OPENING == noone) {
        setSTATE(stateOPENED);
        return;
    }

    if (sprite_index != SPRITES.OPENING) {
        sprite_index = SPRITES.OPENING;
        image_index = 0;
    }

    image_speed = 1;
    if (image_index >= image_number - 1) {
        setSTATE(stateOPENED);
    }
};

stateOPENED = function() {
    if (SPRITES.OPENED != noone && sprite_index != SPRITES.OPENED) {
        sprite_index = SPRITES.OPENED;
        image_index = 0;
    }

    image_speed = 0;
};

STATE = stateIDLE;