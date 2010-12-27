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
package org.seasar.akabana.yui.service.ds.local
{
    import mx.core.mx_internal;
    import mx.rpc.AbstractOperation;
    import mx.rpc.AbstractService;
    import mx.rpc.AsyncDispatcher;
    import mx.rpc.AsyncToken;
    import mx.rpc.Fault;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import org.seasar.akabana.yui.service.ServiceGatewayUrlResolver;
    import org.seasar.akabana.yui.service.local.LocalServiceInvoker;
    import org.seasar.akabana.yui.service.local.LocalServiceMethod;
    import org.seasar.akabana.yui.util.StringUtil;
    
    use namespace mx_internal;
    
    [ExcludeClass]
    public final class LocalOperation extends AbstractOperation {
        
        protected var serviceInvoker:LocalServiceInvoker;
        
        public function LocalOperation(service:AbstractService=null, name:String=null){
            super(service, name);
            serviceInvoker = new LocalServiceInvoker();
        }
        
        public override function send(... args:Array):AsyncToken {   
            const lpackage:String = ServiceGatewayUrlResolver.getLocalPackage(service.endpoint);
            const lservice:String = StringUtil.toUpperCamel(service.destination);
            
            const message:LocalMessage = new LocalMessage();
            message.operation = name;
            message.body = args;
            message.service = lservice;
            
            const token:AsyncToken = new AsyncToken(message);
            try{
                const value:Object = serviceInvoker.invoke.apply(null,[lpackage,lservice,name].concat(args));
                const resultEvent:ResultEvent = ResultEvent.createEvent(value, token, message);
                new LocalServiceMethod(dispatchRpcEvent, [resultEvent]);
            } catch( e:Error ){
                var fault:Fault = new Fault(e.errorID.toString(),e.name,e.message);
                var faultEvent:FaultEvent = FaultEvent.createEvent(fault, token,message);
                new LocalServiceMethod(dispatchRpcEvent, [faultEvent]);
            }
            
            return token;
        }
    }
}