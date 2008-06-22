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
package org.seasar.akabana.yui.framework.core {
    
    import flash.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    
    import mx.core.UIComponent;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    
    public class ComponentRepository {
        
        public static var componentNameMap:Dictionary = new Dictionary(true);
        
        public static var componentMap:Dictionary = new Dictionary(true);
        
        public static var componentChildrenMap:Dictionary = new Dictionary(true);
        
        public static function addComponent( componentName:String, component:Object ):void{
            if( componentMap[ componentName ] == null ){
                componentMap[ componentName ] = component;
            } else {
                throw new Error("UIコンポーネント登録重複エラー:"+componentName);
            }
            componentNameMap[ component ] = componentName;
        }
        
        public static function removeComponent( componentName:String, component:Object ):void{
        	if( componentMap.hasOwnProperty(componentName)){
                componentMap[ componentName ] = null;
                delete componentMap[ componentName ];        	    
        	}
        	
        	if( component != null ){
	        	componentChildrenMap[ component ] = null;
                delete componentChildrenMap[ component ];                
        	}
        }

        public static function getComponentName( component:Object ):String{
            return componentNameMap[ component ];
        }
        
        public static function getComponent( name:String ):Object{
            return componentMap[ name ];
        }
        
        public static function hasComponent( name:String ):Boolean{
            return componentMap.hasOwnProperty( name );
        } 
    }
}