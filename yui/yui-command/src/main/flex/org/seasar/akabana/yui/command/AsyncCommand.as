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
package org.seasar.akabana.yui.command
{
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    import org.seasar.akabana.yui.command.events.CommandEvent;
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;
    
    public class AsyncCommand extends AbstractCommand
    {
        protected var dispatchTimer:Timer;
        
        protected var _result:Object;
        
        protected var _message:Object;
        
        /**
         * 
         * 
         */
        public function AsyncCommand(){
            dispatchTimer = new Timer(1);
        }
        
        /**
         * 
         * @param value
         * 
         */
        public override function done( value:Object = null ):void{
            dispatchTimerStop();
            _result = value;
            dispatchTimerStart();
        } 
        
        /**
         * 
         * @param message
         * 
         */
        public override function failed( message:Object = null ):void{
            dispatchTimerStop();
            _message = message;
            dispatchTimerStart();
        }
        
        /**
         * 
         * 
         */
        protected function dispatchTimerStart():void{
            dispatchTimer.addEventListener(TimerEvent.TIMER,dispatchTimerHandler);
            dispatchTimer.start();
        }
        
        /**
         * 
         * 
         */
        protected function dispatchTimerStop():void{
            if( dispatchTimer.running ){
                dispatchTimer.stop();
            }
        }
        
        /**
         * 
         * @param event
         * 
         */
        protected function dispatchTimerHandler(event:TimerEvent):void{
            dispatchTimer.removeEventListener(TimerEvent.TIMER,dispatchTimerHandler);
            dispatchTimerStop();
            if( _result != null ){
                super.done(_result);
            }
            if( _message != null ){
                super.failed(_message);
            }
            _result = null;
            _message = null;
        }
        
    }
}