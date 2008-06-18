/*
 * Copyright 2004-2007 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.service.rpc {
    
    import flash.events.EventDispatcher;
    
    import org.seasar.akabana.yui.service.Operation;
    import org.seasar.akabana.yui.service.PendingCall;
    import org.seasar.akabana.yui.service.event.InvokeEvent;
    
    public class AbstractRpcOperation extends EventDispatcher implements Operation{
        
        protected var name_:String;
        
        protected var service_:AbstractRpcService;
        
        public function AbstractRpcOperation( service:AbstractRpcService, name:String ){
            super();
            service_ = service;
            name_ = name;
        }
        
        public function get service():AbstractRpcService{
            return service_;
        }
        
        public function get name():String{
            return name_;
        }
        
        public function invoke( args:Array ):PendingCall{
            if( name_ == null || name_.length <= 0 ){
                throw new Error("オペレーション名が指定されていません。");
            }
            
            var pendingCall:PendingCall = doInvoke( args );
            
            dispatchInvokeEvent( pendingCall );
            
            return pendingCall;
        }
        
        protected function doInvoke( operationArgs:Array ):PendingCall{
            return null;
        }
        
        protected function createRpcOperation( resultHandler:Function, faultHandler:Function ):RpcResponder{
            return null;
        }
        
        protected function dispatchInvokeEvent( pendingCall:PendingCall ):void{
            var event:InvokeEvent = new InvokeEvent();
            event.pendigCall = pendingCall;
            event.service = service_;
            event.operation = this;
            service_.dispatchEvent( event );
        }
    }
}