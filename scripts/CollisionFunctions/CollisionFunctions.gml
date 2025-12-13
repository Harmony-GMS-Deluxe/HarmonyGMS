/// @function shape_in_point(shape, x, y)
function shape_in_point(shape, px, py)
{
	return (collision_point(px, py, shape, true, false) != noone);
}


/// @function shape_in_line(shape, x1, y1, x2, y2)
function shape_in_line(shape, x1, y1, x2, y2)
{
	var final_result = 0;
	
	var len = point_distance(x1, y1, x2, y2);
	var dir = point_direction(x1, y1, x2, y2);
	var portion = 0.01;
	for (var d = 0; d <= 1; d += portion) 
	{
		if (position_meeting(x1 + lengthdir_x(len * d, dir), y1 + lengthdir_y(len * d, dir), shape)) 
		{
			final_result = true;
			break;
		}
	}
	
	return final_result;
}