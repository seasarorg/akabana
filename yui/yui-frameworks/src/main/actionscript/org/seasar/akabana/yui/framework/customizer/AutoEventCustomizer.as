/*
 * Copyright 2004-2007 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.framework.customizer {

    import flash.utils.describeType;
    
    import mx.core.Container;
    import mx.core.UIComponent;
    import org.seasar.akabana.yui.framework.core.UIComponentUtil;
    import org.seasar.akabana.yui.framework.core.UIComponentRepository;
    
    public class AutoEventCustomizer {

        private static var HANDLER:String = "Handler";
        
        private static var ON:String = "on";
        
        public static function customizer( view:Container, logic:Object ):void {
            var viewContainerChildren:Array = UIComponentRepository.getComponentChildren(view);
			
			for each( var component:UIComponent in viewContainerChildren ){
				doCustomizeByComponent( component.name, component, logic );
			}
			doCustomizeByComponent( ON, view, logic );
        }

        private static function doCustomizeByComponent( componentName:String, component:UIComponent, logic:Object ):void {
			const methods:XMLList = describeType(Object(logic).constructor).factory.method.(@name.toString().indexOf(componentName) == 0 );
			
			var methodName:String;
			var handlerIndex:int;
			var eventName:String;
			for each( var method:XML in methods ){
			    methodName = method.@name.toString();
			    handlerIndex = methodName.lastIndexOf(HANDLER);
			    eventName = methodName.substr(componentName.length,1).toLocaleLowerCase() + methodName.substring(componentName.length+1,handlerIndex);
		        
	        	//tracecomponentName + ".addEventListener(" + eventName + "," + logic + "." + methodName +")");
	        	component.removeEventListener(eventName, logic[ methodName ],false);
	        	component.addEventListener(eventName, logic[ methodName ],false,0.0,true);
			}
        } 
    }
}