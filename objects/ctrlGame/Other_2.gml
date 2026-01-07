/// @description Setup

// Constants
#macro CAMERA_ID view_camera[0]
#macro CAMERA_PADDING 64
#macro CAMERA_WIDTH 384
#macro CAMERA_HEIGHT 224

#macro DEPTH_OFFSET_PARTICLE 75

#macro SLIDE_DURATION 32
#macro RECOVERY_DURATION 120
#macro INVINCIBILITY_DURATION 1200
#macro SUPERSPEED_DURATION 1200
#macro SPRING_DURATION 16

#macro CEILING_LAND_THRESHOLD -4
#macro SLIDE_THRESHOLD 2.5
#macro ROLL_THRESHOLD 1.03125
#macro UNROLL_THRESHOLD 0.5
#macro BRAKE_THRESHOLD 4
#macro AIR_DRAG_THRESHOLD 0.125
#macro AIR_DRAG 0.96875
#macro SLOPE_FRICTION 0.125
#macro ROLL_SLOPE_FRICTION_UP 0.078125
#macro ROLL_SLOPE_FRICTION_DOWN 0.3125
#macro SPINDASH_ATROPHY 0.96875

enum GAME_MODE
{
	SINGLE_PLAYER, TIME_ATTACK
}

enum CHARACTER
{
	NONE = -1, SONIC, CD_SONIC, TAILS, KNUCKLES
}

enum PHASE
{
	ENTER, STEP, EXIT
}

enum ANIM
{
	IDLE, WALK, RUN, ROLL, PUSH, LOOK_UP, CROUCH_DOWN, SPINDASH, BRAKE, RISE, FALL, TEETER, HURT, DEAD
}

// Misc.
show_debug_overlay(true);
surface_depth_disable(true);
InputPartySetParams(INPUT_VERB.CONFIRM, 1, INPUT_MAX_PLAYERS, false, INPUT_VERB.CANCEL, undefined);
randomize();

// Volumes
global.volume_sound = 1;
global.volume_music = 1;

// Player values
global.characters = [];
global.score_count = 0;
global.ring_count = 0;
global.life_count = 3;

// Fonts
global.font_hud = font_add_sprite(sprFontHUD, ord("0"), false, 1);
global.font_lives = font_add_sprite(sprFontLives, ord("0"), false, 0);

// Create global controllers
instance_create_layer(0, 0, "Controllers", ctrlWindow);
instance_create_layer(0, 0, "Controllers", ctrlMusic);

room_goto_next();