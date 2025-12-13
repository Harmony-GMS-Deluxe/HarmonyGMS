/// @function player_calc_tile_normal(x, y, rot)
/// @description Calculates the surface normal of the 16x16 solid chunk found at the given point.
/// @param {Real} x x-coordinate of the point.
/// @param {Real} y y-coordinate of the point.
/// @param {Real} rot Direction to extend / regress the angle sensors in multiples of 90 degrees.
/// @returns {Real}
function player_calc_tile_normal(ox, oy, rot)
{
	// Setup angle sensors
	var sensor_x = array_create(2, ox);
	var sensor_y = array_create(2, oy);
	var sine = dsin(rot);
	var cosine = dcos(rot);
	
	if (rot mod 180 != 0)
	{
		var right = (rot == 90);
		sensor_y[right] = oy div 16 * 16;
		sensor_y[not right] = sensor_y[right] + 15;
	}
	else
	{
		var up = (rot == 180);
		sensor_x[up] = ox div 16 * 16;
		sensor_x[not up] = sensor_x[up] + 15;
	}
	
	// Extend / regress angle sensors
	for (var n = 0; n < 2; ++n)
	{
		repeat (y_tile_reach)
		{
			if (collision_point(sensor_x[n], sensor_y[n], solid_entities, true, false) == noone)
			{
				sensor_x[n] += sine;
				sensor_y[n] += cosine;
			}
			else if (collision_point(sensor_x[n] - sine, sensor_y[n] - cosine, solid_entities, true, false) != noone)
			{
				sensor_x[n] -= sine;
				sensor_y[n] -= cosine;
			}
			else break;
		}
	}
	
	// Calculate the direction between both angle sensors
	return point_direction(sensor_x[0], sensor_y[0], sensor_x[1], sensor_y[1]) div 1;
}

/// @function player_calc_wall_distance(inst, [xdia])
/// @description Calculates the wall distance of the given collision data. Ported from Sonic for GMS.
/// @param {Id.Instance|Id.TileMapElement} inst Instance or tilemap element to get distance from.
/// @param {Real} [xdia] Distance in pixels to extend the line horizontally on both ends (optional, default is the player's wall radius).
/// @returns {Real|Undefined} Final calculated distance of the wall from the player, or undefined on failure to find a wall.
function player_calc_wall_distance(inst, xdia = x_wall_radius)
{
	var x_int = (x div 1)
	var y_int = (y div 1)
	
	var sine = dsin(mask_direction);
	var cosine = dcos(mask_direction);
	
	var final_distance = undefined;
	
	if (shape_in_point(inst, x_int, y_int))
	{
		for (var ox = xdia; ox < (xdia * 2); ++ox) 
		{
	        if (not shape_in_point(inst, x_int + (cosine * ox), y_int - (sine * ox))) 
			{
	            final_distance = -(xdia + ox); // right side
	            break;
	        } 
			else if (not shape_in_point(inst, x_int - (cosine * ox), y_int + (sine * ox))) 
			{
	            final_distance = (xdia + ox); // left side
	            break;
	        }
	    }
	}
	else
	{
		for (var ox = xdia; ox > -1; --ox) 
		{
	        if (not player_arm_collision(inst, ox)) 
			{
	            if (shape_in_line(inst, x_int, y_int, x_int + (cosine * (ox + 1)), y_int - (sine * (ox + 1)))) 
				{
	                final_distance = (xdia - ox); // right side
	                break;
	            } 
				else if (shape_in_line(inst, x_int, y_int, x_int - (cosine * (ox + 1)), y_int + (sine * (ox + 1)))) 
				{
	                final_distance = -(xdia - ox); // left side
	                break;
	            }
	        }
	    }
	}
	
	return final_distance;
}

/// @function player_detect_entities()
/// @description Finds any instances intersecting a minimum bounding rectangle centered on the player, and executes their reaction.
/// It also records any solid tilemaps and instances for terrain collision detection.
function player_detect_entities()
{
	// Delist zone objects
	static starting_object_count = array_length(object_entities);
	array_resize(object_entities, starting_object_count);
	
	// Delist solid zone objects
	static starting_terrain_count = array_length(solid_entities);
	array_resize(solid_entities, starting_terrain_count);
	
	// Evaluate semisolid tilemap collision
	if (semisolid_tilemap != -1)
	{
		var valid = array_contains(solid_entities, semisolid_tilemap);
		if (not player_beam_collision(semisolid_tilemap))
		{
			if (not valid) array_push(solid_entities, semisolid_tilemap);
		}
		else if (valid) array_pop(solid_entities);
	}
	
	// Setup X and Y radii
	var xdia = x_wall_radius + 0.5;
	var ydia = y_radius + y_tile_reach + 0.5;
	
	// Count total objects
	var total_objects = instance_number(objZoneObject);
	
	// Execute the reaction of all instances
	if (total_objects > 0)
	{
		for (var n = 0; n < total_objects; ++n)
		{
			var inst = instance_find(objZoneObject, n);
			
			if (instance_exists(inst) and player_collision_ext(inst, xdia, ydia))
			{
				// Register general instances.
				array_push(object_entities, inst);
			
				// Register solid instances
				if (object_is_ancestor(inst.object_index, objSolid))
				{
					// Skip the current instance if passing through
					if (inst.semisolid and player_beam_collision(inst)) continue;
					array_push(solid_entities, inst);
				}
			}
		}
	}
	
	/* AUTHOR NOTE:
	(1) There is a limitation with the semisolid tilemap detection where, if the player passes through a semisolid tilemap whilst standing on one,
	they will fall as it will be delisted from their `solid_entities` array.
	
	(2) The size of the bounding rectangle must be coordinated with the distances used for collision checking:
	- Wall collisions check for a distance of `x_wall_radius`, so this is the rectangle's width.
	- Floor collisions check for a distance of `y_tile_reach + y_radius`, so this is the rectangle's height.
	
	The additional 0.5 pixels is there to address a quirk with GameMaker's collision functions where, with the exception of
	`collision_line` and `collision_point`, the colliding shapes must intersect by at least 0.5 pixels for a collision to be registered. */
}

/// @function player_get_wall_data([xrad])
function player_get_wall_data(xrad = x_wall_radius)
{
	wall_id = noone;
	wall_sign = 0;
	
	var tile_data = player_find_wall();
	
	if (tile_data != noone)
	{
		var distance_to_wall = player_calc_wall_distance(tile_data, xrad);
		var sine = dsin(mask_direction);
		var cosine = dcos(mask_direction);
		if (not is_undefined(distance_to_wall))
		{
			x += -(cosine * distance_to_wall);
			y += (sine * distance_to_wall);
			wall_id = tile_data;
			wall_sign = sign(distance_to_wall);
		}
	}
}