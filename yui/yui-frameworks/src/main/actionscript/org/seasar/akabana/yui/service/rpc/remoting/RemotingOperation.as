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
package org.seasar.akabana.yui.service.rpc.remoting {
    
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Responder;
    
    import org.seasar.akabana.yui.service.rpc.AbstractRpcOperation;
    import org.seasar.akabana.yui.service.rpc.AbstractRpcService;
    import org.seasar.akabana.yui.service.rpc.PendingCall;
    import org.seasar.akabana.yui.service.rpc.RpcResponder;
    
    public class RemotingOperation extends AbstractRpcOperation{
        
        private var remotingConnection:RemotingConnection;
        
        [Inspectable(type="Boolean",defaultValue="true")]
        public var showBusyCursor:Boolean;
                
        public function RemotingOperation( service:AbstractRpcService, name:String ){
            super( service, name );
        }

        protected override function createRpcOperation( resultHandler:Function, faultHandler:Function ):RpcResponder{
            return new RemotingResponder(resultHandler,faultHandler);
        }
        
        protected override function doInvoke( operationArgs:Array ):PendingCall{
            var serviceOperationName:String =service_.destination +"." +name_;
            
            var pendingCall:PendingCall = new PendingCall( responders_ );
            var invokeArgs:Array = createServiceInvokeArgs( serviceOperationName, operationArgs, pendingCall );
            
            var rc:RemotingConnection = lookupConnection();
            
            rc.call.apply(rc,invokeArgs);
            
            return pendingCall;
        }
    	
        protected function lookupConnection():RemotingConnection{
            if( name_ == null && name_.length <= 0){
                throw new Error("接続先サービス名が指定されていません。");
            }
            
            var remotingConnection:RemotingConnection = RemotingConnectionFactory.createConnection( name_ );
            configureListeners( remotingConnection ); 

            return remotingConnection;
        }
        
        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler);
        }

        private function netStatusHandler(event:NetStatusEvent):void {
            dispatchEvent(event);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            dispatchEvent(event);
        }
        
        private function ioErrorHandler(event:IOErrorEvent):void{
            dispatchEvent(event); 
        }

        private function createServiceInvokeArgs( serviceOperationName:String, operationArgs:Array, pendingCall:PendingCall ):Array{
            var callArgs:Array = null;
            
            if( operationArgs.length > 0 ){
                callArgs = operationArgs.concat();
            } else {
                callArgs = [];
            }

            callArgs.unshift( serviceOperationName, new Responder( pendingCall.onResult, pendingCall.onStatus ));
            
            return callArgs;
        }
    }
}