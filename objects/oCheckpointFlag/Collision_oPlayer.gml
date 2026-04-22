/// COLLISION WITH oPlayer

var player = instance_place(x, y, oPlayer);
if (player == noone) {
    exit;
}

if (variable_instance_exists(player, "setRespawnPoint")) {
    var setRespawn = variable_instance_get(player, "setRespawnPoint");
    setRespawn(x, y + respawnOffsetY);
}

activateCheckpoint();