/// @description Spawn Player

	var player_inst = instance_create_layer(x, y, "ZoneObjects", objSonic);
	with (player_inst) input_channel = 0;
	instance_destroy();