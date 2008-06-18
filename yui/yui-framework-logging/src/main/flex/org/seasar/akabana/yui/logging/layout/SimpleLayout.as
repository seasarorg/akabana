package org.seasar.akabana.yui.logging.layout
{
    import org.seasar.akabana.yui.logging.LoggingEvent;

    public class SimpleLayout extends LayoutBase
    {

        public override function format( event:LoggingEvent ):String{
            
            return event.level.name + " - " + event.message;
        }
    }
}