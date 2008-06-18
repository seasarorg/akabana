package org.seasar.akabana.yui.logging.appender
{
    import org.seasar.akabana.yui.logging.Appender;
    import org.seasar.akabana.yui.logging.Layout;
    import org.seasar.akabana.yui.logging.LoggingEvent;

    public class AppenderBase implements Appender
    {
        
        protected var _name:String;
        
        public function get name():String
        {
            return _name;
        }
        
        public function set name(value:String):void
        {
            _name = value;
        }
        
        protected var _layout:Layout;
        
        public function get layout():Layout
        {
            return _layout;
        }
        
        public function set layout(value:Layout):void
        {
            _layout = value;
        }
        
        public function AppenderBase()
        {
            super();
        }
        
        public function close():void
        {
            
        }
        
        public function append(event:LoggingEvent):void
        {
        }
    }
}