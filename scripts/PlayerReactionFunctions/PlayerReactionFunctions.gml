function player_memorize_reactions()
{
	if (not (ds_list_empty(reaction_list) and ds_list_empty(previous_reaction_list))) 
	{
		ds_list_copy(previous_reaction_list, reaction_list);
		ds_list_clear(reaction_list);
	}
}

function player_react_to(inst)
{
	if (ds_list_find_index(reaction_list, inst) == -1) 
	{
		ds_list_add(reaction_list, inst);
	}
}

function player_trigger_reactions()
{
	player_test_reactions();
	player_enter_reactions();
	player_exit_reactions();
}

function player_test_reactions()
{
	// Setup bounding rectangle
	var x_int = x div 1;
	var y_int = y div 1;
	var xdia = x_wall_radius + 0.5;
	var ydia = y_radius + y_tile_reach + 0.5;
	
	// Detect instances intersecting the rectangle
	var zone_objects = ds_list_create();
	var total_objects = (mask_direction mod 180 != 0 ?
		collision_rectangle_list(x_int - ydia, y_int - xdia, x_int + ydia, y_int + xdia, objZoneObject, true, false, zone_objects, false) :
		collision_rectangle_list(x_int - xdia, y_int - ydia, x_int + xdia, y_int + ydia, objZoneObject, true, false, zone_objects, false));
		
	// Execute the test reaction of all instances
	if (total_objects > 0)
	{
		for (var n = 0; n < total_objects; ++n)
		{
			var inst = zone_objects[| n];
			
			if (instance_exists(inst) and ds_list_find_index(reaction_list, inst) == -1)
			{
				script_execute(inst.reaction_test, inst);
			}
		}
	}
}

function player_enter_reactions()
{
	// Detect instances intersecting the rectangle
	var total_reactions = ds_list_size(reaction_list);
		
	// Execute the test reaction of all instances
	if (total_reactions > 0)
	{
		for (var n = 0; n < total_reactions; ++n)
		{
			var inst = reaction_list[| n];
			
			if (instance_exists(inst) and ds_list_find_index(previous_reaction_list, inst) == -1)
			{
				script_execute(inst.reaction_on_enter, inst);
			}
		}
	}
}

function player_exit_reactions()
{
	// Detect instances intersecting the rectangle
	var total_reactions = ds_list_size(previous_reaction_list);
		
	// Execute the test reaction of all instances
	if (total_reactions > 0)
	{
		for (var n = 0; n < total_reactions; ++n)
		{
			var inst = previous_reaction_list[| n];
			
			if (instance_exists(inst) and ds_list_find_index(reaction_list, inst) == -1)
			{
				script_execute(inst.reaction_on_exit, inst);
			}
		}
	}
}