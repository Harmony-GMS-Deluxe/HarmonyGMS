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
			timeline_running = true;
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
			rolling = false;
			
			// Check if standing on a cliff
			player_find_cliff();
			
			// Animate
			player_animate(cliff_sign != 0 ? "teeter" : "idle");
			image_angle = gravity_direction;
			
			// Direct Camera
			player_cam_direct(player_cam_is_normal);
			break;
		}
		case PHASE.STEP:
		{
			// Jump
			if (input_button.jump.pressed) return player_perform(player_is_jumping);
			
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
				control_lock_time = slide_duration;
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
			rolling = false;
			
			// Direct Camera
			player_cam_direct(player_cam_is_normal);
			break;
		}
		case PHASE.STEP:
		{
			// Jump
			if (input_button.jump.pressed) return player_perform(player_is_jumping);
			
			// Handle ground motion
			if (control_lock_time == 0)
			{
				if (input_axis_x != 0)
				{
					// If moving in the opposite direction...
					if (x_speed != 0 and sign(x_speed) != input_axis_x)
					{
						// Hit the brakes
						if (abs(x_speed) >= 4)
						{
							image_xscale = -input_axis_x;
							if (mask_direction == gravity_direction)
							{
								sound_play(sfxBrake);
								return player_perform(player_is_braking)
							}
						}
						
						// Decelerate and reverse direction
						x_speed += deceleration * input_axis_x;
						if (sign(x_speed) == input_axis_x) x_speed = deceleration * input_axis_x;
					}
					else
					{
						// Accelerate
						image_xscale = input_axis_x;
						if (abs(x_speed) < speed_cap)
						{
							x_speed = min(abs(x_speed) + acceleration, speed_cap) * input_axis_x;
						}
					}
				}
				else
				{
					// Friction
					x_speed -= min(abs(x_speed), friction) * sign(x_speed);
				}
			}
			
			// Move
			player_move_on_ground();
			if (state_changed) exit;
			
			// Fall
			if (not on_ground) return player_perform(player_is_falling);
			
			// Slide down steep slopes
			if (abs(x_speed) < slide_threshold)
			{
				if (local_direction >= 90 and local_direction <= 270)
				{
					return player_perform(player_is_falling);
				}
				else if (local_direction >= 45 and local_direction <= 315)
				{
					control_lock_time = slide_duration;
				}
			}
			
			// Apply slope friction
			player_resist_slope(0.125);
			
			// Roll
			if (input_axis_x == 0 and abs(x_speed) >= 1.03125 and input_axis_y == 1)
			{
				sound_play(sfxRoll);
				return player_perform(player_is_rolling);
			}
			
			// Stand
			if (x_speed == 0 and input_axis_x == 0) return player_perform(player_is_standing);
			
			// Push
			if (wall_id != noone and wall_sign == input_axis_x and sign(x_speed) != -wall_sign)
			{
				return player_perform(player_is_pushing);
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

/// @function player_is_braking(phase)
function player_is_braking(phase)
{
	switch (phase)
	{
		case PHASE.ENTER:
		{
			rolling = false;
			
			player_animate("brake");
			image_angle = gravity_direction;
			
			// Direct Camera
			player_cam_direct(player_cam_is_normal);
			break;
		}
		case PHASE.STEP:
		{
			// Jump
			if (input_button.jump.pressed) return player_perform(player_is_jumping);
			
			// Handle ground motion
			if (control_lock_time == 0)
			{
				if (input_axis_x != 0)
				{
					// If moving in the opposite direction...
					if (sign(x_speed) != input_axis_x)
					{
						// Decelerate and reverse direction
						x_speed += deceleration * input_axis_x;
						if (sign(x_speed) == input_axis_x) 
						{
							x_speed = deceleration * input_axis_x;
							return player_perform(player_is_running);
						}
					}
					else
					{
						return player_perform(player_is_running);
					}
				}
				else
				{
					// Friction
					x_speed -= min(abs(x_speed), friction) * sign(x_speed);
				}
			}
			
			// Move
			player_move_on_ground();
			if (state_changed) exit;
			
			// Fall
			if (not on_ground) return player_perform(player_is_falling);
			
			// Slide down steep slopes
			if (abs(x_speed) < slide_threshold)
			{
				if (local_direction >= 90 and local_direction <= 270)
				{
					return player_perform(player_is_falling);
				}
				else if (local_direction >= 45 and local_direction <= 315)
				{
					control_lock_time = slide_duration;
					return player_perform(player_is_running);
				}
			}
			
			// Apply slope friction
			player_resist_slope(0.125);
			
			// Roll
			if (input_axis_x == 0 and abs(x_speed) >= 1.03125 and input_axis_y == 1)
			{
				sound_play(sfxRoll);
				return player_perform(player_is_rolling);
			}
			
			// Stand
			if (x_speed == 0 and input_axis_x == 0) return player_perform(player_is_standing);
			
			// Reset
			if (timeline_expired(id))
			{
				return player_perform(player_is_running);
			}
			
			// Spawn particle
			if (not underwater and timeline_position mod 4 == 0)
			{
				// Kick up dust
				var offset = y_radius - 6;
				var ox = x + dsin(direction) * offset;
				var oy = y + dcos(direction) * offset;
				particle_spawn("brake_dust", ox, oy);
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
			player_animate("look");
			
			player_cam_direct(player_cam_is_looking)
			with (camera) look_time = default_look_time;
			break;
		}
		case PHASE.STEP:
		{
			// Jump
			if (input_button.jump.pressed) return player_perform(player_is_jumping);
			
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
				control_lock_time = slide_duration;
				return player_perform(player_is_running);
			}
			
			// Run
			if (x_speed != 0) return player_perform(player_is_running);
			
			// Stand
			if (input_axis_y != -1) return player_perform(player_is_standing);
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
			player_animate("crouch");
			player_cam_direct(player_cam_is_crouching)
			with (camera) look_time = default_look_time;
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
				control_lock_time = slide_duration;
				return player_perform(player_is_running);
			}
			
			// Run
			if (x_speed != 0) return player_perform(player_is_running);
			
			// Stand
			if (input_axis_y != 1) return player_perform(player_is_standing);
			break;
		}
		case PHASE.EXIT:
		{
			break;
		}
	}
}

/// @function player_is_pushing(phase)
function player_is_pushing(phase)
{
	switch (phase)
	{
		case PHASE.ENTER:
		{
			rolling = false;
			
			// TODO: Add in a pushing animation
			player_animate("idle");
			image_angle = gravity_direction;
			
			// Direct Camera
			player_cam_direct(player_cam_is_normal);
			break;
		}
		case PHASE.STEP:
		{
			// Jump
			if (input_button.jump.pressed) return player_perform(player_is_jumping);
			
			// Handle ground motion
			if (input_axis_x != 0)
			{
				if (image_xscale != input_axis_x)
				{
					return player_perform(player_is_running);
				}
				else
				{
					image_xscale = input_axis_x;
					if (abs(x_speed) < speed_cap)
					{
						x_speed = min(abs(x_speed) + acceleration, speed_cap) * input_axis_x;
					}
				}
			}
			else
			{
				return player_perform(abs(x_speed) > 0 ? player_is_running : player_is_standing);
			}
			
			// Move
			player_move_on_ground();
			if (state_changed) exit;
			
			// Fall
			if (not on_ground) return player_perform(player_is_falling);
			
			// Slide down steep slopes
			if (abs(x_speed) < slide_threshold)
			{
				if (local_direction >= 90 and local_direction <= 270)
				{
					return player_perform(player_is_falling);
				}
				else if (local_direction >= 45 and local_direction <= 315)
				{
					control_lock_time = slide_duration;
					return player_perform(player_is_running);
				}
			}
			
			// Apply slope friction
			player_resist_slope(0.125);
			break;
		}
		case PHASE.EXIT:
		{
			control_lock_time = 0;
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
			player_animate("roll");
			image_angle = gravity_direction;
			
			// Direct Camera
			player_cam_direct(player_cam_is_normal);
			break;
		}
		case PHASE.STEP:
		{
			// Jump
			if (input_button.jump.pressed) return player_perform(player_is_jumping);
			
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
			if (abs(x_speed) < slide_threshold)
			{
				if (local_direction >= 90 and local_direction <= 270)
				{
					return player_perform(player_is_falling);
				}
				else if (local_direction >= 45 and local_direction <= 315)
				{
					control_lock_time = slide_duration;
				}
			}
			
			// Apply slope friction
			var friction_uphill = 0.078125;
			var friction_downhill = 0.3125;
			var slope_friction = (sign(x_speed) == sign(dsin(local_direction)) ? friction_uphill : friction_downhill);
			player_resist_slope(slope_friction);
			
			// Unroll
			if (abs(x_speed) < 0.5) return player_perform(player_is_running);
			
			// Animate
			timeline_speed = 1 / max(5 - abs(x_speed) div 1, 1);
			break;
		}
		case PHASE.EXIT:
		{
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
			player_animate("spindash");
			sound_play(sfxSpinRev);
			
			// Direct Camera
			player_cam_direct(player_cam_is_normal);
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
				control_lock_time = slide_duration;
				return player_perform(player_is_rolling);
			}
			
			// Roll
			if (input_axis_y != 1)
			{
				x_speed = image_xscale * (8 + spindash_charge div 2);
				
				with (camera) lag_time = floor(24 - abs(other.x_speed));
				
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
			else spindash_charge *= 0.96875;
			break;
		}
		case PHASE.EXIT:
		{
			break;
		}
	}
}