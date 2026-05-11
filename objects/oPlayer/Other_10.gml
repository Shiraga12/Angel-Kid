///@desc Constants

SPRITES = {
    CLIMB: sAK_Climb,
    DEATH: sAK_Death,
    FLY: sAK_Fly,
    GOOBER_POSE_SCARE: sAK_GooberPosescare,
    HALO: sAK_Halo,
    HALO_THROW: sAK_HaloThrow,
    HIT: sAK_Hit,
    IDLE: sAK_Idle,
    JUMP: sAK_Jump,
    LOOK: {
        DOWN: sAK_Lookdown,
        UP: sAK_Lookup,
    },
    POWER_GIVEN: sAK_PowerGiven,
    PUNCH_CHARGE: sAK_PunchCharge,
    PUNCH: sAK_Punch,
    RUN: sAK_FullSpeed,
    VICTORY_DANCE: sAK_VictoryDance,
    WALK: sAK_Walk,
};

SP = {
    CLIMB: 2.25,
    FLY: 3.5,
    GRV: 0.45,
    H: 0,
    JUMP: 9.25,
    MAX_FALL: 10,
    RUN: 4.5,
    V: 0,
    WALK: 2.5,
};

ATTACK = {
    CHARGE_POWER: 3,
    CHARGE_RANGE: 40,
    CHARGE_TIME: 20,
    HEIGHT: 18,
    POWER: 1,
    RANGE: 28,
    TRIGGER_FRAME: 2,
};

HALO = {
    POWER: 1,
    RANGE: 132,
    RETURN_SPEED: 7,
    SPEED: 6,
    X_OFFSET: 40,
    Y_OFFSET: 9,
};

SOUNDS = {
    TUTORIAL_ISLAND: sndTutorialIsland,
    GAME_OVER: sndGameOver,
    GOOBER_SCARE: sndGooberScare,
    HALO_THROW: sndHaloThrow,
    HIT_IMPACT: sndHitImpact2,
    HIT_LANDED: sndHitLanded,
    JUMP: sndJump,
    LIFE_LOSS: sndLifeLoss,
    PUNCH_HOLD: sndPunchHold,
    FLY: sndFly
};

COLLISIONS = [
    layer_tilemap_get_id("tmSOLID"),
	oBossArenaWall
];

HITSTUN_TIME = 12;
INVUL_TIME = 45;
KNOCKBACK_H = 3.5;
KNOCKBACK_V = 4.5;
RESPAWN_INVUL_TIME = 90;
RESPAWN_HEALTH = 8;