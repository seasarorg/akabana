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
package org.seasar.akabana.yui.framework.component {
    
    import flash.utils.Dictionary;
    
    import mx.core.UIComponent;
    
    public class UIComponentRepository {
        
        private static var componentMap:Dictionary = new Dictionary(true);
        
        public static function addComponent( component:UIComponent ):void{
            //TODO nameもnullなら、component.classから
            const componentName:String = component.id != null ? component.id : component.name;
            componentMap[ componentName ] = component;
        }
        
        public static function getComponent( name:String ):UIComponent{
            return componentMap[ name ] as UIComponent;
        }
        
        public static function hasComponent( name:String ):Boolean{
            return componentMap.hasOwnProperty( name );
        }
    }
}