event_inherited()

timer = 0;
facing = 1;
defeatStarted = false;
HP = 1;
isDefeated = false;

takeHit = method(id, function(_power, _sourceX) {
    if (isDefeated) {
        return;
    }

    HP -= _power;
    facing = sign(x - _sourceX);
    if (facing == 0) {
        facing = 1;
    }

    if (HP <= 0) {
        isDefeated = true;
    }
});