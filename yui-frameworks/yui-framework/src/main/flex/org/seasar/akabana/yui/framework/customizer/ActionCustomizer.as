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
    import __AS3__.vec.Vector;

    import flash.events.IEventDispatcher;

    import mx.core.UIComponent;

    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.framework.core.ILifeCyclable;
    import org.seasar.akabana.yui.framework.logging.debug;
    import org.seasar.akabana.yui.framework.core.InstanceCache;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;

    [ExcludeClass]
    public final class ActionCustomizer extends AbstractComponentCustomizer {
        
        public override function customizeView(view:UIComponent ):void {
            const viewProperties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            const viewName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    _debug("Customizing",viewClassName,actionClassName);
                }
                //
                const actionClassRef:ClassRef = getClassRef(actionClassName);
                const action:Object = InstanceCache.newInstance(actionClassRef);
                
                viewProperties[NamingConvention.ACTION] = action;
                
                if( action is ILifeCyclable ){
                    (action as ILifeCyclable).start();
                }
                //
                CONFIG::DEBUG {
                    _debug("Customized",viewClassName,actionClassName);
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",view,e.getStackTrace());
                }
            }
        }

        public override function uncustomizeView(view:UIComponent ):void {
            const viewProperties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    _debug("Uncustomizing",viewClassName,actionClassName);
                }
                const action:Object = viewProperties[NamingConvention.ACTION];
                if( action is ILifeCyclable ){
                    (action as ILifeCyclable).stop();
                }
                //
                viewProperties[NamingConvention.ACTION] = null;
                delete viewProperties[NamingConvention.ACTION];
                //
                CONFIG::DEBUG {
                    _debug("Uncustomized",viewClassName,actionClassName);
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _debug("CustomizeError",view,e.getStackTrace());
                }
            }
        }
    }
}