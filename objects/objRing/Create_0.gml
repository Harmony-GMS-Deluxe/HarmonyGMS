/// @description Initialize
image_speed = 0;
reaction = function (inst)
{
	// Abort if not intersecting
	if (not player_collision(inst)) exit;
	
	// Collect
	player_gain_rings(1);
	with (inst)
	{
		particle_create(x, y, global.ani_ring_sparkle_v0);
		instance_destroy();
	}
};