event_inherited()

timer = 0;
facing = 1;
defeatStarted = false;
HP = 1;
isDefeated = false;
CONTACT_DAMAGE = 1;
CONTACT_KNOCKBACK_H = 3.5;
CONTACT_KNOCKBACK_V = 4.5;

takeHit = method(id, function(_power, _sourceX) {
    if (isDefeated) {
        return;
    }

    HP -= _power;
    facing = sign(x - _sourceX);
    if (facing == 0) {
        facing = 1;
    }

    var enemyHurtSound = asset_get_index((HP <= 0) ? "sndEnemyHurt2" : "sndEnemyHurt");
    if (enemyHurtSound != -1) {
        audio_play_sound(enemyHurtSound, 0, false);
    }

    if (HP <= 0) {
        isDefeated = true;
    }
});