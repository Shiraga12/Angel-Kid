/// @desc Example usage for the dot-pixel room transition.

var titleThemeMusic = asset_get_index("sndTitleTheme");
audio_stop_all();
if (titleThemeMusic != -1) {
	audio_play_sound(titleThemeMusic, 0, true);
}

transitionPixelAmount = 50;
transitionShader = shdSonicFadeToBlackTransition;