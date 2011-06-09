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
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.framework.core.ILifeCyclable;
	import org.seasar.akabana.yui.framework.logging.debug;
	import org.seasar.akabana.yui.framework.core.InstanceCache;

    [ExcludeClass]
    public class BehaviorCustomizer extends AbstractComponentEventListenerCustomizer {
        
        public override function customizeView(view:UIComponent):void {
            const viewProperties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            const viewName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
            
            try {
                const action:Object = viewProperties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];
                if( action == null ){
                    //no action
                } else {
                    const actionClassRef:ClassRef = getClassRef(action);
                    CONFIG::FP9 {
                        var props:Array = actionClassRef.properties;
                    }
                    CONFIG::FP10 {
                        var props:Vector.<PropertyRef> = actionClassRef.properties;
                    }
    
                    var behaviors:Array = viewProperties[YuiFrameworkGlobals.namingConvention.getBehaviorPackageName()] = [];
                    var behavior:Object;
                    for each(var prop:PropertyRef in props) {
                        if( YuiFrameworkGlobals.namingConvention.isBehaviorOfView( viewClassName, prop.typeClassRef.name )){
    
                            CONFIG::DEBUG {
                                _debug("Customizing",viewClassName,prop.typeClassRef.name);
                            }
                            behavior = InstanceCache.newInstance(prop.typeClassRef);
                            prop.setValue(action,behavior);
                            behaviors.push(behavior);
    
                            super.doEventCustomize(viewName,view,behavior);
    
                            if( behavior is ILifeCyclable ){
                                (behavior as ILifeCyclable).start();
                            }
                            CONFIG::DEBUG {
                                _debug("Customized",viewClassName,prop.typeClassRef.name);
                            }
                        } else {
                            CONFIG::DEBUG {
                                if( YuiFrameworkGlobals.namingConvention.isBehaviorClassName(prop.typeClassRef.name)){
                                    _debug("CustomizeWarning",prop.typeClassRef.name+"isn't the Behavior Class of "+viewClassName);
                                }
                            }
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
            const viewProperties:Object = UIComponentUtil.getProperties(view);
            const viewName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
            const viewClassName:String = getCanonicalName(view);
            const action:Object = viewProperties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];
            if( action == null ){
                return;
            }
            try {
                const actionClassRef:ClassRef = getClassRef(action);
                CONFIG::FP9 {
                    var props:Array = actionClassRef.properties;
                }
                CONFIG::FP10 {
                    var props:Vector.<PropertyRef> = actionClassRef.properties;
                }

                var behaviors:Array = viewProperties[YuiFrameworkGlobals.namingConvention.getBehaviorPackageName()];
                var behaviorClassName:String;
                for each(var behavior:Object in behaviors) {

                    behaviorClassName = getCanonicalName(behavior);
                    CONFIG::DEBUG {
                        _debug("Uncustomizing",viewClassName,behaviorClassName);
                    }
                    
                    if( behavior is ILifeCyclable ){
                        (behavior as ILifeCyclable).stop();
                    }
                    super.doEventUncustomize(view,behavior);

                    CONFIG::DEBUG {
                        _debug("Uncustomized",viewClassName,behaviorClassName);
                    }
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",view,e.getStackTrace());
                }
            }
        }


    }
}