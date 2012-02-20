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
package org.seasar.akabana.yui.service.rpc.local
{
    import flash.events.Event;
    
    import org.seasar.akabana.yui.service.IPendingCall;
    import org.seasar.akabana.yui.service.ServiceGatewayUrlResolver;
    import org.seasar.akabana.yui.service.event.FaultEvent;
    import org.seasar.akabana.yui.service.event.FaultStatus;
    import org.seasar.akabana.yui.service.event.ResultEvent;
    import org.seasar.akabana.yui.service.local.LocalServiceInvoker;
    import org.seasar.akabana.yui.core.reflection.FunctionInvoker;
    import org.seasar.akabana.yui.service.rpc.AbstractRpcOperation;
    import org.seasar.akabana.yui.service.rpc.AbstractRpcService;
    import org.seasar.akabana.yui.service.rpc.RpcPendingCall;
    import org.seasar.akabana.yui.util.StringUtil;
    
    [ExcludeClass]
    public final class LocalOperation extends AbstractRpcOperation {
        
        protected var serviceInvoker:LocalServiceInvoker;
        
        public function LocalOperation( service:AbstractRpcService, name:String ){
            super(service, name);
            serviceInvoker = new LocalServiceInvoker();
        }
        
        protected override function doInvoke( operationArgs:Array ):IPendingCall{
            const lpackage:String = ServiceGatewayUrlResolver.getLocalPackage(service.gatewayUrl);
            var pendingCall:IPendingCall = new RpcPendingCall(this);
            
            try{
                const value:Object = serviceInvoker.invoke.apply(null,[lpackage,service.name,name].concat(operationArgs));
                new FunctionInvoker(resultCallBack,[value,pendingCall]).invokeDelay();
                
            } catch( e:Error ){
                new FunctionInvoker(faultCallBack,[e,pendingCall]).invokeDelay();
            }
            
            return pendingCall;
        }

        private function resultCallBack(value:Object,pendingCall:RpcPendingCall):void{
            pendingCall.onResult(value);
        }
        
        private function faultCallBack(status:Error,pendingCall:RpcPendingCall):void{
            pendingCall.onStatus(status);
        }
    }
}