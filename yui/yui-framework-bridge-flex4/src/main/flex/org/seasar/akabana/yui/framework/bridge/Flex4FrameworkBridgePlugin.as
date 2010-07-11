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
CONFIG::FP10{
	import __AS3__.vec.Vector;
}

    import mx.core.Container;
    import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
    import mx.managers.ISystemManager;
    
    import spark.components.Application;
    import spark.components.Group;
    import spark.components.SkinnableContainer;
    import spark.components.supportClasses.Skin;

    [ExcludeClass]
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
            return !( component is Skin ) && ( component is SkinnableContainer || component is Group || component is Container );
        }
CONFIG::FP9{
		public function getChildren(component:UIComponent):Array{
			var result:Array = [];
			if( component is IVisualElementContainer ){
				var container:IVisualElementContainer = component as IVisualElementContainer;
				numChildren = container.numElements;				
				for( var j:int = 0; j < numChildren; j++ ){
					result.push(container.getElementAt(j));
				}
			}
			if( result.length == 0 ){
				var numChildren:int = component.numChildren;				
				for( var i:int = 0; i < numChildren; i++ ){
					result.push(component.getChildAt(i));
				}
			}
			return result;
		}
}
CONFIG::FP10{
		public function getChildren(component:UIComponent):Vector.<UIComponent>{
			var result:Vector.<UIComponent> = new Vector.<UIComponent>();
			if( component is IVisualElementContainer ){
				var container:IVisualElementContainer = component as IVisualElementContainer;
				numChildren = container.numElements;
				for( var j:int = 0; j < numChildren; j++ ){
					result.push(container.getElementAt(j));
				}
			}
			if( result.length == 0 ){
				var numChildren:int = component.numChildren;
				for( var i:int = 0; i < numChildren; i++ ){
					result.push(component.getChildAt(i));
				}
			}
			return result;
		}
}		
    }
}