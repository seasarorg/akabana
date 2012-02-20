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
package org.seasar.akabana.yui.service.event {
    
    import flash.events.Event;
    
    import org.seasar.akabana.yui.service.IOperation;
    import org.seasar.akabana.yui.service.IPendingCall;
    import org.seasar.akabana.yui.service.IService;
    
    internal class AbstractServiceEvent extends Event {
        
        private var _service:IService;

        public function get service():IService{
            return _service;
        }

        public function set service(value:IService):void{
            _service = value;
        }
        
        private var _operation:IOperation;

        public function get operation():IOperation{
            return _operation;
        }

        public function set operation(value:IOperation):void{
            _operation = value;
        }
        
        private var _pendigCall:IPendingCall;

        public function get pendigCall():IPendingCall{
            return _pendigCall;
        }

        public function set pendigCall(value:IPendingCall):void{
            _pendigCall = value;
        }
        
        public function AbstractServiceEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ){
            super(type,bubbles,cancelable);
        }

        public override function clone():Event{
            return new AbstractServiceEvent(type, bubbles, cancelable);
        }

        public override function toString():String{
            return formatToString("AbstractServiceEvent", "type", "bubbles", "cancelable","eventPhase","service","operation","pendingCall");
        }
    }
}