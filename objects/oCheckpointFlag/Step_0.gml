if (isActive) {
    if (sprite_index == SPRITES.OUT && image_index >= image_number - 1) {
        sprite_index = SPRITES.ACTIVE;
        image_index = 0;
        image_speed = 0;
    }
}
else if (sprite_index != SPRITES.IDLE) {
    sprite_index = SPRITES.IDLE;
    image_index = 0;
    image_speed = 1;
}