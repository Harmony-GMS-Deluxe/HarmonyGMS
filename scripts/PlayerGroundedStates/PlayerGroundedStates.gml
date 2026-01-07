/// @function player_is_ready(phase)
function player_is_ready(phase)
{
	switch (phase)
	{
		case PHASE.ENTER:
		{
			break;
		}
		case PHASE.STEP:
		{
			player_perform(player_is_standing);
			break;
		}
		case PHASE.EXIT:
		{
			break;
		}
	}
}

/// @function player_is_standing(phase)
function player_is_standing(phase)
{
	switch (phase)
	{
		case PHASE.ENTER:
		{
			// Check if standing on a cliff
			cliff_sign = 0;
			var height = y_radius + y_tile_reach;
			if (not player_ray_collision(solid_colliders, 0, height))
			{
				cliff_sign = player_ray_collision(solid_colliders, -x_radius, height) -
					player_ray_collision(solid_colliders, x_radius, height);
			}
			
			// Animate
            var ani_idle = (cliff_sign != 0 ? ANIM.TEETER : ANIM.IDLE);
            animation_init(ani_idle, 0);
			break;
		}
		case PHASE.STEP:
		{
			// Jump
			if (player_try_jump()) return true;
			
			// Move
			player_move_on_ground();
			if (state_changed) exit;
			
			// Fall
			if (not on_ground or (local_direction >= 90 and local_direction <= 270))
			{
				return player_perform(player_is_falling);
			}
			
			// Slide down steep slopes
			if (local_direction >= 45 and local_direction <= 315)
			{
				control_lock_time = SLIDE_DURATION;
				return player_perform(player_is_running);
			}
			
			// Run
            if (x_speed != 0 or input_axis_x != 0)
            {
                return player_perform(player_is_running);
            }
                
            // Look / crouch
            if (cliff_sign == 0)
            {
                if (input_axis_y == -1) return player_perform(player_is_looking);
                if (input_axis_y == 1) return player_perform(player_is_crouching);
            }
			break;
		}
		case PHASE.EXIT:
		{
			break;
		}
	}
}

/// @function player_is_running(phase)
function player_is_running(phase)
{
	switch (phase)
	{
		case PHASE.ENTER:
		{
			// Animate
            animation_init(ANIM.RUN);
			break;
		}
		case PHASE.STEP:
		{
			var facing = sign(x_speed);
			var velocity = abs(x_speed);
			
			// Jump
			if (player_try_jump()) return true;
			
			// Handle ground motion
			var can_brake = false;
			
			if (control_lock_time == 0)
			{
				if (input_axis_x != 0)
				{
					// If moving in the opposite direction...
					if (x_speed != 0 and facing != input_axis_x)
					{
						// Decelerate and reverse direction
						can_brake = true;
						x_speed += deceleration * input_axis_x;
                        if (facing == input_axis_x)
                        {
                            x_speed = deceleration * input_axis_x;
                        }
					}
					else
					{
						// Accelerate
						can_brake = false;
						image_xscale = input_axis_x;
						if (velocity < speed_cap)
						{
							x_speed = min(velocity + acceleration, speed_cap) * input_axis_x;
						}
					}
				}
				else
				{
					// Friction
					x_speed -= min(abs(x_speed), acceleration) * sign(x_speed);
					
					/* AUTHOR NOTE: the values for friction and acceleration are the same in the 16-bit Genesis games. */
				}
			}
			
			// Move
			player_move_on_ground();
			if (state_changed) exit;
			
			// Fall
			if (not on_ground) return player_perform(player_is_falling);
			
			// Slide down steep slopes
			if (abs(x_speed) < SLIDE_THRESHOLD)
			{
				if (local_direction >= 90 and local_direction <= 270)
				{
					return player_perform(player_is_falling);
				}
				else if (local_direction >= 45 and local_direction <= 315)
				{
					control_lock_time = SLIDE_DURATION;
				}
			}
			
			// Apply slope friction
			player_resist_slope(SLOPE_FRICTION);
			
			// Roll
			if (input_axis_y == 1 and velocity >= ROLL_THRESHOLD and input_axis_x == 0)
			{
				sound_play(sfxRoll);
				return player_perform(player_is_rolling);
			}
			
			// Stand
			if (x_speed == 0 and input_axis_x == 0) return player_perform(player_is_standing);
			
			// Animate
			if (can_brake)
			{
				if (animation_data.index != ANIM.BRAKE)
				{
					if (mask_direction == gravity_direction and velocity >= BRAKE_THRESHOLD)
					{
						animation_init(ANIM.BRAKE);
						sound_play(sfxBrake);
					}
				}
				else if (animation_data.time mod 4 == 0)
				{
                   // Kick up dust
					var offset = y_radius - 6;
					var ox = x + dsin(direction) * offset;
					var oy = y + dcos(direction) * offset;
					particle_create(ox, oy, global.ani_brake_dust_v0);
				}
			}
			else if (not ((animation_data.index == ANIM.PUSH and image_xscale == input_axis_x) or
			(animation_data.index == ANIM.BRAKE and animation_data.time < 24 and mask_direction == gravity_direction and image_xscale != input_axis_x)))
			{
				var new_animation = (velocity < 6) ? ANIM.WALK : ANIM.RUN;
				if (animation_data.index != new_animation) animation_init(new_animation);
			}
			break;
		}
		case PHASE.EXIT:
		{
			control_lock_time = 0;
			break;
		}
	}
}

/// @function player_is_looking(phase)
function player_is_looking(phase)
{
	switch (phase)
	{
		case PHASE.ENTER:
		{
			camera_look_time = 120;
			animation_init(ANIM.LOOK_UP);
			break;
		}
		case PHASE.STEP:
		{
			// Jump
			if (player_try_jump()) return true;
			
			// Move
			player_move_on_ground();
			if (state_changed) exit;
			
			// Fall
			if (not on_ground or (local_direction >= 90 and local_direction <= 270))
			{
				return player_perform(player_is_falling);
			}
			
			// Slide down steep slopes
			if (local_direction >= 45 and local_direction <= 315)
			{
				control_lock_time = SLIDE_DURATION;
				return player_perform(player_is_running);
			}
			
			// Run
			if (x_speed != 0) return player_perform(player_is_running);
			
			// Stand
            if (animation_data.index == ANIM.LOOK_UP and animation_data.variant == 1 and animation_is_finished())
            {
            	return player_perform(player_is_standing);
            }
            
			if (input_axis_x == 0 and input_axis_y == 0)
            {
                if (animation_data.index == ANIM.LOOK_UP and animation_data.variant == 0) animation_data.variant = 1;
            }
            else if (input_axis_y != -1)
            {
                return player_perform(player_is_standing);
            }
			
			// Ascend camera
			if (camera_look_time > 0)
			{
				--camera_look_time;
			}
			else with (objCamera)
			{
				if (y_offset > -104) y_offset -= 2;
			}
			break;
		}
		case PHASE.EXIT:
		{
			break;
		}
	}
}

/// @function player_is_crouching(phase)
function player_is_crouching(phase)
{
	switch (phase)
	{
		case PHASE.ENTER:
		{
			camera_look_time = 120;
			animation_init(ANIM.CROUCH_DOWN);
			break;
		}
		case PHASE.STEP:
		{
			// Spindash
			if (input_button.jump.pressed) return player_perform(player_is_spindashing);
			
			// Move
			player_move_on_ground();
			if (state_changed) exit;
			
			// Fall
			if (not on_ground or (local_direction >= 90 and local_direction <= 270))
			{
				return player_perform(player_is_falling);
			}
			
			// Slide down steep slopes
			if (local_direction >= 45 and local_direction <= 315)
			{
				control_lock_time = SLIDE_DURATION;
				return player_perform(player_is_running);
			}
			
			// Run
			if (x_speed != 0) return player_perform(player_is_running);
			
			// Stand
            if (animation_data.index == ANIM.CROUCH_DOWN and animation_data.variant == 1 and animation_is_finished())
            {
            	return player_perform(player_is_standing);
            }
            
			if (input_axis_x == 0 and input_axis_y == 0)
            {
                if (animation_data.index == ANIM.CROUCH_DOWN and animation_data.variant == 0) animation_data.variant = 1;
            }
            else if (input_axis_y != 1)
            {
                return player_perform(player_is_standing);
            }
			
			// Descend camera
			if (camera_look_time > 0)
			{
				--camera_look_time;
			}
			else with (objCamera)
			{
				if (y_offset < 88) y_offset += 2;
			}
			break;
		}
		case PHASE.EXIT:
		{
			break;
		}
	}
}

/// @function player_is_rolling(phase)
function player_is_rolling(phase)
{
	switch (phase)
	{
		case PHASE.ENTER:
		{
			rolling = true;
			animation_init(ANIM.ROLL);
			break;
		}
		case PHASE.STEP:
		{
			// Jump
			if (player_try_jump()) return true;
			
			// Decelerate
			if (control_lock_time == 0)
			{
				if (input_axis_x != 0)
				{
					if (sign(x_speed) != input_axis_x)
					{
						x_speed += roll_deceleration * input_axis_x;
						if (sign(x_speed) == input_axis_x) x_speed = roll_deceleration * input_axis_x;
					}
					else image_xscale = input_axis_x;
				}
				
				// Friction
				x_speed -= min(abs(x_speed), roll_friction) * sign(x_speed);
			}
			
			// Move
			player_move_on_ground();
			if (state_changed) exit;
			
			// Fall
			if (not on_ground) return player_perform(player_is_falling);
			
			// Slide down steep slopes
			if (abs(x_speed) < SLIDE_THRESHOLD)
			{
				if (local_direction >= 90 and local_direction <= 270)
				{
					return player_perform(player_is_falling);
				}
				else if (local_direction >= 45 and local_direction <= 315)
				{
					control_lock_time = SLIDE_DURATION;
				}
			}
			
			// Apply slope friction
			var slope_friction = (sign(x_speed) == sign(dsin(local_direction)) ? ROLL_SLOPE_FRICTION_UP : ROLL_SLOPE_FRICTION_DOWN);
			player_resist_slope(slope_friction);
			
			// Unroll
			if (abs(x_speed) < 0.5) return player_perform(player_is_running);
			break;
		}
		case PHASE.EXIT:
		{
			if (on_ground) rolling = false;
			break;
		}
	}
}

/// @function player_is_spindashing(phase)
function player_is_spindashing(phase)
{
	switch (phase)
	{
		case PHASE.ENTER:
		{
			rolling = true;
			spindash_charge = 0;
			animation_init(ANIM.SPINDASH);
			sound_play(sfxSpinRev);
			break;
		}
		case PHASE.STEP:
		{
			// Move
			player_move_on_ground();
			if (state_changed) exit;
			
			// Fall
			if (not on_ground or (local_direction >= 90 and local_direction <= 270))
			{
				return player_perform(player_is_falling);
			}
			
			// Slide down steep slopes
			if (local_direction >= 45 and local_direction <= 315)
			{
				control_lock_time = SLIDE_DURATION;
				return player_perform(player_is_rolling);
			}
			
			// Roll
			if (input_axis_y != 1)
			{
				x_speed = image_xscale * (8 + spindash_charge div 2);
				objCamera.alarm[0] = 16;
				audio_stop_sound(sfxSpinRev);
				sound_play(sfxSpinDash);
				return player_perform(player_is_rolling);
			}
			
			// Charge / atrophy
			if (input_button.jump.pressed)
			{
				spindash_charge = min(spindash_charge + 2, 8);
				
				// Sound
				var rev_sound = sound_play(sfxSpinRev);
				audio_sound_pitch(rev_sound, 1 + spindash_charge * 0.0625);
			}
			else 
			{
				spindash_charge *= SPINDASH_ATROPHY;
			}
			break;
		}
		case PHASE.EXIT:
		{
			break;
		}
	}
}