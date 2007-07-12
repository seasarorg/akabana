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
    
    import org.seasar.akabana.yui.service.Operation;
    import org.seasar.akabana.yui.service.rpc.AbstractRpcOperation;
    import org.seasar.akabana.yui.service.rpc.AbstractRpcService;
    import org.seasar.akabana.yui.service.rpc.PendingCall;
    
    public dynamic class RemotingService extends AbstractRpcService {
         
        private var gatewayUrl_:String;

        public function RemotingService( destination:String = null){
            super();
            destination_ = destination;
        }
        
        public function get gatewayUrl():String{
            return gatewayUrl_;
        }
        
        public function set gatewayUrl( gatewayUrl:String):void{
            gatewayUrl_ = gatewayUrl;
        }

        protected override function createOperation( operationName:String ):AbstractRpcOperation{
            return new RemotingOperation( this, operationName)
        }
        
    	protected override function invokeOperation( operationName:String, operationArgs:Array ):PendingCall{
			var operation:Operation;
			
			if( hasOperation( operationName )){
                operation = getOperation( operationName );
			} else {
			    throw new Error("オペレーション(" + operationName + ")が、見つかりません。");
            }
            return operation.invoke( operationArgs );
    	}
    }
}