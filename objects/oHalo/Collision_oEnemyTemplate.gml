/// COLLISION WITH oEnemyTemplate

if (returning) {
	exit;
}

var enemy = instance_place(x, y, oEnemyTemplate);

if (enemy != noone) {
	collisionDamage = variable_instance_get(id, "damage");
	collisionSourceX = x;
	var hitImpactSound = sndHitImpact2;

	with (enemy) {
		if (variable_instance_exists(id, "takeHIT")) {
			takeHIT(other.collisionDamage, other.collisionSourceX);
		}
	}

	audio_play_sound(hitImpactSound, 0, false);
}

returning = true;
distanceTraveled = maxDistance;