/// @description Cull
// Deactivate Zone Objects if they are not constant
with (objZoneObject)
{
	if (not constant) instance_deactivate_object(id);
}

// Activate instances inside the view
var vx, vy, vw, vh;
vx = camera_get_view_x(CAMERA_ID) - CAMERA_PADDING;
vy = camera_get_view_y(CAMERA_ID) - CAMERA_PADDING;
vw = CAMERA_WIDTH + (CAMERA_PADDING * 2);
vh = CAMERA_HEIGHT + (CAMERA_PADDING * 2);
instance_activate_region(vx, vy, vw, vh, true);

// Activate instances around the player
with (objPlayer)
{
	if (not instance_in_view())
	{
		instance_activate_region(x - CAMERA_PADDING, y - CAMERA_PADDING, CAMERA_PADDING * 2, CAMERA_PADDING * 2, true);
	}
}

alarm[0] = 5;