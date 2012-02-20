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
package net.akb7.yui.customizer
{
    import __AS3__.vec.Vector;

    import mx.core.UIComponent;
    import net.akb7.yui.core.reflection.ClassRef;
    import net.akb7.yui.core.reflection.PropertyRef;
    import net.akb7.yui.YuiFrameworkGlobals;
    import net.akb7.yui.util.UIComponentUtil;
    import net.akb7.yui.logging.debug;
    import net.akb7.yui.convention.NamingConvention;
    import net.akb7.yui.core.InstanceCache;
    
    [ExcludeClass]
    public final class CommandCustomizer extends AbstractComponentCustomizer {
        
        public override function customizeView(view:UIComponent):void {
            const properties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            
            try {
                const action:Object = properties[NamingConvention.ACTION];
                
                if(action == null) {
                    //no action 
                } else {
                    processCustomize(action);
                    const behaviors:Array = properties[NamingConvention.BEHAVIOR];
                    if(behaviors != null) {
                        for each(var behavior:Object in behaviors) {
                            processCustomize(behavior);
                        }
                    }
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",view,e.getStackTrace());
                }
            }
        }
        
        public override function uncustomizeView(view:UIComponent):void {
            const properties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            
            try {
                const action:Object = properties[NamingConvention.ACTION];
                
                if(action != null) {
                    processUncustomize(action);
                }
                
                const behaviors:Array = properties[NamingConvention.BEHAVIOR];
                if(behaviors != null) {
                    for each(var behavior:Object in behaviors) {
                        processUncustomize(behavior);
                    }
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",view,e.getStackTrace());
                }
            }
        }
        
        private function processCustomize(target:Object):void {
            const classRef:ClassRef = getClassRef(target);
            
            var command:Object;
            for each(var propertyRef:PropertyRef in classRef.properties) {
                var className:String = propertyRef.typeClassRef.className;
                if(
                    YuiFrameworkGlobals.namingConvention.isCommandClassName(className) &&
                    (!propertyRef.typeClassRef.isInterface)
                ) {
                    CONFIG::DEBUG {
                        _debug("Customizing",classRef.name,propertyRef.name);
                    }
                    command = InstanceCache.newInstance( propertyRef.typeClassRef );
                    propertyRef.setValue(target,command);
                    CONFIG::DEBUG {
                        _debug("Customized",classRef.name,propertyRef.name);
                    }
                }
            }
        }
        
        private function processUncustomize(target:Object):void {
            const classRef:ClassRef = getClassRef(target);
            
            for each(var propertyRef:PropertyRef in classRef.properties) {
                var className:String = propertyRef.typeClassRef.className;
                if(
                    YuiFrameworkGlobals.namingConvention.isCommandClassName(className) &&
                    (!propertyRef.typeClassRef.isInterface)
                ) {
                    CONFIG::DEBUG {
                        _debug("Uncustomizing",classRef.name,propertyRef.name);
                    }
                    propertyRef.setValue(target,null);
                    CONFIG::DEBUG {
                        _debug("Uncustomized",classRef.name,propertyRef.name);
                    }
                }
            }
        }
    }
}