/// @function input_check(command)
/// @description Checks if the given command was registered this frame.
/// @param {Enum.INPUT} command Input command constant.
/// @returns {Bool}
function input_check(command)
{
	return ctrlInput.state & (1 << command) != 0;
}

/// @function input_check_pressed(command)
/// @description Checks if the given command was registered this frame and not last frame.
/// @param {Enum.INPUT} command Input command constant.
/// @returns {Bool}
function input_check_pressed(command)
{
	command = 1 << command;
	with (ctrlInput)
	{
		return state & command != 0 and previous_state & command == 0;
	}
}

/// @function input_check_released(command)
/// @description Checks if the given command was registered last frame and not this frame.
/// @param {Enum.INPUT} command Input command constant.
/// @returns {Bool}
function input_check_released(command)
{
	command = 1 << command;
	with (ctrlInput)
	{
		return previous_state & command != 0 and state & command == 0;
	}
}

/// @function input_opposing(negative_command, positive_command)
/// @description Checks if the given commands oppose with one or another.
/// @param {Enum.INPUT} negative_command Negative input command constant.
/// @param {Enum.INPUT} positive_command Positive input command constant.
/// @returns {Integer}
function input_opposing(negative_command, positive_command)
{
	return (input_check(positive_command) - input_check(negative_command));
}