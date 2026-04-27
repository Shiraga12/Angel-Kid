/// @desc Ensures the persistent transition controller exists.
/// @returns {real} The controller instance id.
function transition_ensure_controller() {
	if (!instance_exists(oTransitionController)) {
		instance_create_depth(0, 0, -100000, oTransitionController);
	}

	return instance_find(oTransitionController, 0);
}

/// @desc Returns whether a room transition is currently active.
/// @returns {bool}
function transition_is_active() {
	var controller = transition_ensure_controller();
	if (!instance_exists(controller)) {
		return false;
	}

	var isActiveMethod = variable_instance_get(controller, "isActive");
	return isActiveMethod();
}

/// @desc Returns the default transition duration in frames.
/// @returns {real}
function transition_default_duration() {
	return max(1, round(room_speed));
}

/// @desc Starts a shader-backed transition to a specific room.
/// @param {asset.room} _room
/// @param {real} _focusX
/// @param {real} _focusY
/// @param {real} _durationFrames
/// @param {real} _pixelAmount
/// @param {asset.shader} _shader
/// @returns {bool}
function transition_goto(_room, _focusX = 0.5, _focusY = 0.5, _durationFrames = undefined, _pixelAmount = 50, _shader = shdSonicFadeToBlackTransition) {
	if (_room == noone || _room == -1) {
		return false;
	}

	if (is_undefined(_durationFrames)) {
		_durationFrames = transition_default_duration();
	}

	if (!shaders_are_supported()) {
		room_goto(_room);
		return false;
	}

	var controller = transition_ensure_controller();
	if (!instance_exists(controller)) {
		room_goto(_room);
		return false;
	}

	var beginTransitionMethod = variable_instance_get(controller, "beginTransition");
	return beginTransitionMethod(_room, _focusX, _focusY, _durationFrames, _pixelAmount, _shader);
}

/// @desc Starts a shader-backed transition to the next room in room order.
/// @param {real} _focusX
/// @param {real} _focusY
/// @param {real} _durationFrames
/// @param {real} _pixelAmount
/// @param {asset.shader} _shader
/// @returns {bool}
function transition_goto_next(_focusX = 0.5, _focusY = 0.5, _durationFrames = undefined, _pixelAmount = 50, _shader = shdSonicFadeToBlackTransition) {
	var nextRoom = room_next(room);
	if (nextRoom == -1) {
		return false;
	}

	return transition_goto(nextRoom, _focusX, _focusY, _durationFrames, _pixelAmount, _shader);
}