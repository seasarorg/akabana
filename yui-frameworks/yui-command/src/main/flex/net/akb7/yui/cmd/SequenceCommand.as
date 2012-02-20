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
package net.akb7.yui.cmd
{
    import net.akb7.yui.cmd.core.impl.AbstractComplexCommand;
    import net.akb7.yui.cmd.events.CommandEvent;

    public class SequenceCommand extends AbstractComplexCommand {

        protected var _currentCommandIndex:int;
        
        protected final override function runAsync():void{
            _currentCommandIndex = 0;
            if( _commands.length > 0 ){
                doStartCommands();
            } else {
                doneAsync();
            }
        }
        
        protected final override function childCmd_completeHandler(event:CommandEvent):void{
            _lastCommand = event.command;
            if( _childCompleteEventListener.handler != null ){
                _childCompleteEventListener.handler(event);
            }
            if( _lastCommand.hasResult ){
                pendingResult = _lastCommand.result;
            }
            _currentCommandIndex++;
            if( _currentCommandIndex < _commands.length ){
                var args:Array = [];
                
                if( _lastCommand == null ){
                    args = [argument];
                } else {
                    if( hasPendingResult ){
                        args = [pendingResult];
                    } else {
                        args = [argument];
                    }
                }
                
                doStartCommandAt(_currentCommandIndex,args);
            } else {
                doneAsync();
            }
        }

        protected final override function childCmd_errorHandler(event:CommandEvent):void{
            _lastCommand = event.command;
            if( _childErrorEventListener.handler != null ){
                _childErrorEventListener.handler(event);
            }
            errorAsync(event.data);
        }
        
        protected final function doStartCommands():void{
            _currentCommandIndex = 0;
            doStartCommandAt(_currentCommandIndex,[argument]);
        }
    }
}