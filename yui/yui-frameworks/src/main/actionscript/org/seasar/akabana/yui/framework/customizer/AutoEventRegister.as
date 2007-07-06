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
package org.seasar.akabana.yui.framework.auto {

    import flash.utils.describeType;
    
    import mx.core.Container;
    import mx.core.UIComponent;
    
    public class AutoEventRegister {

        private static var HANDLER:String = "Handler";
        
        public static function register( view:Container, logic:Object ):void {
            var viewContainerChildren:Array = view.getChildren();
			var logicDescribeTypeXml:XML = describeType(Object(logic).constructor);
			
			var methods:XMLList;   			
			var childId:String;
			var methodName:String;
			var handlerIndex:int;
			var eventName:String;
			for each( var child:UIComponent in viewContainerChildren ){
				childId = child.id;
				methods = logicDescribeTypeXml.factory.method.(@name.toString().indexOf(childId) == 0 );
				for each( var method:XML in methods ){
				    methodName = method.@name.toString();
				    handlerIndex = methodName.lastIndexOf(HANDLER);
				    eventName = methodName.substr(childId.length,1).toLocaleLowerCase() + methodName.substring(childId.length+1,handlerIndex);
   					view[childId].addEventListener(eventName, logic[ methodName ]);
				}
			}
        }   
    }
}