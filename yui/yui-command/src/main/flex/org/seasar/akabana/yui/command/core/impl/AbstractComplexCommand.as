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
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.core.ComplexCommand;
    import org.seasar.akabana.yui.command.core.SubCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    
    public class AbstractComplexCommand extends AbstractCommand implements ComplexCommand
    {
        protected var commands:Array;
        
        protected var commandMap:Object;
        
        protected var currentCommandIndex:int;
        
        protected var commandArguments:Array;
        
        protected var childCompleteEventHandler:Function;
        
        public function AbstractComplexCommand()
        {
            super();
            commands = [];
            commandMap = {};
            currentCommandIndex = 0;
        }

        public function setChildCompleteEventListener(handler:Function):ComplexCommand
        {
            this.childCompleteEventHandler = handler;
            return this;
        }
        
        public function addCommand(command:Command):ComplexCommand
        {
            doAddCommand(command);
            return this;
        }

        public function addNamedCommand(name:String,command:Command):ComplexCommand
        {
            doAddCommand(command);
            commandMap[name] = command;
            return this;
        }

        public function getCommandByName(name:String):Command
        {
            var result:Command = commandMap[name];
            return result;
        } 
        
        protected function commandCompleteEventHandler(event:CommandEvent):void{
        }        

        protected function commandErrorEventHandler(event:CommandEvent):void{
        }   
        
        protected function doStartCommand():void{
            var command:Command = commands[ currentCommandIndex ];
            command.start.apply(null,commandArguments);
        }  
        
        private function doAddCommand(command:Command):void{
            command.setCompleteEventListener(commandCompleteEventHandler);            
            command.setErrorEventListener(commandErrorEventHandler);
            commands.push(command);
            if( command is SubCommand ){
                (command as SubCommand).parent = this;
            }
        }
    }
}