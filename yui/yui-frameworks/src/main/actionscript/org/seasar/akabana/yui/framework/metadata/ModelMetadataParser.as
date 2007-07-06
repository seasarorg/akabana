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
package org.seasar.akabana.yui.framework.metadata {
	
	import mx.binding.utils.BindingUtils;
	import mx.core.Container;
	import mx.core.UIComponent;

	import flash.utils.describeType;
	
	import org.seasar.akabana.yui.framework.core.UIComponentRepository;
	import org.seasar.akabana.yui.framework.core.ClassUtil;
	import org.seasar.akabana.yui.framework.customizer.AutoBindCustomizer;
    
    internal class ModelMetadataParser {
        
        private static const BIND_VIEW:String = "bindView";
    
        public static function parse( owner:Object, target:Object, variableXML:XML, metadataXML:XML ):void{
            var variableName:String = variableXML.@name.toString();
            var model:Object;
            if( Object( owner ).hasOwnProperty( variableName )){
                model = owner[ variableName ];
            } else {
                model = ClassUtil.newInstance(variableXML.@type.toString());
            }

    	    var args:XMLList = metadataXML.arg.( @key=BIND_VIEW );
    	    if( args.length() > 0 ){
                if( UIComponentRepository.hasComponent( args[0].@value.toString() )){
                    var viewContainer:Container = UIComponentRepository.getComponent( args[0].@value.toString()) as Container;
                    AutoBindCustomizer.register( viewContainer, model);         				
                }
            }
            
            target[ variableName ] = model;
        }
    }
}