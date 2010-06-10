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
package org.seasar.akabana.yui.framework.bridge
{
    import flash.utils.describeType;

    import mx.core.UIComponent;
    import mx.managers.ISystemManager;

    import spark.components.Application;
    import spark.components.Group;
    import spark.components.SkinnableContainer;
    import spark.components.supportClasses.Skin;

    public final class Flex4FrameworkBridgePlugin implements IFrameworkBridgePlugin
    {
		private static const ROOT_VIEW:String = "rootView";

        protected var _application:Application;

        public function get application():UIComponent{
            return _application;
        }

		public function set application(value:UIComponent):void{
			_application = value as Application;
		}

        public function get parameters():Object{
            return _application.parameters;
        }

        public function get systemManager():ISystemManager{
            return _application.systemManager;
        }

        public function get rootView():UIComponent{
            var result:UIComponent = null;
            if( _application.hasOwnProperty(ROOT_VIEW)){
             	result = _application[ ROOT_VIEW ] as UIComponent;
            }
            return result;
        }

        public function isApplication(component:Object):Boolean{
            return (component is spark.components.Application);
        }

        public function isContainer(component:Object):Boolean{
            return !( component is Skin ) && ( component is SkinnableContainer || component is Group );
        }
    }
}