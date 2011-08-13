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
package org.seasar.akabana.yui.command.core.impl
{
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.core.reflection.FunctionInvoker;
    
    public class AbstractAsyncCommand extends AbstractSubCommand {
        
        private var _hasPendingResult:Boolean;

        protected function get hasPendingResult():Boolean
        {
            return _hasPendingResult;
        }
        
        private var _pendingResult:Object;

        protected final function get pendingResult():Object
        {
            return _pendingResult;
        }

        protected final function set pendingResult(value:Object):void
        {
            _pendingResult = value;
            _hasPendingResult = true;
        }
        
        private var _hasPendingStatus:Boolean;

        protected function get hasPendingStatus():Boolean
        {
            return _hasPendingStatus;
        }
        
        private var _pendingStatus:Object;

        protected final function get pendingStatus():Object
        {
            return _pendingStatus;
        }

        protected final function set pendingStatus(value:Object):void
        {
            _pendingStatus = value;
            _hasPendingStatus = true;
        }

        /**
         * 
         * 
         */
        public function AbstractAsyncCommand(){
        }
        
        /**
         * 
         * @param args
         * 
         */
        public override function clear():void{
            super.clear();
            _completeEventListener.clear();
            _errorEventListener.clear();
            _pendingResult = null;
            _pendingStatus = null;
            _hasPendingResult = false;
            _hasPendingStatus = false;
        }

        /**
         * 
         */
        protected final override function done():void{
        }  
        
        /**
         * 
         */
        protected final override function run():void{
            runAsync();
        }
        
        /**
         * 
         */
        protected function runAsync():void{
        }
        
        /**
         * 
         * @param value
         * 
         */
        protected final function returnAsync( value:Object = null ):void{
            pendingResult = value;
            doneAsync();
        } 
        
        /**
         * 
         * 
         */
        protected final function doneAsync():void{
            new FunctionInvoker(stopAsync).invokeDelay(1);
        }
        
        /**
         * 
         * @param message
         * 
         */
        protected final function errorAsync( error:Object = null ):void{
            pendingStatus = error;
            doneAsync();
        }
        
        /**
         * 
         * @param event
         * 
         */
        private function stopAsync():void{
            if( hasPendingStatus ){
                status = _pendingStatus;

                _pendingResult = null;
                _pendingStatus = null;
                _hasPendingResult = false;
                _hasPendingStatus = false;
                
                super.error();
            } else { 
                if( hasPendingResult ){
                    result = _pendingResult;
                }
                
                _pendingResult = null;
                _pendingStatus = null;
                _hasPendingResult = false;
                _hasPendingStatus = false;
                
                super.done();
            }
        }
        
    }
}