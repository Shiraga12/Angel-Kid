x += projectileSpeed * facing;
image_xscale = facing;

var player = instance_place(x, y, oPlayer);
if (player != noone && variable_instance_exists(player, "takeDamage")) {
    var takeDamageMethod = variable_instance_get(player, "takeDamage");
    takeDamageMethod(attackPower, x);
    instance_destroy();
}

if (place_meeting(x, y, COLLISIONS)) {
    instance_destroy();
}

if (x < -sprite_width || x > room_width + sprite_width) {
    instance_destroy();
}