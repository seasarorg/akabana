package org.seasar.akabana.yui.logging.appender
{
    import org.seasar.akabana.yui.logging.Layout;
    import org.seasar.akabana.yui.logging.LoggingEvent;

    public class SimpleAppender extends AppenderBase
    {
        public override function append(event:LoggingEvent):void
        {
            trace( _layout.format(event));
        }
    }
}