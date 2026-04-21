sprite_index = sAK_Halo;
image_speed = 0.5;

ownerId = noone;
throwDirection = 1;
attackPower = 1;
maxDistance = 132;
travelSpeed = 6;
returnSpeed = 7;
returning = false;
distanceTravelled = 0;
hitTargets = [];

COLLISIONS = [
    layer_tilemap_get_id("tmSOLID")
];

ENEMY_OBJECTS = [
    oBoopoBobblehead,
    oBlocko,
    oBuddyBrawler,
    oCrashTestDashie,
    asset_get_index("oJayCopter"),
    oMollyWopWally,
    asset_get_index("oShelldon"),
    asset_get_index("oThruston")
];

targetAlreadyHit = function(_target) {
    for (var i = 0; i < array_length(hitTargets); i += 1) {
        if (hitTargets[i] == _target) {
            return true;
        }
    }

    return false;
};

hitEnemy = function(_target) {
    if (!instance_exists(_target) || targetAlreadyHit(_target)) {
        return;
    }

    if (variable_instance_exists(_target, "takeHit")) {
        var hitMethod = variable_instance_get(_target, "takeHit");
        hitMethod = method(_target, hitMethod);
        hitMethod(attackPower, x);
        hitTargets[array_length(hitTargets)] = _target;
    }
};

checkEnemyHits = function() {
    for (var i = 0; i < array_length(ENEMY_OBJECTS); i += 1) {
        var enemyObject = ENEMY_OBJECTS[i];

        if (enemyObject == -1) {
            continue;
        }

        var target = collision_circle(x, y, 10, enemyObject, false, true);
        if (target != noone) {
            hitEnemy(target);
        }
    }
};