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
package org.seasar.akabana.yui.framework.customizer
{
    CONFIG::FP10 {
        import __AS3__.vec.Vector;
    }
    import flash.utils.Dictionary;
    import mx.core.UIComponent;
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.logging.Logger;

    [ExcludeClass]
    public class HelperCustomizer extends AbstractComponentCustomizer {

        private static const _logger:Logger = Logger.getLogger(HelperCustomizer);

        public override function customize(view:UIComponent,owner:UIComponent = null):void {
            if( owner != null ){
                return;
            }
            const properties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
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
                setPropertiesValue(helper,viewClassName,view);
                //
                const action:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];

                if(action != null) {
                    setPropertiesValue(action,helperClassName,helper);
                }
                CONFIG::DEBUG {
                    _logger.debug(getMessage("Customized",viewClassName,helperClassName));
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("CustomizeError",view,e.getStackTrace()));
                }
            }
        }

        public override function uncustomize(view:UIComponent,owner:UIComponent = null):void {
            if( owner != null ){
                return;
            }
            const properties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            const helperClassName:String = YuiFrameworkGlobals.namingConvention.getHelperClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("Uncustomizing",viewClassName,helperClassName));
                }
                //
                const helper:Object = properties[YuiFrameworkGlobals.namingConvention.getHelperPackageName()];
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
                    _logger.debug(getMessage("CustomizeError",view,e.getStackTrace()));
                }
            }
        }
    }
}