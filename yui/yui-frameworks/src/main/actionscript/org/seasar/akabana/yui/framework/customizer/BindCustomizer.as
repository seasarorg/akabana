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
    import mx.binding.utils.BindingUtils;
    
    public class BindCustomizer {

        private static const READ_WRITE:String = "readwrite";
        
        public static function register( view:Container, model:Object ):void {
            var typeXML:XML = describeType(Object(model).constructor).factory[0];
            parseFields( typeXML.accessor.( @access == READ_WRITE ), view, model );
            parseFields( typeXML.variable, view, model );            				
        }
        
        private static function parseFields( fieldsXMLList:XMLList, view:Container, model:Object ):void{
			var varName:String;
			var bindName:String;
			var component:UIComponent;
			var getBindNameFunction:Function;
			
			for each( var fieldXml:XML in fieldsXMLList){
			    varName = fieldXml.@name.toString();
			    if( view.hasOwnProperty(varName) ){
			        component = view[ varName ];
                    
                    bindName = AutoBindingDefaultPropertyResolver.getBindingPropertyName(component.className);
		            BindingUtils.bindProperty( component, bindName, model, varName);
		            BindingUtils.bindProperty( model, varName, component, bindName);
			    }
			}
        }
    }
}