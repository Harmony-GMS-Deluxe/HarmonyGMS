/// @description Behave
input_axis_x = InputOpposing(INPUT_VERB.LEFT, INPUT_VERB.RIGHT, input_channel);
input_axis_y = InputOpposing(INPUT_VERB.UP, INPUT_VERB.DOWN, input_channel);

struct_foreach(input_button, function (name, value)
{
    var verb = value.index;
    value.check = InputCheck(verb, input_channel);
    value.pressed = InputPressed(verb, input_channel);
    value.released = InputReleased(verb, input_channel);
});

if (script_exists(state)) 
{
	state(PHASE.STEP);
	if (state_changed) state_changed = false;
}