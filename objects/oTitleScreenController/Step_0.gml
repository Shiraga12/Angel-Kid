if (transition_is_active()) {
    exit;
}

var keyboardPressed = keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space)
    || keyboard_check_pressed(ord("Z"))
    || keyboard_check_pressed(ord("X"));

if (mouse_check_button_pressed(mb_left)) {
    var guiWidth = max(1, display_get_gui_width());
    var guiHeight = max(1, display_get_gui_height());
    var focusX = clamp(device_mouse_x_to_gui(0) / guiWidth, 0, 1);
    var focusY = clamp(device_mouse_y_to_gui(0) / guiHeight, 0, 1);
    transition_goto(targetRoom, focusX, focusY, transitionDuration, transitionPixelAmount, transitionShader);
    exit;
}

if (keyboardPressed) {
    transition_goto(targetRoom, 0.5, 0.5, transitionDuration, transitionPixelAmount, transitionShader);
}