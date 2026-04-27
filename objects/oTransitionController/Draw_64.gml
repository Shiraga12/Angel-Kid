if (transitionState == TRANSITION_STATE.IDLE) {
    exit;
}

var guiWidth = display_get_gui_width();
var guiHeight = display_get_gui_height();

if (transitionState == TRANSITION_STATE.OUTRO) {
    if (!surface_exists(application_surface)) {
        cleanupTransition();
        exit;
    }

    progress = min(progress + progressStep, 0.5);

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

    draw_surface_stretched(application_surface, 0, 0, guiWidth, guiHeight);
    shader_reset();

    if (progress >= 0.5) {
        fromSurface = captureApplicationSurface();
        if (fromSurface == -1) {
            cleanupTransition();
            room_goto(targetRoom);
            exit;
        }

        transitionState = TRANSITION_STATE.CAPTURE_NEXT;
        application_surface_draw_enable(false);
        room_goto(targetRoom);
    }

    exit;
}

if (!surface_exists(fromSurface)) {
    cleanupTransition();
    exit;
}

if (transitionState == TRANSITION_STATE.CAPTURE_NEXT) {
    if (!surface_exists(application_surface)) {
        draw_set_color(c_black);
        draw_rectangle(0, 0, guiWidth, guiHeight, false);
        draw_set_color(c_white);
        exit;
    }

    transitionState = TRANSITION_STATE.ACTIVE;
}

if (!surface_exists(application_surface)) {
    cleanupTransition();
    exit;
}

progress = min(progress + progressStep, 1);

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

if (progress >= 1) {
    cleanupTransition();
}