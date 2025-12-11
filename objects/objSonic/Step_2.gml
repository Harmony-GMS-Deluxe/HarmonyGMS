/// @description Update Animation
event_inherited();
if (not state_changed)
{
	switch (state)
	{
		case player_is_running:
		{
			var velocity = abs(x_speed) div 1;
			var velocity_cap = 6;
			player_animate((velocity < velocity_cap ? "walk" : "run"));
			timeline_speed = 1 / max(8 - velocity, 1);
			image_angle = direction;
			break;
		}
	}
}