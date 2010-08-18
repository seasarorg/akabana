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
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.logging.Logger;
    import org.seasar.akabana.yui.service.Service;
    import org.seasar.akabana.yui.service.ServiceManager;

    [ExcludeClass]
    public class ServiceCustomizer extends AbstractComponentCustomizer {
		
		CONFIG::DEBUG {
			private static const _logger:Logger = Logger.getLogger(ServiceCustomizer);	
		}

        public override function customizeView(view:UIComponent):void {
            const properties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);

            try {
                const action:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];

                if(action != null) {
                    processCustomize(action);
                }

				const behaviors:Array = properties[YuiFrameworkGlobals.namingConvention.getBehaviorPackageName()];
				if(behaviors != null) {
					for each(var behavior:Object in behaviors) {
						processCustomize(behavior);
					}
				}
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("CustomizeError",view,e.getStackTrace()));
                }
            }
        }

        public override function uncustomizeView(view:UIComponent):void {
            const properties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);

            try {
                const action:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];

                if(action != null) {
                    processUncustomize(action);
                }

				const behaviors:Array = properties[YuiFrameworkGlobals.namingConvention.getBehaviorPackageName()];
				if(behaviors != null) {
					for each(var behavior:Object in behaviors) {
						processUncustomize(behavior);
					}
				}
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("CustomizeError",view,e.getStackTrace()));
                }
            }
        }

        protected function processCustomize(target:Object):void {
            const classRef:ClassRef = getClassRef(target);

			var service:Service;
            for each(var propertyRef:PropertyRef in classRef.properties) {
                if(propertyRef.typeClassRef.isAssignableFrom(Service)) {
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Customizing",classRef.name,propertyRef.name));
                    }
                    service = ServiceManager.createService(propertyRef.typeClassRef.concreteClass,propertyRef.name);
                    propertyRef.setValue(target,service);
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Customized",classRef.name,propertyRef.name));
                    }
                }
            }
        }

        protected function processUncustomize(target:Object):void {
            const classRef:ClassRef = getClassRef(target);

			var service:Service;
            for each(var propertyRef:PropertyRef in classRef.properties) {
                if(propertyRef.typeClassRef.isAssignableFrom(Service)) {
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Uncustomizing",classRef.name,propertyRef.name));
                    }
                    service = propertyRef.getValue(target) as Service;
                    service.deletePendingCallOf(target);
                    propertyRef.setValue(target,null);
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Uncustomized",classRef.name,propertyRef.name));
                    }
                }
            }
        }
    }
}