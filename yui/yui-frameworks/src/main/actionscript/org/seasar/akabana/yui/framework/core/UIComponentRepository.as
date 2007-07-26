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
    
    import flash.utils.Dictionary;
    
    import mx.core.UIComponent;
    
    public class UIComponentRepository {
        
        private static var componentMap:Dictionary = new Dictionary(true);
        
        private static var componentChildrenMap:Dictionary = new Dictionary(true);
        
        public static function addComponent( component:UIComponent ):void{
            const componentName:String = UIComponentUtil.getComponentName(component);
            if( componentMap[ componentName ] == null ){
                componentMap[ componentName ] = component;
            } else {
                throw new Error("UIコンポーネント登録重複エラー");
            }
            
            var parentName:String = UIComponentUtil.getComponentName( component.parentDocument as UIComponent );
            var componentChildrenArray:Array = componentChildrenMap[ parentName ];
            if( componentChildrenArray == null ){
                componentChildrenArray = componentChildrenMap[ parentName ] = [];
            }
            componentChildrenArray.push(component);
        }
        
        public static function getComponent( name:String ):UIComponent{
            return componentMap[ name ] as UIComponent;
        }
        
        public static function hasComponent( name:String ):Boolean{
            return componentMap.hasOwnProperty( name );
        }

        public static function getComponentChildren( object:Object ):Array{
            var childrenArray:Array = [];
            do {
                if( object is String ){
                    childrenArray = componentChildrenMap[ object as String ];
                    break;
                }
                if( object is UIComponent ){
                    childrenArray = componentChildrenMap[ UIComponentUtil.getComponentName( object as UIComponent )];
                    break;
                }
            } while( false );
            
            return childrenArray;
        }
    }
}