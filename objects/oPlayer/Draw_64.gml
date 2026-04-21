///

// Draw Health

if STATE != stateDEAD {
    switch(HEALTH) {
        case 8: draw_sprite_ext(sHealthSystem, 0, 70, 70, 2, 2, 0, c_white, 1); break;
        case 7: draw_sprite_ext(sHealthSystem, 1, 70, 70, 2, 2, 0, c_white, 1); break;
        case 6: draw_sprite_ext(sHealthSystem, 2, 70, 70, 2, 2, 0, c_white, 1); break;
        case 5: draw_sprite_ext(sHealthSystem, 3, 70, 70, 2, 2, 0, c_white, 1); break;
        case 4: draw_sprite_ext(sHealthSystem, 4, 70, 70, 2, 2, 0, c_white, 1); break;
        case 3: draw_sprite_ext(sHealthSystem, 5, 70, 70, 2, 2, 0, c_white, 1); break;
        case 2: draw_sprite_ext(sHealthSystem, 6, 70, 70, 2, 2, 0, c_white, 1); break;
        case 1: draw_sprite_ext(sHealthSystem, 7, 70, 70, 2, 2, 0, c_white, 1); break;
        case 0: draw_sprite_ext(sHealthSystem, 8, 70, 70, 2, 2, 0, c_white, 1); break;
    }
}

// Draw Coins
draw_sprite_ext(sCoin, 0, 70, 90, 2, 2, 0, c_white, 1);
draw_set_valign(fa_middle);
draw_set_halign(fa_left);
draw_set_font(FONTS[1]);
draw_text_transformed(80, 90, string(COINS), 2, 2, 0);
draw_set_font(FONTS[0]);