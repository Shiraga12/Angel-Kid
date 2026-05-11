/// @desc Example usage for the dot-pixel room transition.

var titleThemeMusic = sndTitleTheme;

audio_stop_all();
audio_play_sound(titleThemeMusic, 0, true);

transitionPixelAmount = 50;
transitionShader = shdSonicFadeToBlackTransition;