/// @description Initialize
event_inherited();
image_index = 1;
reaction_test = function (inst)
{
	var rotation_offset = angle_wrap(round_to(inst.image_angle, 90) - mask_direction);
	if (player_arms_collision(inst, x_wall_radius)) 
	{
		if ((rotation_offset == 270 and x_speed < 0) or (rotation_offset == 90 and x_speed > 0)) 
		{
			player_react_to(inst);
		}
	} 
	else if (player_part_collision(inst, y_radius)) 
	{
		if (rotation_offset == 0 and y_speed >= 0) 
		{
			player_react_to(inst);
		}
	} 
	else if (rotation_offset == 180 and y_speed < 0 and player_upper_collision(inst, y_radius)) 
	{
		player_react_to(inst);
	}
}
reaction_on_enter = function (inst)
{
	var rotation_offset = angle_wrap(round_to(inst.image_angle, 90) - mask_direction);
	var x_spring_speed = -dsin(rotation_offset) * inst.force;
	var y_spring_speed = -dcos(rotation_offset) * inst.force;
	if (x_spring_speed != 0 or y_spring_speed != 0) 
	{
		timeline_set(inst, animSpring, 1, false);
		//sound_play(sfxSpring);
		if (x_spring_speed != 0) 
		{
			x_speed = x_spring_speed;
			image_xscale = sign(x_spring_speed);
			
			if (y_spring_speed == 0) 
			{
				control_lock_time = spring_duration;
			}
				
			//if (state == player_is_glide_sliding or state == player_is_glide_standing) 
			//{
			//	player_perform(player_is_running);
			//} 
			//else if (state == player_is_gliding) 
			//{
			//	player_perform(player_is_falling);
			//	player_animate("run");
			//}
		}
		
		if (y_spring_speed != 0) 
		{
			player_perform(player_is_falling);
			rolling = false;
			y_speed = y_spring_speed;
			image_angle = gravity_direction;
			//var flip = (inst.special_animation == true);
			//player_animate(flip ? "flip" : "rise", flip);
		}
	}
}