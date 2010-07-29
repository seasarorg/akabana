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
    import mx.core.IMXMLObject;
    import mx.core.UIComponent;
    import mx.core.UIComponentDescriptor;
    import mx.core.mx_internal;
    import mx.effects.IEffect;
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.logging.Logger;
    import mx.core.IUIComponent;

    use namespace mx_internal;

    [ExcludeClass]
    public class EventHandlerCustomizer extends AbstractComponentEventCustomizer implements IComponentCustomizer {
		
		CONFIG::DEBUG {
			private static const _logger:Logger = Logger.getLogger(EventHandlerCustomizer);	
		}
		
		public function customizeComponent( owner:UIComponent, view:UIComponent ):void{
			const componentName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
			const ownerName:String = YuiFrameworkGlobals.namingConvention.getComponentName(owner);
			const ownerClassName:String = getCanonicalName(view);
			const ownerProperties:Object = UIComponentUtil.getProperties(owner);
			const ownerAction_:Object = ownerProperties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];
			
			if(ownerAction_ != null) {
				const actionClassRef:ClassRef = getClassRef(ownerAction_);
				CONFIG::DEBUG {
					_logger.debug(getMessage("Customizing",ownerName,actionClassRef.name));
				}
				CONFIG::FP9 {
					doCustomizingByComponent(
						owner,
						componentName,
						view,
						ownerAction_,
						actionClassRef.functions.filter(
							function(item:*,index:int,array:Array):Boolean {
								return ((item as FunctionRef).name.indexOf(componentName) == 0);
							}
						),
						int.MAX_VALUE>>1
					);
				}
				CONFIG::FP10 {
					doCustomizingByComponent(
						owner,
						componentName,
						view,
						ownerAction_,
						actionClassRef.functions.filter(
							function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
								return ((item as FunctionRef).name.indexOf(componentName) == 0);
							}
						),
						int.MAX_VALUE>>1
					);
				}
				CONFIG::DEBUG {
					_logger.debug(getMessage("Customized",ownerName,actionClassRef.name));
				}
			}
			//
			const ownerBehaviors_:Array = ownerProperties[YuiFrameworkGlobals.namingConvention.getBehaviorPackageName()];
			
			if(ownerBehaviors_ != null) {
				for each(var ownerBehavior_:Object in ownerBehaviors_) {
					const behaviorClassRef:ClassRef = getClassRef(ownerBehavior_);
					CONFIG::DEBUG {
						_logger.debug(getMessage("Customizing",ownerClassName,behaviorClassRef.name));
					}
					CONFIG::FP9 {
						doCustomizingByComponent(
							owner,
							componentName,
							view,
							ownerBehavior_,
							behaviorClassRef.functions.filter(
								function(item:*,index:int,array:Array):Boolean {
									return ((item as FunctionRef).name.indexOf(componentName) == 0);
								}
							),
							0
						);
					}
					CONFIG::FP10 {
						doCustomizingByComponent(
							owner,
							componentName,
							view,
							ownerBehavior_,
							behaviorClassRef.functions.filter(
								function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
									return ((item as FunctionRef).name.indexOf(componentName) == 0);
								}
							),
							0
						);
					}
					CONFIG::DEBUG {
						_logger.debug(getMessage("Customized",ownerClassName,behaviorClassRef.name));
					}
				}
			}
		}

        public override function customizeView(view:UIComponent):void {
            const viewName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
            const viewClassName:String = getCanonicalName(view);
            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);
            const properties:Object = UIComponentUtil.getProperties(view);
            //
            const action_:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];

            if(action_ != null) {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("Customizing",viewClassName,actionClassName));
                }
                doCustomize(view,action_,int.MAX_VALUE>>1);
                CONFIG::DEBUG {
                    _logger.debug(getMessage("Customized",viewClassName,actionClassName));
                }
            }
            //
            const behaviors_:Array = properties[YuiFrameworkGlobals.namingConvention.getBehaviorPackageName()];

            if(behaviors_ != null) {
                for each(var behavior_:Object in behaviors_) {
                    const behaviorClassName:String = getCanonicalName(behavior_);
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Customizing",viewClassName,behaviorClassName));
                    }
                    doCustomize(view,behavior_,int.MAX_VALUE>>1);
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Customized",viewClassName,behaviorClassName));
                    }
                }
            }
        }

		public function isTargetComponent( component:UIComponent ):Boolean{
			return component.initialized && component.parent != null;
		}
		
		public function uncustomizeComponent( owner:UIComponent, component:UIComponent):void{
			const componentName:String = YuiFrameworkGlobals.namingConvention.getComponentName(component);
			const ownerClassName:String = getCanonicalName(owner);
			const ownerProperties:Object = UIComponentUtil.getProperties(owner);
			const ownerAction_:Object = ownerProperties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];
			
			if(ownerAction_ != null) {
				const actionClassRef:ClassRef = getClassRef(ownerAction_);
				CONFIG::DEBUG {
					_logger.debug(getMessage("Uncustomizing",ownerClassName,actionClassRef.name));
				}
				CONFIG::FP9 {
					doUnCustomizingByComponent(
						owner,
						componentName,
						component,
						ownerAction_,
						actionClassRef.functions.filter(
							function(item:*,index:int,array:Array):Boolean {
								return ((item as FunctionRef).name.indexOf(componentName) == 0);
							}
						)
					);
				}
				CONFIG::FP10 {
					doUnCustomizingByComponent(
						owner,
						componentName,
						component,
						ownerAction_,
						actionClassRef.functions.filter(
							function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
								return ((item as FunctionRef).name.indexOf(componentName) == 0);
							}
						)
					);
				}
				CONFIG::DEBUG {
					_logger.debug(getMessage("Uncustomized",ownerClassName,actionClassRef.name));
				}
			}
			//
			const ownerBehaviors_:Array = ownerProperties[YuiFrameworkGlobals.namingConvention.getBehaviorPackageName()];
			
			if(ownerBehaviors_ != null) {
				for each(var ownerBehavior_:Object in ownerBehaviors_) {
					const behaviorClassRef:ClassRef = getClassRef(ownerBehavior_);
					CONFIG::DEBUG {
						_logger.debug(getMessage("Uncustomizing",ownerClassName,behaviorClassRef.name));
					}
					CONFIG::FP9 {
						doUnCustomizingByComponent(
							owner,
							componentName,
							view,
							ownerBehavior_,
							behaviorClassRef.functions.filter(
								function(item:*,index:int,array:Array):Boolean {
									return ((item as FunctionRef).name.indexOf(componentName) == 0);
								}
							)
						);
					}
					CONFIG::FP10 {
						doUnCustomizingByComponent(
							owner,
							componentName,
							component,
							ownerBehavior_,
							behaviorClassRef.functions.filter(
								function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
									return ((item as FunctionRef).name.indexOf(componentName) == 0);
								}
							)
						);
					}
					CONFIG::DEBUG {
						_logger.debug(getMessage("Uncustomized",ownerClassName,behaviorClassRef.name));
					}
				}
			}
		}
		
        public override function uncustomizeView(view:UIComponent):void {
            const properties:Object = UIComponentUtil.getProperties(view);
            const viewName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
            const viewClassName:String = getCanonicalName(view);
            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);

            const action:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];

            if(action != null) {
                CONFIG::DEBUG {
                    _logger.debug(getMessage("Uncustomizing",viewClassName,actionClassName));
                }
                doUncustomize(view,action);
                CONFIG::DEBUG {
                    _logger.debug(getMessage("Uncustomized",viewClassName,actionClassName));
                }
            }
            //
            const behaviors_:Array = properties[YuiFrameworkGlobals.namingConvention.getBehaviorPackageName()];

            if(behaviors_ != null) {
                for each(var behavior_:Object in behaviors_) {
                    const behaviorClassName:String = getCanonicalName(behavior_);
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Uncustomizing",viewClassName,behaviorClassName));
                    }
                    doUncustomize(view,behavior_);
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Uncustomized",viewClassName,behaviorClassName));
                    }
                }
            }
        }

        private function doCustomize(container:UIComponent,action:Object,priority:int = int.MAX_VALUE):void {	
            const actionClassRef:ClassRef = getClassRef(action);
            //for children
            CONFIG::FP9 {
                var props:Array = getClassRef(getCanonicalName(container)).properties;
            }
            CONFIG::FP10 {
                var props:Vector.<PropertyRef> = getClassRef(getCanonicalName(container)).properties;
            }

            for each(var prop:PropertyRef in props) {
                const child:Object = container[prop.name];

                if(child != null &&
                                child is IEventDispatcher &&
                                (child is IUIComponent || child is IMXMLObject || child is IEffect)) {
                    CONFIG::FP9 {
                        doCustomizeByComponent(
										container,
                                        prop.name,
                                        child as IEventDispatcher,
                                        action,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Array):Boolean {
                                            return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                                        }
                                        ),
                                        priority
                                        );
                    }
                    CONFIG::FP10 {
                        doCustomizeByComponent(
										container,
                                        prop.name,
                                        child as IEventDispatcher,
                                        action,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                            return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                                        }
                                        ),
                                        priority
                                        );
                    }
                }
            }
            //for self
            CONFIG::FP9 {
                doCustomizeByComponent(
								container,
                                null,
                                null,
                                action,
                                actionClassRef.functions.filter(
                                function(item:*,index:int,array:Array):Boolean {
                                    return ((item as FunctionRef).name.indexOf(YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix()) == 0);
                                }
                                ),
                                priority
                                );
            }
            CONFIG::FP10 {
                doCustomizeByComponent(
								container,
                                null,
                                null,
                                action,
                                actionClassRef.functions.filter(
                                function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                    return ((item as FunctionRef).name.indexOf(YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix()) == 0);
                                }
                                ),
                                priority
                                );
            }
        }

        CONFIG::FP9 {
            private function doCustomizeByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,action:Object,functionRefs:Array,priority:int):void {
                var componentName:String;

                if(componentName != null) {
                    if(component == null) {
                        if(view.hasOwnProperty(componentName)) {
                            component = view[componentName] as IEventDispatcher;
                        } else {
                            component = view.getChildByName(componentName) as IEventDispatcher;
                        }
                    }
                } else {
                    componentName = YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix();
                    component = view;
                }
                doCustomizingByComponent(view,componentName,component,action,functionRefs,priority);
            }
        }
        CONFIG::FP10 {
            private function doCustomizeByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,action:Object,functionRefs:Vector.<FunctionRef>,priority:int):void {
                var componentName:String;

                if(componentName != null) {
                    if(component == null) {
                        if(view.hasOwnProperty(componentName)) {
                            component = view[componentName] as IEventDispatcher;
                        } else {
                            component = view.getChildByName(componentName) as IEventDispatcher;
                        }
                    }
                } else {
                    componentName = YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix();
                    component = view;
                }
                doCustomizingByComponent(view,componentName,component,action,functionRefs,priority);
            }
        }

        private function doUncustomize(container:UIComponent,action:Object):void {
            const actionClassRef:ClassRef = getClassRef(action);
            //for children
            CONFIG::FP9 {
                const props:Array = getClassRef(getCanonicalName(container)).properties;
            }
            CONFIG::FP10 {
                const props:Vector.<PropertyRef> = getClassRef(getCanonicalName(container)).properties;
            }

            for each(var prop:PropertyRef in props) {
                const child:Object = container[prop.name];

				if(child != null &&
						child is IEventDispatcher &&
						(child is IUIComponent || child is IMXMLObject || child is IEffect)) {
                    CONFIG::FP9 {
                        doUncustomizeByComponent(
										container,
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
                        doUncustomizeByComponent(
										container,
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
            //for self
            CONFIG::FP9 {
                doUncustomizeByComponent(
								container,
                                null,
                                null,
                                action,
                                actionClassRef.functions.filter(
                                function(item:*,index:int,array:Array):Boolean {
                                    return ((item as FunctionRef).name.indexOf(YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix()) == 0);
                                }
                                )
                                );
            }
            CONFIG::FP10 {
                doUncustomizeByComponent(
								container,
                                null,
                                null,
                                action,
                                actionClassRef.functions.filter(
                                function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                    return ((item as FunctionRef).name.indexOf(YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix()) == 0);
                                }
                                )
                                );
            }
        }

        CONFIG::FP9 {
            private function doUncustomizeByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,action:Object,functionRefs:Array):void {
                var componentName:String;

                if(componentName != null) {
                    if(component == null) {
                        if(view.hasOwnProperty(componentName)) {
                            component = view[componentName] as IEventDispatcher;
                        } else {
                            component = view.getChildByName(componentName) as IEventDispatcher;
                        }
                    }
                } else {
                    componentName = YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix();
                    component = view;
                }
                doUnCustomizingByComponent(view,componentName,component,action,functionRefs);
            }
        }
        CONFIG::FP10 {
            private function doUncustomizeByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,action:Object,functionRefs:Vector.<FunctionRef>):void {
                var componentName:String;
                var component:IEventDispatcher;

                if(componentName != null) {
                    if(component == null) {
                        if(view.hasOwnProperty(componentName)) {
                            component = view[componentName] as IEventDispatcher;
                        } else {
                            component = view.getChildByName(componentName) as IEventDispatcher;
                        }
                    }
                } else {
                    componentName = YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix();
                    component = view;
                }
                doUnCustomizingByComponent(view,componentName,component,action,functionRefs);
            }
        }

    }
}