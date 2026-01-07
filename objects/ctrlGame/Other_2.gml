/// @description Setup

// Constants
#macro CAMERA_ID view_camera[0]
#macro CAMERA_PADDING 64
#macro CAMERA_WIDTH 384
#macro CAMERA_HEIGHT 224

#macro DEPTH_OFFSET_PARTICLE 75

#macro SLIDE_DURATION 30

#macro SLIDE_THRESHOLD 2.5
#macro AIR_DRAG_THRESHOLD 0.125
#macro AIR_DRAG 0.96875

enum INPUT
{
	UP, DOWN, LEFT, RIGHT, ACTION
}

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
	IDLE, TEETER, RUN, BRAKE, LOOK_UP, CROUCH_DOWN, HURT, ROLL, SPINDASH
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