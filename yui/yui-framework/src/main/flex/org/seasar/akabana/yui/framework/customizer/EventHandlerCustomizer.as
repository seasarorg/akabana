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
package org.seasar.akabana.yui.framework.customizer {

    import flash.events.IEventDispatcher;
    
    import mx.containers.ControlBar;
    import mx.containers.Panel;
    import mx.controls.NavBar;
    import mx.core.Container;
    import mx.core.IMXMLObject;
    import mx.core.UIComponent;
    import mx.core.mx_internal;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.logging.Logger;
    
    use namespace mx_internal;
    
    public class EventHandlerCustomizer extends AbstractEventCustomizer{
        
        private static const logger:Logger = Logger.getLogger(EventHandlerCustomizer);
        
        public override function customize( viewName:String, view:Container ):void {
            var viewClassName:String = ClassRef.getReflector(view).name;
            var actionName:String = namingConvention.getActionName(viewClassName);
            var action_:Object = view.descriptor.properties[ namingConvention.getActionPackageName() ];
            if( action_ != null){
                 doCustomizer(viewName,view,action_);
            }
        }
        
        private function doCustomizer( viewName:String, view:Container, action:Object ):void{
            var actionClassRef:ClassRef = ClassRef.getReflector(action);
            var component:UIComponent;

            logger.debugMessage("yui_framework","ViewEventCustomizing",viewName,actionClassRef.name);
            
            //for children
            for( var index:int = 0; index < view.numChildren; index++ ){

                component = view.getChildAt(index) as Container;
                if( component != null &&
                    !namingConvention.isViewName(ClassRef.getReflector(component).name )
                ){
                    doCustomizeByContainer(
                        view,
                        component as Container,
                        action
                    );
                }

			    component = view.getChildAt(index) as UIComponent;
			    if( component != null && component.id != null){
			        doCustomizeByComponent(
                        view,
                        component.id,
                        action,
                        actionClassRef.functions.filter(
                            function(item:*, index:int, array:Array):Boolean{
                                return ( FunctionRef(item).name.indexOf(component.id) == 0 );
                            }
                        )
                    );			        
			    }
			}

            if( view is Panel ){
                var controlBar:ControlBar = Panel(view).mx_internal::getControlBar() as ControlBar;
                if( controlBar != null){
                    doCustomizeByContainer(
                        view,
                        controlBar,
                        action
                    );
                }
            }
            
            //for children
			var props:Array = ClassRef.getReflector(ClassRef.getQualifiedClassName(view)).properties;
            for each( var prop:PropertyRef in props ){
                var child:IMXMLObject = view[ prop.name ] as IMXMLObject;
                if( child != null && child is IEventDispatcher ){
                    doCustomizeByComponent(
                        view,
                        prop.name,
                        action,
                        actionClassRef.functions.filter(
                            function(item:*, index:int, array:Array):Boolean{
                                return ( FunctionRef(item).name.indexOf(prop.name) == 0 );
                            }
                        )
                    );
                }
            }
			
			//for self
            doCustomizeByComponent(
                view,
                null,
                action,
                actionClassRef.functions.filter(
                    function(item:*, index:int, array:Array):Boolean{
                        return ( FunctionRef(item).name.indexOf(SELF_HANDLER_PREFIX) == 0 ) &&
                               ( FunctionRef(item).name.indexOf(HANDLER_SUFFIX) > 3 ) ;
                    }
                )
            );  
        }

        private function doCustomizeByContainer( view:Container, container:Container, action:Object):void {
            var actionClassRef:ClassRef = ClassRef.getReflector(action);
            var componentName:String;
            var component:UIComponent;
            if( container.childDescriptors == null ){
                return;
            }
            for( var index:int =0; index < container.numChildren; index++ ){
                do {
                    component = container.getChildAt(index) as Container;
                    if( component != null &&
                        !( namingConvention.isViewName(ClassRef.getReflector(component).name ) )&&
                        !( component is NavBar )
                    ){
                        doCustomizeByContainer(
                            view,
                            component as Container,
                            action
                        );
                    }
                    component = container.getChildAt(index) as UIComponent;
                    if( component != null && component.id != null){
                        doCustomizeByComponent(
                            view,
                            component.id,
                            action,
                            actionClassRef.functions.filter(
                                function(item:*, index:int, array:Array):Boolean{
                                    return FunctionRef(item).name.indexOf(component.id) == 0;
                                }
                            )
                        );                  
                    }
                } while( false );
            }
        }

        private function doCustomizeByComponent( view:Container, componentName:String, action:Object, functionRefs:Array):void {

            var componentViewName:String;
            var component:IEventDispatcher;
            if( componentName != null ){
                componentViewName = componentName;
                component = view[componentName] as IEventDispatcher;
            } else {
                componentViewName = SELF_HANDLER_PREFIX;
                component = view as IEventDispatcher;
            }
            
            var functionName:String;
			var handlerIndex:int;
			var eventName:String;
            var enhancedEventName:String;
			var enhancedFunction:Function;
			for each( var functionRef:FunctionRef in functionRefs ){
			    functionName = functionRef.name;
			    handlerIndex = functionName.lastIndexOf(HANDLER_SUFFIX);
			    
			    eventName = functionName.substr(componentViewName.length,1).toLocaleLowerCase() + functionName.substring(componentViewName.length+1,handlerIndex);
                enhancedEventName = getEnhancedEventName(componentViewName,eventName);
                
                enhancedFunction = loadEnhancedEventHandler( view, enhancedEventName);
                if( enhancedFunction != null ){
                    component.removeEventListener(eventName, enhancedFunction);
                }
                enhancedFunction = createEnhancedEventHandler(component,action[functionName]);
                
                addEventListener( component, eventName, enhancedFunction);	        
	            storeEnhancedEventHandler(view, enhancedEventName,enhancedFunction);                
                logger.debugMessage("yui_framework","ViewEventCustomizingAddEvent",view.className,componentName != null ? componentViewName : view.name, eventName,functionName);
			}
        }
    }
}