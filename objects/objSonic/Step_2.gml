/// @description Update Animation
event_inherited();
if (not state_changed)
{
	switch (state)
	{
		case player_is_running:
		{
			var velocity = abs(x_speed);
			var new_anim = (velocity < 6 ? "walk" : "run");
			if (current_animation != new_anim) player_animate(new_anim);
			timeline_speed = 1 / max(8 - velocity div 1, 1);
			image_angle = direction;
			break;
		}
	}
}