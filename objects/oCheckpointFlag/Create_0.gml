SPRITES = {
    IDLE: sCheckpointFlag_Idle,
    OUT: sCheckpointFlag_Out,
    ACTIVE: sCheckpointFlag_Active
};

isActive = false;
respawnOffsetY = 3;

activateCheckpoint = function() {
    if (isActive) {
        return;
    }

    isActive = true;
    sprite_index = SPRITES.OUT;
    image_index = 0;
    image_speed = 1;
};

sprite_index = SPRITES.IDLE;
image_speed = 1;