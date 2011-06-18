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
package org.seasar.akabana.yui.service.ds {
    import mx.core.mx_internal;
    import mx.messaging.messages.IMessage;
    import mx.rpc.AbstractOperation;
    import mx.rpc.AsyncToken;
    import mx.rpc.IResponder;
    import mx.rpc.Responder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.ParameterRef;
    import org.seasar.akabana.yui.service.ManagedService;
    import org.seasar.akabana.yui.service.OperationCallBack;
    import org.seasar.akabana.yui.service.PendingCall;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ds.responder.RpcDefaultEventResponder;
    import org.seasar.akabana.yui.service.ds.responder.RpcEventResponder;
    import org.seasar.akabana.yui.service.ds.responder.RpcNoneResponder;
    import org.seasar.akabana.yui.service.ds.responder.RpcObjectResponder;
    import org.seasar.akabana.yui.service.ds.responder.RpcResponderFactory;
    import org.seasar.akabana.yui.service.resonder.Responder;
    import org.seasar.akabana.yui.service.resonder.ResponderFactory;

    use namespace mx_internal;

    [ExcludeClass]
    public final class DsPendingCall extends AsyncToken implements PendingCall {

        private static const RESULT_HANDLER:String = "ResultHandler";

        private static const FAULT_HANDLER:String = "FaultHandler";

        private static const _responderFactory:ResponderFactory = new RpcResponderFactory();

        private static function createResponder( destination:String,operationName:String, responder:Object ):IResponder{
            const classRef:ClassRef = getClassRef(responder);
            const resultFuncDef:FunctionRef = _responderFactory.findResultFunctionRef( classRef, destination, operationName );
            const faultFuncDef:FunctionRef = _responderFactory.findFaultFunctionRef( classRef, destination, operationName );

            var result:IResponder = null;
            var responderClass:Class;
            if( resultFuncDef.parameters.length <= 0 ){
                responderClass = RpcNoneResponder;
            } else {
                var parameter:ParameterRef = resultFuncDef.parameters[0] as ParameterRef;
                if( parameter.isEvent ){
                    responderClass = RpcDefaultEventResponder;
                } else {
                    responderClass = RpcObjectResponder;
                }
            }
            if( faultFuncDef == null){
                result = new responderClass(resultFuncDef.getFunction(responder),null);
            } else {
                result = new responderClass(resultFuncDef.getFunction(responder),faultFuncDef.getFunction(responder));
            }
            return result;
        }

        protected var _internalAsyncToken:AsyncToken;

        protected var _responder:IResponder;

        private var _responderOwner:Object;

        private var _operation:AbstractOperation;

        public function DsPendingCall(message:IMessage=null)
        {
            super(message);
        }

        public function clear():void{
            _responder = null;
        }

        public function setInternalAsyncToken( asyncToken:AsyncToken, operation:AbstractOperation ):void{
            _internalAsyncToken = asyncToken;
            _internalAsyncToken.addResponder( new mx.rpc.Responder(onResult,onStatus));
            _operation = operation;
        }

        public function setResponder( responder:Object ):void{
            if( responder is IResponder ){
                _responderOwner = null;
                _responder = responder as IResponder;
            } else if( responder is org.seasar.akabana.yui.service.resonder.Responder ){
                _responderOwner = null;
                _responder = new RpcEventResponder(responder.onResult,responder.onFault);
            } else {
                _responderOwner = responder;
                var service:Service = _operation.service as Service;
                _responder = createResponder( service.name, _operation.name, responder );
            }
        }

        public function getResponder():Object{
            if( _responderOwner == null ){
                return _responder;
            } else {
                return _responderOwner;
            }
        }

        public function get service():Service{
            return _operation.service as Service;
        }

        public function onResult( resultEvent:ResultEvent ):void{
            if( service is ManagedService ){
                ( service as ManagedService ).finalizePendingCall(this);
            }

            if( OperationCallBack.resultCallBack != null ){
                OperationCallBack.resultCallBack.apply(null,[resultEvent]);
            }

            if( _responder != null ){
                _responder.result( resultEvent );
            }

            _responder = null;
            _responderOwner = null;
            _operation = null;
            _internalAsyncToken = null;
        }

        public function onStatus( faultEvent:FaultEvent ):void{
            if( service is ManagedService ){
                ( service as ManagedService ).finalizePendingCall(this);
            }
            
            if( OperationCallBack.faultCallBack != null ){
                OperationCallBack.faultCallBack.apply(null,[faultEvent]);
            }

            if( _responder != null ){
                _responder.fault( faultEvent );
            }

            _responder = null;
            _responderOwner = null;
            _operation = null;
            _internalAsyncToken = null;
        }
        
        mx_internal override function setResult(newResult:Object):void
        {
        }

    }
}