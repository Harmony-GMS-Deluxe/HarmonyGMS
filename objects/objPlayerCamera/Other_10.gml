/// @description Attach

	camera_direct(player_cam_is_normal, id);
    camera_centre(x, y);
	var view_x = clamp(camera_get_view_x(CAMERA_ID), bound_left, bound_right - CAMERA_WIDTH);
	var view_y = clamp(camera_get_view_y(CAMERA_ID), bound_top, bound_bottom - CAMERA_HEIGHT);
	var border_x = (CAMERA_WIDTH * 0.5) - x_border;
	var border_y = (CAMERA_HEIGHT * 0.5) - y_border;
	camera_set_view_pos(CAMERA_ID, view_x, view_y);
	camera_set_view_border(CAMERA_ID, border_x, border_y);
	camera_set_view_speed(CAMERA_ID, x_speed, y_speed);