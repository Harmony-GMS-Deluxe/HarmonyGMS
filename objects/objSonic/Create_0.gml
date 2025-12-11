/// @description Setup
// Inherit the parent event
event_inherited();

// Define Animations
player_define_animation("idle", animSonicIdle);
//player_define_animation("idle_loop", SonicStanceLoopAnim);
player_define_animation("walk", animSonicWalk);
player_define_animation("run", animSonicRun);
player_define_animation("brake", animSonicBrake);
player_define_animation("roll", animSonicRoll);
//player_define_animation("push", SonicPushAnim);
//player_define_animation("rise", SonicRisingAnim);
//player_define_animation("flip", SonicFlipAnim);
//player_define_animation("breathe", SonicBreatheAnim);
player_define_animation("look", animSonicLook);
player_define_animation("crouch", animSonicCrouch);
player_define_animation("spindash", animSonicSpindash);
//player_define_animation("hurt", SonicStunnedAnim);
//player_define_animation("dead", SonicDeathAnim);
//player_define_animation("drown", SonicDrownAnim);
//player_define_animation("transform", SonicTransformAnim);
player_define_animation("teeter", animSonicTeeter);
//player_define_animation("teeter_back", SonicTeeterBackAnim);