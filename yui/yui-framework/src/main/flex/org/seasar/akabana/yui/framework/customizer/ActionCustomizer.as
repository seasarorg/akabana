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
    
    import org.seasar.akabana.yui.core.error.ClassNotFoundError;
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.core.ViewComponentRepository;
    import org.seasar.akabana.yui.logging.Logger;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceRepository;
    
    public class ActionCustomizer extends AbstractComponentCustomizer {
        
        private static const logger:Logger = Logger.getLogger(ActionCustomizer);
        
        public override function customize( viewName:String, view:Container ):void {
            var viewClassName:String = ClassRef.getReflector(view).name;
            var actionName:String = _namingConvention.getActionName(viewClassName);
            var actionClassRef:ClassRef = null;
            try{
                actionClassRef = ClassRef.getReflector(actionName);
                processActionCustomize( viewName, view, actionClassRef );
            } catch( e:Error ){
                logger.debugMessage("yui_framework","ClassNotFoundError",viewName,actionName);
            }
        }
            
        protected function processActionCustomize( viewName:String, view:Container, actionClassRef:ClassRef ):void{
            var action:Object = null;
            if( actionClassRef != null ){
                action = view.descriptor.properties[ namingConvention.getActionPackageName() ]  = actionClassRef.getInstance();
            }
            if( action != null ){
                logger.debugMessage("yui_framework","ActionCustomizing",viewName,actionClassRef.name);
                
                for each( var propertyRef_:PropertyRef in actionClassRef.properties ){
                    if( namingConvention.isViewHelperName( propertyRef_.type )){
                        action[ propertyRef_.name ] = processHelperCustomize(viewName,propertyRef_);
                        logger.debugMessage("yui_framework","HelperCustomized",actionClassRef.name,propertyRef_.name,propertyRef_.type);
                        continue;
                    }

                    if(
                        propertyRef_.typeClassRef.concreteClass == Service ||
                        propertyRef_.typeClassRef.isAssignableFrom( Service )
                    ){
                        action[ propertyRef_.name ] = processServiceCustomize(viewName,propertyRef_);
                        logger.debugMessage("yui_framework","ServiceCustomized",actionClassRef.name,propertyRef_.name,propertyRef_.type);
                        continue;
                    }
                }
            }
        }

        public override function uncustomize( name:String, view:Container ):void{
            if( view.descriptor != null ){
                view.descriptor.properties[ namingConvention.getActionPackageName() ] = null;           
            }
        }

        protected function processHelperCustomize( viewName:String, propertyRef:PropertyRef ):Object{
            var helper:Object = null;
            
            var helperClassRef:ClassRef = null;

            try{
                helperClassRef = ClassRef.getReflector( propertyRef.type );
                helper = helperClassRef.getInstance();
                var viewClassName:String = namingConvention.getViewName( helperClassRef.name );
                var propertyRefs:Array = helperClassRef.getPropertyRefByType(viewClassName); 
                    
                for each( var propertyRef_:PropertyRef in propertyRefs ){
                    if( propertyRef_.name == "view"){
                        helper[ propertyRef_.name ] = ViewComponentRepository.getComponent(propertyRef_.typeClassRef.concreteClass);
                    } else {
                        helper[ propertyRef_.name ] = ViewComponentRepository.getComponent(propertyRef_.name );
                    }
                }
            } catch( e:ClassNotFoundError ){ 
                logger.debugMessage("yui_framework","ClassNotFoundError",viewName,propertyRef.type);
            }
            
            return helper;
        }
        
        protected function processServiceCustomize( viewName:String, propertyRef:PropertyRef ):Service{
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