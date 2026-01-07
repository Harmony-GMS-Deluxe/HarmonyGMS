/// @description Update
if (ctrlGame.game_paused) exit;

if (x_acceleration != 0) x_speed += image_xscale * x_acceleration;
if (y_acceleration != 0) y_speed += image_yscale * y_acceleration;
animation_update();