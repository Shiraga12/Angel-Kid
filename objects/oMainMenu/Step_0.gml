if (transition_is_active()) {
    exit;
}

if (noticeTimer > 0) {
    noticeTimer -= 1;
}

var keyUP = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var keyDOWN = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));

if (keyUP) {
    selectNEXT(-1);
}
else if (keyDOWN) {
    selectNEXT(1);
}

var guiWidth = max(1, display_get_gui_width());
var guiHeight = max(1, display_get_gui_height());
var menuX = guiWidth * menuAnchorX;
var mouseX = device_mouse_x_to_gui(0);
var mouseY = device_mouse_y_to_gui(0);
var itemCount = array_length(menuItems);

for (var i = 0; i < itemCount; i++) {
    var item = menuItems[i];
    var itemY = guiHeight * menuAnchorY + ((i - ((itemCount - 1) * 0.5)) * menuSpacing);
    var halfWidth = sprite_get_width(item.sprite) * menuScale * 0.5;
    var halfHeight = sprite_get_height(item.sprite) * menuScale * 0.5;

    if (mouseX >= menuX - halfWidth && mouseX <= menuX + halfWidth && mouseY >= itemY - halfHeight && mouseY <= itemY + halfHeight) {
        selectedIndex = i;

        if (mouse_check_button_pressed(mb_left)) {
            activateSELECTED();
        }

        break;
    }
}

var keyCONFIRM = keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space)
    || keyboard_check_pressed(ord("Z"))
    || keyboard_check_pressed(ord("X"));

if (keyCONFIRM) {
    activateSELECTED();
}