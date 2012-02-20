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
package net.akb7.yui.rpc.local
{
    import flash.events.Event;
    
    import net.akb7.yui.service.IPendingCall;
    import net.akb7.yui.service.ServiceGatewayUrlResolver;
    import net.akb7.yui.service.event.FaultEvent;
    import net.akb7.yui.service.event.FaultStatus;
    import net.akb7.yui.service.event.ResultEvent;
    import net.akb7.yui.service.local.LocalServiceInvoker;
    import net.akb7.yui.core.reflection.FunctionInvoker;
    import net.akb7.yui.rpc.AbstractRpcOperation;
    import net.akb7.yui.rpc.AbstractRpcService;
    import net.akb7.yui.rpc.RpcPendingCall;
    import net.akb7.yui.util.StringUtil;
    
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