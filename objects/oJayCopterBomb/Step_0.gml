VSP += GRV;
y += VSP;

var player = instance_place(x, y, oPlayer);
if (player != noone && variable_instance_exists(player, "takeDamage")) {
    var takeDamageMethod = variable_instance_get(player, "takeDamage");
    takeDamageMethod(ATTACK_POWER, x);
    instance_destroy();
}

if (place_meeting(x, y, layer_tilemap_get_id("tmSOLID"))) {
    instance_destroy();
}

if (y > room_height + 32) {
    instance_destroy();
}