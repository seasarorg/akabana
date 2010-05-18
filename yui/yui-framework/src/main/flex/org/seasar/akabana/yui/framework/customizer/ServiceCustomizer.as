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
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceManager;

    [ExcludeClass]
    public class ServiceCustomizer extends AbstractComponentCustomizer {
        private static const _logger:Logger = Logger.getLogger(ServiceCustomizer);

        public override function customize(view:UIComponent,owner:UIComponent = null):void {
            if( owner != null ){
                return;
            }
            const properties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);

            try {
                const action:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];

                if(action != null) {
                    processCustomize(action);
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

            try {
                const action:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];

                if(action != null) {
                    processUncustomize(action);
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("CustomizeError",view,e.getStackTrace()));
                }
            }
        }

        protected function processCustomize(action:Object):void {
            const actionClassRef:ClassRef = getClassRef(action);

            for each(var propertyRef:PropertyRef in actionClassRef.properties) {
                if(propertyRef.typeClassRef.isAssignableFrom(Service)) {
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Customizing",actionClassRef.name,propertyRef.name));
                    }
                    var service:Service = ServiceManager.createService(propertyRef.typeClassRef.concreteClass,propertyRef.name);
                    propertyRef.setValue(action,service);
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Customized",actionClassRef.name,propertyRef.name));
                    }
                }
            }
        }

        protected function processUncustomize(action:Object):void {
            const actionClassRef:ClassRef = getClassRef(action);

            for each(var propertyRef:PropertyRef in actionClassRef.properties) {
                if(propertyRef.typeClassRef.isAssignableFrom(Service)) {
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Uncustomizing",actionClassRef.name,propertyRef.name));
                    }
                    var service:Service = propertyRef.getValue(action) as Service;
                    service.deletePendingCallOf(action);
                    propertyRef.setValue(action,null);
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Uncustomized",actionClassRef.name,propertyRef.name));
                    }
                }
            }
        }
    }
}