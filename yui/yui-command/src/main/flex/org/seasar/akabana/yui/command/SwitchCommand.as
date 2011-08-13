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
package org.seasar.akabana.yui.command
{
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;
    
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.command.core.impl.AbstractAsyncCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    import org.seasar.akabana.yui.util.StringUtil;

    public final class SwitchCommand extends AbstractAsyncCommand{ 
        
        protected var _commandMap:Dictionary;
        
        protected var _defaultCommand:ICommand;
        
        private var _property:String;

        public function get property():String
        {
            return _property;
        }

        public function set property(value:String):void
        {
            _property = value;
        }

        
        public function SwitchCommand(){
            super();
            _commandMap = new Dictionary();
        }
        
        protected override function runAsync():void{
            var cmd:ICommand = null;
            var arg:Object = _argument;
            var key:Object = arg;
            if( !StringUtil.isEmpty(property) && (property in arg)){
                key = arg[ property ];
            }
            if( key in _commandMap){
                cmd = _commandMap[ key ];
            } else {
                cmd = _defaultCommand;
            }

            if( cmd == null ){
                status = new IllegalOperationError("Command Not Found for " + key);
                error();
            } else {
                cmd.completeCallBack(commandCompleteEventListener);
                cmd.errorCallBack(commandErrorEventListener);
                cmd.start(arg);
            }
        }
        
        public function caseCommand( key:Object, command:ICommand ):SwitchCommand{
            _commandMap[ key ] = command;
            return this;
        }
        
        public function caseCallBack( key:Object, callback:Function ):SwitchCommand{
            _commandMap[ key ] = new CallBackCommand(callback);
            return this;
        }

        public function defaultCommand( command:ICommand ):SwitchCommand{
            _defaultCommand = command;
            return this;
        }
        
        protected function commandCompleteEventListener(event:CommandEvent):void{
            if( event.command.hasResult ){
                returnAsync(event.command.result);
            } else {
                doneAsync();
            }
        }

        protected function commandErrorEventListener(event:CommandEvent):void{
            errorAsync(event.data);
        }
    }
}