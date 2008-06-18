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
    
    import mx.core.Container;
    import mx.core.UIComponent;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.Reflectors;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    
    public class ViewEventCustomizer extends AbstractEventCustomizer{
        
        public override function customize( name:String, view:Container ):void {
            var actionName:String;
            var dxoName:String;
            actionName = namingConvention.getActionName(name);

            var action_:Object = view.descriptor.properties[ namingConvention.getActionPackageName() ];
            if( action_ != null){
                 doCustomizer(name,view,action_);
            }
        }
        
        private function doCustomizer( name:String, view:Container, action:Object ):void{
            var actionClassRef:ClassRef = Reflectors.getClassReflector(action);
            var component:UIComponent;
            var componentName:String;
			for( var index:int =0; index < view.numChildren; index++ ){
			    component = view.getChildAt(index) as UIComponent;
			    if( component != null ){
			        componentName = UIComponentUtil.getName(component);
                    doCustomizeByComponent(
                        view,
                        componentName,
                        action,
                        actionClassRef.functions.filter(
                            function(item:*, index:int, array:Array):Boolean{
                                return FunctionRef(item).name.indexOf(componentName) == 0;
                            }
                        )
                    );       			        
			    }
			}
			
            doCustomizeByComponent(
                view,
                null,
                action,
                actionClassRef.functions.filter(
                    function(item:*, index:int, array:Array):Boolean{
                        return FunctionRef(item).name.indexOf(SELF_EVENT_PREFIX) == 0;
                    }
                )
            );  
        }

        private function doCustomizeByComponent( view:Container, componentName:String, action:Object, functionRefs:Array):void {
            var functionName:String;
			var handlerIndex:int;
			var eventName:String;
			var enhancedFunction:Function;
            var enhancedFunctionName:String;
			var component:IEventDispatcher;
			for each( var functionRef:FunctionRef in functionRefs ){
			    functionName = functionRef.name;
			    handlerIndex = functionName.lastIndexOf(HANDLER);
			    if( componentName != null ){
			        component = view.getChildByName(componentName) as IEventDispatcher;
			        
			        eventName = functionName.substr(componentName.length,1).toLocaleLowerCase() + functionName.substring(componentName.length+1,handlerIndex);
                    
                    enhancedFunctionName = componentName + "_" + eventName;
                    enhancedFunction = loadEnhancedEventHandler( view, enhancedFunctionName);
                    if( enhancedFunction != null ){
                        component.removeEventListener(eventName, enhancedFunction);
                    }
                    
                    enhancedFunction = createEnhancedEventHandler(component,action[functionName]);
                    addEventListener(component,eventName,enhancedFunction);
		        
		            storeEnhancedEventHandler(view,componentName + "_" + eventName,enhancedFunction);
            
		        } else {
		            component = view as IEventDispatcher;
		            
		            eventName = functionName.substr(2,1).toLocaleLowerCase() + functionName.substring(3,handlerIndex);
                    
                    enhancedFunctionName = "on_" + eventName;
		            enhancedFunction = loadEnhancedEventHandler( view, enhancedFunctionName);
                    if( enhancedFunction != null ){
                        view.removeEventListener(eventName, enhancedFunction);
                    }
                    		            
                    enhancedFunction = createEnhancedEventHandler(component,action[functionName]);
                    addEventListener(component,eventName,enhancedFunction);
                    
		            storeEnhancedEventHandler(view,eventName,enhancedFunction);
                
                }
			}
        }
    }
}