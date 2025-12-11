/// @description Resize the window
	//Screen resizing
	camera_set_view_size(CAMERA_ID, CAMERA_WIDTH, CAMERA_HEIGHT);

	//Resize the window:
	window_set_size(CAMERA_WIDTH * scale, CAMERA_HEIGHT * scale);

	//Resize the surface:
	surface_resize(application_surface, CAMERA_WIDTH, CAMERA_HEIGHT);
	
	//Resize the GUI:
	display_set_gui_size(CAMERA_WIDTH, CAMERA_HEIGHT);
	
	//Center the screen
	window_center();
	
	//Fullscreen
	window_set_fullscreen(scale >= 4);
	
	