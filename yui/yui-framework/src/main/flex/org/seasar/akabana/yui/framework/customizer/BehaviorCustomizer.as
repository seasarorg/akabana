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

    import mx.core.UIComponent;

    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.logging.Logger;

    [ExcludeClass]
    public class BehaviorCustomizer extends ActionCustomizer {

        private static const _logger:Logger = Logger.getLogger(BehaviorCustomizer);

        public override function customize(view:UIComponent,owner:UIComponent = null):void {
            if( owner != null ){
                return;
            }

            const properties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            const viewName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);

            try {
                const action:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];
                const actionClassRef:ClassRef = getClassRef(action);
                CONFIG::FP9 {
                    var props:Array = actionClassRef.properties;
                }
                CONFIG::FP10 {
                    var props:Vector.<PropertyRef> = actionClassRef.properties;
                }

                var behaviors:Array = properties[YuiFrameworkGlobals.namingConvention.getBehaviorPackageName()] = [];
                for each(var prop:PropertyRef in props) {
                    if( YuiFrameworkGlobals.namingConvention.isBehaviorClassName( prop.typeClassRef.name )){

                        CONFIG::DEBUG {
                            _logger.debug(getMessage("Customizing",viewClassName,prop.typeClassRef.name));
                        }
                        const behavior:Object = prop.typeClassRef.newInstance();

                        behaviors.push(behavior);

                        super.doEventCustomize(viewName,view,behavior);

                        CONFIG::DEBUG {
                            _logger.debug(getMessage("Customized",viewClassName,prop.typeClassRef.name));
                        }
                    }
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
            const viewName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
            const viewClassName:String = getCanonicalName(view);
            try {
                const action:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];
                const actionClassRef:ClassRef = getClassRef(action);
                CONFIG::FP9 {
                    var props:Array = actionClassRef.properties;
                }
                CONFIG::FP10 {
                    var props:Vector.<PropertyRef> = actionClassRef.properties;
                }

                var behaviors:Array = properties[YuiFrameworkGlobals.namingConvention.getBehaviorPackageName()];
                for each(var behavior:Object in behaviors) {

                    const behaviorClassName:String = getCanonicalName(view);
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Uncustomizing",viewClassName,behaviorClassName));
                    }

                    super.doEventUncustomize(view,behavior);

                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Uncustomized",viewClassName,behaviorClassName));
                    }
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("CustomizeError",view,e.getStackTrace()));
                }
            }
        }


    }
}