package org.seasar.akabana.yui.framework.event
{
    import flash.events.Event;
    

    public class FrameworkEvent extends Event
    {
        public static const ASSEMBLED:String = "assembled";
        
        public static const APPLICATION_START:String = "applicationStart";
        
        public function FrameworkEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}