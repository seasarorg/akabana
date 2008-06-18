package org.seasar.akabana.yui.framework.customizer
{
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    
    import mx.core.UIComponent;
    
    import org.seasar.akabana.yui.framework.error.RuntimeError;
    
    internal class AbstractEventCustomizer extends AbstractComponentCustomizer
    {

        protected static var HANDLER:String = "Handler";
        
        protected static var SELF_EVENT_PREFIX:String = "on";
        
        protected function addEventListener( component:IEventDispatcher, eventName:String, handler:Function ):void{
            component.addEventListener( eventName, handler, false, 0, true );
        } 
        
        protected function storeEnhancedEventHandler( component:UIComponent, eventName:String, handler:Function ):void{
            checkDescriptor(component);
            component.descriptor.events[getEnhancedFunctionName(eventName)] = handler;
        }

        protected function loadEnhancedEventHandler( component:UIComponent, functionName:String ):Function{
            checkDescriptor(component);
            return component.descriptor.events[getEnhancedFunctionName(functionName)];
        }
        
        protected function createEnhancedEventHandler( owner:IEventDispatcher, handler:Function ):Function{
            
            var func_:Object = function( event:Event ):void{
                var callee:Object = arguments.callee; 
                var error:Error = null;                              
                try{
                   callee.proto.apply(callee.owner,[event]);
                } catch(re:RuntimeError){
                    error = re;
                    if( callee.owner is IEventDispatcher ){
                        var event:Event = new ErrorEvent(ErrorEvent.ERROR,true,false,re.message);                   
                        IEventDispatcher(callee.owner).dispatchEvent(event);
                    } else {
                        throw re;
                    }
                } catch(e:Error){
                    error = e;
                    throw e;
                } finally {
                    if( error != null ){
                        //trace(error.getStackTrace());
                    }
                }
            };

            func_.owner = owner;
            func_.proto = handler;
            
            return func_ as Function;
        }
        
        private static function getEnhancedFunctionName( eventName:String ):String{
            return "__enhanced_" + eventName + "Handler";
        }
        
        private static function checkDescriptor(component:UIComponent):void{
            if( component.descriptor.events == null ){
                component.descriptor.events = new Dictionary(true);
            }
        }
    }
}