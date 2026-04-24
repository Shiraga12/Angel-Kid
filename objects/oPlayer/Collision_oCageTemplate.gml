/// COLLISION WITH oCageTemplate

var cage = instance_place(x, y, oCageTemplate);

if (cage == noone) {
	exit;
}

if (variable_instance_exists(cage, "isOpened") && variable_instance_get(cage, "isOpened")) {
	exit;
}

var deltaX = x - xprevious;
var deltaY = y - yprevious;
var overlapX = 0;
var overlapY = 0;

if (deltaX > 0) {
	overlapX = bbox_right - cage.bbox_left;
}
else if (deltaX < 0) {
	overlapX = cage.bbox_right - bbox_left;
}

if (deltaY > 0) {
	overlapY = bbox_bottom - cage.bbox_top;
}
else if (deltaY < 0) {
	overlapY = cage.bbox_bottom - bbox_top;
}

var resolveHorizontal = false;

if (deltaX != 0 && deltaY != 0) {
	resolveHorizontal = overlapX <= overlapY;
}
else {
	resolveHorizontal = (deltaX != 0);
}

if (resolveHorizontal && deltaX != 0) {
	x = xprevious;

	if (sign(SP.H) == sign(deltaX)) {
		SP.H = 0;
	}

	if (sign(hurtHsp) == sign(deltaX)) {
		hurtHsp = 0;
	}
}
else if (deltaY != 0) {
	y = yprevious;

	if (sign(SP.V) == sign(deltaY)) {
		SP.V = 0;
	}

	if (sign(hurtVsp) == sign(deltaY)) {
		hurtVsp = 0;
	}
}
else {
	x = xprevious;
	y = yprevious;
	SP.H = 0;
	SP.V = 0;
	hurtHsp = 0;
	hurtVsp = 0;
}

if (instance_place(x, y, cage.object_index) != noone) {
	x = xprevious;
	y = yprevious;
	SP.H = 0;
	SP.V = 0;
	hurtHsp = 0;
	hurtVsp = 0;
}