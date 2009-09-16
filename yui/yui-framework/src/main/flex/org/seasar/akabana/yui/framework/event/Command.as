package org.seasar.akabana.yui.framework.event
{
    import flash.events.Event;

    public class Command extends Event
    {
        public function Command(type:String)
        {
            super(type, false, true);
        }        
    }
}