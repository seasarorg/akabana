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
package org.seasar.akabana.yui.service.ds {
    import mx.core.mx_internal;
    import mx.messaging.messages.IMessage;
    import mx.messaging.messages.RemotingMessage;
    import mx.rpc.AsyncToken;
    import mx.rpc.IResponder;
    import mx.rpc.Responder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import org.seasar.akabana.yui.core.error.NotFoundError;
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.ParameterRef;
    import org.seasar.akabana.yui.service.PendingCall;
    import org.seasar.akabana.yui.service.ds.responder.RpcEventResponder;
    import org.seasar.akabana.yui.service.ds.responder.RpcNoneResponder;
    import org.seasar.akabana.yui.service.ds.responder.RpcObjectResponder;
    import org.seasar.akabana.yui.util.StringUtil;

    use namespace mx_internal;

    public class RpcPendingCall extends AsyncToken implements PendingCall {

        private static const RESULT_HANDLER:String = "ResultHandler";

        private static const FAULT_HANDLER:String = "FaultHandler";

        private static function createResponder( message:RemotingMessage, responder:Object ):IResponder{
            var rpcResponder:IResponder = null;

            var classRef:ClassRef = ClassRef.getReflector(responder);
            var serviceMethod:String = StringUtil.toLowerCamel( message.destination ) + StringUtil.toUpperCamel( message.operation );
            var result:FunctionRef = classRef.getFunctionRef( serviceMethod + RESULT_HANDLER);
            var fault:FunctionRef = classRef.getFunctionRef( serviceMethod + FAULT_HANDLER);

            if( result == null ){
                throw new NotFoundError( responder, serviceMethod + RESULT_HANDLER);
            } else {
                var responderClass:Class;
                if( result.parameters.length <= 0 ){
                    responderClass = RpcNoneResponder;
                } else {
                    var parameter:ParameterRef = result.parameters[0];
                    if( parameter.isEvent ){
                        responderClass = RpcEventResponder;
                    } else {
                        responderClass = RpcObjectResponder;
                    }
                }
                if( fault == null){
                    rpcResponder = new responderClass(result.getFunction(responder),null);
                } else {
                    rpcResponder = new responderClass(result.getFunction(responder),fault.getFunction(responder));
                }
            }
            return rpcResponder;
        }

        protected var _internalAsyncToken:AsyncToken;

        protected var _responder:IResponder;
        
        private var _responderOwner:Object;

        public function RpcPendingCall(message:IMessage=null)
        {
            super(message);
        }

        public function setInternalAsyncToken( asyncToken:AsyncToken ):void{
            _internalAsyncToken = asyncToken;
            _internalAsyncToken.addResponder( new Responder(onResult,onStatus));
        }

        public function setResponder( responder:Object ):void{
             if( responder is IResponder ){
                _responderOwner = null;
                _responder = responder as IResponder;
             } else {
                _responderOwner = responder;
                _responder = createResponder( message as RemotingMessage, responder );
             }
        }

        public function getResponder():Object{
            if( _responderOwner == null ){
                return _responder;
            } else {
                return _responderOwner;
            }
        }

        mx_internal override function setResult(newResult:Object):void
        {
        }

        public function onResult( resultEvent:ResultEvent ):void{
            if( RemotingService.resultCallBack != null ){
                RemotingService.resultCallBack.apply(null,[resultEvent]);
            }

            if( _responder != null ){
                _responder.result( resultEvent );
            }

            _responder = null;
        }

        public function onStatus( faultEvent:FaultEvent ):void{
            if( RemotingService.faultCallBack != null ){
                RemotingService.faultCallBack.apply(null,[faultEvent]);
            }

            if( _responder != null ){
                _responder.fault( faultEvent );
            }

            _responder = null;
        }
    }
}