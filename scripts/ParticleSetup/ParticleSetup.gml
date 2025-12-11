// Setup particles
sprite_particles = {};
with (sprite_particles)
{
	particles = ds_map_create();
	system = part_system_create();
	
	particles[? "splash"] = part_type_create();
	part_type_life(particles[? "splash"], 32, 32);
	part_type_sprite(particles[? "splash"], sprSplash, true, true, false);
	
	particles[? "ring_sparkle"] = part_type_create();
	part_type_life(particles[? "ring_sparkle"], 24, 24);
	part_type_sprite(particles[? "ring_sparkle"], sprRingSparkle, true, true, false);
	
	particles[? "brake_dust"] = part_type_create();
	part_type_life(particles[? "brake_dust"], 16, 16);
	part_type_sprite(particles[? "brake_dust"], sprBrakeDust, true, true, false);
}