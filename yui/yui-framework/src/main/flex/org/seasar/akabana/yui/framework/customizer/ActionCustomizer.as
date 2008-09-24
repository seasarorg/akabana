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

    import flash.utils.Dictionary;
    
    import mx.core.Container;
    import mx.core.UIComponent;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.core.ViewComponentRepository;
    import org.seasar.akabana.yui.logging.Logger;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceRepository;
    
    public class ActionCustomizer extends AbstractComponentCustomizer {
        
        private static const logger:Logger = Logger.getLogger(ActionCustomizer);
        
        private static const viewToHelper:Object = new Dictionary(true);
        
        public override function customize( viewName:String, view:Container ):void {
            var viewClassName:String = ClassRef.getReflector(view).name;
            var actionName:String = _namingConvention.getActionName(viewClassName);
            var actionClassRef:ClassRef = null;
            try{
                if( view.descriptor.properties[ namingConvention.getActionPackageName() ] != null ){
                    throw new Error("already Customized");
                }
                
                actionClassRef = ClassRef.getReflector(actionName);
                processActionCustomize( viewName, view, actionClassRef );
            } catch( e:Error ){
                logger.debugMessage("yui_framework","HelperCustomizeError",viewName,e.getStackTrace());
            }
        }
            
        protected function processActionCustomize( viewName:String, view:Container, actionClassRef:ClassRef ):void{
            var action:Object = null;
            if( actionClassRef != null ){
                action = 
                    view.descriptor.properties[ namingConvention.getActionPackageName() ] = 
                    actionClassRef.newInstance();
            }
            if( action != null ){
                logger.debugMessage("yui_framework","ActionCustomizing",viewName,actionClassRef.name);
                
                for each( var propertyRef_:PropertyRef in actionClassRef.properties ){
                    if( namingConvention.isViewHelperName( propertyRef_.type )){
                        action[ propertyRef_.name ] = processHelperCustomize(view,propertyRef_);
                        logger.debugMessage("yui_framework","HelperCustomized",actionClassRef.name,propertyRef_.name,propertyRef_.type);
                        continue;
                    }

                    if( namingConvention.isLogicName( propertyRef_.type )){
                        action[ propertyRef_.name ] = processLogicCustomize(viewName,propertyRef_);
                        logger.debugMessage("yui_framework","LogicCustomized",actionClassRef.name,propertyRef_.name,propertyRef_.type);
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

        protected function processHelperCustomize( view:Container, propertyRef:PropertyRef ):Object{
            const baseViewClassRef:ClassRef = ClassRef.getReflector(view);
            var helper:Object = null;
            var helperClassRef:ClassRef = null;
            
            try{
                
                helperClassRef = ClassRef.getReflector( propertyRef.type );
                var viewClassName:String = namingConvention.getViewName( helperClassRef.name );
                var propertyRefs:Array = helperClassRef.getPropertyRefByType(viewClassName);
                
                if( propertyRefs != null && propertyRefs.length > 0 ){
                    var helperView:UIComponent;
                    var propertyRef_:PropertyRef = propertyRefs[0];
                    if( propertyRef_.typeClassRef == baseViewClassRef){
                        helperView = view;
                    } else {
                        helperView = ViewComponentRepository.getComponent(propertyRef_.typeClassRef.concreteClass );
                    }
                    helper = viewToHelper[ helperView ];
                    if( helper == null ){
                        helper = helperClassRef.newInstance();
                        viewToHelper[ helperView ] = helper;
                    } 
                    helper[ propertyRef_.name ] = helperView;
                }
            } catch( e:Error ){
                logger.debugMessage("yui_framework","HelperCustomizeError",propertyRef.type,e.getStackTrace());
            } 
            
            return helper;
        }

        protected function processLogicCustomize( viewName:String, propertyRef:PropertyRef ):Object{
            var logic:Object = null;            
            try{
                logic = propertyRef.typeClassRef.newInstance();
                for each( var propertyRef_:PropertyRef in propertyRef.typeClassRef.properties ){
                    if(
                        propertyRef_.typeClassRef.concreteClass == Service ||
                        propertyRef_.typeClassRef.isAssignableFrom( Service )
                    ){
                        logic[ propertyRef_.name ] = processServiceCustomize(viewName,propertyRef_);
                        logger.debugMessage("yui_framework","ServiceCustomized",propertyRef.name,propertyRef_.name,propertyRef_.type);
                        continue;
                    }
                }
            } catch( e:Error ){
                logger.debugMessage("yui_framework","HelperCustomizeError",propertyRef.type,e.getStackTrace());
            } 
            
            return logic;
        }
        
        protected function processServiceCustomize( viewName:String, propertyRef:PropertyRef ):Service{
            var rpcservice:Service = ServiceRepository.getService( propertyRef.name );
            if( rpcservice == null && !propertyRef.typeClassRef.isInterface){
                rpcservice = propertyRef.typeClassRef.newInstance(propertyRef.name) as Service;
                rpcservice.destination = propertyRef.name;
                ServiceRepository.addService( rpcservice );
            }
            return rpcservice;
        }
        
    }
}