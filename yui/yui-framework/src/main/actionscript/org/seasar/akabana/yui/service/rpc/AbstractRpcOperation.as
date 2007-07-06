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
    import org.seasar.akabana.yui.service.rpc.event.RpcInvokeEvent;
    
    public class AbstractRpcOperation extends EventDispatcher implements Operation{
        
        protected var name_:String;
        
        protected var service_:AbstractRpcService;
        
        protected var responders_:Array;
        
        public function AbstractRpcOperation( service:AbstractRpcService, name:String ){
            super();
            service_ = service;
            name_ = name;
            responders_ = [];
        }
        
        public function get responders():Array{
            return responders_;
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
            
            this.dispatchEvent( new RpcInvokeEvent(pendingCall));
            
            return pendingCall;
        }
        
        public function addResponder( responder:RpcResponder ):void{
            responders_.push(responder);
        }
        
        public function addResponseHandler( resultHandler:Function, faultHandler:Function ):void{
            responders_.push( createRpcOperation( resultHandler, faultHandler) );
        }
        
        protected function doInvoke( operationArgs:Array ):PendingCall{
            return null;
        }
        
        protected function createRpcOperation( resultHandler:Function, faultHandler:Function ):RpcResponder{
            return null;
        }
    }
}