/*
 * Copyright 2004-2008 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.framework.core
{
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import mx.managers.CursorManager;
    import mx.managers.DragManager;
    import mx.managers.PopUpManager;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.StyleManager;

    import org.seasar.akabana.yui.framework.message.MessageManager;
    import org.seasar.akabana.yui.logging.Logger;

    internal class YuiFrameworkContainerBase
    {
        include "../Version.as";

        protected static const ROOT_VIEW:String = "rootView";

        {
            CursorManager;
            PopUpManager;
            DragManager;
        }

        protected var _callTimer:Timer = new Timer(100,1);

        public function YuiFrameworkContainerBase(){
        }

        public function callLater(callBack:Function):void{
            _callTimer.addEventListener(TimerEvent.TIMER,
            function timerHandler(event:TimerEvent):void{
                _callTimer.removeEventListener(TimerEvent.TIMER,arguments.callee);
                callBack.call();
            }
            ,false,0,true
            );
            _callTimer.start();
        }

        public function getMessage(resourceName:String,...parameters):String{
            return MessageManager.yuiframework.getMessage.apply(null,[resourceName].concat(parameters));
        }


        protected function getDefaultCustomizerClasses():Array{
            var customizersDef:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".customizers");
            var classNames:Array = customizersDef.getStyle("classNames") as Array;
            var result:Array = [];
            for each( var className:String in classNames ){
                result.push( customizersDef.getStyle(className));
            }
            return result;
        }
    }
}