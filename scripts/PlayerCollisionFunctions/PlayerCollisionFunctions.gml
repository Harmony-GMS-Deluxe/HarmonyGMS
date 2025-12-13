/// @function player_collision(obj)
/// @description Checks if the given entity's mask intersects the player's virtual mask.
/// @param {Asset.GMObject|Id.Instance|Id.TileMapElement} obj Object, instance or tilemap element to check.
/// @returns {Bool}
function player_collision(obj)
{
	var x_int = x div 1;
	var y_int = y div 1;
	
	return (mask_direction mod 180 != 0 ?
		collision_rectangle(x_int - y_radius, y_int - x_radius, x_int + y_radius, y_int + x_radius, obj, true, false) != noone :
		collision_rectangle(x_int - x_radius, y_int - y_radius, x_int + x_radius, y_int + y_radius, obj, true, false) != noone);
}

/// @function player_collision_ext(obj, xrad, yrad)
/// @description Checks if the given entity's mask intersects the player's virtual mask.
/// @param {Asset.GMObject|Id.Instance|Id.TileMapElement} obj Object, instance or tilemap element to check.
/// @param {Real} xrad Distance in pixels to extend the player's mask horizontally.
/// @param {Real} yrad Distance in pixels to extend the player's mask vertically.
/// @returns {Bool}
function player_collision_ext(obj, xrad, yrad)
{
	var x_int = x div 1;
	var y_int = y div 1;
	
	return (mask_direction mod 180 != 0 ?
		collision_rectangle(x_int - yrad, y_int - xrad, x_int + yrad, y_int + xrad, obj, true, false) != noone :
		collision_rectangle(x_int - xrad, y_int - yrad, x_int + xrad, y_int + yrad, obj, true, false) != noone);
}

/// @function player_part_collision(obj, yrad)
/// @description Checks if the given entity's mask intersects a vertical portion of the player's virtual mask.
/// @param {Asset.GMObject|Id.Instance|Id.TileMapElement} obj Object, instance or tilemap element to check.
/// @param {Real} yrad Distance in pixels to extend the player's mask vertically.
/// @returns {Bool}
function player_part_collision(obj, yrad)
{
	var x_int = x div 1;
	var y_int = y div 1;
	var sine = dsin(mask_direction);
	var cosine = dcos(mask_direction);
	
	var x1 = x_int - cosine * x_radius;
	var y1 = y_int + sine * x_radius;
	var x2 = x_int + cosine * x_radius + sine * yrad;
	var y2 = y_int - sine * x_radius + cosine * yrad;
	
	return collision_rectangle(x1, y1, x2, y2, obj, true, false) != noone;
}

/// @function player_beam_collision(obj, [xdia], [yoff])
/// @description Checks if the given entity's mask intersects a line from the player's position.
/// @param {Asset.GMObject|Id.Instance|Id.TileMapElement} obj Object, instance or tilemap element to check.
/// @param {Real} [xdia] Distance in pixels to extend the line horizontally on both ends (optional, default is the player's wall radius).
/// @param {Real} [yoff] Distance in pixels to offset the line vertically (optional, default is 0).
/// @returns {Bool}
function player_beam_collision(obj, xdia = x_wall_radius, yoff = 0)
{
	var x_int = x div 1;
	var y_int = y div 1;
	var sine = dsin(mask_direction);
	var cosine = dcos(mask_direction);
	
	var x1 = x_int - cosine * xdia + sine * yoff;
	var y1 = y_int + sine * xdia + cosine * yoff;
	var x2 = x_int + cosine * xdia + sine * yoff;
	var y2 = y_int - sine * xdia + cosine * yoff;
	
	return collision_line(x1, y1, x2, y2, obj, true, false) != noone;
}

/// @function player_ray_collision(obj, xoff, yrad)
/// @description Checks if the given entity's mask intersects a line from the player's position.
/// @param {Asset.GMObject|Id.Instance|Id.TileMapElement} obj Object, instance or tilemap element to check.
/// @param {Real} xoff Distance in pixels to offset the line horizontally.
/// @param {Real} yrad Distance in pixels to extend the line downward.
/// @returns {Bool}
function player_ray_collision(obj, xoff, yrad)
{
	var x_int = x div 1;
	var y_int = y div 1;
	var sine = dsin(mask_direction);
	var cosine = dcos(mask_direction);
	
	var x1 = x_int + cosine * xoff;
	var y1 = y_int - sine * xoff;
	var x2 = x_int + cosine * xoff + sine * yrad;
	var y2 = y_int - sine * xoff + cosine * yrad;
	
	return collision_line(x1, y1, x2, y2, obj, true, false) != noone;
}

/// @function player_arm_collision(obj, xdia)
/// @description Checks if the given entity's mask intersects a line from the player's arm.
/// @param {Asset.GMObject|Id.Instance|Id.TileMapElement} obj Object, instance or tilemap element to check.
/// @param {Real} xdia Distance in pixels to extend the line horizontally on both ends.
/// @returns {Bool}
function player_arm_collision(obj, xdia)
{
	var x_int = x div 1;
	var y_int = y div 1;
	var sine = dsin(mask_direction);
	var cosine = dcos(mask_direction);
	
	var x1 = x_int;
	var y1 = y_int;
	var x2 = x_int + (cosine * xdia);
	var y2 = y_int - (sine * xdia);
	
	return shape_in_line(obj, x1, y1, x2, y2);
}

/// @function player_arms_collision(obj, xdia)
/// @description Checks if the given entity's mask intersects a line from the player's arms.
/// @param {Asset.GMObject|Id.Instance|Id.TileMapElement} obj Object, instance or tilemap element to check.
/// @param {Real} xdia Distance in pixels to extend the line horizontally on both ends.
/// @returns {Bool}
function player_arms_collision(obj, xdia)
{
	var x_int = x div 1;
	var y_int = y div 1;
	var sine = dsin(mask_direction);
	var cosine = dcos(mask_direction);
	
	var x1 = x_int - (cosine * xdia);
	var y1 = y_int + (sine * xdia);
	var x2 = x_int + (cosine * xdia);
	var y2 = y_int - (sine * xdia);
	
	return shape_in_line(obj, x1, y1, x2, y2);
}

/// @function player_point_in_rectangle(obj, [x], [y])
/// @description Checks if the given entity's rectangle intersects a point within from the player's position.
/// @param {Asset.GMObject|Id.Instance|Id.TileMapElement} obj Object, instance or tilemap element to check.
/// @param {Real} x Horizontal position in pixels (Optional, defaults is the player's x position.)
/// @param {Real} y Vertical position in pixels (Optional, defaults is the player's y position.)
/// @returns {Bool}
function player_point_in_rectangle(obj, pos_x = x, pos_y = y)
{
	var x_int = pos_x div 1;
	var y_int = pos_y div 1;
	
	var x1 = obj.bbox_left;
	var y1 = obj.bbox_top;
	var x2 = obj.bbox_right;
	var y2 = obj.bbox_bottom;
	
	return point_in_rectangle(x_int, y_int, x1, y1, x2, y2);
}