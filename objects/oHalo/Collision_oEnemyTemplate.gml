/// COLLISION WITH oEnemyTemplate

if (returning) {
	exit;
}

var enemy = instance_place(x, y, oEnemyTemplate);

if (enemy != noone) {
	with (enemy) {
		if (variable_instance_exists(id, "takeHit")) {
			takeHit(other.damage, other.x);
		}
	}
}

returning = true;
distanceTraveled = maxDistance;