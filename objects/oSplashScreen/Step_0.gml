/// 

if image_index >= sprite_get_number(sprite_index) - 1 {
    image_speed = 0;
    transition_goto(rmTitleScreen, 0.5, 0.5, 60, 50, shdSonicFadeToBlackTransition);
};