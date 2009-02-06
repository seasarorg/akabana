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
    
    import org.seasar.akabana.yui.framework.event.RuntimeErrorEvent;
    import org.seasar.akabana.yui.logging.Logger;
    
    internal class AbstractEventCustomizer extends AbstractComponentCustomizer
    {
    	private static const logger:Logger = Logger.getLogger(AbstractEventCustomizer);
    	
        protected static const ENHANCED_SEPARETOR:String = "$";
        
        protected static const ENHANCED_PREFIX:String = ENHANCED_SEPARETOR + "enhanced" + ENHANCED_SEPARETOR;
        
        protected static const HANDLER_SUFFIX:String = "Handler";
        
        protected static const SELF_HANDLER_PREFIX:String = "on";
        
        private static function checkDescriptor(component:UIComponent):void{
            if( component.descriptor.events == null ){
                component.descriptor.events = new Dictionary(true);
            }
        }
        
        protected static function getEnhancedEventName( viewName:String, eventName:String ):String{
            return viewName + ENHANCED_PREFIX + eventName;
        }        
        
        protected function addEventListener( component:IEventDispatcher, eventName:String, handler:Function ):void{
            component.addEventListener( eventName, handler, false, 0, true );
        } 
        
        protected function storeEnhancedEventHandler( component:UIComponent, eventName:String, handler:Function ):void{
            checkDescriptor(component);
            component.descriptor.events[eventName] = handler;
        }

        protected function loadEnhancedEventHandler( component:UIComponent, eventName:String ):Function{
            checkDescriptor(component);
            return component.descriptor.events[eventName];
        }
        
        protected function createEnhancedEventHandler( owner:IEventDispatcher, handler:Function ):Function{
            
            var func_:Object = function( event:Event ):void{
                var callee:Object = arguments.callee; 
                try{
                   	var proto:Function = callee.properties["proto"] as Function;
                   	if( proto != null ){
                   		proto.apply(null,[event]);
                   	} else {
                   		throw new Error("EnhancedEventHandler doesn't have prote Handler");
                   	}
                } catch(e:Error){
                    logger.debug(e.getStackTrace());
                   	var owner:Object = callee.properties["owner"];
                   	if( owner is IEventDispatcher ){
                        IEventDispatcher(owner).dispatchEvent(RuntimeErrorEvent.createEvent(e));
                    } else {
                        throw e;
                    }
                }
            };

            var properties:Dictionary = new Dictionary(true);
            properties["owner"] = owner;
            properties["proto"] = handler;
			func_.properties = properties;
            
            return func_ as Function;
        }
    }
}