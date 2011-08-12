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
        
        private var _hasPendingResultChanged:Boolean;
        
        private var _pendingResult:Object;

        protected function get pendingResult():Object
        {
            return _pendingResult;
        }

        protected function set pendingResult(value:Object):void
        {
            _pendingResult = value;
            _hasPendingResultChanged = true;
        }
        
        private var _hasPendingStatusChanged:Boolean;
        
        private var _pendingStatus:Object;

        protected function get pendingStatus():Object
        {
            return _pendingStatus;
        }

        protected function set pendingStatus(value:Object):void
        {
            _pendingStatus = value;
            _hasPendingStatusChanged = true;
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
        public override function start( ...args ):ICommand{
            new FunctionInvoker(super.start, args ).invokeDelay(1);
            return this;
        }
        
        /**
         * 
         */
        protected override function done():void{
        }  
        
        /**
         * 
         * @param value
         * 
         */
        protected function doDoneCommand( value:Object = null ):void{
            pendingResult = value;
            doDone();
        } 

        /**
         * 
         * @param message
         * 
         */
        protected function doFailedCommand( error:Object = null ):void{
            pendingStatus = error;
            doDone();
        }
        
        /**
         * 
         * 
         */
        protected function doDone():void{
            new FunctionInvoker(finalyTask).invokeDelay(1);
        }
        
        /**
         * 
         * @param event
         * 
         */
        protected function finalyTask():void{
            if( _pendingStatus == null ){
                if( _hasPendingResultChanged ){
                    result = _pendingResult;
                }
                _pendingResult = null;
                _pendingStatus = null;
                super.done();
            } else {
                if( _hasPendingStatusChanged ){
                    status = _pendingStatus;
                }
                _pendingResult = null;
                _pendingStatus = null;
                super.failed();
            }
        }
        
    }
}