package org.seasar.akabana.yui.command.core.impl
{
    import flash.utils.Dictionary;

    internal class EventListener
    {
        protected var _handler:Function;
        
        public function get handler():Function{
            return _handler;
        }        
        
        public function set handler( value:Function ):void{
            _handler = value;
        }
        
        public function EventListener(){
        }
        
        public function clear():void{
            _handler = null;
        }

    }
}