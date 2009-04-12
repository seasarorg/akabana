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
    import caurina.transitions.Tweener;
    import caurina.transitions.properties.CurveModifiers;
    
    import flash.display.DisplayObject;
    
    import org.seasar.akabana.yui.command.core.impl.AbstractCommand;

    public class TweenerCommand extends AbstractCommand
    {
        protected var target:DisplayObject;
        protected var parameter:Object;
        
        public function TweenerCommand(shape:DisplayObject,parameter:Object)
        {
            super();
            this.target = shape;
            this.parameter = parameter;
        }

        protected override function doRun(...args):void{
            trace("command:",this);
            parameter["onComplete"] = rotateCompleteHandler;
            parameter["time"] = args[0];
            Tweener.addTween(target, parameter);
        }  
        
        private function rotateCompleteHandler():void{
            complete("value"); 
        }
    }
}