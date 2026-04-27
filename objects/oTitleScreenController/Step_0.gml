if (transition_is_active()) {
    exit;
}

var keyboardPressed = keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space)
    || keyboard_check_pressed(ord("Z"))
    || keyboard_check_pressed(ord("X"));

if (keyboardPressed) {
    transition_goto(rmMainMenu, 0.5, 0.5, 60, 50, shdSonicFadeToBlackTransition);
}