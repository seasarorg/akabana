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
package jp.akb7.yui.event
{
    import flash.events.ErrorEvent;
    
    import jp.akb7.yui.core.reflection.ClassRef;
    
    public final class RuntimeErrorEvent extends ErrorEvent {
        
        public static const RUNTIME_ERROR:String = "runtimeError";
        
        public static function createEvent( e:Error ):RuntimeErrorEvent{
            var runtimeErrorEvent:RuntimeErrorEvent = new RuntimeErrorEvent(RUNTIME_ERROR, e);
            runtimeErrorEvent.error = e;
            return runtimeErrorEvent;
        }
        
        private var _error:Error;

        public function get error():Error{
            return _error;
        }

        public function set error(value:Error):void{
            _error = value;
        }

        public function RuntimeErrorEvent(type:String, error:Error, bubbles:Boolean = true, cancelable:Boolean = true){
            super(type,bubbles,cancelable,error.toString(),error.errorID);
            this.error = error;
        }
    }
}