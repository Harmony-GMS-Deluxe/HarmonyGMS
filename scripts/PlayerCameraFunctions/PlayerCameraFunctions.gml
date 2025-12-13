function player_cam_connect()
{
	if (instance_exists(camera)) 
	{
		with (camera) event_user(0);
	}
}

function player_cam_constraint(left = 0, top = 0, right = room_width, bottom = room_height)
{
	with (camera)
	{
		bound_left = left;
	    bound_top = top
	    bound_right = right;
	    bound_bottom = bottom;
	}
}

function player_cam_disconnect()
{
	if (instance_exists(camera)) 
	{
		with (camera) event_user(1);
	}
}

function player_cam_direct(cam_state)
{
	if (instance_exists(camera))
	{
		camera_direct(cam_state, camera)
	}
}

function player_cam_is_common()
{
	var sine = dsin(gravity_direction);
	var cosine = dcos(gravity_direction);
	var ox = (owner.x div 1) + (x_offset * cosine) + (y_offset * sine);
	var oy = (owner.y div 1) - (x_offset * sine) + (y_offset * cosine);

	camera_follow(ox, oy);

	var view_x = clamp(camera_get_view_x(CAMERA_ID), bound_left, bound_right - CAMERA_WIDTH);
	var view_y = clamp(camera_get_view_y(CAMERA_ID), bound_top, bound_bottom - CAMERA_HEIGHT);
	camera_set_view_pos(CAMERA_ID, view_x, view_y);
}

function player_cam_is_normal()
{
	if (x_offset != 0) 
	{
	    x_offset -= 2 * sign(x_offset);
	}
	if (y_offset != 0) 
	{
	    y_offset -= 2 * sign(y_offset);
	}

	player_cam_is_grounded();
}

function player_cam_is_grounded()
{
	var speed_h = x_speed * (lag_time <= 0);
	var owner_y_int = owner.y div 1;
	var owner_yprevious_int = owner.yprevious div 1;
	var speed_v = min(min_y_speed + abs(owner_y_int - owner_yprevious_int), y_speed);
	var border_x = camera_get_view_border_x(CAMERA_ID);
	var border_y = (CAMERA_HEIGHT * 0.5);
	camera_set_view_speed(CAMERA_ID, speed_h, speed_v);
	camera_set_view_border(CAMERA_ID, border_x, border_y);

	player_cam_is_common();
}

function player_cam_is_looking()
{
	if (look_time <= 0) 
	{
	    if (y_offset > y_distance_up)
		{
			y_offset -= 2;
		}
	}
	else if (y_offset != 0) 
	{
	    y_offset -= 2 * sign(y_offset);
	}

	player_cam_is_common();
}

function player_cam_is_crouching()
{
	if (look_time <= 0) 
	{
	    if (y_offset < y_distance_down)
		{
			y_offset += 2;
		}
	}
	else if (y_offset != 0) 
	{
	    y_offset -= 2 * sign(y_offset);
	}

	player_cam_is_common();
}

function player_cam_is_aerial()
{
	if (x_offset != 0) 
	{
	    x_offset -= 2 * sign(x_offset);
	}
	
	if (y_offset != 0) 
	{
	    y_offset -= 2 * sign(y_offset);
	}
	
	var speed_h = x_speed * (lag_time <= 0);
	var owner_y_int = owner.y div 1;
	var owner_yprevious_int = owner.yprevious div 1;
	var speed_v = min(min_y_speed + abs(owner_y_int - owner_yprevious_int), y_speed);
	var border_x = camera_get_view_border_x(CAMERA_ID);
	var border_y = (CAMERA_HEIGHT * 0.5);
	camera_set_view_speed(CAMERA_ID, speed_h, speed_v);
	camera_set_view_border(CAMERA_ID, border_x, border_y);

	player_cam_is_common();
}