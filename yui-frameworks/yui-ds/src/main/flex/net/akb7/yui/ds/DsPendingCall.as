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
package net.akb7.yui.ds {
    import mx.core.mx_internal;
    import mx.messaging.messages.IMessage;
    import mx.rpc.AbstractOperation;
    import mx.rpc.AsyncToken;
    import mx.rpc.IResponder;
    import mx.rpc.Responder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import net.akb7.yui.core.reflection.ClassRef;
    import net.akb7.yui.core.reflection.FunctionRef;
    import net.akb7.yui.core.reflection.ParameterRef;
    import net.akb7.yui.service.IManagedService;
    import net.akb7.yui.service.IPendingCall;
    import net.akb7.yui.service.IService;
    import net.akb7.yui.service.OperationCallBack;
    import net.akb7.yui.ds.responder.RpcDefaultEventResponder;
    import net.akb7.yui.ds.responder.RpcEventResponder;
    import net.akb7.yui.ds.responder.RpcNoneResponder;
    import net.akb7.yui.ds.responder.RpcObjectResponder;
    import net.akb7.yui.ds.responder.RpcResponderFactory;
    import net.akb7.yui.service.resonder.IServiceResponder;
    import net.akb7.yui.service.resonder.ServiceResponderFactory;

    use namespace mx_internal;

    [ExcludeClass]
    public final class DsPendingCall extends AsyncToken implements IPendingCall {

        private static const RESULT_HANDLER:String = "ResultHandler";

        private static const FAULT_HANDLER:String = "FaultHandler";

        private static const RESPONDER_FACTORY:ServiceResponderFactory = new RpcResponderFactory();

        private static function createResponder( destination:String,operationName:String, responder:Object ):IResponder{
            const classRef:ClassRef = getClassRef(responder);
            const resultFuncDef:FunctionRef = RESPONDER_FACTORY.findResultFunctionRef( classRef, destination, operationName );
            const faultFuncDef:FunctionRef = RESPONDER_FACTORY.findFaultFunctionRef( classRef, destination, operationName );

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

        private var _internalAsyncToken:AsyncToken;

        private var _responder:IResponder;

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
            } else if( responder is IServiceResponder ){
                _responderOwner = null;
                _responder = new RpcEventResponder(responder.onResult,responder.onFault);
            } else {
                _responderOwner = responder;
                var service:IService = _operation.service as IService;
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

        public function get service():IService{
            return _operation.service as IService;
        }

        public function onResult( resultEvent:ResultEvent ):void{
            if( service is IManagedService ){
                ( service as IManagedService ).finalizePendingCall(this);
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
            if( service is IManagedService ){
                ( service as IManagedService ).finalizePendingCall(this);
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