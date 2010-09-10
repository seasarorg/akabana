/*
 * Copyright 2004-2010 the Seasar Foundation and the Others.
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
    import org.seasar.akabana.yui.framework.customizer.IElementCustomizer;
    import org.seasar.akabana.yui.framework.message.MessageManager;
    import org.seasar.akabana.yui.framework.util.StyleManagerUtil;
    import org.seasar.akabana.yui.logging.Logger;
    import flash.utils.Dictionary;
    import org.seasar.akabana.yui.core.reflection.ClassRef;

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
        protected var _customizers:Vector.<IElementCustomizer>;
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

        protected var _systemManagerMap:Dictionary;

        public function YuiFrameworkContainerBase(){
CONFIG::FP9{
            _systemManagers = [];
}
CONFIG::FP10{
            _systemManagers = new Vector.<ISystemManager>;
}
            _systemManagerMap = new Dictionary(true);
        }

        public function addExternalSystemManager(systemManager:ISystemManager ):void{
        }
        
        public function removeExternalSystemManager(sm:ISystemManager ):void{
        }

        public function customizeView( container:UIComponent ):void{
        }

        public function uncustomizeView( container:UIComponent ):void{
        }
        
        public function customizeComponent( container:UIComponent, child:UIComponent):void{
        }
        
        public function uncustomizeComponent( container:UIComponent, child:UIComponent):void{
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

        protected function addSystemManager(sm:ISystemManager):void{
CONFIG::DEBUG{
            _logger.debug("add systemManager"+sm);
}
            _systemManagers.push(sm);
            _systemManagerMap[ sm ] = _systemManagers.length-1;
        }
        
        protected function removeSystemManager(sm:ISystemManager):void{
CONFIG::DEBUG{
            _logger.debug("remove systemManager"+sm);
}
            if( sm in _systemManagerMap ){
                var index:int = _systemManagerMap[ sm ] as int;
                delete _systemManagerMap[ sm ];
                _systemManagers.splice(index,1);
            }
        }

        protected function getDefaultCustomizerClasses():Array{
            const styleManager:IStyleManager2 = StyleManagerUtil.getStyleManager();
            const customizersDef:CSSStyleDeclaration = styleManager.getStyleDeclaration(".customizers");
            const defaultFactory:Function = customizersDef.defaultFactory;

            const result:Array = [];
            const keys:Array = [];

            var customizers:Object = {};
            if (defaultFactory != null)
            {
                defaultFactory.prototype = {};
                customizers = new defaultFactory();
            }

            var customizer:Class;
            for( var key:String in customizers ){
                keys.push(key);
            }
            keys.sort();
            for( var i:int = 0; i < keys.length; i++ ){                
                customizer = customizers[keys[i]] as Class;
                result.push(customizer);
            }
CONFIG::DEBUG{
            _logger.debug("default customizers is "+result);
}
            return result;
        }
    }
}