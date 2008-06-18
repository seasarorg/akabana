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
package org.seasar.akabana.yui.framework.customizer {

    import mx.core.Container;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.core.reflection.Reflectors;
    import org.seasar.akabana.yui.framework.core.UIComponentRepository;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceRepository;
    
    public class ActionCustomizer extends AbstractComponentCustomizer {
        
        public override function customize( name:String, view:Container ):void {
            var actionName:String = _namingConvention.getActionName(name);
            var actionClassRef:ClassRef = Reflectors.getClassReflector(actionName);
            var action:Object;
            
            if( actionClassRef != null ){
                action = view.descriptor.properties[ namingConvention.getActionPackageName() ]  = actionClassRef.getInstance();
            }
            if( action != null ){
                for each( var actionPropertyRef:PropertyRef in actionClassRef.properties ){
                    if( namingConvention.isViewHelperName( actionPropertyRef.type )){
                        action[ actionPropertyRef.name ] = processHelperCustomize(actionPropertyRef);
                        continue;
                    }

                    if(
                        actionPropertyRef.typeClassRef.concreteClass == Service ||
                        actionPropertyRef.typeClassRef.isAssignableFrom( Service )
                    ){
                        action[ actionPropertyRef.name ] = processServiceCustomize(actionPropertyRef);
                        continue;
                    }

                }
            }
        }
        
        protected function processHelperCustomize( propertyRef:PropertyRef ):Object{
            var helperClassRef:ClassRef = Reflectors.getClassReflector( propertyRef.type );
            var helper:Object = helperClassRef.getInstance();
            
            var viewName:String = namingConvention.getViewName( helperClassRef.name );
            
            for each( var helperPropertyRef:PropertyRef in helperClassRef.getPropertyRefByType(viewName) ){
                if( helperPropertyRef != null ){
                    helper[ helperPropertyRef.name ] = UIComponentRepository.getComponent(viewName);
                    break;
                }
            }
                        
            return helper;
        }
        
        protected function processServiceCustomize( propertyRef:PropertyRef ):Service{
            var rpcservice:Service = ServiceRepository.getService( propertyRef.name );
            if( rpcservice == null && !propertyRef.typeClassRef.isInterface){
                rpcservice = propertyRef.typeClassRef.getInstance() as Service;
                rpcservice.destination = propertyRef.name;
                ServiceRepository.addService( rpcservice );
            }
            return rpcservice;
        }
        
    }
}