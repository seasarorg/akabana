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
    import org.seasar.akabana.yui.command.core.impl.AbstractComplexCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class SequenceCommand extends AbstractComplexCommand
    {
        protected var currentCommandIndex:int;
        
        protected override function run(...args):void{
            currentCommandIndex = 0;
            if( commands.length > 0 ){
                doStartCommands(args);
            } else {
                done();
            }
        }
        
        protected override function childCommandCompleteEventHandler(event:CommandEvent):void{
            if( childCompleteEventHandler != null ){
                childCompleteEventHandler(event);
            }
            currentCommandIndex++;
            if( currentCommandIndex < commands.length ){
                doStartCommandAt(currentCommandIndex);
            } else {
                childCompleteEventHandler = null;
                done();
            }
        }     

        protected override function childCommandErrorEventHandler(event:CommandEvent):void{
            if( childErrorEventHandler != null ){
                childErrorEventHandler(event);
            }
            childErrorEventHandler = null;
            failed(event);
        }
        
        protected function doStartCommands(args:Array):void{
            currentCommandIndex = 0;
            commandArguments = args;

            doStartCommandAt(currentCommandIndex);
        }
    }
}