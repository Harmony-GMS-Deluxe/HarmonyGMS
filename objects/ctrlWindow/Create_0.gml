/// @description Initialize
scale = 2;

// Resize
event_user(0);

/* AUTHOR NOTE: due to being created 1 frame after the start of the game,
the Room Start event does not run, so it's invoked here. */
event_perform(ev_other, ev_room_start);