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
    import flash.errors.IllegalOperationError;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.ParameterRef;
    import org.seasar.akabana.yui.service.PendingCall;
    import org.seasar.akabana.yui.service.Responder;
    import org.seasar.akabana.yui.service.event.FaultEvent;
    import org.seasar.akabana.yui.service.event.FaultStatus;
    import org.seasar.akabana.yui.service.event.ResultEvent;
    import org.seasar.akabana.yui.service.rpc.responder.RpcEventResponder;
    import org.seasar.akabana.yui.service.rpc.responder.RpcNoneResponder;
    import org.seasar.akabana.yui.service.rpc.responder.RpcObjectResponder;
    import org.seasar.akabana.yui.service.rpc.responder.RpcResponder;
    import org.seasar.akabana.yui.util.StringUtil;

    public class RpcPendingCall implements PendingCall {

        private static const RESULT_HANDLER:String = "ResultHandler";

        private static const FAULT_HANDLER:String = "FaultHandler";

        private static function createResponder( operation:RemotingOperation, responder:Object ):Responder{
            var rpcResponder:RpcResponder = null;

            var classRef:ClassRef = ClassRef.getReflector(responder);
            var serviceMethod:String = StringUtil.toLowerCamel( operation.service.name ) + StringUtil.toUpperCamel( operation.name );
            var result:FunctionRef = classRef.getFunctionRef( serviceMethod + RESULT_HANDLER);
            var fault:FunctionRef = classRef.getFunctionRef( serviceMethod + FAULT_HANDLER);

            if( result == null ){
                throw new IllegalOperationError(serviceMethod);
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

        private var _responder:Responder;

        private var _operation:RemotingOperation;

        public function RpcPendingCall(opration:RemotingOperation){
            this._operation = opration as RemotingOperation;
        }

        public function setResponder( responder:Object ):void{
            if( responder is Responder ){
                _responder = responder as Responder;
             } else {
                 _responder = createResponder( _operation, responder );
             }
        }

        public function onResult( result:* ):void{
            var resultEvent:ResultEvent = new ResultEvent();
            resultEvent.pendigCall = this;
            resultEvent.result = result;

            if( _responder != null ){
                _responder.onResult( resultEvent );
            }

            if( RemotingOperation.resultCallBack != null ){
                RemotingOperation.resultCallBack.apply(null,[resultEvent]);
            }
            _responder = null;
        }

        public function onStatus( status:* ):void{
            var faultEvent:FaultEvent = new FaultEvent();
            faultEvent.pendigCall = this;

            if( status != null ){
                var faultStatus:FaultStatus = new FaultStatus( status.code, status.description, status.details);
                faultEvent.faultStatus = faultStatus;
            }

            if( _responder != null ){
                _responder.onFault( faultEvent );
            }

            if( RemotingOperation.faultCallBack != null ){
                RemotingOperation.faultCallBack.apply(null,[faultEvent]);
            }
            _responder = null;
        }
    }
}