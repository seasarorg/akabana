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
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.command.core.ComplexCommand;
    import org.seasar.akabana.yui.command.core.EventListener;
    import org.seasar.akabana.yui.command.core.SubCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    
    /**
     * 
     * @author arikawa.eiichi
     * 
     */
    public class AbstractComplexCommand extends AsyncCommand implements ComplexCommand
    {
        /**
         * 
         */
        protected var commands:Array;
        
        /**
         * 
         */
        protected var commandMap:Object;
        
        /**
         * 
         */
        protected var commandArguments:Array;
        
        /**
         * 
         */
        protected var childCompleteEventListener:EventListener;
        
        /**
         * 
         */
        protected var childErrorEventListener:EventListener;
        
        /**
         * 
         */
        public function AbstractComplexCommand()
        {
            super();
            commands = [];
            commandMap = {};
            childCompleteEventListener = new EventListener();
            childErrorEventListener = new EventListener();
        }
        
        /**
         * 
         * @param handler
         * @return 
         * 
         */
        public function childComplete(handler:Function):ComplexCommand
        {
            this.childCompleteEventListener.handler = handler;
            return this;
        }
        
        /**
         * 
         * @param handler
         * @return 
         * 
         */
        public function childError(handler:Function):ComplexCommand
        {
            this.childErrorEventListener.handler = handler;
            return this;
        }
        
        /**
         * 
         * @param command
         * @return 
         * 
         */
        public function add(command:ICommand,name:String=null):ComplexCommand
        {
            if( command is AbstractCommand ){
                doAddCommand(command as AbstractCommand);
            }
            if( name != null ){
                commandMap[name] = command;
            }
            doRegisterCommand(command);
            return this;
        }

        /**
         * 
         * @param name
         * @return 
         * 
         */
        public function fetch(name:String):ICommand
        {
            var result:ICommand = commandMap[name];
            return result;
        }

        /**
         * 
         * @param index
         * 
         */
        protected function doStartCommandAt(index:int):void{
            var command:ICommand = commands[ index ];
            (command.start as Function).apply(null,commandArguments);
        }         
                
        /**
         * 
         * @param event
         * 
         */
        protected function childCommandCompleteEventHandler(event:CommandEvent):void{
        }        

        /**
         * 
         * @param event
         * 
         */
        protected function childCommandErrorEventHandler(event:CommandEvent):void{
        }   
        
        /**
         * 
         * @param command
         * 
         */
        protected function doAddCommand(command:AbstractCommand):void{
            command
            	.complete(childCommandCompleteEventHandler)         
            	.error(childCommandErrorEventHandler);
        }
        
        /**
         * 
         * @param command
         * 
         */
        protected function doRegisterCommand(command:ICommand):void{
            commands.push(command);
            if( command is SubCommand ){
                (command as SubCommand).parent = this;
            }
        }
        
    }
}