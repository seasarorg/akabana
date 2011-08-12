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
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;
    import org.seasar.akabana.yui.core.reflection.FunctionInvoker;
    
    public final class WaitCommand extends AsyncCommand {
        
        protected var _invoker:FunctionInvoker;
        
        protected var _sleep:int;

        public function get sleep():int{
            return _sleep;
        }

        public function set sleep(value:int):void{
            _sleep = value;
        }
        
        public function WaitCommand(sleep:int=0){
            super();
            this._sleep = sleep;
        }
        
        protected override function run():void{
            if( _invoker != null && _invoker.isStarted ){
                return;
            }
            _invoker = new FunctionInvoker(doSleepEnd).invokeDelay(_sleep);
        }
        
        protected function doSleepEnd():void{
            _invoker = null;
            doDone();
        }
    }
}