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
    
    import org.seasar.akabana.yui.framework.component.UIComponentRepository;
    
    internal class ViewMetadataParser {
        
        public static function parse( owner:Object, target:Object, variableXML:XML, metadataXML:XML ):void{
            var variableName:String = variableXML.@name.toString();
            
            if( UIComponentRepository.hasComponent( variableName )){
                var viewContainer:Container = UIComponentRepository.getComponent(variableName) as Container;
                AutoEventRegister.register( viewContainer, target );
                target[ variableName ] = viewContainer;
            }
        }
    }
}