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
package net.akb7.yui.rpc {

    import flash.events.EventDispatcher;
    import flash.net.Responder;
    
    import net.akb7.yui.service.IOperation;
    import net.akb7.yui.service.IPendingCall;
    import net.akb7.yui.service.error.IllegalOperationError;
    import net.akb7.yui.service.event.InvokeEvent;
    import net.akb7.yui.util.StringUtil;

    [ExcludeClass]
    public class AbstractRpcOperation extends EventDispatcher implements IOperation {

        protected var _name:String;

        protected var _service:AbstractRpcService;

        public function AbstractRpcOperation( service:AbstractRpcService, name:String ){
            super();
            _service = service;
            _name = name;
        }

        public function get service():AbstractRpcService{
            return _service;
        }

        public function get name():String{
            return _name;
        }

        public function get serviceName():String{
            return _service.name;
        }

        public function invoke( args:Array ):IPendingCall{
            if( _name == null || _name.length <= 0 ){
                throw new IllegalOperationError(_name);
            }

            var pendingCall:IPendingCall = doInvoke( args );

            dispatchInvokeEvent( pendingCall );

            return pendingCall;
        }
        
        protected function doInvoke( operationArgs:Array ):IPendingCall{
            return null;
        }

        protected function dispatchInvokeEvent( pendingCall:IPendingCall ):void{
            var event:InvokeEvent = new InvokeEvent();
            event.pendigCall = pendingCall;
            event.service = _service;
            event.operation = this;
            _service.dispatchEvent( event );
        }
        
        protected function createServiceInvokeArgs( serviceOperationName:String, operationArgs:Array, pendingCall:IPendingCall ):Array{
            var callArgs:Array = null;
            
            if( operationArgs.length > 0 ){
                callArgs = operationArgs.concat();
            } else {
                callArgs = [];
            }
            
            var rpcPendingCall:RpcPendingCall = pendingCall as RpcPendingCall;
            callArgs.unshift( serviceOperationName, new Responder( rpcPendingCall.onResult, rpcPendingCall.onStatus ));
            
            return callArgs;
        }
        
        protected function getServiceOperationName():String{
            const result:String = _service.destination + StringUtil.DOT +_name;
            return result;
        }
    }
}