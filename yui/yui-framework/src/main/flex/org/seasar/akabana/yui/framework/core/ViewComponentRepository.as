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
    
    import mx.core.UIComponent;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.framework.error.ComponentDuplicatedRegistrationError;
    
    public class ViewComponentRepository {
        
        public static var componentNameMap:Dictionary = new Dictionary(true);
        
        public static var componentMap:Dictionary = new Dictionary(true);

        public static var componentClassMap:Dictionary = new Dictionary(true);
        
        public static function addComponent( componentName:String, component:UIComponent ):void{
            var className:String = ClassRef.getReflector(component).name;
            if( componentClassMap[ className ] == null ){
                componentClassMap[ className ] = {};
            }
            var componentClasses:Object = componentClassMap[ className ];

            if( componentName == null ){
                componentName = className;
                if( componentMap[ componentName ] == null ){
                    componentMap[ componentName ] = component;
                    componentNameMap[ component.toString() ] = componentName;
                    componentClasses[ component.name ] = component;
                } else {
                    throw new ComponentDuplicatedRegistrationError("UIコンポーネント登録重複エラー:"+componentName);
                }
            } else {
                componentMap[ componentName ] = component;
                componentNameMap[ component ] = componentName;
                componentNameMap[ component ] = componentName;
                componentClasses[ component.id ] = component;
            }
        }
        
        public static function removeComponent( componentName:String, component:UIComponent ):void{
        	if( componentMap.hasOwnProperty(componentName)){
                componentMap[ componentName ] = null;
                delete componentMap[ componentName ];

                var className:String = ClassRef.getReflector(component).name;
                
                var componentClasses:Object = componentClassMap[ className ];
                componentClasses[ component.id ] = null;
                delete componentClasses[ component.id ];  
        	}        
        }

        public static function getComponentName( component:UIComponent ):String{
            return componentNameMap[ component ];
        }
        
        public static function getComponent( key:Object, componentId:String = null ):UIComponent{
            var component:UIComponent = null;
            
            do{
                if( key is Class ){
                    var className:String = ClassRef.getReflector(key as Class).name;
                    var componentClasses:Object = componentClassMap[ className ];
                    if( componentId != null){
                        component = componentClasses[ componentId ] as UIComponent;
                    } else {
                        for each( var component_:UIComponent in componentClasses ){
                            if( component_ != null ){
                                component = component_;
                            }
                        }
                    }
                    break;
                }   
                if( key is String ){
                    component = componentMap[ key ] as UIComponent;
                    if( componentId != null ){
                        if( component.id != componentId ){
                            component = null;
                        }
                    }
                    break;
                }
            } while( false );
            
            return component;
        }
        
        public static function hasComponent( name:String ):Boolean{
            return componentMap.hasOwnProperty( name );
        }
    }
}