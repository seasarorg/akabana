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
package org.seasar.akabana.yui.command.core.impl
{
    import flash.events.EventDispatcher;
    
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class AbstractCommand extends EventDispatcher implements Command
    {
        private var completeEventHandler:Function;
        
        private var errorEventHandler:Function;
        
        public function start(...args):Command
        {
            return this;
        }
        
        public function setCompleteEventListener(handler:Function):Command
        {
            this.completeEventHandler = handler;
            addEventListener(CommandEvent.COMPLETE,handler,false,int.MAX_VALUE);
            return this;
        }
        
        public function setErrorEventListener(handler:Function):Command
        {
            this.errorEventHandler = handler;
            addEventListener(CommandEvent.ERROR,handler,false,int.MAX_VALUE);
            return this;
        }
        
        public function dispatchCompleteEvent(value:Object=null):void
        {
            dispatchEvent(CommandEvent.createCompleteEvent(this,value));
        } 
        
        public function dispatchErrorEvent(message:Object):void
        {
            dispatchEvent(CommandEvent.createErrorEvent(this,message));
        }

        internal function addCompleteEventListener(handler:Function):Command
        {
            this.completeEventHandler = handler;
            addEventListener(CommandEvent.COMPLETE,handler,false,0);
            return this;
        }
        
        internal function addErrorEventListener(handler:Function):Command
        {
            this.errorEventHandler = handler;
            addEventListener(CommandEvent.ERROR,handler,false,0);
            return this;
        }
    }
}