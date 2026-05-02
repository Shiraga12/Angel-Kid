/// COLLISION WITH oEnemyTemplate

var enemy = instance_place(x, y, oEnemyTemplate);
if (enemy == noone || !canTAKE_DAMAGE()) {
    exit;
}

if (variable_instance_exists(enemy, "isDefeated") && variable_instance_get(enemy, "isDefeated")) {
    exit;
}

var contactDamage = 1;
var knockbackH = KNOCKBACK_H;
var knockbackV = KNOCKBACK_V;

if (variable_instance_exists(enemy, "CONTACT_DAMAGE")) {
    contactDamage = variable_instance_get(enemy, "CONTACT_DAMAGE");
}

if (variable_instance_exists(enemy, "CONTACT_KNOCKBACK_H")) {
    knockbackH = variable_instance_get(enemy, "CONTACT_KNOCKBACK_H");
}

if (variable_instance_exists(enemy, "CONTACT_KNOCKBACK_V")) {
    knockbackV = variable_instance_get(enemy, "CONTACT_KNOCKBACK_V");
}

takeKNOCKBACK(contactDamage, enemy.x, knockbackH, knockbackV);