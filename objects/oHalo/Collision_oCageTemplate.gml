/// COLLISION WITH oCageTemplate

if (returning) {
    exit;
}

var cage = instance_place(x, y, oCageTemplate);

if (cage != noone) {
	collisionDamage = variable_instance_get(id, "damage");
	collisionSourceX = x;
	var hitImpactSound = sndHitImpact2;

    with (cage) {
        if (variable_instance_exists(id, "takeHIT")) {
            takeHIT(other.collisionDamage, other.collisionSourceX);
        }
    }

	audio_play_sound(hitImpactSound, 0, false);
}

returning = true;
distanceTraveled = maxDistance;