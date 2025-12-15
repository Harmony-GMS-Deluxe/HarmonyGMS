/// @description Initialize
event_inherited();
image_index = 1;
reaction_test = function (inst)
{
	if (player_collision(inst)) 
	{
		player_react_to(inst);
	}
}
reaction_on_enter = function (inst)
{
	player_perform(player_is_falling);
	rolling = false;
	var rotation_offset = angle_wrap(45 + round_to(inst.image_angle, 90) - mask_direction);
	x_speed = -dsin(rotation_offset) * inst.force;
	y_speed = -dcos(rotation_offset) * inst.force;
	image_xscale = sign(x_speed);
	//var flip = (inst.special_animation == true);
	//player_animate(flip ? "flip" : "rise", flip);
	image_angle = gravity_direction;
	timeline_set(inst, animSpring, 1, false);
	//sound_play(sfxSpring);
}