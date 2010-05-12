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
package org.seasar.akabana.yui.service.rpc {

    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    import org.seasar.akabana.yui.service.Operation;
    import org.seasar.akabana.yui.service.PendingCall;

    public dynamic class RemotingService extends AbstractRpcService {

        public static var invokeCallBack:Function;

        public static var resultCallBack:Function;

        public static var faultCallBack:Function;

        private var _pendingCallMap:Dictionary;

        private var _gatewayUrl:String;

        public function get gatewayUrl():String{
            return _gatewayUrl;
        }

        public function set gatewayUrl( gatewayUrl:String):void{
            _gatewayUrl = gatewayUrl;
        }

        public function RemotingService( destination:String = null){
            super();
            _destination = destination;
            _pendingCallMap = new Dictionary();
        }

        public function deleteCallHistory(pc:PendingCall):void{
            if( pc != null ){
                _pendingCallMap[ pc ] = null;
                delete _pendingCallMap[ pc ];
            }
        }

        public override function deletePendingCallOf(responder:Object):void{
            for( var item:* in _pendingCallMap ){
                var pc:RpcPendingCall = item as RpcPendingCall;
                if( pc != null && pc.getResponder() === responder){
                    pc.clear();
                }
            }
        }

        protected override function createOperation( operationName:String ):AbstractRpcOperation{
            return new RemotingOperation( this, operationName)
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