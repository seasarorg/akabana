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
CONFIG::FP10{
    import __AS3__.vec.Vector;
}

    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import mx.core.UIComponent;
    import mx.managers.CursorManager;
    import mx.managers.DragManager;
    import mx.managers.ISystemManager;
    import mx.managers.PopUpManager;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.IStyleManager2;

    import org.seasar.akabana.yui.core.yui_internal;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import org.seasar.akabana.yui.framework.customizer.IComponentCustomizer;
    import org.seasar.akabana.yui.framework.message.MessageManager;
    import org.seasar.akabana.yui.framework.util.StyleManagerUtil;
    import org.seasar.akabana.yui.logging.Logger;

    [ExcludeClass]
    internal class YuiFrameworkContainerBase implements IYuiFrameworkContainer
    {
        include "../Version.as";
		
CONFIG::DEBUG {
        protected static const _logger:Logger = Logger.getLogger(IYuiFrameworkContainer);
}
        {
            CursorManager;
            PopUpManager;
            DragManager;
        }

        protected var _callTimer:Timer = new Timer(100,1);

CONFIG::FP9{
        protected var _customizers:Array;
}
CONFIG::FP10{
        protected var _customizers:Vector.<IComponentCustomizer>;
}
        protected var _isApplicationStarted:Boolean = true;

        protected var _namingConvention:NamingConvention;

CONFIG::FP9{
        protected var _systemManagers:Array;

        public function get systemManagers():Array{
            return _systemManagers;
        }
}
CONFIG::FP10{
        protected var _systemManagers:Vector.<ISystemManager>;

        public function get systemManagers():Vector.<ISystemManager>{
            return _systemManagers;
        }
}

        public function YuiFrameworkContainerBase(){
        }

        public function addExternalSystemManager(systemManager:ISystemManager ):void{
        }

        public function customizeComponent( container:UIComponent, owner:UIComponent=null):void{
        }

        public function uncustomizeComponent( container:UIComponent, owner:UIComponent=null):void{
        }

        public function callLater(callBack:Function):void{
            _callTimer
                .addEventListener(
                    TimerEvent.TIMER,
                    function timerHandler(event:TimerEvent):void{
                        _callTimer.stop();
                        _callTimer.removeEventListener(TimerEvent.TIMER,arguments.callee);
                        callBack.call();
                    }
                );
            _callTimer.start();
        }

CONFIG::DEBUG{
        protected function getMessage(resourceName:String,...parameters):String{
            return MessageManager.yui_internal::yuiframework.getMessage.apply(null,[resourceName].concat(parameters));
        }
}

        protected function addSystemManager(systemManager:ISystemManager):void{
CONFIG::DEBUG{
            _logger.debug("add systemManager"+systemManager);
}
            _systemManagers.push(systemManager);
        }

        protected function getDefaultCustomizerClasses():Array{
		    var styleManager:IStyleManager2 = StyleManagerUtil.getStyleManager();
            var customizersDef:CSSStyleDeclaration = styleManager.getStyleDeclaration(".customizers");
            var classNames:Object = customizersDef.getStyle("classNames");
            if( classNames is String ){
                classNames = [ classNames ];
            }
            var result:Array = [];
            for each( var className:String in classNames ){
                result.push( customizersDef.getStyle(className));
            }
CONFIG::DEBUG{
            _logger.debug("default customizers is "+result);
}
            return result;
        }
    }
}