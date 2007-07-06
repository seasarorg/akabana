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
package org.seasar.akabana.yui.framework.core {
    
    import flash.utils.describeType;
    
    public class PropertyUtil{
        
        public static function copyProperties( src:Object, des:Object):void{
			
			var typeXML:XML = describeType(Object(src).constructor).factory[0];
			var typeName:String = typeXML.@type.toString();
			if( typeName != "Object"){
    			var accessorXMLList:XMLList = typeXML.accessor.( @access == "readwrite" );
    			var variableXMLList:XMLList = typeXML.variable;
    			
    			var varName:String;
    			for each( var accessor:XML in accessorXMLList){
    			    varName = accessor.@name.toString();
    			    if( des.hasOwnProperty( varName )){
    			        des[ varName ] = src[ varName ];
    			    }
    			}
    			for each( var variable:XML in variableXMLList){
    			    varName = variable.@name.toString();
    			    if( des.hasOwnProperty( varName )){
    			        des[ varName ] = src[ varName ];
    			    }			    
    			}
			} else {
			    for( var name:String in src ){
    			    if( des.hasOwnProperty( name )){
    			        des[ name ] = src[ name ];
    			    }
			    }
			}
        }
    }
}