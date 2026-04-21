// Controls
keyLEFT = keyboard_check(vk_left);
keyRIGHT = keyboard_check(vk_right);
keyUP = keyboard_check(vk_up);
keyDOWN = keyboard_check(vk_down);
keyRUN = keyboard_check(vk_shift);
keyFLY = keyboard_check(ord("F"));
keyHALO_PRESSED = keyboard_check_pressed(ord("X"));
keyPUNCH = keyboard_check(ord("Z"));
keyPUNCH_PRESSED = keyboard_check_pressed(ord("Z"));
keyPUNCH_RELEASED = keyboard_check_released(ord("Z"));
keyJUMP = keyboard_check_pressed(vk_space);
keyPOSE = keyboard_check_pressed(ord("C"));


STATE()

// Parallax background logic
if layer_exists("BackgroundA") {
    background_a = layer_get_id("BackgroundA");
}
if layer_exists("BackgroundB") {
    background_b = layer_get_id("BackgroundB");
}
if layer_exists("BackgroundC") {
    background_c = layer_get_id("BackgroundC");
}
if (background_a != -1) {
    layer_x(background_a, camera_get_view_x(view_camera[0]) / 2);
    layer_y(background_a, camera_get_view_y(view_camera[0]) / 2);
}
if (background_b != -1) {
    layer_x(background_b, camera_get_view_x(view_camera[0]) / 3);
    layer_y(background_b, camera_get_view_y(view_camera[0]) / 3);
}
if (background_c != -1) {
    layer_x(background_c, camera_get_view_x(view_camera[0]) / 4);
    layer_y(background_c, camera_get_view_y(view_camera[0]) / 4);
}
