globalvar FONTS;
globalvar FONT_LOOKUP;

FONTS = [
	font_add_sprite_ext(sUpperCaseFNT, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", true, 0),
	font_add_sprite_ext(sNumberFNT, "0123456789", true, 0),
	font_add_sprite_ext(sStageIntroFNT, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", true, 0),
	font_add_sprite_ext(sStageIntroNumberFNT, "12345678", true, 0)
];

FONT_LOOKUP = {
	sUpperCaseFNT: FONTS[0],
	sNumberFNT: FONTS[1],
	sStageIntroFNT: FONTS[2],
	sStageIntroNumberFNT: FONTS[3]
};

draw_set_font(FONTS[0]);