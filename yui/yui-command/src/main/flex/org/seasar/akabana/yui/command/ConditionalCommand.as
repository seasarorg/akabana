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
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.core.StatefulObject;
    import org.seasar.akabana.yui.command.core.impl.AbstractSubCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class ConditionalCommand extends AbstractSubCommand
    {       
        protected var target:StatefulObject;
        
        protected var targetName:String;
        
        protected var caseMap:Object;
        
        protected var defaultCommand:Command;
        
        public function ConditionalCommand()
        {
            super();
            caseMap = {};
        }
        
        public function setTarget(target:StatefulObject):ConditionalCommand{
            this.target = target;
            return this;
        }
        
        public function setTargetByName(name:String):ConditionalCommand{
            this.targetName = name;
            return this;
        }

        protected override function run(...args):void{
         
            var result:Command = null;
            if( target == null && targetName != null && targetName.length > 0 ){
                target = parent.fetch(targetName) as StatefulObject;
            }
            var state:String = target.state;
            if( caseMap.hasOwnProperty( state )){
                result = caseMap[ state ];
            } else {
                result = defaultCommand;
            }
            result.complete(commandCompleteEventListener);
            result.error(commandErrorEventListener);
            result.start(target);
        }
        
        public function addCaseCommand( value:String, command:Command ):ConditionalCommand{
            caseMap[ value ] = command;
            return this;
        }

        public function setDefaultCommand( command:Command ):ConditionalCommand{
            defaultCommand = command;
            return this;
        }
        
        protected function commandCompleteEventListener(event:CommandEvent):void{
            done(event.value);
        }

        protected function commandErrorEventListener(event:CommandEvent):void{
            failed(event.value);            
        }
    }
}