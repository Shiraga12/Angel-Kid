if (!instance_exists(ownerId)) {
    instance_destroy();
    exit;
}

if (!returning) {
    var nextX = x + (throwDirection * travelSpeed);

    if (place_meeting(nextX, y, COLLISIONS)) {
        returning = true;
    }
    else {
        x = nextX;
        distanceTravelled += abs(throwDirection * travelSpeed);

        if (distanceTravelled >= maxDistance) {
            returning = true;
        }
    }
}

if (returning) {
    var targetX = ownerId.x + (ownerId.image_xscale * 6);
    var targetY = ownerId.y - 14;
    var returnDirection = point_direction(x, y, targetX, targetY);

    x += lengthdir_x(returnSpeed, returnDirection);
    y += lengthdir_y(returnSpeed, returnDirection);

    if (point_distance(x, y, targetX, targetY) <= returnSpeed + 2) {
        instance_destroy();
        exit;
    }
}

checkEnemyHits();