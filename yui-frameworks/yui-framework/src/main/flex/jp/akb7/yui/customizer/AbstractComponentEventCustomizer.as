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
package jp.akb7.yui.customizer
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    
    import mx.core.UIComponent;
    import mx.core.UIComponentDescriptor;
    
    import jp.akb7.yui.core.event.MessageEvent;
    import jp.akb7.yui.core.event.NotificationEvent;
    import jp.akb7.yui.core.reflection.ClassRef;
    import jp.akb7.yui.core.reflection.FunctionRef;
    import jp.akb7.yui.YuiFrameworkGlobals;
    import jp.akb7.yui.convention.NamingConvention;
    import jp.akb7.yui.event.RuntimeErrorEvent;
    import jp.akb7.yui.logging.debug;
    import jp.akb7.yui.util.UIComponentUtil;
    
    [ExcludeClass]
    public class AbstractComponentEventCustomizer extends AbstractComponentCustomizer {
        
        private static const ENHANCED_SEPARETOR:String = "$";
        private static const ENHANCED_PREFIX:String = ENHANCED_SEPARETOR + "enhanced" + ENHANCED_SEPARETOR;
        private static const FUNCTION_OWNER:String = "$owner";
        private static const FUNCTION_PROTO:String = "$proto";

        protected function getEventName(functionRef:FunctionRef,componentName:String):String {
            return YuiFrameworkGlobals.namingConvention.getEventName(functionRef.name,functionRef.uri,componentName);
        }

        protected function getEnhancedEventName(viewName:String,eventName:String,listener:Object):String {
            var listenerClassName:String = getCanonicalName(listener);
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
CONFIG::UNCAUGHT_ERROR_EVENT {
            const func_:Object = 
                function(event:Event):void {
                    var callee:Object = arguments.callee;
                    try {
                        var proto:Function = callee.properties[FUNCTION_PROTO] as Function;
                        if(proto != null) {
                            if( event is MessageEvent ){
                                proto.apply(null,[(event as MessageEvent).data]);
                            } else if( event is NotificationEvent ){
                                proto.apply(null,[(event as NotificationEvent).data]);
                            } else {
                                proto.apply(null,[event]);
                            }
                        } else {
                            throw new Error("EnhancedEventHandler doesn't have proto Handler");
                        }
                    } catch(e:Error) {
                        CONFIG::DEBUG {
                            debug(this,e.getStackTrace());
                        }
                        var owner:Object = callee.properties[FUNCTION_OWNER];
                        if(owner is IEventDispatcher) {
                            (owner as IEventDispatcher).dispatchEvent(RuntimeErrorEvent.createEvent(e));
                        } else {
                            throw e;
                        }
                    }
                };
}
CONFIG::UNCAUGHT_ERROR_GLOBAL {
            const func_:Object = 
                function(event:Event):void {
                    var callee:Object = arguments.callee;
                    var proto:Function = callee.properties[FUNCTION_PROTO] as Function;
                    if(proto != null) {
                        if( event is MessageEvent ){
                            proto.apply(null,[(event as MessageEvent).data]);
                        } else if( event is NotificationEvent ){
                            proto.apply(null,[(event as NotificationEvent).data]);
                        } else {
                            proto.apply(null,[event]);
                        }
                    } else {
                        throw new Error("EnhancedEventHandler doesn't have proto Handler");
                    }
                };
}               
            const properties:Dictionary = new Dictionary(true);
            properties[FUNCTION_OWNER] = owner;
            properties[FUNCTION_PROTO] = handler;
            func_.properties = properties;
            return func_ as Function;
        }

        protected function createEnhancedEventNoneHandler(owner:IEventDispatcher,handler:Function):Function {
CONFIG::UNCAUGHT_ERROR_EVENT {
            const func_:Object =
                function(event:Event):void {
                    var callee:Object = arguments.callee;
                    try {
                        var proto:Function = callee.properties[FUNCTION_PROTO] as Function;
                        if(proto != null) {
                            proto.apply(null);
                        } else {
                            throw new Error("EnhancedEventHandler doesn't have proto Handler");
                        }
                    } catch(e:Error) {
                        CONFIG::DEBUG {
                            debug(this,e.getStackTrace());
                        }
                        var owner:Object = callee.properties[FUNCTION_OWNER];
                        if(owner is IEventDispatcher) {
                            (owner as IEventDispatcher).dispatchEvent(RuntimeErrorEvent.createEvent(e));
                        } else {
                            throw e;
                        }
                    }
                };
}
CONFIG::UNCAUGHT_ERROR_GLOBAL {
            const func_:Object =
                function(event:Event):void {
                    var callee:Object = arguments.callee;
                    var proto:Function = callee.properties[FUNCTION_PROTO] as Function;
                    if(proto != null) {
                        proto.apply(null);
                    } else {
                        throw new Error("EnhancedEventHandler doesn't have proto Handler");
                    }
                };
}
            const properties:Dictionary = new Dictionary(true);
            properties[FUNCTION_OWNER] = owner;
            properties[FUNCTION_PROTO] = handler;
            func_.properties = properties;
            return func_ as Function;
        }

        protected function doCustomizingByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,listener:Object,functionRefs:Vector.<FunctionRef>,priority:int):void {
            var eventName:String;
            var enhancedEventName:String;
            var enhancedFunction:Function;

            for each(var functionRef:FunctionRef in functionRefs) {
                eventName = getEventName(functionRef,componentName);
                enhancedEventName = getEnhancedEventName(componentName,eventName,listener);
                enhancedFunction = getEnhancedEventHandler(view,enhancedEventName);

                if(enhancedFunction != null) {
                    continue;
                }

                if(functionRef.parameters.length > 0) {
                    enhancedFunction = createEnhancedEventHandler(view,functionRef.getFunction(listener));
                } else {
                    enhancedFunction = createEnhancedEventNoneHandler(view,functionRef.getFunction(listener));
                }
                addEventListener(component,eventName,enhancedFunction,priority);
                storeEnhancedEventHandler(view,enhancedEventName,enhancedFunction);
                CONFIG::DEBUG {
                    _debug("Event_AddEventListener",getCanonicalName(view),componentName == YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix() ? view.name : componentName,eventName,getCanonicalName(listener),functionRef.name);
                }
            }
        }

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
                        _debug("Event_RemoveEventListener",getCanonicalName(view),componentName == YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix() ? view.toString() : componentName,eventName,getCanonicalName(listener),functionRef.name);
                    }
                }
            }
        }
    }
}