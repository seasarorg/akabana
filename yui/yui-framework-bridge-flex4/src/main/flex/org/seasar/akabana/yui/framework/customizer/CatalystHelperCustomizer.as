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
	import mx.core.IVisualElement;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.core.ILifeCyclable;
    import org.seasar.akabana.yui.framework.ns.viewpart;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.framework.util.CatalystGroupUtil;
	import org.seasar.akabana.yui.framework.logging.debug;
	import org.seasar.akabana.yui.framework.ns.viewpart;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;

    [ExcludeClass]
    public class CatalystHelperCustomizer extends HelperCustomizer {
        
        public override function customizeView(container:UIComponent):void {
            super.customizeView(container);

            const properties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const helperClassName:String = YuiFrameworkGlobals.namingConvention.getHelperClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    _debug("Customizing",viewClassName,helperClassName);
                }
                const helper:Object = properties[NamingConvention.HELPER];
                const helperClassRef:ClassRef = getClassRef(helper);

                //
                var elements:Vector.<IVisualElement> = CatalystGroupUtil.getAllElements(container);      
                var component:UIComponent;     
                var componentName:String;
                var helperPropRef:PropertyRef;
                for each(var element:IVisualElement in elements) {
                    if( element is UIComponent ){
                        component = element as UIComponent;
                        componentName = YuiFrameworkGlobals.namingConvention.getComponentName(component);
                        helperPropRef = helperClassRef.getPropertyRef(componentName);
                        if( helperPropRef != null && helperPropRef.uri == viewpart.toString()){
                            helperPropRef.setValue(helper,component);                   
                        }
                    }
                }
                CONFIG::DEBUG {
					_debug("Customized",viewClassName,helperClassName);
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
					_debug("CustomizeError",container,e.getStackTrace());
                }
            }
        }
    }
}