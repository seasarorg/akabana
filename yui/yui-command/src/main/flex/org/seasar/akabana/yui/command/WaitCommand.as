/*
 * Copyright 2004-2011 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.command
{
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;
    
    public final class WaitCommand extends AsyncCommand {
        
        protected var _timer:Timer;
        
        protected var _sleep:int;
        
        public function WaitCommand(sleep:int=0){
            super();
            this._sleep = sleep;
        }
        
        protected override function run():void{
            _timer = createTimer();
            _timer.start();
        }
        
        protected function createTimer():Timer{
            var result:Timer = new Timer(_sleep);
            result.addEventListener(TimerEvent.TIMER,timerHandler,false,int.MAX_VALUE,false);
            return result;
        }
        
        protected function timerHandler( event:TimerEvent ):void{
            if( _timer != null ){
                _timer.stop();
                _timer.removeEventListener(TimerEvent.TIMER,timerHandler,false);
                _timer = null;
            }
            done();
        }
    }
}