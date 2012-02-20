/*
 * Copyright 2004-2011 the Seasar Foundation and the Others.
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
package net.akb7.yui.core {

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    
    import net.akb7.yui.core.reflection.ClassRef;
    import net.akb7.yui.YuiFrameworkGlobals;
    import net.akb7.yui.error.ComponentDuplicatedRegistrationError;
    import net.akb7.yui.util.UIComponentUtil;

    [ExcludeClass]
    /**
     * 
     */
    public final class ViewComponentRepository {
        
        /**
         * @private
         */
        private static const COMPONENT_INSTANCE_MAP:Dictionary = new Dictionary(true);
        
        /**
         * @private
         */
        private static const VIEW_MAP:Dictionary = new Dictionary(true);

        /**
         * 
         * @return 
         * 
         */
        public static function get allView():Dictionary{
            return VIEW_MAP;
        }
        
        /**
         * 
         * @param component
         * 
         */
        public static function addComponent( component:DisplayObject ):void{
            var className:String = getCanonicalName(component);
            if( COMPONENT_INSTANCE_MAP[ className ] == null ){
                COMPONENT_INSTANCE_MAP[ className ] = new Dictionary(true);
            }
            var componentInstances:Object = COMPONENT_INSTANCE_MAP[ className ];

            var componentId:String = YuiFrameworkGlobals.namingConvention.getComponentName(component);
            if( VIEW_MAP[ componentId ] == null ){
                VIEW_MAP[ componentId ] = component;
                componentInstances[ componentId ] = component;
            } else {
                throw new ComponentDuplicatedRegistrationError(componentId);
            }
        }

        /**
         * 
         * @param component
         * 
         */
        public static function removeComponent( component:DisplayObject ):void{
            if( VIEW_MAP.hasOwnProperty(component.name)){
                var componentId:String = YuiFrameworkGlobals.namingConvention.getComponentName(component);
                VIEW_MAP[ componentId ] = null;
                delete VIEW_MAP[ componentId ];

                var className:String = getCanonicalName(component);

                var componentInstances:Object = COMPONENT_INSTANCE_MAP[ className ];
                componentInstances[ componentId ] = null;
                delete componentInstances[ componentId ];
            }
        }

        /**
         * 
         * @param key
         * @param componentId
         * @return 
         * 
         */
        public static function getComponent( key:Object, componentId:String = null):DisplayObjectContainer{
            var result:DisplayObjectContainer = null;
            var componentInstances:Object;
            do{
                if( key is Class ){
                    var className:String = getCanonicalName(result);
                    componentInstances = COMPONENT_INSTANCE_MAP[ className ];
                    if( componentId != null){
                        result = componentInstances[ componentId ] as DisplayObjectContainer;
                    } else {
                        for each( var component_:DisplayObjectContainer in componentInstances ){
                            if( component_ != null ){
                                result = component_;
                                break;
                            }
                        }
                    }
                    break;
                }
                if( key is String ){
                    if( componentId != null ){
                        componentInstances = COMPONENT_INSTANCE_MAP[ key ];
                        result = componentInstances[ componentId ] as DisplayObjectContainer;
                    } else {
                        result = VIEW_MAP[ key ] as DisplayObjectContainer;
                    }
                    break;
                }
            } while( false );

            return result;
        }

        /**
         * 
         * @param key
         * @param parent
         * @return 
         * 
         */
        public static function getComponentByParent( key:Class, parent:DisplayObjectContainer):DisplayObject{
            var component:DisplayObject = null;

            var className:String = getCanonicalName(key);
            var componentInstances:Object = COMPONENT_INSTANCE_MAP[ className ];

            for each( var component_:DisplayObject in componentInstances ){
                if( parent.contains(component_) ){
                    component = component_;
                    break;
                }
            }

            return component;
        }

        /**
         * 
         * @param name
         * @return 
         * 
         */
        public static function hasComponent( name:String ):Boolean{
            return VIEW_MAP.hasOwnProperty( name );
        }
    }
}