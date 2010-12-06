/*
* Copyright 2004-2010 the Seasar Foundation and the Others.
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
    
    import org.seasar.akabana.yui.service.PendingCall;
    import org.seasar.akabana.yui.service.ServiceGatewayUrlResolver;
    import org.seasar.akabana.yui.service.event.FaultEvent;
    import org.seasar.akabana.yui.service.event.FaultStatus;
    import org.seasar.akabana.yui.service.event.ResultEvent;
    import org.seasar.akabana.yui.service.local.LocalServiceInvoker;
    import org.seasar.akabana.yui.service.local.LocalServiceMethod;
    import org.seasar.akabana.yui.service.rpc.AbstractRpcOperation;
    import org.seasar.akabana.yui.service.rpc.AbstractRpcService;
    import org.seasar.akabana.yui.service.rpc.RpcPendingCall;
    import org.seasar.akabana.yui.util.StringUtil;
    
    [ExcludeClass]
    public class LocalOperation extends AbstractRpcOperation {
        
        protected var serviceInvoker:LocalServiceInvoker;
        
        public function LocalOperation( service:AbstractRpcService, name:String ){
            super(service, name);
            serviceInvoker = new LocalServiceInvoker();
        }
        
        protected override function doInvoke( operationArgs:Array ):PendingCall{
            const lpackage:String = ServiceGatewayUrlResolver.getLocalPackage(service.gatewayUrl);
            const lservice:String = StringUtil.toUpperCamel(service.destination);
            const serviceClassName:String = 
                    lpackage+
                    StringUtil.DOT+
                    LocalServiceInvoker.SERVICE+
                    StringUtil.DOT+
                    lservice;
            
            var serviceOperationName:String = _service.destination + StringUtil.DOT +_name;
            
            var pendingCall:PendingCall = new RpcPendingCall(this);
            var invokeArgs:Array = createServiceInvokeArgs( serviceOperationName, operationArgs, pendingCall );
            
            try{
                const value:Object = serviceInvoker.invoke.apply(null,[serviceClassName,name].concat(operationArgs));
                new LocalServiceMethod(resultCallBack,[value,pendingCall],10);
                
            } catch( e:Error ){
                new LocalServiceMethod(faultCallBack,[e,pendingCall],10);
            }
            
            return pendingCall;
        }

        protected function resultCallBack(value:Object,pendingCall:RpcPendingCall):void{
            pendingCall.onResult(value);
        }
        protected function faultCallBack(status:Error,pendingCall:RpcPendingCall):void{
            pendingCall.onStatus(status);
        }
    }
}