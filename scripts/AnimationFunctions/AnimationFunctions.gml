/// @function animation(sprite, duration, [loop], [order])
/// @description Creates a new animation with the given sprite and given duration.
/// @param {Asset.GMSprite} sprite Sprite to draw.
/// @param {Real|Array} duration Duration of each frame. Provide an array to set the duration per frame.
/// @param {Real} [loop] Loop frame. If a custom order is provided, this will be an index in that order. Use -1 to mark that the animation doesn't loop.
/// @param {Array} [order] Custom frame order.
function animation(_sprite, _duration, _loop = 0, _order = []) constructor
{
    sprite = _sprite;
    duration = _duration;
    loop = _loop;
    order = _order;
}

/// @function animation_core()
/// @description Creates a new animation core.
function animation_core() constructor
{
    index  = 0;
    variant = 0;
    ani = undefined;
    force = false;
    alarm = 0;
    speed = 1;
    pos = 0;
    time = 0;
}

/// @function animation_init(index, [variant], [alternatives])
/// @description Initializes the given index within the animation core.
/// @param {Real} index Animation index to set.
/// @param {Real} [variant] Variant to set (optional, defaults to 0 if the indexes don't match).
function animation_init(index, variant = -1, alternatives = [])
{
    // Abort if...
    if (variant == -1 and animation_data.index == index) exit; // Indexes match with no given variant
    if (array_contains(alternatives, animation_data.index)) exit; // Current index is an alternative
    
    if (variant == -1) variant = 0;
    animation_data.force = (animation_data.index == index);
    animation_data.index = index;
    animation_data.variant = variant;
}

/// @function animation_set(ani)
/// @description Sets the given animation within the animation core.
/// @param {Undefined|Struct.animation|Array} ani Animation to set. Accepts an array as animation variants.
function animation_set(ani)
{
    ani = (is_array(ani) ? ani[min(array_length(ani) - 1, animation_data.variant)] : ani);
    
    if (is_undefined(ani))
    {
        animation_data.alarm = 0;
        animation_data.pos = -1;
        animation_data.time = 0;
        sprite_index = -1;
        image_index = 0;
    }
    else if (animation_data.ani != ani or animation_data.force)
    {
        var sprite = ani.sprite;
        var duration = ani.duration;
        var loop = ani.loop;
        var order = ani.order;
        var start = 0;
        
        animation_data.alarm = (is_array(duration) ? duration[start] : duration);
        animation_data.pos = start;
        animation_data.time = 0;
        sprite_index = sprite;
        image_index = (array_length(order) > 0 ? order[start] : start);
    }
    
    animation_data.ani = ani;
    animation_data.force = false;
    animation_data.speed = 1;
}

/// @function animation_update()
/// @description Updates the animation core.
function animation_update()
{
    if (not is_undefined(animation_data.ani))
    {
        if (animation_data.alarm > 0)
        {
            animation_data.alarm -= animation_data.speed;
            
            if (animation_data.alarm <= 0)
            {
                var ani = animation_data.ani;
                var sprite = ani.sprite;
                var duration = ani.duration;
                var order = ani.order;
                var order_length = array_length(order);
                var last = (order_length > 0 ? order_length - 1 : sprite_get_number(sprite) - 1);
                
                animation_data.pos++;
                
                if (animation_data.pos > last)
                {
                    var loop = ani.loop;
                    animation_data.pos = loop;
                }
                
                if (animation_data.pos != -1)
                {
					if(is_array(duration))
					{
						var arr_size, result;
					
						arr_size = array_length(duration);
					
						result = min(animation_data.pos, arr_size - 1);
					
						var new_duration = duration[result];
					}
					else
					{
						var new_duration = duration;
					}
					animation_data.alarm = new_duration;
					image_index = (order_length > 0 ? order[animation_data.pos] : animation_data.pos);
                }
            }
        }
        animation_data.time++;
    }
}

/// @function animation_is_starting([index])
/// @description Checks if the current animation has just started playing at the given index.
/// @param {Real} [index] Index to check (optional, defaults to 0).
/// @returns {Bool}
function animation_is_starting(index = 0)
{
    var duration = animation_data.ani.duration;
    return (animation_data.pos == index and animation_data.alarm == (is_array(duration) ? duration[index] : duration));
}

/// @function animation_is_finished()
/// @description Checks if the animation is finished.
/// @returns {Bool}
function animation_is_finished()
{
    return animation_data.pos == -1;
}

/// @function stamp()
/// @description Creates a new stamp.
function stamp() constructor
{
    x = 0;
    y = 0;
    sprite_index = -1;
    image_index = 0;
    image_xscale = 1;
    image_yscale = 1;
    image_angle = 0;
    image_blend = c_white;
    image_alpha = 1;
    animation_data = new animation_core();
    visible = true;
}