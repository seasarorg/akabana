/*
 * Copyright 2004-2009 the Seasar Foundation and the Others.
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
    
    import org.seasar.akabana.yui.command.Command;

    public class CommandEvent extends Event
    {
        public static const COMPLETE:String = "onCommandComplete";
        
        public static const ERROR:String = "onCommandError";
        
        public static function createCompleteEvent(command:Command,value:Object):CommandEvent{
            var event:CommandEvent = new CommandEvent(COMPLETE,false,false);
            event.value = value;
            event.command = command;
            
            return event;
        }
        
        public static function createErrorEvent(command:Command,message:Object):CommandEvent{
            var event:CommandEvent = new CommandEvent(ERROR,false,false);
            event.value = message;
            event.command = command;
            
            return event;
        }
        
        public var value:Object;
        
        public var command:Command;
        
        public function CommandEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
        
    }
}