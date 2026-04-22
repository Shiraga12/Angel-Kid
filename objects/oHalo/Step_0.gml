// Move forward
var moveSpd = returning ? returnSpeed : speed;

x += lengthdir_x(moveSpd, direction);
y += lengthdir_y(moveSpd, direction);

// Track distance
distanceTraveled += moveSpd;

// Start returning
if (!returning && distanceTraveled >= maxDistance) {
    returning = true;
}

// Return to player
if (returning && instance_exists(owner)) {
    direction = point_direction(x, y, owner.x, owner.y);

    // If close enough, destroy and "give back"
    if (point_distance(x, y, owner.x, owner.y) < 10) {
        owner.haloInstanceId = noone;
        instance_destroy();
    }
}