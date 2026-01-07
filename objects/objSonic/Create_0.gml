/// @description Initialize
event_inherited();

character_index = CHARACTER.SONIC;

player_animate = function()
{
	switch (animation_data.index)
	{
		case ANIM.IDLE:
		{
			player_set_animation(global.ani_sonic_idle_v0, gravity_direction);
			break;
		}
		case ANIM.TEETER:
		{
			player_animate_teeter(global.ani_sonic_teeter);
			break;
		}
		case ANIM.RUN:
		{
			player_animate_run(global.ani_sonic_run);
			break;
		}
		case ANIM.BRAKE:
		{
			player_set_animation(global.ani_sonic_brake_v0);
			break;
		}
		case ANIM.LOOK_UP:
		{
			player_set_animation(global.ani_sonic_look);
			break;
		}
		case ANIM.CROUCH_DOWN:
		{
			player_set_animation(global.ani_sonic_crouch);
			break;
		}
		case ANIM.HURT:
		{
			player_set_animation(global.ani_sonic_hurt_v0, gravity_direction);
			break;
		}
		case ANIM.ROLL:
		{
			player_animate_roll(global.ani_sonic_roll_v0);
			break;
		}
		case ANIM.SPINDASH:
		{
			player_set_animation(global.ani_sonic_spindash_v0);
			break;
		}
	}
}