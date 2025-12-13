/// @description Initialize
image_speed = 0;
reaction_test = function (inst)
{
	// Check if the player is within the water.
	if (player_point_in_rectangle(inst))
	{
		player_react_to(inst);
	}
}
reaction_on_enter = function (inst)
{
	// Enable the player's underwater flag
	if (not underwater)
	{
		underwater = true;
		remaining_air_time = remaining_air_duration;
		player_refresh_physics();
		y_speed *= 0.25;
		
		if (not player_point_in_rectangle(inst, xprevious, yprevious))
		{
			particle_spawn("splash", x div 1, inst.bbox_top);
		}
	}
}

reaction_on_exit = function (inst)
{
	// Disable the player's underwater flag
	if (underwater)
	{
		// Reset all reactions
		var total_reactions = array_length(reactions);
		
		if (total_reactions > 0)
		{
			for (var n = 0; n < total_reactions; ++n)
			{
				var index = array_get(reactions, n);
				if (instance_exists(index))
				{
					if (index.object_index == objWater or 
					object_is_ancestor(index.object_index, objWater))
					{
						return false;
					}
				}
			}
		}
		
		// Restore normal physics
		underwater = false;
		remaining_air_time = 0;
		player_refresh_physics();
		y_speed *= 2;
		particle_spawn("splash", x div 1, inst.bbox_top);
	}
	
}