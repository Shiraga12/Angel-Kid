VSP += GRV;
y += VSP;

var player = instance_place(x, y, oPlayer);
if (player != noone) {
    player.takeKNOCKBACK(ATTACK_POWER, x);
    instance_destroy();
}

if (place_meeting(x, y, layer_tilemap_get_id("tmSOLID"))) {
    instance_destroy();
}

if (y > room_height + 32) {
    instance_destroy();
}