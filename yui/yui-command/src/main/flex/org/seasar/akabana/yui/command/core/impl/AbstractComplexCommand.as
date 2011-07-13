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
package org.seasar.akabana.yui.command.core.impl
{
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.command.core.IComplexCommand;
    import org.seasar.akabana.yui.command.core.ISubCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    import org.seasar.akabana.yui.core.reflection.FunctionInvoker;
    
    /**
     * 
     * 
     */
    public class AbstractComplexCommand extends AbstractAsyncCommand implements IComplexCommand {
        /**
         * 
         */
        protected var _commands:Array;
        
        /**
         * 
         */
        protected var _commandMap:Object;
        
        /**
         * 
         */
        protected var _childCompleteEventListener:EventListener;
        
        /**
         * 
         */
        protected var _childErrorEventListener:EventListener;
        
        /**
         * 
         */
        protected var _lastCommand:ICommand;
        
        /**
         * 
         */
        public function get lastCommand():ICommand{
            return _lastCommand;
        }
        
        /**
         * 
         */
        public function AbstractComplexCommand(){
            super();
            _commands = [];
            _commandMap = {};
            _childCompleteEventListener = new EventListener();
            _childErrorEventListener = new EventListener();
        }
        
        /**
         * 
         * @param handler
         * @return 
         * 
         */
        public function childComplete(handler:Function):IComplexCommand{
            this._childCompleteEventListener.handler = handler;
            return this;
        }
        
        /**
         * 
         * @param handler
         * @return 
         * 
         */
        public function childError(handler:Function):IComplexCommand{
            this._childErrorEventListener.handler = handler;
            return this;
        }
        
        /**
         * 
         * @param command
         * @return 
         * 
         */
        public function add(command:ICommand,name:String=null):IComplexCommand{
            if( command is AbstractCommand ){
                doAddCommand(command as AbstractCommand);
            }
            if( name != null ){
                _commandMap[name] = command;
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
        public function commandByName(name:String):ICommand{
            var result:ICommand = _commandMap[name];
            return result;
        }

        /**
         * 
         * @param index
         * 
         */
        protected function doStartCommandAt(index:int,args:Array):ICommand{
            var command:ICommand = _commands[ index ];
            new FunctionInvoker(command.start as Function,args).invokeDelay();
            return command;
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
            _commands.push(command);
            if( command is ISubCommand ){
                (command as ISubCommand).parent = this;
            }
        }
        
    }
}