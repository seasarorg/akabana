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
package org.seasar.akabana.yui.framework.bridge
{
CONFIG::FP10{
    import __AS3__.vec.Vector;
}
    import flash.errors.IllegalOperationError;
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    
    import mx.core.UIComponent;
    import mx.managers.ISystemManager;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.IStyleManager2;
    
    import org.seasar.akabana.yui.core.ns.yui_internal;
    import org.seasar.akabana.yui.framework.util.StyleManagerUtil;

    [ExcludeClass]
    public class FrameworkBridge
    {
        public static function initialize():FrameworkBridge{
            var styleManager:IStyleManager2 = StyleManagerUtil.getStyleManager();
            var result:FrameworkBridge = new FrameworkBridge();
            var frameworkBridgeCss:CSSStyleDeclaration = styleManager.getStyleDeclaration("org.seasar.akabana.yui.framework.core.YuiFrameworkSettings");
            if( frameworkBridgeCss == null ){
                frameworkBridgeCss = styleManager.getStyleDeclaration("YuiFrameworkSettings");
                if( frameworkBridgeCss == null ){
                    throw new IllegalOperationError("No Framework BridgePlugin");
                }
            }
            var pluginClass:Class = frameworkBridgeCss.getStyle("frameworkBridgePlugin");
            result.frameworkBridgePlugin = new pluginClass();
            return result;
        }

        protected var frameworkBridgePlugin:IFrameworkBridgePlugin;

        public function get application():DisplayObjectContainer{
            return frameworkBridgePlugin.application;
        }

        public function set application(value:DisplayObjectContainer):void{
            frameworkBridgePlugin.application = value;
        }
        
        public function get parameters():Object{
            return frameworkBridgePlugin.parameters;
        }
        
        public function get rootView():DisplayObjectContainer{
            return frameworkBridgePlugin.rootView;
        }

        public function get systemManager():DisplayObject{
            return frameworkBridgePlugin.systemManager;
        }

        public function isApplication(application:DisplayObject):Boolean{
            return frameworkBridgePlugin.isApplication(application);
        }

        public function isContainer(component:DisplayObject):Boolean{
            return frameworkBridgePlugin.isContainer(component);
        }
        
        public function isComponent(component:DisplayObject):Boolean{
            return frameworkBridgePlugin.isComponent(component);
        }
CONFIG::FP9{
        public function getChildren(component:DisplayObjectContainer):Array{
            return frameworkBridgePlugin.getChildren(component);
        }
}
CONFIG::FP10{
        public function getChildren(component:DisplayObjectContainer):Vector.<DisplayObject>{
            return frameworkBridgePlugin.getChildren(component);
        }
}
    }
}