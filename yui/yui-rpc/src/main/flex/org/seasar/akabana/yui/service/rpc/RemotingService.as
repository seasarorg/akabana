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

    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    import org.seasar.akabana.yui.service.Operation;
    import org.seasar.akabana.yui.service.PendingCall;
    
    import org.seasar.akabana.yui.service.OperationCallBack;
    import org.seasar.akabana.yui.service.PendingCall;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceGatewayUrlResolver;
    import org.seasar.akabana.yui.service.ServiceManager;
    import org.seasar.akabana.yui.service.rpc.local.LocalOperation;
    import org.seasar.akabana.yui.util.URLUtil;
    
    public dynamic class RemotingService extends AbstractRpcService {

        private var _pendingCallMap:Dictionary;

        public function RemotingService( destination:String = null){
            super();
            _destination = destination;
            _pendingCallMap = new Dictionary();
            _gatewayUrl = ServiceGatewayUrlResolver.resolve(destination);
        }
        
        public override function finalizeResponder(responder:Object):void{
            for( var item:* in _pendingCallMap ){
                var pc:RpcPendingCall = item as RpcPendingCall;
                if( pc != null && pc.getResponder() === responder){
                    pc.clear();
                }
            }
        }

        public override function finalizePendingCall(pc:PendingCall):void{
            if( pc != null ){
                _pendingCallMap[ pc ] = null;
                delete _pendingCallMap[ pc ];
            }
        }

        protected override function createOperation( operationName:String ):AbstractRpcOperation{
            if( ServiceGatewayUrlResolver.isLocalUrl(gatewayUrl) ){
                return new LocalOperation( this, operationName);
            } else {
                return new RemotingOperation( this, operationName)
            }
        }

        protected override function invokeOperation( operationName:String, operationArgs:Array ):PendingCall{
            var operation:Operation;
            if( !hasOperation( operationName )){
                addOperation(operationName);
            }
            operation = getOperation( operationName );
            if( operation is RemotingOperation ){
                RemotingOperation(operation).credentialsUsername = _credentialsUsername;
                RemotingOperation(operation).credentialsPassword = _credentialsPassword;
            }

            var result:PendingCall = operation.invoke( operationArgs );
            if( result != null ){
                _pendingCallMap[ result ] = getTimer();
            }
            return result;
        }
    }
}