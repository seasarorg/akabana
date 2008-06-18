/*
 * Copyright 2004-2007 the Seasar Foundation and the Others.
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
        
        private var responders_:Array;
        
        public function RpcPendingCall(){
            responders_ = [];
        }
        
        public function addResponder( responder:Responder ):void{
            responders_.push( responder );   
        }

        public function addResponceHandler( resultHandler:Function, faultFunction:Function ):void{
            responders_.push( new RpcResponder( resultHandler, faultFunction ) );   
        }        
        
        public function onResult( result:* ):void{
            var resultEvent:ResultEvent = new ResultEvent();
            resultEvent.pendigCall = this;
            resultEvent.result = result;
            
            for each( var responder:Object in responders_ ){
                if( responder is Responder){
                    responder.onResult( resultEvent );
                }                
            }
        }
        
        public function onStatus( status:* ):void{
            var faultStatus:FaultStatus = new FaultStatus( status.code, status.description, status.details);
            var faultEvent:FaultEvent = new FaultEvent();
            faultEvent.pendigCall = this;            
            faultEvent.faultStatus = faultStatus;
            
            for each( var responder:Object in responders_ ){
                if( responder is Responder){
                    responder.onFault( faultEvent );
                }
            }
        }
    }
}