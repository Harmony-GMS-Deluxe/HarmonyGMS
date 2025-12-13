/// @description Example of a script used with game_camera_direct. The script can do just about anything.
/// @argument {real} vind view index
function camera_default_behavior() 
{
	camera_follow(x, y);
}

/// @description Binds the given script to the viewport to be run every step
/// @argument {real} script index to run (the script should accept a view index as its only argument)
/// @argument {real} [caller] (optional) instance or object index that will call the script (if unspecified, the Camera object is the caller)
function camera_direct(cam_state, caller = undefined) 
{
	with (ctrlCamera) 
	{
	    self.state = cam_state;
	    self.caller = is_undefined(caller) ? id : caller;
	}
}

/// @description Centers the given camera at the given point, taking the room boundaries into consideration
/// @argument {real} x focal point x-position
/// @argument {real} y focal point y-position
function camera_centre(ox, oy)
{
	var _x = clamp(ox - (CAMERA_WIDTH * 0.5), 0, room_width - CAMERA_WIDTH);
	var _y = clamp(oy - (CAMERA_HEIGHT * 0.5), 0, room_height - CAMERA_HEIGHT);
	camera_set_view_pos(CAMERA_ID, _x, _y);
}

/// @description Moves the specified camera as if camera_set_view_target were set to an instance at point {ox, oy}
/// @argument {real} x focal point x-position
/// @argument {real} y focal point y-position
function camera_follow(ox, oy)
{
	var view_x = camera_get_view_x(CAMERA_ID);
	var view_y = camera_get_view_y(CAMERA_ID);

	// calculate offset from centre point
	var cx = view_x + (CAMERA_WIDTH * 0.5);
	var cy = view_y + (CAMERA_HEIGHT * 0.5);
	var ocx = ox - cx;
	var ocy = oy - cy;

	// limit to view border
	var hborder = (CAMERA_WIDTH * 0.5) - camera_get_view_border_x(CAMERA_ID);
	var vborder = (CAMERA_HEIGHT * 0.5) - camera_get_view_border_y(CAMERA_ID);
	ocx = max(abs(ocx) - hborder, 0) * sign(ocx);
	ocy = max(abs(ocy) - vborder, 0) * sign(ocy);

	// limit movement speed
	var view_speed_x = camera_get_view_speed_x(CAMERA_ID);
	if (includes(view_speed_x, 0, abs(ocx))) 
	{
		ocx = view_speed_x * sign(ocx);
	}
	var view_speed_y = camera_get_view_speed_y(CAMERA_ID);
	if (includes(view_speed_y, 0, abs(ocy))) 
	{
		ocy = view_speed_y * sign(ocy);
	}

	// move the view
	if (ocx != 0 or ocy != 0) 
	{
		var _x = clamp(view_x + ocx, 0, room_width - CAMERA_WIDTH);
		var _y = clamp(view_y + ocy, 0, room_height - CAMERA_HEIGHT);
		camera_set_view_pos(CAMERA_ID, _x, _y);
	}
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