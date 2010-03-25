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

    import mx.core.UIComponent;
    import mx.core.UIComponentDescriptor;

    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.logging.Logger;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceRepository;

    public class ActionCustomizer extends AbstractComponentCustomizer {

        private static const _logger:Logger = Logger.getLogger(ActionCustomizer);

        private static const LOGIC_OWNER:String = "owner";

        private static var viewToHelperMap:Object = new Dictionary(true);

        private static var viewToActionMap:Object = new Dictionary(true);

        public override function customize( view:UIComponent, owner:UIComponent=null):void {
        	if( owner == null ){
	            const viewName:String = UIComponentUtil.getName(view);
	            const viewClassName:String = YuiFrameworkGlobals.namingConvention.getClassName(view);
	            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);
	            var actionClassRef:ClassRef = null;
	            try{
	                if( view.descriptor.properties[ YuiFrameworkGlobals.namingConvention.getActionPackageName() ] != null ){
	                    throw new Error("already Customized");
	                }
	                actionClassRef = ClassRef.getReflector(actionClassName);
	                processActionCustomize( viewName, view, actionClassRef );
	            } catch( e:Error ){
CONFIG::DEBUG{
	                _logger.debug(getMessage("CustomizeError",viewName,e.getStackTrace()));
}
	            }
            } else {
            }
        }

        public override function uncustomize( view:UIComponent, owner:UIComponent=null):void{
            if( owner == null ){
	            const viewName:String = UIComponentUtil.getName(view);
	            const viewClassName:String = YuiFrameworkGlobals.namingConvention.getClassName(view);
	            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);
	            var actionClassRef:ClassRef = null;
	            try{
	                actionClassRef = ClassRef.getReflector(actionClassName);
	                processActionUncustomize( viewName, view, actionClassRef );
	            } catch( e:Error ){
CONFIG::DEBUG{
	                _logger.debug(getMessage("CustomizeError",viewName,e.getStackTrace()));
}
	            }
            } else {
            }
        }

        protected function processActionCustomize( viewName:String, view:UIComponent, actionClassRef:ClassRef ):void{
            var action:Object = null;
            if( actionClassRef != null ){
                action = viewToActionMap[view];
                if( action == null ){
                    action = actionClassRef.newInstance();
                    viewToActionMap[view] = action;
                }
                view.descriptor.properties[ YuiFrameworkGlobals.namingConvention.getActionPackageName() ] = action;
            }
            if( action != null ){
CONFIG::DEBUG{
                _logger.debug(getMessage("ActionCustomizing",viewName,actionClassRef.name));
}

                for each( var propertyRef_:PropertyRef in actionClassRef.properties ){
                    if( YuiFrameworkGlobals.namingConvention.isHelperClassName( propertyRef_.type )){
                        var helper:Object = processHelperCustomize(view,propertyRef_);
                        propertyRef_.setValue(action,helper);
CONFIG::DEBUG{
                        _logger.debug(getMessage("HelperCustomized",actionClassRef.name,propertyRef_.name,propertyRef_.type));
}
                        continue;
                    }

                    if( YuiFrameworkGlobals.namingConvention.isLogicClassName( propertyRef_.type )){
                        var logic:Object = processLogicCustomize(viewName,propertyRef_,action);
                        propertyRef_.setValue(action,logic);
CONFIG::DEBUG{
                        _logger.debug(getMessage("LogicCustomized",actionClassRef.name,propertyRef_.name,propertyRef_.type));
}
                        continue;
                    }

                    if(
                        propertyRef_.typeClassRef.concreteClass == Service ||
                        propertyRef_.typeClassRef.isAssignableFrom( Service )
                    ){
                        var service:Object = processServiceCustomize(viewName,propertyRef_);
                        propertyRef_.setValue(action,service);
CONFIG::DEBUG{
                        _logger.debug(getMessage("ServiceCustomized",actionClassRef.name,propertyRef_.name,propertyRef_.type));
}
                        continue;
                    }

                    if( YuiFrameworkGlobals.namingConvention.isValidatorClassName( propertyRef_.type ) ){
                        if( view.descriptor.properties.hasOwnProperty( YuiFrameworkGlobals.namingConvention.getValidatorPackageName() )){
                            var validator:Object = view.descriptor.properties[ YuiFrameworkGlobals.namingConvention.getValidatorPackageName() ];
                            propertyRef_.setValue(action,validator);
CONFIG::DEBUG{
                        _logger.debug(getMessage("ValidatorCustomized",actionClassRef.name,propertyRef_.name,propertyRef_.type));
}
                            continue;
                        }
                    }
                }
            }
        }

        protected function processActionUncustomize( viewName:String, view:UIComponent, actionClassRef:ClassRef ):void{
            var viewDescriptor:UIComponentDescriptor = view.descriptor;
            if( view.isPopUp ){
                viewToActionMap[ view ] = null;
                delete viewToActionMap[ view ];
            }

            var action:Object = null;
			if ( view.descriptor != null && view.descriptor.properties != null ){
                action = viewDescriptor.properties[ YuiFrameworkGlobals.namingConvention.getActionPackageName() ];
            }

            if( action == null ){
            } else {
CONFIG::DEBUG{
                _logger.debug(getMessage("ActionUnCustomizing",viewName,actionClassRef.name));
}
                for each( var propertyRef_:PropertyRef in actionClassRef.properties ){
                    if( YuiFrameworkGlobals.namingConvention.isHelperClassName( propertyRef_.type )){
                        processHelperUncustomize(view,propertyRef_);
                        propertyRef_.setValue(action,null);
CONFIG::DEBUG{
                        _logger.debug(getMessage("HelperUncustomized",actionClassRef.name,propertyRef_.name,propertyRef_.type));
}
                        continue;
                    }

                    if( YuiFrameworkGlobals.namingConvention.isLogicClassName( propertyRef_.type )){
                        processLogicUncustomize(action,propertyRef_);
                        propertyRef_.setValue(action,null);
CONFIG::DEBUG{
                        _logger.debug(getMessage("LogicUncustomized",actionClassRef.name,propertyRef_.name,propertyRef_.type));
}
                        continue;
                    }

                    if(
                        propertyRef_.typeClassRef.concreteClass == Service ||
                        propertyRef_.typeClassRef.isAssignableFrom( Service )
                    ){
                        var service:Service = propertyRef_.getValue(action) as Service;
                        service.deletePendingCallOf(action);
                        propertyRef_.setValue(action,null);
CONFIG::DEBUG{
                        _logger.debug(getMessage("ServiceUncustomized",actionClassRef.name,propertyRef_.name,propertyRef_.type));
}
                        continue;
                    }

                    if( YuiFrameworkGlobals.namingConvention.isValidatorClassName( propertyRef_.type ) ){
                        propertyRef_.setValue(action,null);
CONFIG::DEBUG{
                        _logger.debug(getMessage("ValidatorUncustomized",actionClassRef.name,propertyRef_.name,propertyRef_.type));
}
                        continue;
                    }
                }
                viewDescriptor.properties[ YuiFrameworkGlobals.namingConvention.getActionPackageName() ] = null;
                delete viewDescriptor.properties[ YuiFrameworkGlobals.namingConvention.getActionPackageName() ];
            }
        }

        protected function processHelperCustomize( view:UIComponent, propertyRef:PropertyRef ):Object{
            var helper:Object = null;

            try{
                const helperClassRef:ClassRef = ClassRef.getReflector( propertyRef.type );
                const viewClassName:String = ClassRef.getClassName( view );
                const helperPropertyRefs:Array = helperClassRef.getPropertyRefByType(viewClassName);

                if( helperPropertyRefs != null && helperPropertyRefs.length > 0 ){
            		var helperPropertyRef_:PropertyRef = helperPropertyRefs[0];

                    helper = viewToHelperMap[ view ];
                    if( helper == null ){
                        helper = helperClassRef.newInstance();
                        viewToHelperMap[ view ] = helper;
                    }
                    helper[ helperPropertyRef_.name ] = view;
                }

            } catch( e:Error ){
CONFIG::DEBUG{
                _logger.debug(getMessage("CustomizeError",propertyRef.type,e.getStackTrace()));
}
            }

            return helper;
        }

        protected function processHelperUncustomize( view:UIComponent, propertyRef:PropertyRef ):void{
            try{
                const helperClassRef:ClassRef = ClassRef.getReflector( propertyRef.type );
                const viewClassName:String = YuiFrameworkGlobals.namingConvention.getViewClassName( helperClassRef.name );
                const helperPropertyRefs:Array = helperClassRef.getPropertyRefByType( viewClassName );

                if( helperPropertyRefs != null && helperPropertyRefs.length > 0 ){
            		var helperPropertyRef_:PropertyRef = helperPropertyRefs[0];
                    viewToHelperMap[ view ] = null;
                    delete viewToHelperMap[ view ];
                }

            } catch( e:Error ){
CONFIG::DEBUG{
                _logger.debug(getMessage("UncustomizeError",propertyRef.type,e.getStackTrace()));
}
            }
        }

        protected function processLogicCustomize( viewName:String, propertyRef:PropertyRef, owner:Object ):Object{
            var logic:Object = null;
            try{
                logic = propertyRef.typeClassRef.newInstance();
                for each( var propertyRef_:PropertyRef in propertyRef.typeClassRef.properties ){
                    if(
                        propertyRef_.typeClassRef.concreteClass == Service ||
                        propertyRef_.typeClassRef.isAssignableFrom( Service )
                    ){
                        logic[ propertyRef_.name ] = processServiceCustomize(viewName,propertyRef_);
CONFIG::DEBUG{
                        _logger.debug(getMessage("ServiceCustomized",propertyRef.name,propertyRef_.name,propertyRef_.type));
}
                        continue;
                    }
                    if( propertyRef_.name == LOGIC_OWNER){
                        logic[ propertyRef_.name ] = owner;
                        continue;
                    }
                }
            } catch( e:Error ){
CONFIG::DEBUG{
                _logger.debug(getMessage("CustomizeError",propertyRef.type,e.getStackTrace()));
}
            }

            return logic;
        }

        protected function processLogicUncustomize( action:Object, propertyRef:PropertyRef ):void{
            try{
                var logic:Object = propertyRef.getValue(action);
                if( logic == null ){
                    return;
                }
                for each( var propertyRef_:PropertyRef in propertyRef.typeClassRef.properties ){
                    if(
                        propertyRef_.typeClassRef.concreteClass == Service ||
                        propertyRef_.typeClassRef.isAssignableFrom( Service )
                    ){
                        processServiceUncustomize(logic,propertyRef_);
CONFIG::DEBUG{
                        _logger.debug(getMessage("ServiceUncustomized",propertyRef.name,propertyRef_.name,propertyRef_.type));
}
                        continue;
                    }
                    if( propertyRef_.name == LOGIC_OWNER){
                        propertyRef.setValue(logic,null);
                        continue;
                    }
                }
            } catch( e:Error ){
CONFIG::DEBUG{
                _logger.debug(getMessage("UncustomizeError",propertyRef.type,e.getStackTrace()));
}
            }
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

        protected function processServiceUncustomize( owner:Object, propertyRef:PropertyRef ):void{
            var service:Service = propertyRef.getValue(owner) as Service;
            service.deletePendingCallOf(owner);
            propertyRef.setValue(owner,null);
        }
    }
}