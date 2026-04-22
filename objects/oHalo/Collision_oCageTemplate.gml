/// COLLISION WITH oCageTemplate

if (returning) {
    exit;
}

var cage = instance_place(x, y, oCageTemplate);

if (cage != noone) {
    with (cage) {
        if (variable_instance_exists(id, "takeHit")) {
            takeHit(other.damage, other.x);
        }
    }
}

returning = true;
distanceTraveled = maxDistance;