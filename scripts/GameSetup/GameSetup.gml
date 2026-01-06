// Constants
#macro CAMERA_ID view_camera[0]
#macro CAMERA_PADDING 64
#macro CAMERA_WIDTH 400
#macro CAMERA_HEIGHT 224

#macro DEPTH_OFFSET_AFTERIMAGE 25
#macro DEPTH_OFFSET_PLAYER 50
#macro DEPTH_OFFSET_PARTICLE 75

enum INPUT
{
	UP, DOWN, LEFT, RIGHT, ACTION
}

enum PHASE
{
	ENTER, STEP, EXIT
}

enum ANIM
{
	IDLE, TEETER, RUN, BRAKE, LOOK_UP, CROUCH_DOWN, ROLL, SPINDASH
}

// Misc.
show_debug_overlay(true);
surface_depth_disable(true);
audio_channel_num(16);
randomize();

// Volumes
volume_sound = 1;
volume_music = 1;

// Player values
score = 0;
lives = 3;
rings = 0;

// Fonts
font_hud = font_add_sprite(sprFontHUD, ord("0"), false, 1);
font_lives = font_add_sprite(sprFontLives, ord("0"), false, 0);

// Create global controllers
call_later(1, time_source_units_frames, function ()
{
	instance_create_layer(0, 0, "Controllers", ctrlWindow);
	instance_create_layer(0, 0, "Controllers", ctrlInput);
	instance_create_layer(0, 0, "Controllers", ctrlMusic);
	
	music_enqueue(bgmMadGear, 0);
});

/* AUTHOR NOTE: this must be done one frame later as the first room will not have loaded yet.
Due to this, for testing purposes, the Mad Gear track is enqueued here. */