/// @description Initialize
image_speed = 0;

// State machine
state = player_is_ready;
state_previous = -1;
state_changed = false;

rolling = false;
jump_action = false;

spindash_charge = 0;

badnik_chain = 0;

// Timers
rotation_lock_time = 0;
control_lock_time = 0;
recovery_time = 0;
superspeed_time = 0;
invincibility_time = 0;
camera_look_time = 0;

slide_duration = 30;

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
//ground_snap = true;

direction = 0;
gravity_direction = 0;
local_direction = 0;
mask_direction = 0;

/* AUTHOR NOTE: "down" is treated as 0 degrees instead of 270. */

cliff_sign = 0;

collision_layer = 0;

// Copy the stage's tilemaps
solid_colliders = variable_clone(ctrlZone.tilemaps, 0);
tilemap_count = array_length(solid_colliders);

// Validate semisolid tilemap; if it exists, the tilemap count is even
semisolid_tilemap = -1;
if (tilemap_count & 1 == 0)
{
	semisolid_tilemap = array_last(solid_colliders);
	--tilemap_count;
}

// Delist the "CollisionPlane1" layer tilemap, if it exists
if (tilemap_count == 3)
{
	array_delete(solid_colliders, 2, 1);
	--tilemap_count;
}

// Input
input_axis_x = 0;
input_axis_y = 0;

// Animation
animation_data = new animation_core();
//animation_history = array_create(16);

// Stamps
spin_dash_stamp = new stamp();

// Misc.
instance_create_layer(x, y, layer, objCamera, { gravity_direction });

/// @method player_perform(action, [reset])
/// @description Sets the given function as the player's current state.
/// @param {Function} action State function to set.
/// @param {Boolean} [reset] Reset state function.
player_perform = function (action, reset = false)
{
	if (state != action or reset)
	{
		state_previous = state;
		state = action;
		state_changed = true;
		if (script_exists(state_previous)) state_previous(PHASE.EXIT);
		if (script_exists(state)) state(PHASE.ENTER);
	}
};

/// @method player_rotate_mask()
/// @description Rotates the player's virtual mask, if applicable.
player_rotate_mask = function ()
{
	if (rotation_lock_time > 0 and not landed)
	{
		--rotation_lock_time;
		exit;
	}
	
	var new_rotation = round(direction / 90) mod 4 * 90;
	if (mask_direction != new_rotation)
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
	
	x_speed -= dsin(local_direction) * force;
};

/// @method player_animate()
/// @description Sets the player's current animation.
player_animate = function() {};

/// @method player_set_animation(ani, [ang])
/// @description Sets the given animation within the player's animation core.
/// @param {Undefined|Struct.animation|Array} ani Animation to set. Accepts an array as animation variants.
/// @param {Real} [ang] Angle to set (optional, defaults to gravity_direction).
player_set_animation = function(ani, ang = gravity_direction)
{
	animation_set(ani);
	image_angle = ang;
};

/// @method player_animate_teeter(ani)
/// @description Sets the given animation within the player's animation core based on teeter conditions.
/// @param {Undefined|Struct.animation|Array} ani Animation to set. Accepts an array as animation variants.
player_animate_teeter = function(ani)
{
	animation_data.variant = (cliff_sign != image_xscale);
	player_set_animation(ani);
};

/// @method player_animate_run(ani)
/// @description Sets the given animation within the player's animation core based on running conditions.
/// @param {Undefined|Struct.animation|Array} ani Animation to set. Accepts an array as animation variants.
/// @param {Real} [ang] Angle to set (optional, defaults to direction).
player_animate_run = function(ani, ang = direction)
{
    var variant = animation_data.variant;
    var speed_abs = abs(x_speed);
    variant = 1;
    if (speed_abs < 6) variant = 0;
    player_set_animation(ani, ang);
    animation_data.variant = variant;
    animation_data.speed = 1 / max(8 - speed_abs div 1, 1);
};

/// @method player_animate_roll(ani, [speed])
/// @description Sets the given animation within the player's animation core based on rolling conditions.
/// @param {Undefined|Struct.animation|Array} ani Animation to set. Accepts an array as animation variants.
/// @param {Real} [speed] Speed to set (optional).
player_animate_roll = function(ani, ani_speed = 1 / max(5 - abs(x_speed) div 1, 1))
{
	player_set_animation(ani);
    animation_data.speed = ani_speed;
};

/// @method player_gain_score(num)
/// @description Increases the player's score count by the given amount.
/// @param {Real} num Amount of points to give.
player_gain_score = function (num)
{
	var previous_count = score div 50000;
	score = min(score + num, 999999);
	
	// Gain lives
	var count = score div 50000;
	if (count != previous_count) player_gain_lives(count - previous_count);
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
		var count = global.rings div 100;
		player_gain_lives(count - ring_life_threshold div 100);
		ring_life_threshold = count * 100 + 99;
	}
	
	/* TODO: convert `ring_life_threshold` into a global variable or something else,
	as static variables in methods retain their values even if the holding instance has been destroyed. */
};

/// @method player_gain_lives(num)
/// @description Increases the player's life count by the given amount.
/// @param {Real} num Amount of lives to give.
player_gain_lives = function (num)
{
	lives = min(lives + num, 99);
	music_overlay(bgmLife);
};

/// @method player_damage(inst)
/// @description Evaluates the player's condition after taking a hit.
/// @param {Id.Instance} inst Instance to recoil from.
player_damage = function (inst)
{
	// Abort if already invulnerable in any way
	if (recovery_time > 0 or invincibility_time > 0 or state == player_is_hurt) exit;
	
	if (global.rings > 0)
	{
		player_perform(player_is_hurt);
		
		// Recoil
		x_speed = 2 * (gravity_direction mod 180 == 0 ?
			sign(x - inst.x) * dcos(gravity_direction) :
			sign(inst.y - y) * dsin(gravity_direction));
		
		if (x_speed == 0) x_speed = 2;
		y_speed = -4;
	}
	
	/* TODO:
	- Check for shields (once they've been added).
	- Add dropped rings, and toss them.
	- Add death state. */
};

/// @method player_draw_before()
/// @description Draws player effects behind the character sprite.
player_draw_before = function() {};

/// @method player_draw_after()
/// @description Draws player effects in front of the character sprite.
player_draw_after = function() {};
