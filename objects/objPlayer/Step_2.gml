/// @description Stamps
var x_int = x div 1;
var y_int = y div 1;
var sine = dsin(gravity_direction);
var cosine = dcos(gravity_direction);
var action = state;

#region Spin Dash Dust

with (spin_dash_stamp)
{
    if (action == player_is_spindashing)
    {
        x = x_int;
        y = y_int;
        image_xscale = other.image_xscale;
        image_angle = other.mask_direction;
        animation_set(global.ani_spindash_dust_v0);
    }
    else if (not is_undefined(animation_data.ani))
    {
        animation_set(undefined);
    }
}

#endregion
