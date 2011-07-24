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
package org.seasar.akabana.yui.service.rpc {

    import flash.errors.IllegalOperationError;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Responder;
    
    import org.seasar.akabana.yui.service.OperationCallBack;
    import org.seasar.akabana.yui.service.PendingCall;
    import org.seasar.akabana.yui.service.event.FaultEvent;
    import org.seasar.akabana.yui.service.event.FaultStatus;
    import org.seasar.akabana.yui.service.rpc.AbstractRpcOperation;
    import org.seasar.akabana.yui.service.rpc.AbstractRpcService;
    import org.seasar.akabana.yui.service.rpc.RpcPendingCall;
    import org.seasar.akabana.yui.util.StringUtil;

    [ExcludeClass]
    public final class RemotingOperation extends AbstractRpcOperation {

        public static const CREDENTIALS_PASSWORD:String = "credentialsPassword";

        public static const CREDENTIALS_USERNAME:String = "credentialsUsername";

        private var remotingConnection:RemotingConnection;

        [Inspectable(type="Boolean",defaultValue="true")]
        public var showBusyCursor:Boolean;

        public function get remotingService():RemotingService{
            return _service as RemotingService;
        }

        internal var credentialsUsername:String;

        internal var credentialsPassword:String;

        public function RemotingOperation( service:AbstractRpcService, name:String ){
            super( service, name );
        }

        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(NetStatusEvent.NET_STATUS, errorEventHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorEventHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR , errorEventHandler);
        }

        private function errorEventHandler(event:Event):void {
            var faultStatus:FaultStatus = null;
            if( event is NetStatusEvent ){
                var netStatusEvent:NetStatusEvent = event as NetStatusEvent;
                faultStatus = new FaultStatus(
                    netStatusEvent.type,
                    netStatusEvent.info["code"]+":"+netStatusEvent.info["level"],
                    netStatusEvent.toString()
                );
            }
            if( event is SecurityErrorEvent ){
                var securityErrorEvent:SecurityErrorEvent = event as SecurityErrorEvent;
                faultStatus = new FaultStatus(
                    securityErrorEvent.type,
                    "",
                    securityErrorEvent.toString()
                    );
            }
            if( event is IOErrorEvent ){
                var ioErrorEvent:IOErrorEvent = event as IOErrorEvent;
                faultStatus = new FaultStatus(
                    ioErrorEvent.type,
                    ioErrorEvent.text,
                    ioErrorEvent.toString()
                    );
            }
            if( event is ErrorEvent ){
                var errorEvent:ErrorEvent = event as ErrorEvent;
                faultStatus = new FaultStatus(
                    errorEvent.type,
                    errorEvent.text,
                    errorEvent.toString()
                );
            }
            var faultEvent:FaultEvent = new FaultEvent(faultStatus);
            _service.dispatchEvent(faultEvent);
        }

        private function setupCredentials(rc:RemotingConnection):void {
            if( credentialsUsername != null ){
                rc.addHeader(
                    CREDENTIALS_USERNAME,
                    false,
                    credentialsUsername
                );
                rc.addHeader(
                    CREDENTIALS_PASSWORD,
                    false,
                    credentialsPassword
                );
                credentialsUsername = null;
                credentialsPassword = null;
            }
        }

        protected override function doInvoke( operationArgs:Array ):PendingCall{
            const rc:RemotingConnection = lookupConnection();
            const pendingCall:PendingCall = new RpcPendingCall(this);

            const serviceOperationName:String = getServiceOperationName();
            const invokeArgs:Array = createServiceInvokeArgs( serviceOperationName, operationArgs, pendingCall );

            setupCredentials(rc);
            rc.call.apply(rc,invokeArgs);

            if( OperationCallBack.invokeCallBack != null ){
                OperationCallBack.invokeCallBack.apply(null,[serviceOperationName,operationArgs]);
            }

            return pendingCall;
        }

        protected function lookupConnection():RemotingConnection{
            if( _name == null && _name.length <= 0){
                throw new IllegalOperationError(_name);
            }

            if( remotingConnection == null ){
                remotingConnection = RemotingConnectionFactory.createConnection( remotingService.gatewayUrl, _service.name );
                configureListeners( remotingConnection );
            }

            return remotingConnection;
        }
    }
}