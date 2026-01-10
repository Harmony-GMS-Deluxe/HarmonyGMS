/// @function sonic_is_homing(phase)
function sonic_is_homing(phase)
{
	switch (phase)
	{
		case PHASE.ENTER:
		{
			break;
		}
		case PHASE.STEP:
		{
			// Move
			player_move_in_air();
			if (state_changed) exit;
			
			// Fall if the reticle can no longer be locked on to
			if (not player_can_lock_on(objHomingReticle.target_id))
			{
				jump_action = false;
				instance_destroy(objHomingReticle);
				return player_perform(player_is_falling);
			}
			
			// Move towards the reticle
			var homing_speed = 12;
			var dir = point_direction(x, y, objHomingReticle.x, objHomingReticle.y) - mask_direction;
			x_speed = lengthdir_x(homing_speed, dir);
			y_speed = lengthdir_y(homing_speed, dir);
			break;
		}
		case PHASE.EXIT:
		{
			break;
		}
	}
}

/// @function cd_sonic_is_peeling_out(phase)
function cd_sonic_is_peeling_out(phase)
{
	switch (phase)
	{
		case PHASE.ENTER:
		{
			break;
		}
		case PHASE.STEP:
		{
			break;
		}
		case PHASE.EXIT:
		{
			break;
		}
	}
}

/// @function cd_sonic_is_peeling_out(phase)
function cd_sonic_is_spindashing(phase)
{
	switch (phase)
	{
		case PHASE.ENTER:
		{
			break;
		}
		case PHASE.STEP:
		{
			break;
		}
		case PHASE.EXIT:
		{
			break;
		}
	}
}