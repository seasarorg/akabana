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
    import org.seasar.akabana.yui.mx.util.PopUpUtil;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceRepository;

    public class ActionCustomizer extends AbstractComponentCustomizer {
        
        private static const logger:Logger = Logger.getLogger(ActionCustomizer);
        
        private static const viewToHelperMap:Object = new Dictionary(true);
        
        private static const viewToValidator:Object = new Dictionary(true);
        
        public override function customize( viewName:String, view:Container ):void {
            var viewClassName:String = ClassRef.getReflector(view).name;
            var actionClassName:String = _namingConvention.getActionClassName(viewClassName);
            var actionClassRef:ClassRef = null;
            try{
                if( view.descriptor.properties[ namingConvention.getActionPackageName() ] != null ){
                    throw new Error("already Customized");
                }
                actionClassRef = ClassRef.getReflector(actionClassName);
                processActionCustomize( viewName, view, actionClassRef );
            } catch( e:Error ){
                logger.debugMessage("yui_framework","CustomizeError",viewName,e.getStackTrace());
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
                    if( namingConvention.isHelperClassName( propertyRef_.type )){
                        action[ propertyRef_.name ] = processHelperCustomize(view,propertyRef_);
                        logger.debugMessage("yui_framework","HelperCustomized",actionClassRef.name,propertyRef_.name,propertyRef_.type);
                        continue;
                    }

                    if( namingConvention.isLogicClassName( propertyRef_.type )){
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
                    
                    if( namingConvention.isValidatorClassName( propertyRef_.type ) ){
                        if( view.descriptor.properties.hasOwnProperty( namingConvention.getValidatorPackageName() )){
                            action[ propertyRef_.name ] = view.descriptor.properties[ namingConvention.getValidatorPackageName() ];
                            logger.debugMessage("yui_framework","ValidatorCustomized",actionClassRef.name,propertyRef_.name,propertyRef_.type);
                        }
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
                var viewClassName:String = namingConvention.getViewClassName( helperClassRef.name );
                var propertyRefs:Array = helperClassRef.getPropertyRefByType(viewClassName);
                
                if( propertyRefs != null && propertyRefs.length > 0 ){
                    var helperView:UIComponent;
                    var propertyRef_:PropertyRef = propertyRefs[0];
                    
                    if( propertyRef_.typeClassRef == baseViewClassRef){
                        helperView = view;
                    } else {
                        if( namingConvention.isHelperName( propertyRef.name )){
                            if( view.isPopUp ){
                                var popupOwner:Container = PopUpUtil.lookupPopupOwner(view);
                                if( ClassRef.getReflector(popupOwner).concreteClass == 
                                    propertyRef_.typeClassRef.concreteClass
                                ){
                                    helperView = popupOwner;
                                } else {
                                    throw new Error("Helpers other than parents are registered in PopupView.");
                                }
                            } else {
                                helperView = ViewComponentRepository.getComponentByParent(
                                                propertyRef_.typeClassRef.concreteClass,view
                                                );                                
                            }
                        }
                    }
                    helper = viewToHelperMap[ helperView.toString() ];
                    if( helper == null ){
                        helper = helperClassRef.newInstance();
                        viewToHelperMap[ helperView.toString() ] = helper;
                    } 
                    helper[ propertyRef_.name ] = helperView;

                    //for vilidator
                    var validatorClassName:String = namingConvention.getValidatorClassName( viewClassName );
                    propertyRefs = helperClassRef.getPropertyRefByType(validatorClassName);

                    if( propertyRefs != null && propertyRefs.length > 0 ){
                        propertyRef_ = propertyRefs[0];
                        helper[ propertyRef_.name ] = helperView.descriptor.properties[ namingConvention.getValidatorPackageName() ];
                    }
                }
                
            } catch( e:Error ){
                logger.debugMessage("yui_framework","CustomizeError",propertyRef.type,e.getStackTrace());
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
                logger.debugMessage("yui_framework","CustomizeError",propertyRef.type,e.getStackTrace());
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