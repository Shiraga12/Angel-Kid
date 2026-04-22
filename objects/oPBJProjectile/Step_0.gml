x += projectileSpeed * facing;
image_xscale = facing;

if (place_meeting(x, y, oPlayer)) {
    damage(attackPower);
    instance_destroy();
}

if (place_meeting(x, y, COLLISIONS)) {
    instance_destroy();
}

if (x < -sprite_width || x > room_width + sprite_width) {
    instance_destroy();
}