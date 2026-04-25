var guiWidth = display_get_gui_width();
var guiHeight = display_get_gui_height();
var menuX = guiWidth * menuAnchorX;
var itemCount = array_length(menuItems);

for (var i = 0; i < itemCount; i++) {
    var item = menuItems[i];
    var itemY = guiHeight * menuAnchorY + ((i - ((itemCount - 1) * 0.5)) * menuSpacing);
    var frame = (i == selectedIndex) ? 1 : 0;
    var alpha = item.enabled ? 1 : 0.7;

    if (!item.enabled && i == selectedIndex) {
        alpha = 0.85;
    }

    draw_sprite_ext(item.sprite, frame, menuX, itemY, menuScale, menuScale, 0, c_white, alpha);
}

if (noticeTimer > 0 && noticeText != "") {
    var noticeAlpha = min(1, noticeTimer / max(1, noticeDuration * 0.2));

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_alpha(noticeAlpha);
    draw_set_colour(c_black);
    draw_text(guiWidth * 0.5 + 2, guiHeight * 0.82 + 2, noticeText);
    draw_set_colour(c_white);
    draw_text(guiWidth * 0.5, guiHeight * 0.82, noticeText);

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}