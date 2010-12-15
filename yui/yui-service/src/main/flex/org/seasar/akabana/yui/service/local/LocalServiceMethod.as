package org.seasar.akabana.yui.service.local
{
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    [ExcludeClass]
    public final class LocalServiceMethod
    {
        private var _method:Function;
        
        private var _args:Array;
        
        private var _timer:Timer;
        
        public function LocalServiceMethod(method:Function, args:Array, delay:Number)
        {
            super();
            _method = method;
            _args = args;
            _timer = new Timer(delay);
            _timer.addEventListener(TimerEvent.TIMER, timerEventHandler);
            _timer.start();
        }
        
        private function timerEventHandler(event:TimerEvent):void
        {
            _timer.stop();
            _timer.removeEventListener(TimerEvent.TIMER, timerEventHandler);
            _method.apply(null, _args);
        }
    }
}