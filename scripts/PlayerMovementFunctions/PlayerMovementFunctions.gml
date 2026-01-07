/// @function player_move_on_ground()
/// @description Updates the player's position on the ground and checks for collisions.
function player_move_on_ground()
{
	// Ride moving platforms
	with (instance_place(x div 1 + dsin(mask_direction), y div 1 + dcos(mask_direction), objSolid))
	{
		var dx = x - xprevious;
		var dy = y - yprevious;
		if (dx != 0) other.x += dx;
		if (dy != 0) other.y += dy;
	}
	
	/* AUTHOR NOTE: using `instance_place` here is cheeky as the player's sprite mask is used
	to check for collision instead of their virtual mask.
	However, unless the player's virtual mask is wider than their sprite's, this is not an issue. */
	
	// Calculate the number of steps for collision checking
	var total_steps = 1 + abs(x_speed) div x_radius;
	var step = x_speed / total_steps;
	
	// Loop over the number of steps
	repeat (total_steps)
	{
		// Move by a single step
		x += dcos(direction) * step;
		y -= dsin(direction) * step;
		player_keep_in_bounds(); // TODO: add death state and call it if this is false
		
		// Detect instances and tilemaps
		player_get_collisions();
		
		// Handle wall collision
		var tile_data = player_beam_collision(solid_colliders);
		if (tile_data != noone)
		{
			var wall_sign = player_eject_wall(tile_data);
			
			if (sign(x_speed) == wall_sign) 
			{
				x_speed = 0;
				
				// Set pushing animation, if applicable
				if (animation_data.index != ANIM.PUSH and input_axis_x == wall_sign and image_xscale == wall_sign)
				{
					animation_init(ANIM.PUSH);
				}
			}
		}
		
		// Handle floor collision
		if (on_ground)
		{
			//tile_data = player_find_floor(y_radius + (ground_snap ? y_tile_reach : 1));
			tile_data = player_find_floor(y_radius + min(2 + abs(x_speed) div 1, y_tile_reach));
			if (tile_data != undefined)
			{
				player_ground(tile_data);
				player_rotate_mask();
			}
			else on_ground = false;
		}
	}
}

/// @function player_move_in_air()
/// @description Updates the player's position in the air and checks for collisions.
function player_move_in_air()
{
	// Get Cosine and Sine
	var sine = dsin(mask_direction);
	var cosine = dcos(mask_direction);
	
	// Calculate the number of steps for horizontal collision checking
	var total_steps = 1 + abs(x_speed) div x_radius;
	var step = x_speed / total_steps;
	
	// Loop over the number of horizontal steps
	repeat (total_steps)
	{
		// Move by a single step
		x += cosine * step;
		y -= sine * step;
		player_keep_in_bounds();
		
		// Detect instances and tilemaps
		player_get_collisions();
		
		// Handle wall collision
		var tile_data = player_beam_collision(solid_colliders);
		if (tile_data != noone)
		{
			var wall_sign = player_eject_wall(tile_data);
			
			if (sign(x_speed) == wall_sign) x_speed = 0;
		}
	}
	
	// Calculate the number of steps for vertical collision checking
	total_steps = 1 + abs(y_speed) div y_radius;
	step = y_speed / total_steps;
	
	// Loop over the number of vertical steps
	repeat (total_steps)
	{
		// Move by a single step
		x += sine * step;
		y += cosine * step;
		player_keep_in_bounds();
		
		// Register nearby instances
		player_detect_entities();
		
		// Handle floor collision
		if (y_speed >= 0)
		{
			var tile_data = player_find_floor(y_radius);
			if (tile_data != undefined)
			{
				landed = true;
				player_ground(tile_data);
				player_rotate_mask();
			}
		}
		else
		{
			// Handle ceiling collision
			var tile_data = player_find_ceiling(y_radius);
			if (tile_data != undefined)
			{
				// Flip mask and land on the ceiling
				mask_direction = (mask_direction + 180) mod 360;
				landed = true;
				player_ground(tile_data);
				
				// Abort if rising slowly or the ceiling is too shallow
				if (y_speed > CEILING_LAND_THRESHOLD or (local_direction >= 135 and local_direction <= 225))
				{
					// Slide against it
					sine = dsin(local_direction);
					cosine = dcos(local_direction);
					var g_speed = cosine * x_speed - sine * y_speed;
					x_speed = cosine * g_speed;
					y_speed = -sine * g_speed;
					
					// Revert mask rotation and exit loop
					mask_direction = gravity_direction;
					landed = false;
					break;
				}
			}
		}
		
		// Land
		if (landed)
		{
			// Calculate landing speed
			if (abs(x_speed) <= abs(y_speed) and local_direction >= 22.5 and local_direction <= 337.5)
			{
				x_speed = -y_speed * sign(dsin(local_direction));
				if (local_direction < 45 or local_direction > 315) x_speed *= 0.5;
			}
			
			// Stop falling and exit loop
			y_speed = 0;
			landed = false;
			on_ground = true;
			objCamera.on_ground = true;
			if (badnik_chain > 0 and invincibility_time == 0) badnik_chain = 0;
			break;
		}
		
		// Handle wall collision (again)
		var wall_data = player_beam_collision(solid_colliders);
		if (wall_data != noone) player_eject_wall(wall_data);
	}
}