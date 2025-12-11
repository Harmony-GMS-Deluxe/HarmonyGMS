function __InputConfigVerbs()
{
    enum INPUT_VERB
    {
        //Add your own verbs here!
        UP,
        DOWN,
        LEFT,
        RIGHT,
        JUMP,
        BACK,
        EXTRA,
        START,
    }
    
    enum INPUT_CLUSTER
    {
        //Add your own clusters here!
        //Clusters are used for two-dimensional checkers (InputDirection() etc.)
        NAVIGATION,
    }
    
    if (not INPUT_ON_SWITCH)
    {
        InputDefineVerb(INPUT_VERB.UP,       "up",      vk_up,        [-gp_axislv, gp_padu]);
        InputDefineVerb(INPUT_VERB.DOWN,     "down",    vk_down,      [ gp_axislv, gp_padd]);
        InputDefineVerb(INPUT_VERB.LEFT,     "left",    vk_left,      [-gp_axislh, gp_padl]);
        InputDefineVerb(INPUT_VERB.RIGHT,    "right",   vk_right,     [ gp_axislh, gp_padr]);
        InputDefineVerb(INPUT_VERB.JUMP,     "jump",    "A",            gp_face1);
        InputDefineVerb(INPUT_VERB.BACK,     "back",    "S",            gp_face2);
        InputDefineVerb(INPUT_VERB.EXTRA,    "extra",   "D",            gp_face3);
        InputDefineVerb(INPUT_VERB.START,    "start",   vk_enter,       gp_start);
    }
    else //Flip A/B over on Switch
    {
        InputDefineVerb(INPUT_VERB.UP,       "up",      undefined, [-gp_axislv, gp_padu]);
        InputDefineVerb(INPUT_VERB.DOWN,     "down",    undefined, [ gp_axislv, gp_padd]);
        InputDefineVerb(INPUT_VERB.LEFT,     "left",    undefined, [-gp_axislh, gp_padl]);
        InputDefineVerb(INPUT_VERB.RIGHT,    "right",   undefined, [ gp_axislh, gp_padr]);
        InputDefineVerb(INPUT_VERB.JUMP,     "jump",    undefined,   gp_face2); // !!
        InputDefineVerb(INPUT_VERB.BACK,     "back",    undefined,   gp_face1); // !!
        InputDefineVerb(INPUT_VERB.EXTRA,    "extra",   undefined,   gp_face3);
        InputDefineVerb(INPUT_VERB.START,    "start",   undefined,   gp_start);
    }
    
    //Define a cluster of verbs for moving around
    InputDefineCluster(INPUT_CLUSTER.NAVIGATION, INPUT_VERB.UP, INPUT_VERB.RIGHT, INPUT_VERB.DOWN, INPUT_VERB.LEFT);
}
