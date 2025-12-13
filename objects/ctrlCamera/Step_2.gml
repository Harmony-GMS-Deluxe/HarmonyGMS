/// @description Execute camera behavior
if (script_exists(state)) 
{
    with (caller) 
	{
        script_execute(other.state);
    }
}