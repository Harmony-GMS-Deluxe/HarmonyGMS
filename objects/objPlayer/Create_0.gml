/// @description Initialize
image_speed = 0;

// State machine
state = player_is_ready;
state_previous = -1;
state_changed = false;

rolling = false;
underwater = false;

jump_action = true;

spindash_charge = 0;

// Timers
control_lock_time = 0;
remaining_air_time = 0;
recovery_time = 0;
superspeed_time = 0;
invincibility_time = 0;
camera_look_time = 0;

slide_duration = 32;
spring_duration = 16;
remaining_air_duration = 1800;
recovery_duration = 120;

// Physics
x_speed = 0;
y_speed = 0;

player_refresh_physics();

slide_threshold = 2.5;

air_drag_threshold = 0.125;
air_drag = 0.96875;

// Collision detection
x_radius = 8;
x_wall_radius = 10;

y_radius = 15;
y_tile_reach = 16;

landed = false;
on_ground = true;
ground_snap = true;

direction = 0;
gravity_direction = 0;
local_direction = 0;
mask_direction = 0;

cliff_sign = 0;

solid_entities = [layer_tilemap_get_id("TilesMain")];
if (layer_exists("TilesLayer0"))
{
	array_push(solid_entities, layer_tilemap_get_id("TilesLayer0"));
	collision_layer = 0;
}
semisolid_tilemap = layer_tilemap_get_id("TilesSemisolid");

reaction_list = ds_list_create();
previous_reaction_list = ds_list_create();

// Input
input_axis_x = 0;
input_axis_y = 0;

/// @function button(verb)
/// @description Creates a button struct.
/// @param {Enum.INPUT_VERB} verb Verb to check.
function button(verb) constructor
{
    index = verb;
    check = false;
    pressed = false;
    released = false;
}

input_button =
{
    jump : new button(INPUT_VERB.JUMP),
    back : new button(INPUT_VERB.BACK),
    extra : new button(INPUT_VERB.EXTRA),
    start : new button(INPUT_VERB.START)
};


// Animations
image_speed = 0;

animations = ds_map_create();
animation = "";

// Misc.
camera = instance_create_layer(x, y, "Controllers", objCamera,);
camera.owner = id;

/// @method player_perform(action, [enter])
/// @description Sets the given function as the player's current state.
/// @param {Function} action State function to set.
/// @param {Bool} enter Whether to perform the enter phase.
player_perform = function(action, enter = true)
{
	var state_reset = (argument_count > 1);
	if (state != action || state_reset)
	{
		state_previous = state;
		state = action;
		state_changed = true;
		if (script_exists(state_previous)) state_previous(PHASE.EXIT);
		if (enter) 
		{
			if (script_exists(state)) state(PHASE.ENTER);
		}
	}
};

/// @method player_rotate_mask()
/// @description Rotates the player's virtual mask, if applicable.
player_rotate_mask = function ()
{
	static rotation_lock_time = 0;
	if (rotation_lock_time > 0) then --rotation_lock_time;
	
	var new_rotation = (round(direction / 90) mod 4) * 90;
	if (mask_direction != new_rotation and (landed or rotation_lock_time == 0))
	{
		mask_direction = new_rotation;
		rotation_lock_time = (not landed) * max(16 - abs(x_speed * 2) div 1, 0);
	}
};

/// @method player_resist_slope(force)
/// @description Applies slope friction to the player's horizontal speed, if appropriate.
/// @param {Real} force Friction value to use.
player_resist_slope = function (force)
{
	// Abort if...
	if (x_speed == 0 and control_lock_time == 0) exit; // Not moving
	if (local_direction < 22.5 or local_direction > 337.5) exit; // Moving along a shallow slope
	if (local_direction >= 135 and local_direction <= 225) exit; // Attached to a ceiling
	
	// Apply
	x_speed -= dsin(local_direction) * force;
};

/// @method player_animate(name, [reset])
/// @description Sets the player's current animation to the given string, and their timeline to that which matches it.
/// @param {String} name Animation to set.
/// @param {Bool} [reset] Reset the animation.
player_animate = function (name, reset = false)
{
	var index = ds_map_find_value(animations, name);
	if ((index != -1 and timeline_index != index) or reset)
	{
		animation = name;
		timeline_set(id, index, 1, true, reset);
	}
};

/// @method player_animating(name)
/// @description Gets the player's current animation to check.
/// @param {String} name Animation to check.
/// @returns {Bool}
player_animating = function (name)
{
	return animation == name;
};

/// @method player_define_animation(name, timeline)
/// @description Sets the player's animation data.
/// @param {String} name Animation to set.
/// @param {Asset.GMTimeline} timeline Timeline to set.
player_define_animation = function (name, timeline)
{
	animations[? name] = timeline;
};

/// @method player_gain_rings(num)
/// @description Increases the player's ring count by the given amount.
/// @param {Real} num Amount of rings to give.
player_gain_rings = function (num)
{
	global.rings = min(global.rings + num, 999);
	sound_play(sfxRing);
	
	// Gain lives
	static ring_life_threshold = 99;
	if (global.rings > ring_life_threshold)
	{
		var change = global.rings div 100;
		player_gain_lives(change - ring_life_threshold div 100);
		ring_life_threshold = change * 100 + 99;
	}
};

/// @method player_gain_lives(num)
/// @description Increases the player's life count by the given amount.
/// @param {Real} num Amount of lives to give.
player_gain_lives = function (num)
{
	lives = min(lives + num, 99);
	music_overlay(bgmLife);
};