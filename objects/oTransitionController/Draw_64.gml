if (transitionState == TRANSITION_STATE.IDLE) {
    exit;
}

var guiWidth = display_get_gui_width();
var guiHeight = display_get_gui_height();

if (!surface_exists(fromSurface)) {
    cleanupTransition();
    exit;
}

if (transitionState == TRANSITION_STATE.CAPTURE_NEXT) {
    if (surface_exists(application_surface)) {
        transitionState = TRANSITION_STATE.ACTIVE;
    }

    draw_surface_stretched(fromSurface, 0, 0, guiWidth, guiHeight);
    exit;
}

if (!surface_exists(application_surface)) {
    cleanupTransition();
    exit;
}

shader_set(currentShader);

if (uToTexture != -1) {
    texture_set_stage(uToTexture, surface_get_texture(application_surface));
}

if (uProgress != -1) {
    shader_set_uniform_f(uProgress, progress);
}

if (uResolution != -1) {
    shader_set_uniform_f(uResolution, guiWidth, guiHeight);
}

if (uFocus != -1) {
    shader_set_uniform_f(uFocus, focusX, focusY);
}

if (uPixelAmount != -1) {
    shader_set_uniform_f(uPixelAmount, pixelAmount);
}

draw_surface_stretched(fromSurface, 0, 0, guiWidth, guiHeight);
shader_reset();

if (finishAfterDraw) {
    cleanupTransition();
}
else {
    progress = min(progress + progressStep, 1);
    if (progress >= 1) {
        finishAfterDraw = true;
    }
}