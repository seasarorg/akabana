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

    import flash.events.IEventDispatcher;

    import mx.core.UIComponent;

    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.framework.core.ILifeCyclable;
	import org.seasar.akabana.yui.framework.logging.debug;

    [ExcludeClass]
    public class ActionCustomizer extends AbstractEventListenerCustomizer {
        
        public override function customizeView(view:UIComponent ):void {
            const properties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            const viewName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    debug(this,getMessage("Customizing",viewClassName,actionClassName));
                }
                //
                const actionClassRef:ClassRef = getClassRef(actionClassName);
                const action:Object = newInstance(actionClassRef);
                doEventCustomize(viewName,view,action);
                properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()] = action;
                
                if( action is ILifeCyclable ){
                    (action as ILifeCyclable).start();
                }
                //
                CONFIG::DEBUG {
                    debug(this,getMessage("Customized",viewClassName,actionClassName));
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    debug(this,getMessage("CustomizeError",view,e.getStackTrace()));
                }
            }
        }

        public override function uncustomizeView(view:UIComponent ):void {
            const properties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    debug(this,getMessage("Uncustomizing",viewClassName,actionClassName));
                }
                const action:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];
                if( action is ILifeCyclable ){
                    (action as ILifeCyclable).stop();
                }
                //
                doEventUncustomize(view,action);
                properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()] = null;
                delete properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];
                //
                CONFIG::DEBUG {
                    debug(this,getMessage("Uncustomized",viewClassName,actionClassName));
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    debug(this,getMessage("CustomizeError",view,e.getStackTrace()));
                }
            }
        }
    }
}