// Setup particles
sprite_particles = {};
with (sprite_particles)
{
	system = part_system_create();
	
	splash = part_type_create();
	part_type_life(splash, 32, 32);
	part_type_sprite(splash, sprSplash, true, true, false);
	
	ring_sparkle = part_type_create();
	part_type_life(ring_sparkle, 24, 24);
	part_type_sprite(ring_sparkle, sprRingSparkle, true, true, false);
	
	brake_dust = part_type_create();
	part_type_life(brake_dust, 16, 16);
	part_type_sprite(brake_dust, sprBrakeDust, true, true, false);
}