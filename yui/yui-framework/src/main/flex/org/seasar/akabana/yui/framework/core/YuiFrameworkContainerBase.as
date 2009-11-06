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
    
    import mx.core.Application;
    import mx.core.Container;
    import mx.managers.CursorManager;
    import mx.managers.DragManager;
    import mx.managers.ISystemManager;
    import mx.managers.PopUpManager;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.StyleManager;
    
    import org.seasar.akabana.yui.core.yui_internal;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import org.seasar.akabana.yui.framework.message.MessageManager;
    import org.seasar.akabana.yui.logging.Logger;

    internal class YuiFrameworkContainerBase implements IYuiFrameworkContainer
    {
        include "../Version.as";

        protected static const _logger:Logger = Logger.getLogger(IYuiFrameworkContainer);
        
        protected static const ROOT_VIEW:String = "rootView";

        {
            CursorManager;
            PopUpManager;
            DragManager;
        }

        protected var _callTimer:Timer = new Timer(100,1);

        protected var _customizers:Array;

        protected var _isApplicationStarted:Boolean = true;

        protected var _application:Application;
        
        protected var _namingConvention:NamingConvention;
        
        protected var _systemManagers:Array;

        public function get systemManagers():Array{
            return _systemManagers;
        }

        public function YuiFrameworkContainerBase(){
        }

        public function addExternalSystemManager(systemManager:ISystemManager ):void{
        }

        public function customizeComponent( container:Container, owner:Container=null):void{
        }
        
        public function uncustomizeComponent( container:Container, owner:Container=null):void{
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

CONFIG::DEBUG{
        protected function getMessage(resourceName:String,...parameters):String{
            return MessageManager.yui_internal::yuiframework.getMessage.apply(null,[resourceName].concat(parameters));
        }
}  
        
        protected function addSystemManager(systemManager:ISystemManager):void{
CONFIG::DEBUG{
            _logger.info("add systemManager"+systemManager);
}              
            _systemManagers.push(systemManager);
        }

        protected function getDefaultCustomizerClasses():Array{
            var customizersDef:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".customizers");
            var classNames:Array = customizersDef.getStyle("classNames") as Array;
            var result:Array = [];
            for each( var className:String in classNames ){
                result.push( customizersDef.getStyle(className));
            }
CONFIG::DEBUG{
            _logger.info("default customizers is "+result);
}            
            return result;
        }
    }
}