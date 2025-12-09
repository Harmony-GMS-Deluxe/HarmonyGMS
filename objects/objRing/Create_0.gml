/// @description Initialize
image_speed = 0;
reaction_test = function (inst)
{
	// React if intersecting the ring
	if (player_collision(inst))
	{
		player_react_to(inst);
	};
}

reaction_on_enter = function (inst)
{
	// Collect
	player_gain_rings(1);
	with (inst)
	{
		particle_spawn("ring_sparkle", x, y);
		instance_destroy();
	}
};