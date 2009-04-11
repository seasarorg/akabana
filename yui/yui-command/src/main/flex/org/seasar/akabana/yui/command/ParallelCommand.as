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
package org.seasar.akabana.yui.command
{
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.core.impl.AbstractComplexCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class ParallelCommand extends AbstractComplexCommand
    {
        protected var finishedCommand:Object;
        
        protected var finishedCommandCount:int;
        
        protected var hasError:Boolean;
        
        protected var errorCommandEvents:Array;
        
        private var commandStartTimer:Timer;
        
        private var currentCommandIndex:int;
        
        public function ParallelCommand()
        {
            super();
        }

        public override function start(...args):Command
        {
            commandArguments = args;
            if( commands.length > 0 ){            
                doStartCommands(args);
            } else {
                dispatchCompleteEvent(null);
            }
            return this;
        } 

        protected function doStartCommands(args:Array):void{
            commandArguments = args;
            finishedCommand = {};
            finishedCommandCount = 0;
            hasError = false;
            errorCommandEvents = [];
            currentCommandIndex = 0;
            commandStartTimer = new Timer(24);
            commandStartTimer.addEventListener(TimerEvent.TIMER,commandStartTimerHandler);
            commandStartTimer.start();
        }   

        protected override function childCommandCompleteEventHandler(event:CommandEvent):void{
            if( childCompleteEventHandler != null ){
                childCompleteEventHandler(event);
            }
            doCheckFinishedCommand();
        }     

        protected override function childCommandErrorEventHandler(event:CommandEvent):void{
            if( childErrorEventHandler != null ){
                childErrorEventHandler(event);
            }
            hasError = true;
            errorCommandEvents.push( event );
            doCheckFinishedCommand();
        }  
        
        protected function doCheckFinishedCommand():void{
            finishedCommandCount++;
            if( finishedCommandCount >= commands.length ){
                if( hasError ){
                    dispatchErrorEvent(errorCommandEvents);
                } else {
                    dispatchCompleteEvent();
                }
            }
        }
        
        private function commandStartTimerHandler(event:TimerEvent):void{
            doStartCommandAt(currentCommandIndex);
            currentCommandIndex++;
            
            if( currentCommandIndex >= commands.length ){
                commandStartTimer.stop();
            }
        }
    }
}