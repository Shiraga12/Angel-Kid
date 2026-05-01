if (uiAlpha > 0.01) {
    var barLeft = (guiWIDTH - UI_BAR_WIDTH) * 0.5;
    var barTop = 28;
    var healthRatio = clamp(HP / MAX_HP, 0, 1);

    draw_set_alpha(uiAlpha);
    draw_set_color(c_black);
    draw_rectangle(barLeft - 12, barTop - 20, barLeft + UI_BAR_WIDTH + 12, barTop + 28, false);

    draw_set_color(make_color_rgb(64, 32, 32));
    draw_rectangle(barLeft, barTop, barLeft + UI_BAR_WIDTH, barTop + 14, false);

    draw_set_color(make_color_rgb(230, 88, 64));
    draw_rectangle(barLeft, barTop, barLeft + (UI_BAR_WIDTH * healthRatio), barTop + 14, false);

    draw_set_color(c_white);
    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(barLeft + (UI_BAR_WIDTH * 0.5), barTop - 8, BOSS_NAME);
    draw_text(barLeft + (UI_BAR_WIDTH * 0.5), barTop + 22, getPHASE_LABEL());
    draw_set_alpha(1);
}

if (bannerTimer > 0) {
    var bannerAlpha = min(1, bannerTimer / 12);

    draw_set_alpha(bannerAlpha);
    draw_set_color(c_black);
    draw_rectangle(centerX - 160, centerY - 24, centerX + 160, centerY + 28, false);

    draw_set_color(c_white);
    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(centerX, centerY - 2, bannerText);

    if (!introComplete && !encounterCleared) {
        draw_text(centerX, centerY + 18, BOSS_SUBTITLE);
    }

    draw_set_alpha(1);
}

draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);