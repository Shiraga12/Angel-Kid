globalvar FONTS;

FONTS = [
	font_add_sprite_ext(sUpperCaseFNT, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", true, 0),
	font_add_sprite_ext(sNumberFNT, "0123456789", true, 0),
	font_add_sprite_ext(sStageIntroFNT, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", true, 0)
]

draw_set_font(FONTS[0]);