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
    
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.command.core.impl.AbstractAsyncCommand;
    import org.seasar.akabana.yui.command.core.impl.AbstractSubCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    import org.seasar.akabana.yui.core.error.NotFoundError;

    public final class SwitchCommand extends AbstractAsyncCommand{ 
        
        protected var _caseMap:Object;
        
        protected var _defaultCommand:ICommand;
        
        public function SwitchCommand(){
            super();
            _caseMap = {};
        }
        
        protected override function run():void{
            var cmd:ICommand = null;
            var lastCommand:ICommand = _parent.lastCommand;
            if( lastCommand == null && _name != null && _name.length > 0 ){
                lastCommand = _parent.commandByName(_name);
            }
            var targetResult:Object = lastCommand.result;
            if( lastCommand == null ){
                cmd = _defaultCommand;
            } else {
                if( targetResult in _caseMap){
                    cmd = _caseMap[ targetResult ];
                } else {
                    cmd = _defaultCommand;
                }
            }
            if( cmd == null ){
                status = new IllegalOperationError("Command Not Found for " + targetResult);
                failed();
            } else {
                cmd.complete(commandCompleteEventListener);
                cmd.error(commandErrorEventListener);
                cmd.start(targetResult);
            }
        }
        
        public function caseCommand( value:Object, command:ICommand ):SwitchCommand{
            _caseMap[ value ] = command;
            return this;
        }
        
        public function caseCallBack( value:Object, callback:Function ):SwitchCommand{
            _caseMap[ value ] = new CallBackCommand(callback);
            return this;
        }

        public function defaultCommand( command:ICommand ):SwitchCommand{
            _defaultCommand = command;
            return this;
        }
        
        protected function commandCompleteEventListener(event:CommandEvent):void{
            if( event.command.hasResult ){
                doDoneCommand(event.command.result);
            } else {
                doDone();
            }
        }

        protected function commandErrorEventListener(event:CommandEvent):void{
            doFailedCommand(event.data);
        }
    }
}