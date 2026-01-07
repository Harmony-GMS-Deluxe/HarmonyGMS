#region Objects

global.ani_ring_sparkle_v0 = new animation(sprRingSparkle, 4, -1);

global.ani_exhaust_v0 = new animation(sprExhaust, 2, -1);

#endregion

#region Player

global.ani_brake_dust_v0 = new animation(sprBrakeDust, 2, -1);

global.ani_spindash_dust_v0 = new animation(sprDashSmoke, 2);

#endregion

#region Sonic

// TODO: Maybe wait until a proper waiting animation gets added but for now...
// Shove that into the idle animation.
global.ani_sonic_idle_v0 = new animation(sprSonicIdle, [288, 12], 3);

global.ani_sonic_walk_v0 = new animation(sprSonicWalk, 1);
global.ani_sonic_run_v0 = new animation(sprSonicRun, 1);

global.ani_sonic_roll_v0 = new animation(sprSonicRoll, 1, 0, [1, 0, 2, 0, 3, 0, 4, 0]);

global.ani_sonic_push_v0 = new animation(sprSonicPush, 32);

global.ani_sonic_look_v0 = new animation(sprSonicLook, 6,  1);
global.ani_sonic_look_v1 = new animation(sprSonicLook, 6, -1, [1, 0]);
global.ani_sonic_look = [global.ani_sonic_look_v0, global.ani_sonic_look_v1];

global.ani_sonic_crouch_v0 = new animation(sprSonicCrouch, 6, 2, [0, 1, 2]);
global.ani_sonic_crouch_v1 = new animation(sprSonicCrouch, 6, -1, [1, 0]);
global.ani_sonic_crouch = [global.ani_sonic_crouch_v0, global.ani_sonic_crouch_v1];

global.ani_sonic_spindash_v0 = new animation(sprSonicSpindash, 1, 0, [0, 1, 0, 2, 0, 3, 0, 4]);

global.ani_sonic_brake_v0 = new animation(sprSonicBrake, 6, 3);

global.ani_sonic_teeter_front_v0 = new animation(sprSonicTeeterFront, 6);
global.ani_sonic_teeter_back_v0 = new animation(sprSonicTeeterBack, 6);
global.ani_sonic_teeter = [global.ani_sonic_teeter_front_v0, global.ani_sonic_teeter_back_v0];

global.ani_sonic_hurt_v0 = new animation(sprSonicHurt, 6, 0);

#endregion