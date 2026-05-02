// Controls
keyLEFT = keyboard_check(vk_left) || keyboard_check(ord("A"));
keyRIGHT = keyboard_check(vk_right) || keyboard_check(ord("D"));
keyUP = keyboard_check(vk_up) || keyboard_check(ord("W"));
keyDOWN = keyboard_check(vk_down) || keyboard_check(ord("S"));
keyRUN = keyboard_check(vk_shift);
keyFLY = keyboard_check(ord("F"));
keyHALO_PRESSED = keyboard_check_pressed(ord("X"));
keyPUNCH = keyboard_check(ord("Z"));
keyPUNCH_PRESSED = keyboard_check_pressed(ord("Z"));
keyPUNCH_RELEASED = keyboard_check_released(ord("Z"));
keyJUMP = keyboard_check_pressed(vk_space) || keyUP;
keyPOSE = keyboard_check_pressed(ord("C"));

state()

if (invulFrames > 0) {
    invulFrames -= 1;
}

if (state != stateDEAD && invulFrames > 0) {
    image_alpha = (((invulFrames div 4) mod 2) == 0) ? 0.35 : 1;
}
else {
    image_alpha = 1;
}