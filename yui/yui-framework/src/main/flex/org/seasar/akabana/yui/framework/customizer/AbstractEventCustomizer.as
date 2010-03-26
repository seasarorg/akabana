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

    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.core.event.RuntimeErrorEvent;
    import org.seasar.akabana.yui.framework.ns.handler;
    import org.seasar.akabana.yui.logging.Logger;

    internal class AbstractEventCustomizer extends AbstractComponentCustomizer
    {
    	private static const _logger:Logger = Logger.getLogger(AbstractEventCustomizer);

        protected static const EVENT_SEPARETOR:String = "_";

        protected static const ENHANCED_SEPARETOR:String = "$";

        protected static const ENHANCED_PREFIX:String = ENHANCED_SEPARETOR + "enhanced" + ENHANCED_SEPARETOR;

        protected static const FUNCTION_OWNER:String = "$owner";

        protected static const FUNCTION_PROTO:String = "$proto";

        protected function getEventName( functionRef:FunctionRef, componentName:String):String{
			const functionName:String = functionRef.name;
            const ns:Namespace = handler;
            const eventWord:String = functionName.substr(componentName.length);
            const handlerIndex:int = eventWord.lastIndexOf(YuiFrameworkGlobals.namingConvention.getHandlerSuffix());

            var result:String = null;
            if( eventWord.charAt(0) == EVENT_SEPARETOR ){
                if( functionRef.uri == ns.uri){
                    result = eventWord.substring(1);
                } else {
    			    result = eventWord.substring(1,handlerIndex);
                }
            } else {
                if( functionRef.uri == ns.uri){
                    result = eventWord.substr(0,1).toLocaleLowerCase() + eventWord.substring(1);
                } else {
    			    result = eventWord.substr(0,1).toLocaleLowerCase() + eventWord.substring(1,handlerIndex);
                }
            }
            return result;
        }

        protected function getEnhancedEventName( viewName:String, eventName:String ):String{
            return viewName + ENHANCED_PREFIX + eventName;
        }

        protected function addEventListener( component:IEventDispatcher, eventName:String, handler:Function ):void{
            component.addEventListener( eventName, handler, false, 0, true );
        }

        protected function storeEnhancedEventHandler( component:UIComponent, eventName:String, handler:Function ):void{
            checkDescriptor(component);
            component.descriptor.events[eventName] = handler;
        }

        protected function removeEnhancedEventHandler( component:UIComponent, eventName:String ):void{
            if( component.descriptor.events != null ){
            	component.descriptor.events[eventName] = null;
            	delete component.descriptor.events[eventName];
            }
        }

        protected function checkDescriptor(component:UIComponent):void{
            if( component.descriptor.events == null ){
                component.descriptor.events = new Dictionary(true);
            }
        }

        protected function getEnhancedEventHandler( component:UIComponent, eventName:String ):Function{
            return component.descriptor.events[eventName];
        }

        protected function createEnhancedEventHandler( owner:IEventDispatcher, handler:Function ):Function{
            const func_:Object = function( event:Event ):void{
                var callee:Object = arguments.callee;
                try{
                   	var proto:Function = callee.properties[FUNCTION_PROTO] as Function;
                   	if( proto != null ){
                   		proto.apply(null,[event]);
                   	} else {
                   		throw new Error("EnhancedEventHandler doesn't have proto Handler");
                   	}
                } catch(e:Error){
                    _logger.debug(e.getStackTrace());
                   	var owner:Object = callee.properties[FUNCTION_OWNER];
                   	if( owner is IEventDispatcher ){
                        IEventDispatcher(owner).dispatchEvent(RuntimeErrorEvent.createEvent(e));
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

        protected function createEnhancedEventNoneHandler( owner:IEventDispatcher, handler:Function ):Function{
            const func_:Object = function( event:Event ):void{
                var callee:Object = arguments.callee;
                try{
                   	var proto:Function = callee.properties[FUNCTION_PROTO] as Function;
                   	if( proto != null ){
                   		proto.apply(null);
                   	} else {
                   		throw new Error("EnhancedEventHandler doesn't have proto Handler");
                   	}
                } catch(e:Error){
                    _logger.debug(e.getStackTrace());
                   	var owner:Object = callee.properties[FUNCTION_OWNER];
                   	if( owner is IEventDispatcher ){
                        IEventDispatcher(owner).dispatchEvent(RuntimeErrorEvent.createEvent(e));
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
    }
}