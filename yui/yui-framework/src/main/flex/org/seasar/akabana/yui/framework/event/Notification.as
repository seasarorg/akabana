package org.seasar.akabana.yui.framework.event
{
    import flash.events.Event;

    public class Notification extends Event
    {
        public function Notification(type:String)
        {
            super(type, true, false);
        }        
    }
}