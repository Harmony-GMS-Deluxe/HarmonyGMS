/// @function rect([left], [top], [right], [bottom])
/// @description Creates a rectangle with arguments assuming (0, 0) origin.
/// @param {Real} left Left radius of the rectangle.
/// @param {Real} top Top radius of the rectangle.
/// @param {Real} right Right radius of the rectangle.
/// @param {Real} bottom Bottom radius of the rectangle.
function rect(_left = 0, _top = 0, _right = 0, _bottom = 0) constructor
{
	left = _left;
	top = _top;
	right = _right;
	bottom = _bottom;
    static set_size = function(_left = 0, _top = 0, _right = 0, _bottom = 0)
    {
        left = _left;
        top = _top;
        right = _right;
        bottom = _bottom;
    }
}

/// @function angle_wrap(ang)
/// @description Wraps the given angle between 0 and 359 degrees inclusively.
/// @param {Real} ang Angle to wrap.
/// @returns {Real}
function angle_wrap(ang)
{
	return (ang mod 360 + 360) mod 360;
}

/// @function rotate_towards(dest, src, [amt])
/// @description Rotates the source angle to the destination angle.
/// @param {Real} dest Destination angle.
/// @param {Real} src Source angle.
/// @param {Real} amt The maximum amount to straighten by.
/// @returns {Real}
function rotate_towards(dest, src, amt = 2.8125)
{
	if (src != dest)
	{
		var diff = angle_difference(dest, src);
		return src + min(amt, abs(diff)) * sign(diff);
	}
    return src;
}

/// @function instance_in_view([obj], [padding])
/// @description Checks if the given instance is visible within the game view.
/// @param {Asset.GMObject|Id.Instance} [obj] Object or instance to check (optional, default is the calling instance).
/// @param {Real} [padding] Distance in pixels to extend the size of the view when checking (optional, default is the CAMERA_PADDING macro).
/// @returns {Bool}
function instance_in_view(obj = id, padding = CAMERA_PADDING)
{
	var left = camera_get_view_x(CAMERA_ID);
	var top = camera_get_view_y(CAMERA_ID);
	var right = left + CAMERA_WIDTH;
	var bottom = top + CAMERA_HEIGHT;
	
	with (obj) return point_in_rectangle(x, y, left - padding, top - padding, right + padding, bottom + padding);
}

/// @function particle_spawn(name, x, y, [num])
/// @description Creates the given sprite particle a given number of times at the given position.
/// @param {String} name Name of the particle.
/// @param {Real} x x-coordinate of the particle.
/// @param {Real} y y-coordinate of the particle.
/// @param {Real} [num] Number of particles to create (optional, default is 1).
function particle_spawn(name, ox, oy, num = 1)
{
	with (global.sprite_particles)
	{
		if (ds_map_exists(particles, name))
		{
			part_particles_create(system, ox, oy, particles[? name], num);
		}
	}
}

/// @function draw_reset()
/// @description Resets draw color, alpha, and text alignment. Ported from GM8.2.
function draw_reset()
{
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

/// @function timeline_set(obj, timeline, [frames], [loop], [reset])
/// @description Assigns the given timeline to the calling instance
/// @param {Asset.GMObject|Id.Instance} obj Object or instance to check
/// @param {Asset.GMTimeline} timeline Timeline to set.
/// @param {Real} frames (Optional) timeline speed in frames
/// @param {Bool} loop (Optional) whether or not the timeline should repeat
/// @param {Bool} reset (Optional) whether or not to ignore if the same timeline is already assigned
function timeline_set(obj, timeline, frames = 1, loop = true, reset = true)
{
	with (obj) {
		if (timeline_index != timeline or reset) {
	        timeline_index = timeline;
	        timeline_speed = 1 / frames;
			timeline_loop = loop;
			timeline_running = timeline_exists(timeline);
			timeline_position = 0;
	    }
	}
}

/// @function timeline_expired(obj)
/// @description Checks if any obj (or instance) has a timeline that has reached its last moment
/// @param {Asset.GMObject|Id.Instance} obj Object or instance to check
/// @returns {Bool}
function timeline_expired(obj)
{
	return (instance_exists(obj) and timeline_exists(obj.timeline_index) and 
		obj.timeline_position >= timeline_max_moment(obj.timeline_index));
}