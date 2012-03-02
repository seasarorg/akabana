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
package jp.akb7.yui.ds.responder {

    import mx.rpc.Fault;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import jp.akb7.yui.service.event.FaultEvent;
    import jp.akb7.yui.service.event.FaultStatus;
    import jp.akb7.yui.service.event.ResultEvent;

    [ExcludeClass]
    public final class RpcEventResponder extends AbstractRpcEventResponder {

        public function RpcEventResponder( resultFunction:Function, faultFunction:Function){
            this.resultFunction = resultFunction;
            this.faultFunction = faultFunction;
        }

        public override function result(data:Object):void
        {
            var result:Object = (data as mx.rpc.events.ResultEvent).result;
            var newEvent:jp.akb7.yui.service.event.ResultEvent = new jp.akb7.yui.service.event.ResultEvent(result);
            resultFunction.call( null, newEvent );
            resultFunction = null;
            faultFunction = null;
        }

        public override function fault(info:Object):void
        {
            if( faultFunction != null ){
                var fault:Fault = (info as mx.rpc.events.FaultEvent).fault;
                var faultStatus:FaultStatus = new FaultStatus( fault.faultCode, fault.faultString, fault.faultDetail );
                var newEvent:jp.akb7.yui.service.event.FaultEvent = new jp.akb7.yui.service.event.FaultEvent(faultStatus);
                faultFunction.call( null, newEvent);
            }
            resultFunction = null;
            faultFunction = null;
        }
    }
}