/// @description Attach
if (instance_exists(source)) 
{
    x = source.x div 1;
    y = source.y div 1;
	linked_object_id = source.linked_object_id;
} 
else 
{
    instance_destroy();
}