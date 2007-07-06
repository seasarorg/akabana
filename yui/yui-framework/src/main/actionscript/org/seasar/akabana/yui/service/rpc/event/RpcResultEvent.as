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
package org.seasar.akabana.yui.service.rpc.event {
    
    import flash.events.Event;
    
    import org.seasar.akabana.yui.service.rpc.PendingCall;
    
    public class RpcResultEvent extends AbstractRpcEvent {
        
        public static const RESULT:String = "onResult";
        
        private var result_:Object;
        
        public function RpcResultEvent( pendigCall:PendingCall, result:Object, bubbles:Boolean = false, cancelable:Boolean = false ){
            super( RESULT, pendigCall, bubbles, cancelable);
            result_ = result;
        }
        
        public function get result():Object{
            return result_;
        }
    }
}