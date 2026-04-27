var logoSound = asset_get_index("sndAngelincLogo");

audio_stop_all();

if (logoSound != -1) {
    audio_play_sound(logoSound, 0, false);
}