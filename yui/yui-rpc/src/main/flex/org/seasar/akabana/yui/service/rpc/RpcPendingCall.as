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
package org.seasar.akabana.yui.service.rpc {
    import org.seasar.akabana.yui.service.OperationCallBack;
    import org.seasar.akabana.yui.service.PendingCall;
    import org.seasar.akabana.yui.service.event.FaultEvent;
    import org.seasar.akabana.yui.service.event.FaultStatus;
    import org.seasar.akabana.yui.service.event.ResultEvent;
    import org.seasar.akabana.yui.service.resonder.Responder;
    import org.seasar.akabana.yui.service.resonder.ResponderFactory;
    import org.seasar.akabana.yui.service.rpc.responder.RpcResponderFactory;

    [ExcludeClass]
    public final class RpcPendingCall implements PendingCall {

        private static const _responderFactory:ResponderFactory = new RpcResponderFactory();

        private var _responder:Responder;

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
            if( responder is Responder ){
                _responderOwner = null;
                _responder = responder as Responder;
            } else {
                _responderOwner = responder;
                _responder = _responderFactory.createResponder( _operation, responder );
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