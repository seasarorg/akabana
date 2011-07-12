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
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.command.core.IStatefulObject;
    import org.seasar.akabana.yui.command.core.impl.AbstractSubCommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    public class ConditionalCommand extends AbstractSubCommand{ 
        
        protected var _target:IStatefulObject;
        
        protected var _caseMap:Object;
        
        protected var _defaultCommand:ICommand;
        
        public function ConditionalCommand(){
            super();
            _caseMap = {};
        }
        
        public function setTarget(target:IStatefulObject):ConditionalCommand{
            this._target = target;
            return this;
        }

        protected override function run(...args):void{
            var result:ICommand = null;
            if( _target == null && _name != null && _name.length > 0 ){
                _target = parent.commandByName(_name) as IStatefulObject;
            }
            var state:String = _target.state;
            if( _caseMap.hasOwnProperty( state )){
                result = _caseMap[ state ];
            } else {
                result = _defaultCommand;
            }
            result.complete(commandCompleteEventListener);
            result.error(commandErrorEventListener);
            result.start(_target);
        }
        
        public function addCaseCommand( value:String, command:ICommand ):ConditionalCommand{
            _caseMap[ value ] = command;
            return this;
        }

        public function setDefaultCommand( command:ICommand ):ConditionalCommand{
            _defaultCommand = command;
            return this;
        }
        
        protected function commandCompleteEventListener(event:CommandEvent):void{
            done(event.data);
        }

        protected function commandErrorEventListener(event:CommandEvent):void{
            failed(event.data);
        }
    }
}