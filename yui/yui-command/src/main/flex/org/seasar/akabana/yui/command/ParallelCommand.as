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
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    import org.seasar.akabana.yui.command.core.impl.AbstractComplexCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class ParallelCommand extends AbstractComplexCommand {

        protected var _finishedCommand:Object;
        
        protected var _finishedCommandCount:int;
        
        protected var _hasError:Boolean;
        
        protected var _errorCommandEvents:Array;
        
        protected var _commandStartTimer:Timer;
        
        protected var _currentCommandIndex:int;
        
        protected override function run(...args):void{
            _commandArguments = args;
            if( _commands.length > 0 ){            
                doStartCommands(args);
            } else {
                complete(null);
            }
        } 

        protected function doStartCommands(args:Array):void{
            _commandArguments = args;
            _finishedCommand = {};
            _finishedCommandCount = 0;
            _hasError = false;
            _errorCommandEvents = [];
            _currentCommandIndex = 0;
            _commandStartTimer = new Timer(1);
            _commandStartTimer.addEventListener(TimerEvent.TIMER,commandStartTimerHandler);
            _commandStartTimer.start();
        }   

        protected override function childCommandCompleteEventHandler(event:CommandEvent):void{
            if( _childCompleteEventListener.handler != null ){
                _childCompleteEventListener.handler(event);
            }
            doCheckFinishedCommand();
        }     

        protected override function childCommandErrorEventHandler(event:CommandEvent):void{
            if( _childErrorEventListener.handler != null ){
                _childErrorEventListener.handler(event);
            }
            _hasError = true;
            _errorCommandEvents.push( event );
            doCheckFinishedCommand();
        }  
        
        protected function doCheckFinishedCommand():void{
            _finishedCommandCount++;
            if( _finishedCommandCount >= _commands.length ){
                if( _hasError ){
                    failed(_errorCommandEvents);
                } else {
                    done();
                }
            }
        }
        
        protected function doReset():void{
        }
        
        private function commandStartTimerHandler(event:TimerEvent):void{
            doStartCommandAt(_currentCommandIndex);
            _currentCommandIndex++;
            
            if( _currentCommandIndex >= _commands.length ){
                _commandStartTimer.stop();
            }
        }
    }
}