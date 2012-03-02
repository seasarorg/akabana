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
package jp.akb7.yui.bridge
{
    import __AS3__.vec.Vector;

    import flash.errors.IllegalOperationError;
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    
    import mx.managers.ISystemManager;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.IStyleManager2;
    
    import jp.akb7.yui.util.StyleManagerUtil;

    [ExcludeClass]
    public final class FrameworkBridge {
        
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
            result._plugin = new pluginClass();
            return result;
        }

        private var _plugin:IFrameworkBridgePlugin;

        public function get application():DisplayObjectContainer{
            return _plugin.application;
        }

        public function set application(value:DisplayObjectContainer):void{
            _plugin.application = value;
        }
        
        public function get parameters():Object{
            return _plugin.parameters;
        }
        
        public function get rootView():DisplayObjectContainer{
            return _plugin.rootView;
        }

        public function get systemManager():DisplayObject{
            return _plugin.systemManager;
        }

        public function isApplication(application:DisplayObject):Boolean{
            return _plugin.isApplication(application);
        }

        public function isContainer(component:DisplayObject):Boolean{
            return _plugin.isContainer(component);
        }
        
        public function isComponent(component:DisplayObject):Boolean{
            return _plugin.isComponent(component);
        }
        
        public function getDocumentOf(component:DisplayObject):DisplayObject{
            return _plugin.getDocumentOf(component);
        }
        
        public function getChildren(component:DisplayObjectContainer):Vector.<DisplayObject>{
            return _plugin.getChildren(component);
        }
    }
}