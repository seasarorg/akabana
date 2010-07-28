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
package org.seasar.akabana.yui.framework.customizer {

    import mx.core.UIComponent;
    import mx.core.mx_internal;
    import mx.validators.Validator;

    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.logging.Logger;

    use namespace mx_internal;

    [ExcludeClass]
    public class ValidatorCustomizer extends AbstractComponentEventCustomizer{
		
		CONFIG::DEBUG {
        	private static const _logger:Logger = Logger.getLogger(ValidatorCustomizer);
		}
		
        public override function customize( view:UIComponent, owner:UIComponent=null):void {
            if( owner == null ){
	            try{
    	            var viewName:String = UIComponentUtil.getName(view);
    	            var viewClassName:String = getCanonicalName(view);
    	            var validatorClassName:String = YuiFrameworkGlobals.namingConvention.getValidatorClassName(viewClassName);
    	            var validatorClassRef:ClassRef = null;
CONFIG::DEBUG{
                    _logger.debug(getMessage("ViewEventCustomizing",viewName,validatorClassName));
}
	                validatorClassRef = getClassRef(validatorClassName);
	                processValidatorCustomize( viewName, view, validatorClassRef );
CONFIG::DEBUG{
                    _logger.debug(getMessage("ViewEventCustomized",viewName,validatorClassName));
}
	            } catch( e:Error ){
	            }
            }
        }

        public override function uncustomize( view:UIComponent, owner:UIComponent=null):void{
            if( owner == null ){

                try{
    	            var viewName:String = UIComponentUtil.getName(view);
    	            var viewClassName:String = getCanonicalName(view);
    	            var validatorClassName:String = YuiFrameworkGlobals.namingConvention.getValidatorClassName(viewClassName);
    	            var validatorClassRef:ClassRef = null;
CONFIG::DEBUG{
            _logger.debug(getMessage("ValidatorUncustomizing",viewName,validatorClassName));
}
	                validatorClassRef = getClassRef(validatorClassName);
	                processValidatorUncustomize( viewName, view, validatorClassRef );
CONFIG::DEBUG{
                    _logger.debug(getMessage("ValidatorUncustomized",viewName,validatorClassName));
}
	            } catch( e:Error ){
	            }
            }
        }

        protected function processValidatorCustomize( viewName:String, view:UIComponent, validatorClassRef:ClassRef ):void{
            const properties:Object = UIComponentUtil.getProperties(view);
            var validator:Object = null;
            if( validatorClassRef != null ){
                validator =
                    properties[ YuiFrameworkGlobals.namingConvention.getValidatorPackageName() ] =
                        validatorClassRef.newInstance();
            }
            if( validator != null ){
                for each( var propertyRef_:PropertyRef in validatorClassRef.properties ){
                    var childValidator:Validator = validator[ propertyRef_.name ] as Validator;
                    if( childValidator != null ){
CONFIG::DEBUG{
                        _logger.debug(propertyRef_.name + "," + propertyRef_.type);
}
                        childValidator.source = view[ propertyRef_.name ];
                    }
                }
            }
        }

        protected function processValidatorUncustomize( viewName:String, view:UIComponent, validatorClassRef:ClassRef ):void{
            const properties:Object = UIComponentUtil.getProperties(view);
            var validator:Object = properties[ YuiFrameworkGlobals.namingConvention.getValidatorPackageName() ];
            if( validator != null ){
                for each( var propertyRef_:PropertyRef in validatorClassRef.properties ){
                    var childValidator:Validator = validator[ propertyRef_.name ] as Validator;
                    if( childValidator != null ){
                        childValidator.source = null;
                    }
                }
            }
            properties[ YuiFrameworkGlobals.namingConvention.getValidatorPackageName() ] = null;
            delete properties[ YuiFrameworkGlobals.namingConvention.getValidatorPackageName() ];
        }

    }
}