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
    import org.seasar.akabana.yui.framework.ns.viewpart;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
	import org.seasar.akabana.yui.framework.logging.debug;

    [ExcludeClass]
    public class HelperCustomizer extends AbstractComponentCustomizer {
        
        public override function customizeView(container:UIComponent):void {
            const properties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const helperClassName:String = YuiFrameworkGlobals.namingConvention.getHelperClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    debug(this,getMessage("Customizing",viewClassName,helperClassName));
                }
                properties[YuiFrameworkGlobals.namingConvention.getHelperPackageName()] = {};
                //
                const action:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];
                if(action != null) {
                    setHelperProperties(container,action);
                }
                
                //
                const behaviors:Array = properties[YuiFrameworkGlobals.namingConvention.getBehaviorPackageName()];
                if(behaviors != null) {
                    for each( var behavior:Object in behaviors){
                        setHelperProperties(container,behavior);
                    }
                }
                CONFIG::DEBUG {
                    debug(this,getMessage("Customized",viewClassName,helperClassName));
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
            const helperClassName:String = YuiFrameworkGlobals.namingConvention.getHelperClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    debug(this,getMessage("Uncustomizing",viewClassName,helperClassName));
                }
                //
                const helperMap:Object = properties[YuiFrameworkGlobals.namingConvention.getHelperPackageName()];
                for each( var helper:Object in helperMap){
                    if( helper is ILifeCyclable ){
                        (helper as ILifeCyclable).stop();
                    }
                    //
                    setPropertiesValue(helper,viewClassName,null);
                }
                properties[YuiFrameworkGlobals.namingConvention.getHelperPackageName()] = null;
                delete properties[YuiFrameworkGlobals.namingConvention.getHelperPackageName()];
                //
                CONFIG::DEBUG {
                    debug(this,getMessage("Uncustomized",viewClassName,helperClassName));
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    debug(this,getMessage("CustomizeError",container,e.getStackTrace()));
                }
            }
        }
        
        
        protected function setHelperProperties(container:UIComponent,obj:Object):void{
            const properties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const classRef:ClassRef = getClassRef(obj);
            const helperMap:Object = properties[YuiFrameworkGlobals.namingConvention.getHelperPackageName()];
            CONFIG::FP9 {
                const props:Array =
                    classRef.properties.filter(
                        function(item:*,index:int,array:Array):Boolean {
                            return ( YuiFrameworkGlobals.namingConvention.isHelperOfView( viewClassName, (item as PropertyRef).typeClassRef.name ));
                        }
                    );
            }
            CONFIG::FP10 {
                const props:Vector.<PropertyRef> =
                    classRef.properties.filter(
                        function(item:*,index:int,array:Vector.<PropertyRef>):Boolean {
                            return ( YuiFrameworkGlobals.namingConvention.isHelperOfView( viewClassName, (item as PropertyRef).typeClassRef.name ));
                        }
                    );
            }
            
            var helper:Object;
            var helperClassRef:ClassRef;
            for each(var prop:PropertyRef in props) {
                helperClassRef = getClassRef(prop.typeClassRef.name);
                if( helperClassRef.name in helperMap){
                    helper = helperMap[helperClassRef.name];
                } else {
                    helper = newInstance(prop.typeClassRef);
                    helperMap[helperClassRef.name] = helper;               
                }
                
                setPropertiesValue(helper,viewClassName,container);
                setViewComponents(container,helperClassRef,helper);

                prop.setValue(obj,helper);
                //
                if( helper is ILifeCyclable ){
                    (helper as ILifeCyclable).start();
                }
            }
        }

        protected function setViewComponents(container:UIComponent,helperClassRef:ClassRef,helper:Object):void{
            CONFIG::FP9 {
                const viewProps:Array = getClassRef(container).properties;
            }
            CONFIG::FP10 {
                const viewProps:Vector.<PropertyRef> = getClassRef(container).properties;
            }
            var helperPropRef:PropertyRef;
            for each(var viewProp:PropertyRef in viewProps) {
                helperPropRef = helperClassRef.getPropertyRef(viewProp.name);
                if( helperPropRef != null && helperPropRef.uri == viewpart.toString()){
                    helperPropRef.setValue(helper,viewProp.getValue(container));                   
                }
            }       
        }
    }
}