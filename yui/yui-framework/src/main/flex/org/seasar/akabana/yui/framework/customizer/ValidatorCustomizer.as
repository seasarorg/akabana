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
    import org.seasar.akabana.yui.framework.ns.viewpart;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.framework.logging.debug;
    import org.seasar.akabana.yui.framework.core.InstanceCache;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;

    [ExcludeClass]
    public final class ValidatorCustomizer extends AbstractComponentCustomizer {
        
        public override function customizeView(container:UIComponent):void {
            const viewProperties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const validatorClassName:String = YuiFrameworkGlobals.namingConvention.getValidatorClassName(viewClassName);

            try {
                const action:Object = viewProperties[NamingConvention.ACTION];
                if(action == null) {
                    //no action
                } else {
                    CONFIG::DEBUG {
                        _debug("Customizing",viewClassName,validatorClassName);
                    }
                    viewProperties[NamingConvention.VALIDATOR] = {};
                    //
                    setValidatorProperties(container,action);
                    //
                    const behaviors:Array = viewProperties[NamingConvention.BEHAVIOR];
                    if(behaviors != null) {
                        for each( var behavior:Object in behaviors){
                            setValidatorProperties(container,behavior);
                        }
                    }
                    CONFIG::DEBUG {
                        _debug("Customized",viewClassName,validatorClassName);
                    }
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",container,e.getStackTrace());
                }
            }
        }

        public override function uncustomizeView(container:UIComponent):void {
            const viewProperties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const validatorClassName:String = YuiFrameworkGlobals.namingConvention.getValidatorClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    _debug("Uncustomizing",viewClassName,validatorClassName);
                }
                //
                const validatorMap:Object = viewProperties[NamingConvention.VALIDATOR];
                for each( var validator:Object in validatorMap){
                    if( validator is ILifeCyclable ){
                        (validator as ILifeCyclable).stop();
                    }
                    //
                    setPropertiesValue(validator,viewClassName,null);
                }
                viewProperties[NamingConvention.VALIDATOR] = null;
                delete viewProperties[NamingConvention.VALIDATOR];
                //
                CONFIG::DEBUG {
                    _debug("Uncustomized",viewClassName,validatorClassName);
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",container,e.getStackTrace());
                }
            }
        }
        
        
        private function setValidatorProperties(container:UIComponent,obj:Object):void{
            const viewProperties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const targetClassRef:ClassRef = getClassRef(obj);
            const validatorMap:Object = viewProperties[NamingConvention.VALIDATOR];
            CONFIG::FP9 {
                const props:Array = targetClassRef.properties.filter(
                        function(item:*,index:int,array:Array):Boolean {
                            return ( YuiFrameworkGlobals.namingConvention.isValidatorOfView( viewClassName, (item as PropertyRef).typeClassRef.name ));
                        }
                    );
            }
            CONFIG::FP10 {
                const props:Vector.<PropertyRef> = 
                    targetClassRef.properties.filter(
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
                    validator = InstanceCache.newInstance(prop.typeClassRef);
                    validatorMap[validatorClassRef.name] = validator;               
                }
                
                setPropertiesValue(validator,viewClassName,container);
                setViewParts(container,validatorClassRef,validator);

                prop.setValue(obj,validator);
                //
                if( validator is ILifeCyclable ){
                    (validator as ILifeCyclable).start();
                }
            }
        }
        
        private function setViewParts(container:UIComponent,validatorClassRef:ClassRef,validator:Object):void{
            const ns:Namespace = viewpart;
            CONFIG::FP9 {
                const validatorProps:Array = validatorClassRef.properties;
            }
            CONFIG::FP10 {
                const validatorProps:Vector.<PropertyRef> = validatorClassRef.properties;
            }
            
            for each(var validatorProp:PropertyRef in validatorProps) {
                if( validatorProp.uri == ns.uri){
                    if( validatorProp.name in container ){
                        validatorProp.setValue(validator,container[validatorProp.name]);
                    }
                }
            }       
        }
    }
}