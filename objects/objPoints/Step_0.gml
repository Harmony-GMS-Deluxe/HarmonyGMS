/// @description Rise
if (ctrlGame.game_paused) exit;

if (y_speed < 0)
{
	y += y_speed;
	y_speed += 0.09375;
}
else
{
	instance_destroy();
}