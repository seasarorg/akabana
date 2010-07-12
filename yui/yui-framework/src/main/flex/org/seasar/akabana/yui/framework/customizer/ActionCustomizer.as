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

    import flash.events.IEventDispatcher;

    import mx.core.UIComponent;

    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.logging.Logger;
    import org.seasar.akabana.yui.framework.core.ILifeCyclable;

    [ExcludeClass]
    public class ActionCustomizer extends AbstractEventCustomizer {

        private static const _logger:Logger = Logger.getLogger(ActionCustomizer);

        public override function customize(view:UIComponent,owner:UIComponent = null):void {
            if( owner != null ){
                return;
            }
            const properties:Object = UIComponentUtil.getProperties(view);
            const viewClassName:String = getCanonicalName(view);
            const viewName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("Customizing",viewClassName,actionClassName));
                }
                //
                const actionClassRef:ClassRef = getClassRef(actionClassName);
                const action:Object = actionClassRef.newInstance();
                doEventCustomize(viewName,view,action);
                properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()] = action;
				
				if( action is ILifeCyclable ){
					(action as ILifeCyclable).start();
				}
                //
                CONFIG::DEBUG {
                    _logger.debug(getMessage("Customized",viewClassName,actionClassName));
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
            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);

            try {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("Uncustomizing",viewClassName,actionClassName));
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
                    _logger.debug(getMessage("Uncustomized",viewClassName,actionClassName));
                }
            } catch(e:Error) {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("CustomizeError",view,e.getStackTrace()));
                }
            }
        }

        protected function doEventCustomize(viewName:String,view:UIComponent,action:Object):void {
            const actionClassRef:ClassRef = getClassRef(action);
            CONFIG::FP9 {
                var props:Array = actionClassRef.properties;
            }
            CONFIG::FP10 {
                var props:Vector.<PropertyRef> = actionClassRef.properties;
            }

            for each(var prop:PropertyRef in props) {
                const child:Object = prop.getValue(action);

                if(child != null && child is IEventDispatcher) {
                    CONFIG::FP9 {
                        doCustomizingByComponent(
                                        view,
                                        prop.name,
                                        child as IEventDispatcher,
                                        action,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Array):Boolean {
                                            return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                                        }
                                        ),
                                        int.MAX_VALUE>>2
                                        );
                    }
                    CONFIG::FP10 {
                        doCustomizingByComponent(
                                        view,
                                        prop.name,
                                        child as IEventDispatcher,
                                        action,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                            return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                                        }
                                        ),
                                        int.MAX_VALUE>>2
                                        );
                    }
                }
            }
        }

        protected function doEventUncustomize(view:UIComponent,action:Object):void {
            const actionClassRef:ClassRef = getClassRef(action);
            CONFIG::FP9 {
                var props:Array = actionClassRef.properties;
            }
            CONFIG::FP10 {
                var props:Vector.<PropertyRef> = actionClassRef.properties;
            }

            for each(var prop:PropertyRef in props) {
                const child:Object = prop.getValue(action);

                if(child != null && child is IEventDispatcher) {
                    CONFIG::FP9 {
                        doUnCustomizingByComponent(
                                        view,
                                        prop.name,
                                        child as IEventDispatcher,
                                        action,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Array):Boolean {
                                            return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                                        }
                                        )
                                        );
                    }
                    CONFIG::FP10 {
                        doUnCustomizingByComponent(
                                        view,
                                        prop.name,
                                        child as IEventDispatcher,
                                        action,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                            return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                                        }
                                        )
                                        );
                    }
                }
            }
        }
    }
}