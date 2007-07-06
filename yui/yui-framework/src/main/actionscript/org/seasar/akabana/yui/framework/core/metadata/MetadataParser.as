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
package org.seasar.akabana.yui.framework.core.metadata {
    
    import flash.utils.describeType;
    
    import mx.core.Container;
    import mx.core.UIComponent;
    
    public class MetadataParser {
        
        private static const PARSE:String = "parse";
        
        private static const METADATA:String = "Metadata";
        
        public static function parse( owner:Container, target:Object ):void{
            var describeTypeXml:XML = describeType(Object(target).constructor);
		    var variableXMLList:XMLList = describeTypeXml.factory.variable;

			for each( var variableXML:XML in variableXMLList ){
                parseVariableMetadata(owner,target,variableXML);
			}
		}
		
		private static function parseVariableMetadata( owner:Container, target:Object, variableXML:XML):void{
            var metadataXMLList:XMLList = variableXML.metadata;
            var metadataName:String;
            var parseMetadataFunction:Function;
            
            for each( var metadataXML:XML in metadataXMLList ){
                metadataName = metadataXML.@name.toString();
                
                parseMetadataFunction = null;
                try{
                    parseMetadataFunction = MetadataParser[ PARSE + metadataName + METADATA];
                }catch( e:Error ){
                    trace( "Not Found MetadataParse Function :" + metadataName + "@" + owner);
                }
                if( parseMetadataFunction != null && parseMetadataFunction is Function){
                    parseMetadataFunction.apply(null,[owner, target, variableXML, metadataXML]);
                }
            } 
		}

        public static function parseViewMetadata( owner:Container, target:Object, variableXML:XML, metadataXML:XML ):void{
            ViewMetadataParser.parse( owner, target, variableXML, metadataXML);
        }
     
        public static function parseModelMetadata( owner:Container, target:Object, variableXML:XML, metadataXML:XML ):void{
            ModelMetadataParser.parse( owner, target, variableXML, metadataXML);
        }

        public static function parseServiceMetadata( owner:Container, target:Object, variableXML:XML, metadataXML:XML ):void{
            ServiceMetadataParser.parse( owner, target, variableXML, metadataXML);
        }
    }
}