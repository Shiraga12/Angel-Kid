VSP += GRV;
y += VSP;

if (place_meeting(x, y, oPlayer)) {
    instance_destroy();
}

if (place_meeting(x, y, layer_tilemap_get_id("tmSOLID"))) {
    instance_destroy();
}

if (y > room_height + 32) {
    instance_destroy();
}