/// @desc Controls shader-driven room transitions.

TRANSITION_STATE = {
    IDLE: 0,
    CAPTURE_NEXT: 1,
    ACTIVE: 2
};

transitionState = TRANSITION_STATE.IDLE;
targetRoom = noone;
fromSurface = -1;
toSurface = -1;
progress = 0;
progressStep = 0;
focusX = 0.5;
focusY = 0.5;
pixelAmount = 50;
finishAfterDraw = false;
currentShader = shdDotPixelTransition;

uProgress = -1;
uResolution = -1;
uFocus = -1;
uPixelAmount = -1;
uToTexture = -1;

configureShader = method(id, function(_shader) {
    if (is_undefined(_shader) || _shader == -1) {
        _shader = shdDotPixelTransition;
    }

    currentShader = _shader;
    uProgress = shader_get_uniform(currentShader, "u_progress");
    uResolution = shader_get_uniform(currentShader, "u_resolution");
    uFocus = shader_get_uniform(currentShader, "u_focus");
    uPixelAmount = shader_get_uniform(currentShader, "u_pixelAmount");
    uToTexture = shader_get_sampler_index(currentShader, "u_toTexture");
});

configureShader(currentShader);

cleanupTransition = method(id, function() {
    application_surface_draw_enable(true);

    if (surface_exists(fromSurface)) {
        surface_free(fromSurface);
    }

    if (surface_exists(toSurface)) {
        surface_free(toSurface);
    }

    fromSurface = -1;
    toSurface = -1;
    progress = 0;
    progressStep = 0;
    focusX = 0.5;
    focusY = 0.5;
    pixelAmount = 50;
    finishAfterDraw = false;
    targetRoom = noone;
    transitionState = TRANSITION_STATE.IDLE;
});

captureApplicationSurface = method(id, function() {
    if (!surface_exists(application_surface)) {
        return -1;
    }

    var capturedSurface = surface_create(
        surface_get_width(application_surface),
        surface_get_height(application_surface)
    );

    if (capturedSurface == -1) {
        return -1;
    }

    surface_copy(capturedSurface, 0, 0, application_surface);
    return capturedSurface;
});

beginTransition = method(id, function(_room, _focusX, _focusY, _durationFrames, _pixelAmount, _shader) {
    if (transitionState != TRANSITION_STATE.IDLE) {
        return false;
    }

    configureShader(_shader);

    var capturedSurface = captureApplicationSurface();
    if (capturedSurface == -1) {
        room_goto(_room);
        return false;
    }

    if (surface_exists(fromSurface)) {
        surface_free(fromSurface);
    }

    if (surface_exists(toSurface)) {
        surface_free(toSurface);
    }

    fromSurface = capturedSurface;
    toSurface = -1;
    targetRoom = _room;
    progress = 0;
    progressStep = 1 / max(1, round(_durationFrames));
    focusX = clamp(_focusX, 0, 1);
    focusY = clamp(_focusY, 0, 1);
    pixelAmount = max(1, _pixelAmount);
    finishAfterDraw = false;
    transitionState = TRANSITION_STATE.CAPTURE_NEXT;

    application_surface_draw_enable(false);
    room_goto(targetRoom);
    return true;
});

isActive = method(id, function() {
    return transitionState != TRANSITION_STATE.IDLE;
});