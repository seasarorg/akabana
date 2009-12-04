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
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.error.ComponentDuplicatedRegistrationError;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    
    public class ViewComponentRepository {
        
        public static var componentMap:Dictionary = new Dictionary(true);

        public static var componentInstanceMap:Dictionary = new Dictionary(true);
        
        public static function addComponent( component:UIComponent ):void{
            var className:String = YuiFrameworkGlobals.namingConvention.getClassName(component);
            if( componentInstanceMap[ className ] == null ){
                componentInstanceMap[ className ] = new Dictionary(true);
            }
            var componentInstances:Object = componentInstanceMap[ className ];

			var componentId:String = UIComponentUtil.getName(component);
            if( componentMap[ componentId ] == null ){
                componentMap[ componentId ] = component;
                componentInstances[ componentId ] = component;
            } else {
                throw new ComponentDuplicatedRegistrationError(componentId);
            }
        }
        
        public static function removeComponent( component:UIComponent ):void{
        	if( componentMap.hasOwnProperty(component.name)){
        		var componentId:String = UIComponentUtil.getName(component);
                componentMap[ componentId ] = null;
                delete componentMap[ componentId ];

                var className:String = YuiFrameworkGlobals.namingConvention.getClassName(component);
                
                var componentInstances:Object = componentInstanceMap[ className ];
                componentInstances[ componentId ] = null;
                delete componentInstances[ componentId ];  
        	}        
        }
        
        public static function getComponent( key:Object, componentId:String = null):UIComponent{
            var component:UIComponent = null;
            var componentInstances:Object;
            do{
                if( key is Class ){
                    var className:String = YuiFrameworkGlobals.namingConvention.getClassName(component);
                    componentInstances = componentInstanceMap[ className ];
                    if( componentId != null){
                        component = componentInstances[ componentId ] as UIComponent;
                    } else {
                        for each( var component_:UIComponent in componentInstances ){
                            if( component_ != null ){
                                component = component_;
                                break;
                            }
                        }
                    }
                    break;
                }   
                if( key is String ){
                    if( componentId != null ){
						componentInstances = componentInstanceMap[ key ];
						component = componentInstances[ componentId ] as UIComponent;
                    } else {
                    	component = componentMap[ key ] as UIComponent;
                    }
                    break;
                }
            } while( false );
            
            return component;
        }

        public static function getComponentByParent( key:Class, parent:Container):UIComponent{
            var component:UIComponent = null;
            
            var className:String = ClassRef.getReflector(key).name;
            var componentInstances:Object = componentInstanceMap[ className ];

            for each( var component_:UIComponent in componentInstances ){
                if( parent.contains(component_) ){
                    component = component_;
                    break;
                }
            }
            
            return component;
        }
        
        public static function hasComponent( name:String ):Boolean{
            return componentMap.hasOwnProperty( name );
        }
    }
}