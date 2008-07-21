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
    
    import flash.utils.Dictionary;
    
    import mx.core.Container;
    import mx.core.UIComponent;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.framework.error.ComponentDuplicatedRegistrationError;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    
    public class ViewComponentRepository {
        
        public static var componentNameMap:Dictionary = new Dictionary(true);
        
        public static var componentMap:Dictionary = new Dictionary(true);

        public static var componentClassMap:Dictionary = new Dictionary(true);
        
        public static var componentChildrenMap:Dictionary = new Dictionary(true);
        
        public static function addComponent( componentName:String, component:UIComponent ):void{
            var className:String = ClassRef.getReflector(component).name;
            if( componentName == null ){
                componentName = className;
                if( componentMap[ componentName ] == null ){
                    componentMap[ componentName ] = component;
                    componentClassMap[ componentName ] = component;
                    componentNameMap[ component ] = componentName;
                } else {
                    throw new ComponentDuplicatedRegistrationError("UIコンポーネント登録重複エラー:"+componentName);
                }
            } else {
                componentMap[ componentName ] = component;
                componentNameMap[ component ] = componentName;
                componentClassMap[ className ] = component;
                componentNameMap[ component ] = componentName;
            }
            
//            addRelation( component.parentDocument as Container, componentName, component );                
        }
        
        public static function removeComponent( componentName:String, component:UIComponent ):void{
        	if( componentMap.hasOwnProperty(componentName)){
                componentMap[ componentName ] = null;
                delete componentMap[ componentName ];

                var className:String = ClassRef.getReflector(component).name;
                componentClassMap[ className ] = null;
                delete componentClassMap[ className ];  
        	}
        	
        	if( component != null ){
	        	removeParentDocumentRelation( component.parentDocument as Container, componentName, component );	        	

                componentChildrenMap[ component ] = null;
                delete componentChildrenMap[ component ];
        	}
        }

        public static function getComponentName( component:UIComponent ):String{
            return componentNameMap[ component ];
        }
        
        public static function getComponent( key:Object ):UIComponent{
            var component:UIComponent = null;
            
            do{
                if( key is Class ){
                    var className:String = ClassRef.getReflector(key as Class).name;
                    component = componentClassMap[ className ] as UIComponent;
                    break;
                }   
                if( key is String ){
                    component = componentMap[ key ] as UIComponent;
                    break;
                }
            } while( false );
            
            return component;
        }
        
        public static function hasComponent( name:String ):Boolean{
            return componentMap.hasOwnProperty( name );
        }

        public static function hasComponentChildren( object:Object ):Boolean{
            var hasChildren:Boolean = false;
            var componentName:String = "";
            do {
                if( object is String ){
                    componentName = object as String;
                    break;
                }
                if( object is UIComponent ){
                    componentName = UIComponentUtil.getName( object as UIComponent );
                    break;
                }
            } while( false );
            
            return componentChildrenMap.hasOwnProperty(componentName);
        }

        public static function getComponentChildren( object:Object ):Object{
            var children:Object = Dictionary;
            do {
                if( object is String ){
                    children = componentChildrenMap[ object as String ] as Dictionary;
                    break;
                }
                if( object is UIComponent ){
                    children = componentChildrenMap[ UIComponentUtil.getName( object as UIComponent )] as Dictionary;
                    break;
                }
            } while( false );
            
            if( children == null ){
                children = {};
            }
            return children;
        }
        
        private static function addRelation( parent:Container, componentName:String, child:UIComponent ):void{            
            var parentClassName:String = ClassRef.getQualifiedClassName( parent );
            var componentChildrenMap_:Dictionary = componentChildrenMap[ parentClassName ];
            if( componentChildrenMap_ == null ){
                componentChildrenMap_ = componentChildrenMap[ parentClassName ] = new Dictionary(true);
            }
            componentChildrenMap_[ componentName ] = child;
        }
        
        private static function removeParentDocumentRelation( parent:Container, componentName:String, child:UIComponent ):void{            
            var parentClassName:String = ClassRef.getQualifiedClassName( parent );
            var componentChildrenMap_:Dictionary = componentChildrenMap[ parentClassName ] as Dictionary;
            if( componentChildrenMap_ != null ){
            	if( componentChildrenMap_.hasOwnProperty(componentName)){
            	    componentChildrenMap_[ componentName ] = null;
            	    delete componentChildrenMap_[ componentName ];
            	}
            }
        }   
    }
}