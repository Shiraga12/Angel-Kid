/// COLLISION WITH oCageTemplate

if (returning) {
    exit;
}

var cage = instance_place(x, y, oCageTemplate);

if (cage != noone) {
	collisionDamage = variable_instance_get(id, "damage");
	collisionSourceX = x;
	var hitImpactSound = asset_get_index("sndHitImpact2");

    with (cage) {
        if (variable_instance_exists(id, "takeHit")) {
            takeHit(other.collisionDamage, other.collisionSourceX);
        }
    }

	if (hitImpactSound != -1) {
    		audio_play_sound(hitImpactSound, 0, false);
	}
}

returning = true;
distanceTraveled = maxDistance;