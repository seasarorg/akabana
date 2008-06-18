package org.seasar.akabana.yui.logging.layout
{
    import org.seasar.akabana.yui.logging.Layout;
    import org.seasar.akabana.yui.logging.LoggingEvent;

    public class LayoutBase implements Layout
    {
        private static const EMPTY_STRING:String = "";
        
        protected var _header:String;
        
        public function get header():String{
            return _header;
        }
        
        public function set header( value:String ):void{
            _header = value;
        }

        protected var _footer:String;
        
        public function get footer():String{
            return _footer;
        }
        
        public function set footer( value:String ):void{
            _footer = value;
        }

        public function format( event:LoggingEvent ):String{
            return EMPTY_STRING;
        }
    }
}