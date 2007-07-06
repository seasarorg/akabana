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
    
    import org.seasar.akabana.yui.resources.embed.EmbedXmlReader;
    
    internal class AutoBindingDefaultPropertyResolver {

		[Embed(source='AutoBindingDefaultProperty.xml', mimeType='application/octet-stream')]
        private static const bindingPropertyMapEmbed:Class;

        private static const initialized:Boolean = initialize();

        private static var bindingPropertyXml:XML;

		private static function initialize():Boolean{
			var embedReader:EmbedXmlReader = new EmbedXmlReader();
		    bindingPropertyXml = embedReader.read( bindingPropertyMapEmbed ) as XML;
		    return true;
		}
			
        public static function getBindingPropertyName( componentName:String ):String {
            var propertyName:String = null;
            var components:XMLList = bindingPropertyXml.component.(@name == componentName);
            if( components.length() > 0 ){
                propertyName = components[0].children()[0].toString();
            }
            return propertyName;
        }   
    }
}