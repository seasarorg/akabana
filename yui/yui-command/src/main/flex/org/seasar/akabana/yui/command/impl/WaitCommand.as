/*
 * Copyright 2004-2009 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.command.impl
{
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    import org.seasar.akabana.yui.command.Command;
    
    public class WaitCommand extends AbstractCommand
    {
        protected var timer:Timer;
        
        protected var sleep:int;
        
        public function WaitCommand(sleep:int=0)
        {
            super();
            this.sleep = sleep;
        }
        
        public override function start(...args):Command
        {
            timer = createTimer();
            timer.start();
            return this;
        }
        
        protected function createTimer():Timer{
            var result:Timer = new Timer(sleep);
            result.addEventListener(TimerEvent.TIMER,timerHandler,false,int.MAX_VALUE,false);
            return result;
        }
        
        protected function timerHandler( event:TimerEvent ):void{
            if( timer.running ){
                timer.stop();
            }
            dispatchCompleteEvent(this,null);
        }
    }
}