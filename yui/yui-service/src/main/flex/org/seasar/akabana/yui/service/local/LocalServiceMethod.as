/*
* Copyright 2004-2010 the Seasar Foundation and the Others.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
* either express or implied. See the License for the specific language
* governing permissions and limitations under the License.
*/
package org.seasar.akabana.yui.service.local
{
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    [ExcludeClass]
    public final class LocalServiceMethod{
		
        private var _method:Function;
        
        private var _args:Array;
        
        private var _timer:Timer;
        
        public function LocalServiceMethod(method:Function, args:Array, delay:Number=20){
            super();
            _method = method;
            _args = args;
            _timer = new Timer(delay);
            _timer.addEventListener(TimerEvent.TIMER, timerEventHandler);
            _timer.start();
        }
        
        private function timerEventHandler(event:TimerEvent):void{
            _timer.stop();
            _timer.removeEventListener(TimerEvent.TIMER, timerEventHandler);
            _method.apply(null, _args);
        }
    }
}