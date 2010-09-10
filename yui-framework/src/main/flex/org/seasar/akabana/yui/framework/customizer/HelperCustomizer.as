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
    import org.seasar.akabana.yui.logging.Logger;

    [ExcludeClass]
    public class HelperCustomizer extends AbstractComponentCustomizer {
        
        CONFIG::DEBUG {
            private static const _logger:Logger = Logger.getLogger(HelperCustomizer);
        }
        
        public override function customizeView(container:UIComponent):void {
            const properties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const helperClassName:String = YuiFrameworkGlobals.namingConvention.getHelperClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("Customizing",viewClassName,helperClassName));
                }
                //
                const helperClassRef:ClassRef = getClassRef(helperClassName);
                const helper:Object = helperClassRef.newInstance();
                properties[YuiFrameworkGlobals.namingConvention.getHelperPackageName()] = helper;
                //
                setPropertiesValue(helper,viewClassName,container);
                var viewPropertyRef:PropertyRef = helperClassRef.getPropertyRef("view");
                if( viewPropertyRef != null && viewPropertyRef.isWriteable ){
                    var value:Object = viewPropertyRef.getValue(helper);
                    if( value == null ){
                        viewPropertyRef.setValue(helper,container);
                    }
                }
                //
                CONFIG::FP9 {
                    const viewProps:Array = getClassRef(getCanonicalName(container)).properties;
                }
                CONFIG::FP10 {
                    const viewProps:Vector.<PropertyRef> = getClassRef(getCanonicalName(container)).properties;
                }
                var helperPropRef:PropertyRef;
                for each(var viewProp:PropertyRef in viewProps) {
                    helperPropRef = helperClassRef.getPropertyRef(viewProp.name);
                    if( helperPropRef != null && helperPropRef.uri == view.toString()){
                        helperPropRef.setValue(helper,viewProp.getValue(container));                   
                    }
                }
                //
                const action:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];

                if(action != null) {
                    setPropertiesValue(action,helperClassName,helper);
                }
                //
                const behaviors:Array = properties[YuiFrameworkGlobals.namingConvention.getBehaviorPackageName()];

                if(behaviors != null) {
                    for each( var behavior:Object in behaviors){
                        setPropertiesValue(behavior,helperClassName,helper);
                    }
                }
                
                if( helper is ILifeCyclable ){
                    (helper as ILifeCyclable).start();
                }
                CONFIG::DEBUG {
                    _logger.debug(getMessage("Customized",viewClassName,helperClassName));
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("CustomizeError",container,e.getStackTrace()));
                }
            }
        }

        public override function uncustomizeView(container:UIComponent):void {
            const properties:Object = UIComponentUtil.getProperties(container);
            const viewClassName:String = getCanonicalName(container);
            const helperClassName:String = YuiFrameworkGlobals.namingConvention.getHelperClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("Uncustomizing",viewClassName,helperClassName));
                }
                //
                const helper:Object = properties[YuiFrameworkGlobals.namingConvention.getHelperPackageName()];
                if( helper is ILifeCyclable ){
                    (helper as ILifeCyclable).stop();
                }
                //
                const action:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];
                if(action != null) {
                    setPropertiesValue(action,helperClassName,null);
                }
                //
                setPropertiesValue(helper,viewClassName,null);
                properties[YuiFrameworkGlobals.namingConvention.getHelperPackageName()] = null;
                delete properties[YuiFrameworkGlobals.namingConvention.getHelperPackageName()];
                //
                CONFIG::DEBUG {
                    _logger.debug(getMessage("Uncustomized",viewClassName,helperClassName));
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("CustomizeError",container,e.getStackTrace()));
                }
            }
        }
    }
}