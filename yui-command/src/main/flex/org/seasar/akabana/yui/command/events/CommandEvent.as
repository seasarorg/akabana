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
package org.seasar.akabana.yui.command.events
{
    import flash.events.Event;
    
    import org.seasar.akabana.yui.command.core.ICommand;

    public final class CommandEvent extends Event {
        
        public static const COMPLETE:String = "complete";
        
        public static const ERROR:String = "error";
        
        public static function createCompleteEvent(command:ICommand,data:Object):CommandEvent{
            var event:CommandEvent = new CommandEvent(COMPLETE,false,false);
            event.data = data;
            event.command = command;
            
            return event;
        }
        
        public static function createErrorEvent(command:ICommand,message:Object):CommandEvent{
            var event:CommandEvent = new CommandEvent(ERROR,false,false);
            event.data = message;
            event.command = command;
            
            return event;
        }
        
        private var _data:Object;
        
        public function get data():Object
        {
            return _data;
        }
        
        public function set data(value:Object):void
        {
            _data = value;
        }
        
        private var _command:ICommand;
        
        public function get command():ICommand
        {
            return _command;
        }
        
        public function set command(value:ICommand):void
        {
            _command = value;
        }
        
        public function CommandEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(type, bubbles, cancelable);
        }

        public override function clone():Event{
            var result:CommandEvent = new CommandEvent(type, bubbles, cancelable);
            result.command = _command;
            result.data = _data;
            return result;
        }
        
        public override function toString():String{
            return formatToString("CommandEvent", "type", "bubbles", "cancelable","eventPhase","command","data");
        }
    }
}