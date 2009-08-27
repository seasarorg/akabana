/*
 * Copyright 2004-2008 the Seasar Foundation and the Others.
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
package org.seasar.akabana.yui.framework.util
{

    import mx.core.UIComponent;
    import mx.core.UIComponentDescriptor;
    import mx.core.mx_internal;
    
    public final class UIComponentUtil {
        
        public static function getName( component:UIComponent ):String{
            var componentName:String = null;
            if( component != null ){
                componentName = component.id;
                if( componentName == null ){
                    componentName = component.name;
                }
            }
            return componentName;
        }
        
        public static function getDocumentDescriptor( component:UIComponent ):UIComponentDescriptor{
        	return component.mx_internal::_documentDescriptor;
        }    

        public static function getDocumentProperties( component:UIComponent ):Object{
        	return getDocumentDescriptor(component).properties;
        }    
    }
}