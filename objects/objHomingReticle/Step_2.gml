/// @description Move and animate
if (ctrlGame.game_paused) exit;

// Abort if the player is no longer jumping or if the object no longer exists
if (not player_id.rolling or not instance_exists(target_id))
{
	instance_destroy();
	exit;
}

// Update position
x = target_id.x div 1;
y = target_id.y div 1;

// Fade in
if (image_alpha < 1)
{
	image_alpha = lerp(image_alpha, 1, 0.15);
}

// Scale down
var scale_limit = 0.8;
if (circle_scale > scale_limit)
{
	circle_scale = lerp(circle_scale, scale_limit, 0.5);
}
if (arrow_scale > scale_limit)
{
	arrow_scale = lerp(arrow_scale, scale_limit, 0.5);
}

// Rotate
circle_angle += 5;
arrow_angle -= 5;