/*
 * Copyright 2004-2010 the Seasar Foundation and the Others.
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

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.error.ComponentDuplicatedRegistrationError;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;

    [ExcludeClass]
    public class ViewComponentRepository {
        
        public static const componentInstanceMap:Dictionary = new Dictionary(true);
        
        private static const _viewDic:Dictionary = new Dictionary(true);

		public static function get allView():Dictionary{
			return _viewDic;
		}
		
        public static function addComponent( component:DisplayObject ):void{
            var className:String = getCanonicalName(component);
            if( componentInstanceMap[ className ] == null ){
                componentInstanceMap[ className ] = new Dictionary(true);
            }
            var componentInstances:Object = componentInstanceMap[ className ];

            var componentId:String = YuiFrameworkGlobals.namingConvention.getComponentName(component);
            if( _viewDic[ componentId ] == null ){
                _viewDic[ componentId ] = component;
                componentInstances[ componentId ] = component;
            } else {
                throw new ComponentDuplicatedRegistrationError(componentId);
            }
        }

        public static function removeComponent( component:DisplayObject ):void{
            if( _viewDic.hasOwnProperty(component.name)){
                var componentId:String = YuiFrameworkGlobals.namingConvention.getComponentName(component);
                _viewDic[ componentId ] = null;
                delete _viewDic[ componentId ];

                var className:String = getCanonicalName(component);

                var componentInstances:Object = componentInstanceMap[ className ];
                componentInstances[ componentId ] = null;
                delete componentInstances[ componentId ];
            }
        }

        public static function getComponent( key:Object, componentId:String = null):DisplayObjectContainer{
            var result:DisplayObjectContainer = null;
            var componentInstances:Object;
            do{
                if( key is Class ){
                    var className:String = getCanonicalName(result);
                    componentInstances = componentInstanceMap[ className ];
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
                        componentInstances = componentInstanceMap[ key ];
                        result = componentInstances[ componentId ] as DisplayObjectContainer;
                    } else {
                        result = _viewDic[ key ] as DisplayObjectContainer;
                    }
                    break;
                }
            } while( false );

            return result;
        }

        public static function getComponentByParent( key:Class, parent:DisplayObjectContainer):DisplayObject{
            var component:DisplayObject = null;

            var className:String = getCanonicalName(key);
            var componentInstances:Object = componentInstanceMap[ className ];

            for each( var component_:DisplayObject in componentInstances ){
                if( parent.contains(component_) ){
                    component = component_;
                    break;
                }
            }

            return component;
        }

        public static function hasComponent( name:String ):Boolean{
            return _viewDic.hasOwnProperty( name );
        }
    }
}