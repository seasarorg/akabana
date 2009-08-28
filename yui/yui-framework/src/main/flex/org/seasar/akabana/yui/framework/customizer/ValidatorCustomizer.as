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
    import mx.core.mx_internal;
    import mx.validators.Validator;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.logging.Logger;
    
    use namespace mx_internal;
    
    public class ValidatorCustomizer extends AbstractEventCustomizer{
        
        private static const logger:Logger = Logger.getLogger(ValidatorCustomizer);

        public function ValidatorCustomizer(namingConvention:NamingConvention){
            super(namingConvention);
        }
                
        public override function customize( view:Container, owner:Container=null):void {
            if( owner == null ){  
	            var viewName:String = UIComponentUtil.getName(view);
	            var viewClassName:String = ClassRef.getReflector(view).name;
	            var validatorClassName:String = namingConvention.getValidatorClassName(viewClassName);
	            var validatorClassRef:ClassRef = null;
	            try{
	                if( view.descriptor.properties[ namingConvention.getValidatorPackageName() ] != null ){
	                    throw new Error("already Customized");
	                }
	                
	                validatorClassRef = ClassRef.getReflector(validatorClassName);
	                processValidatorCustomize( viewName, view, validatorClassRef );
	            } catch( e:Error ){
	                //logger.debugMessage("yui_framework","CustomizeError",viewName,e.getStackTrace());
	            }   
            
            } else {        
            }     
        }

        public override function uncustomize( view:Container, owner:Container=null):void{
            if( owner == null ){    	
	            var viewName:String = UIComponentUtil.getName(view);
	            var viewClassName:String = ClassRef.getReflector(view).name;
	            var validatorClassName:String = namingConvention.getValidatorClassName(viewClassName);
	            var validatorClassRef:ClassRef = null;
	            try{
	                validatorClassRef = ClassRef.getReflector(validatorClassName);
	                processValidatorUnCustomize( viewName, view, validatorClassRef );
	            } catch( e:Error ){
	                //logger.debugMessage("yui_framework","CustomizeError",viewName,e.getStackTrace());
	            }   
            
            } else {    
            }
        }
        
        protected function processValidatorCustomize( viewName:String, view:Container, validatorClassRef:ClassRef ):void{
            var validator:Object = null;
            if( validatorClassRef != null ){
                validator = 
                    view.descriptor.properties[ namingConvention.getValidatorPackageName() ] = 
                        validatorClassRef.newInstance();
            }
            if( validator != null ){
                for each( var propertyRef_:PropertyRef in validatorClassRef.properties ){
                    var childValidator:Validator = validator[ propertyRef_.name ] as Validator;
                    if( childValidator != null ){
                        logger.debug(propertyRef_.name + "," + propertyRef_.type);
                        childValidator.source = view[ propertyRef_.name ];
                    }
                }
            }
        }
        
        protected function processValidatorUnCustomize( viewName:String, view:Container, validatorClassRef:ClassRef ):void{
            var validator:Object = view.descriptor.properties[ namingConvention.getValidatorPackageName() ]; 
            if( validator != null ){
                for each( var propertyRef_:PropertyRef in validatorClassRef.properties ){
                    var childValidator:Validator = validator[ propertyRef_.name ] as Validator;
                    if( childValidator != null ){
                        childValidator.source = null;
                    }
                }
            }
            view.descriptor.properties[ namingConvention.getValidatorPackageName() ] = null;
            delete view.descriptor.properties[ namingConvention.getValidatorPackageName() ];
        }

    }
}