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
    import org.seasar.akabana.yui.service.PendingCall;
    import org.seasar.akabana.yui.service.Responder;
    import org.seasar.akabana.yui.service.event.FaultEvent;
    import org.seasar.akabana.yui.service.event.FaultStatus;
    import org.seasar.akabana.yui.service.event.ResultEvent;
    
    public class RpcPendingCall implements PendingCall {
        
        private var _responder:Responder;
        
        public function RpcPendingCall(){
        }
        
        public function addResponder( responder:Responder ):void{
            _responder = responder;
        }

        public function addResponceHandler( resultHandler:Function, faultFunction:Function ):void{
            _responder = new RpcResponder( resultHandler, faultFunction );   
        }
        
        public function onResult( result:* ):void{
            var resultEvent:ResultEvent = new ResultEvent();
            resultEvent.pendigCall = this;
            resultEvent.result = result;
            
            _responder.onResult( resultEvent );
        }
        
        public function onStatus( status:* ):void{
            var faultEvent:FaultEvent = new FaultEvent();
            faultEvent.pendigCall = this;            
            
            if( status != null ){
                var faultStatus:FaultStatus = new FaultStatus( status.code, status.description, status.details);
                faultEvent.faultStatus = faultStatus;
            }
            
            _responder.onFault( faultEvent );
        }
    }
}