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
package org.seasar.akabana.yui.framework.bridge
{
CONFIG::FP10{
    import __AS3__.vec.Vector;
}
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;

    import mx.core.Application;
    import mx.core.Container;
    import mx.core.UIComponent;
    import mx.managers.ISystemManager;

    [ExcludeClass]
    public final class Flex3FrameworkBridgePlugin implements IFrameworkBridgePlugin
    {
        private static const ROOT_VIEW:String = "rootView";

        protected var _application:Application;

        public function get application():DisplayObjectContainer{
            return _application;
        }
        
        public function set application(value:DisplayObjectContainer):void{
            _application = value as Application;
        }

        public function get parameters():Object{
            return _application.parameters;
        }

        public function get systemManager():DisplayObject{
            return _application.systemManager as DisplayObject;
        }

        public function get rootView():DisplayObjectContainer{
            var result:UIComponent = null;
            if( _application.hasOwnProperty(ROOT_VIEW)){
                 result = _application[ ROOT_VIEW ] as UIComponent;
            }
            if( result == null ){
                if( application.numChildren > 0 ){
                    result = application.getChildAt(0) as UIComponent;
                }
            }
            return result;
        }

        public function isApplication(component:Object):Boolean{
            return component is Application;
        }

        public function isContainer(component:Object):Boolean{
            return component is Container;
        }
        
        public function isComponent(component:Object):Boolean{
            return (component is UIComponent);
        }
CONFIG::FP9{
        public function getChildren(component:DisplayObjectContainer):Array{
            var result:Array = [];
            var numChildren:int = component.numChildren;
            
            for( var i:int = 0; i < numChildren; i++ ){
                result.push(component.getChildAt(i));
            }
            
            return result;
        }
}
CONFIG::FP10{
        public function getChildren(component:DisplayObjectContainer):Vector.<DisplayObject>{
            var result:Vector.<DisplayObject> = new Vector.<DisplayObject>();
            var numChildren:int = component.numChildren;
            
            for( var i:int = 0; i < numChildren; i++ ){
                result.push(component.getChildAt(i));
            }
            
            return result;
        }
}
    }
}