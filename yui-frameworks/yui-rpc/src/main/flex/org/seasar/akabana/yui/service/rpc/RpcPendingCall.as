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
package org.seasar.akabana.yui.service.rpc {
    import org.seasar.akabana.yui.service.OperationCallBack;
    import org.seasar.akabana.yui.service.IPendingCall;
    import org.seasar.akabana.yui.service.event.FaultEvent;
    import org.seasar.akabana.yui.service.event.FaultStatus;
    import org.seasar.akabana.yui.service.event.ResultEvent;
    import org.seasar.akabana.yui.service.resonder.IServiceResponder;
    import org.seasar.akabana.yui.service.resonder.ServiceResponderFactory;
    import org.seasar.akabana.yui.service.rpc.responder.RpcResponderFactory;

    [ExcludeClass]
    public final class RpcPendingCall implements IPendingCall {

        private static const RESPONDER_FACTORY:ServiceResponderFactory = new RpcResponderFactory();

        private var _responder:IServiceResponder;

        private var _responderOwner:Object;

        private var _operation:AbstractRpcOperation;

        public function get remotingService():RemotingService{
            return _operation.service as RemotingService;
        }

        public function RpcPendingCall(opration:AbstractRpcOperation){
            _operation = opration;
        }

        public function clear():void{
            _responder = null;
        }

        public function setResponder( responder:Object ):void{
            if( responder is IServiceResponder ){
                _responderOwner = null;
                _responder = responder as IServiceResponder;
            } else {
                _responderOwner = responder;
                _responder = RESPONDER_FACTORY.createResponder( _operation, responder );
            }
        }

        public function getResponder():Object{
            if( _responderOwner == null ){
                return _responder;
            } else {
                return _responderOwner;
            }
        }

        public function onResult( result:* ):void{
            remotingService.finalizePendingCall(this);

            var resultEvent:ResultEvent = new ResultEvent(result);
            resultEvent.pendigCall = this;

            if( _responder != null ){
                _responder.onResult( resultEvent );
            }

            if( OperationCallBack.resultCallBack != null ){
                OperationCallBack.resultCallBack.apply(null,[resultEvent]);
            }

            _responder = null;
            _responderOwner = null;
            _operation = null;
        }

        public function onStatus( status:* ):void{
            remotingService.finalizePendingCall(this);

            var faultStatus:FaultStatus = new FaultStatus();
            if( status != null ){
                faultStatus.code = status.code;
                faultStatus.description = status.description;
                faultStatus.details = status.details;
            }
            
            var faultEvent:FaultEvent = new FaultEvent(faultStatus);
            faultEvent.pendigCall = this;
            
            if( _responder != null ){
                _responder.onFault( faultEvent );
            }

            if( OperationCallBack.faultCallBack != null ){
                OperationCallBack.faultCallBack.apply(null,[faultEvent]);
            }

            _responder = null;
            _responderOwner = null;
            _operation = null;
        }
    }
}