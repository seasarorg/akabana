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
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;

    import mx.core.UIComponent;
    import mx.core.UIComponentDescriptor;

    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.core.event.RuntimeErrorEvent;
    import org.seasar.akabana.yui.framework.ns.handler;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.logging.Logger;

    internal class AbstractEventCustomizer extends AbstractComponentCustomizer {
        private static const _logger:Logger = Logger.getLogger(AbstractEventCustomizer);

        protected static const EVENT_SEPARETOR:String = "_";

        protected static const ENHANCED_SEPARETOR:String = "$";

        protected static const ENHANCED_PREFIX:String = ENHANCED_SEPARETOR + "enhanced" + ENHANCED_SEPARETOR;

        protected static const FUNCTION_OWNER:String = "$owner";

        protected static const FUNCTION_PROTO:String = "$proto";

        protected function getEventName(functionRef:FunctionRef,componentName:String):String {
            const functionName:String = functionRef.name;
            const ns:Namespace = handler;
            const eventWord:String = functionName.substr(componentName.length);
            const handlerIndex:int = eventWord.lastIndexOf(YuiFrameworkGlobals.namingConvention.getHandlerSuffix());
            var result:String = null;

            if(eventWord.charAt(0) == EVENT_SEPARETOR) {
                if(functionRef.uri == ns.uri) {
                    result = eventWord.substring(1);
                } else {
                    result = eventWord.substring(1,handlerIndex);
                }
            } else {
                if(functionRef.uri == ns.uri) {
                    result = eventWord.substr(0,1).toLocaleLowerCase() + eventWord.substring(1);
                } else {
                    result = eventWord.substr(0,1).toLocaleLowerCase() + eventWord.substring(1,handlerIndex);
                }
            }
            return result;
        }

        protected function getEnhancedEventName(viewName:String,eventName:String,listener:Object):String {
            var listenerClassName:String = ClassRef.getCanonicalName(listener);
            return viewName + ENHANCED_PREFIX + listenerClassName + ENHANCED_SEPARETOR + eventName;
        }

        protected function addEventListener(component:IEventDispatcher,eventName:String,handler:Function,priority:int):void {
            component.addEventListener(eventName,handler,false,priority,true);
        }

        protected function storeEnhancedEventHandler(component:UIComponent,enhancedEventName:String,handler:Function):void {
            var descriptor:UIComponentDescriptor = UIComponentUtil.getDescriptor(component);
            descriptor.events[enhancedEventName] = handler;
        }

        protected function removeEnhancedEventHandler(component:UIComponent,enhancedEventName:String):void {
            if(component.descriptor.events != null) {
                component.descriptor.events[enhancedEventName] = null;
                delete component.descriptor.events[enhancedEventName];
            }
        }

        protected function getEnhancedEventHandler(component:UIComponent,eventName:String):Function {
            var descriptor:UIComponentDescriptor = UIComponentUtil.getDescriptor(component);
            return descriptor.events[eventName];
        }

        protected function createEnhancedEventHandler(owner:IEventDispatcher,handler:Function):Function {
            const func_:Object = function(event:Event):void {
                                var callee:Object = arguments.callee;
                                try {
                                    var proto:Function = callee.properties[FUNCTION_PROTO] as Function;
                                    if(proto != null) {
                                        proto.apply(null,[event]);
                                    } else {
                                        throw new Error("EnhancedEventHandler doesn't have proto Handler");
                                    }
                                } catch(e:Error) {
                                    _logger.debug(e.getStackTrace());
                                    var owner:Object = callee.properties[FUNCTION_OWNER];
                                    if(owner is IEventDispatcher) {
                                        (owner as IEventDispatcher).dispatchEvent(RuntimeErrorEvent.createEvent(e));
                                    } else {
                                        throw e;
                                    }
                                }
                            };
            const properties:Dictionary = new Dictionary(true);
            properties[FUNCTION_OWNER] = owner;
            properties[FUNCTION_PROTO] = handler;
            func_.properties = properties;
            return func_ as Function;
        }

        protected function createEnhancedEventNoneHandler(owner:IEventDispatcher,handler:Function):Function {
            const func_:Object = function(event:Event):void {
                                var callee:Object = arguments.callee;
                                try {
                                    var proto:Function = callee.properties[FUNCTION_PROTO] as Function;
                                    if(proto != null) {
                                        proto.apply(null);
                                    } else {
                                        throw new Error("EnhancedEventHandler doesn't have proto Handler");
                                    }
                                } catch(e:Error) {
                                    _logger.debug(e.getStackTrace());
                                    var owner:Object = callee.properties[FUNCTION_OWNER];
                                    if(owner is IEventDispatcher) {
                                        (owner as IEventDispatcher).dispatchEvent(RuntimeErrorEvent.createEvent(e));
                                    } else {
                                        throw e;
                                    }
                                }
                            };
            const properties:Dictionary = new Dictionary(true);
            properties[FUNCTION_OWNER] = owner;
            properties[FUNCTION_PROTO] = handler;
            func_.properties = properties;
            return func_ as Function;
        }

        CONFIG::FP9 {
            protected function doCustomizingByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,listener:Object,functionRefs:Array,priority:int):void {
                var eventName:String;
                var enhancedEventName:String;
                var enhancedFunction:Function;

                for each(var functionRef:FunctionRef in functionRefs) {
                    eventName = getEventName(functionRef,componentName);
                    enhancedEventName = getEnhancedEventName(componentName,eventName,listener);
                    enhancedFunction = getEnhancedEventHandler(view,enhancedEventName);

                    if(enhancedFunction != null) {
                        component.removeEventListener(eventName,enhancedFunction);
                    }

                    if(functionRef.parameters.length > 0) {
                        enhancedFunction = createEnhancedEventHandler(view,functionRef.getFunction(listener));
                    } else {
                        enhancedFunction = createEnhancedEventNoneHandler(view,functionRef.getFunction(listener));
                    }
                    addEventListener(component,eventName,enhancedFunction,priority);
                    storeEnhancedEventHandler(view,enhancedEventName,enhancedFunction);
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("EventAddEvent",view.className,componentName == YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix() ? view.name : componentName,eventName,functionRef.name));
                    }
                }
            }
        }
        CONFIG::FP10 {
            protected function doCustomizingByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,listener:Object,functionRefs:Vector.<FunctionRef>,priority:int):void {
                var eventName:String;
                var enhancedEventName:String;
                var enhancedFunction:Function;

                for each(var functionRef:FunctionRef in functionRefs) {
                    eventName = getEventName(functionRef,componentName);
                    enhancedEventName = getEnhancedEventName(componentName,eventName,listener);
                    enhancedFunction = getEnhancedEventHandler(view,enhancedEventName);

                    if(enhancedFunction != null) {
                        component.removeEventListener(eventName,enhancedFunction);
                    }

                    if(functionRef.parameters.length > 0) {
                        enhancedFunction = createEnhancedEventHandler(view,functionRef.getFunction(listener));
                    } else {
                        enhancedFunction = createEnhancedEventNoneHandler(view,functionRef.getFunction(listener));
                    }
                    addEventListener(component,eventName,enhancedFunction,priority);
                    storeEnhancedEventHandler(view,enhancedEventName,enhancedFunction);
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("EventAddEvent",view.className,componentName == YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix() ? view.name : componentName,eventName,functionRef.name));
                    }
                }
            }
        }
        CONFIG::FP9 {
            protected function doUnCustomizingByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,listener:Object,functionRefs:Array):void {
                var eventName:String;
                var enhancedEventName:String;
                var enhancedFunction:Function;

                for each(var functionRef:FunctionRef in functionRefs) {
                    eventName = getEventName(functionRef,componentName);
                    enhancedEventName = getEnhancedEventName(componentName,eventName,listener);
                    enhancedFunction = getEnhancedEventHandler(view,enhancedEventName);

                    if(enhancedFunction != null) {
                        component.removeEventListener(eventName,enhancedFunction);
                        removeEnhancedEventHandler(view,enhancedEventName);
                        CONFIG::DEBUG {
                            _logger.debug(getMessage("EventRemoveEvent",view.className,componentName == YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix() ? view.toString() : componentName,eventName,functionRef.name));
                        }
                    }
                }
            }
        }
        CONFIG::FP10 {
            protected function doUnCustomizingByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,listener:Object,functionRefs:Vector.<FunctionRef>):void {
                var eventName:String;
                var enhancedEventName:String;
                var enhancedFunction:Function;

                for each(var functionRef:FunctionRef in functionRefs) {
                    eventName = getEventName(functionRef,componentName);
                    enhancedEventName = getEnhancedEventName(componentName,eventName,listener);
                    enhancedFunction = getEnhancedEventHandler(view,enhancedEventName);

                    if(enhancedFunction != null) {
                        component.removeEventListener(eventName,enhancedFunction);
                        removeEnhancedEventHandler(view,enhancedEventName);
                        CONFIG::DEBUG {
                            _logger.debug(getMessage("EventRemoveEvent",view.className,componentName == YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix() ? view.toString() : componentName,eventName,functionRef.name));
                        }
                    }
                }
            }
        }
    }
}