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
package org.seasar.akabana.yui.framework.customizer
{
    CONFIG::FP10 {
        import __AS3__.vec.Vector;
    }
    import mx.core.UIComponent;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.core.ILifeCyclable;
    import org.seasar.akabana.yui.framework.ns.view;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
	import org.seasar.akabana.yui.framework.logging.debug;

    [ExcludeClass]
    public class ValidatorCustomizer extends AbstractComponentCustomizer {
        
        public override function customizeView(container:UIComponent):void {
            const properties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const validatorClassName:String = YuiFrameworkGlobals.namingConvention.getValidatorClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    debug(this,getMessage("Customizing",viewClassName,validatorClassName));
                }
                properties[YuiFrameworkGlobals.namingConvention.getValidatorPackageName()] = {};
                //
                const action:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];
                if(action != null) {
                    setValidatorProperties(container,action);
                }
                
                //
                const behaviors:Array = properties[YuiFrameworkGlobals.namingConvention.getBehaviorPackageName()];
                if(behaviors != null) {
                    for each( var behavior:Object in behaviors){
                        setValidatorProperties(container,behavior);
                    }
                }
                CONFIG::DEBUG {
                    debug(this,getMessage("Customized",viewClassName,validatorClassName));
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    debug(this,getMessage("CustomizeError",container,e.getStackTrace()));
                }
            }
        }

        public override function uncustomizeView(container:UIComponent):void {
            const properties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const validatorClassName:String = YuiFrameworkGlobals.namingConvention.getValidatorClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    debug(this,getMessage("Uncustomizing",viewClassName,validatorClassName));
                }
                //
                const validatorMap:Object = properties[YuiFrameworkGlobals.namingConvention.getValidatorPackageName()];
                for each( var validator:Object in validatorMap){
                    if( validator is ILifeCyclable ){
                        (validator as ILifeCyclable).stop();
                    }
                    //
                    setPropertiesValue(validator,viewClassName,null);
                }
                properties[YuiFrameworkGlobals.namingConvention.getValidatorPackageName()] = null;
                delete properties[YuiFrameworkGlobals.namingConvention.getValidatorPackageName()];
                //
                CONFIG::DEBUG {
                    debug(this,getMessage("Uncustomized",viewClassName,validatorClassName));
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    debug(this,getMessage("CustomizeError",container,e.getStackTrace()));
                }
            }
        }
        
        
        protected function setValidatorProperties(container:UIComponent,obj:Object):void{
            const properties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const classRef:ClassRef = getClassRef(obj);
            const validatorMap:Object = properties[YuiFrameworkGlobals.namingConvention.getValidatorPackageName()];
            CONFIG::FP9 {
                const props:Array = classRef.properties.filter(
                        function(item:*,index:int,array:Array):Boolean {
                            return ( YuiFrameworkGlobals.namingConvention.isValidatorOfView( viewClassName, (item as PropertyRef).typeClassRef.name ));
                        }
                    );
            }
            CONFIG::FP10 {
                const props:Vector.<PropertyRef> = 
                    classRef.properties.filter(
                        function(item:*,index:int,array:Vector.<PropertyRef>):Boolean {
                            return ( YuiFrameworkGlobals.namingConvention.isValidatorOfView( viewClassName, (item as PropertyRef).typeClassRef.name ));
                        }
                    );
            }
            
            var validator:Object;
            var validatorClassRef:ClassRef;
            for each(var prop:PropertyRef in props) {
                validatorClassRef = getClassRef(prop.typeClassRef.name);
                if( validatorClassRef.name in validatorMap){
                    validator = validatorMap[validatorClassRef.name];
                } else {
                    validator = newInstance(prop.typeClassRef);
                    validatorMap[validatorClassRef.name] = validator;               
                }
                
                setPropertiesValue(validator,viewClassName,container);
                setViewComponents(container,validatorClassRef,validator);

                prop.setValue(obj,validator);
                //
                if( validator is ILifeCyclable ){
                    (validator as ILifeCyclable).start();
                }
            }
        }

        protected function setViewComponents(container:UIComponent,validatorClassRef:ClassRef,validator:Object):void{
            CONFIG::FP9 {
                const viewProps:Array = getClassRef(getCanonicalName(container)).properties;
            }
            CONFIG::FP10 {
                const viewProps:Vector.<PropertyRef> = getClassRef(getCanonicalName(container)).properties;
            }
            var validatorPropRef:PropertyRef;
            for each(var viewProp:PropertyRef in viewProps) {
                validatorPropRef = validatorClassRef.getPropertyRef(viewProp.name);
                if( validatorPropRef != null && validatorPropRef.uri == view.toString()){
                    validatorPropRef.setValue(validator,viewProp.getValue(container));                   
                }
            }       
        }
    }
}