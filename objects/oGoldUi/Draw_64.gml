if oPlayer.state != oPlayer.stateDEAD {
    draw_sprite_ext(sHealthSystem, 8, 70, 70, 2, 2, 0, c_white, 1);
}
else {
    draw_sprite_ext(sHealthSystemBroken, oPlayer.image_index, 70, 70, 2, 2, 0, c_white, 1);
}

// Draw global.COINS
draw_sprite_ext(sCoin, 0, 60, 160, 2, 2, 0, c_white, 1);
draw_set_valign(fa_middle);
draw_set_halign(fa_left);
draw_set_font(FONTS[1]);
draw_text_transformed(80, 160, string(global.COINS), 2, 2, 0);
draw_set_font(FONTS[0]);