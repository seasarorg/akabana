/*
 * Copyright 2004-2008 the Seasar Foundation and the Others.
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
    
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Responder;
    
    import org.seasar.akabana.yui.service.PendingCall;
    import org.seasar.akabana.yui.service.event.FaultEvent;
    import org.seasar.akabana.yui.service.event.FaultStatus;
    import org.seasar.akabana.yui.service.rpc.AbstractRpcOperation;
    import org.seasar.akabana.yui.service.rpc.AbstractRpcService;
    import org.seasar.akabana.yui.service.rpc.RpcPendingCall;
    import org.seasar.akabana.yui.service.rpc.RpcResponder;
    
    public class RemotingOperation extends AbstractRpcOperation{
        
        private var remotingConnection:RemotingConnection;
        
        [Inspectable(type="Boolean",defaultValue="true")]
        public var showBusyCursor:Boolean;
        
        public function get remotingService():RemotingService{
            return service_ as RemotingService;
        }
        
                
        public function RemotingOperation( service:AbstractRpcService, name:String ){
            super( service, name );
        }
        
        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(NetStatusEvent.NET_STATUS, errorEventHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorEventHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR , errorEventHandler);
        }

        private function errorEventHandler(event:Event):void {
            var faultEvent:FaultEvent = new FaultEvent();
            if( event is NetStatusEvent ){
                var netStatusEvent:NetStatusEvent = event as NetStatusEvent;
                faultEvent.faultStatus = new FaultStatus(
                    netStatusEvent.type,
                    netStatusEvent.info["code"]+":"+netStatusEvent.info["level"],
                    netStatusEvent.toString()
                ); 
            }
            if( event is SecurityErrorEvent ){
                var securityErrorEvent:SecurityErrorEvent = event as SecurityErrorEvent;
                faultEvent.faultStatus = new FaultStatus(
                    securityErrorEvent.type,
                    "",
                    securityErrorEvent.toString()
                    ); 
            }
            if( event is IOErrorEvent ){
                var ioErrorEvent:IOErrorEvent = event as IOErrorEvent;
                faultEvent.faultStatus = new FaultStatus(
                    ioErrorEvent.type,
                    ioErrorEvent.text,
                    ioErrorEvent.toString()
                    ); 
            }                        
            service_.dispatchEvent(faultEvent);
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

        protected override function createRpcOperation( resultHandler:Function, faultHandler:Function ):RpcResponder{
            return new RpcResponder(resultHandler,faultHandler);
        }
        
        protected override function doInvoke( operationArgs:Array ):PendingCall{
            var serviceOperationName:String =service_.destination +"." +name_;
            
            var pendingCall:PendingCall = new RpcPendingCall();
            var invokeArgs:Array = createServiceInvokeArgs( serviceOperationName, operationArgs, pendingCall );
            
            var rc:RemotingConnection = lookupConnection();
            
            rc.call.apply(rc,invokeArgs);
            
            return pendingCall;
        }
        
        protected function lookupConnection():RemotingConnection{
            if( name_ == null && name_.length <= 0){
                throw new Error("接続先サービス名が指定されていません。");
            }
            
            if( remotingConnection == null ){
                remotingConnection = RemotingConnectionFactory.createConnection( remotingService.gatewayUrl, name_ );
                configureListeners( remotingConnection ); 
            }
            
            return remotingConnection;
        }
    }
}