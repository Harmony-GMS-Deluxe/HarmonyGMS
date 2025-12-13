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
	// Get total object entities
	var total_objects = array_length(object_entities);
		
	// Execute the test reaction of all instances
	if (total_objects > 0)
	{
		for (var n = 0; n < total_objects; ++n)
		{
			var inst = object_entities[n];
			
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