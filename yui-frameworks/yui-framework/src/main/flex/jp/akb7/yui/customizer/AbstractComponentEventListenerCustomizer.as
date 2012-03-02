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
    import __AS3__.vec.Vector;
    
    import flash.events.IEventDispatcher;
    
    import mx.core.UIComponent;
    
    import jp.akb7.yui.core.reflection.ClassRef;
    import jp.akb7.yui.core.reflection.FunctionRef;
    import jp.akb7.yui.core.reflection.PropertyRef;
    
    [ExcludeClass]
    public class AbstractComponentEventListenerCustomizer extends AbstractComponentEventCustomizer {
        
        protected function doEventCustomize(name:String,component:UIComponent,listener:Object):void {
            const listenerClassRef:ClassRef = getClassRef(listener);
            const props:Vector.<PropertyRef> = listenerClassRef.properties;
            
            var child:Object;
            for each(var prop:PropertyRef in props) {
                child = prop.getValue(listener);
                
                if(child != null && child is IEventDispatcher) {
                    doCustomizingByComponent(
                        component,
                        prop.name,
                        child as IEventDispatcher,
                        listener,
                        listenerClassRef.functions.filter(
                            function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                            }
                        ),
                        int.MAX_VALUE>>2
                    );
                }
            }
        }
        
        protected function doEventUncustomize(component:UIComponent,listener:Object):void {
            const listenerClassRef:ClassRef = getClassRef(listener);
            const props:Vector.<PropertyRef> = listenerClassRef.properties;
            
            var child:Object;
            for each(var prop:PropertyRef in props) {
                child = prop.getValue(listener);
                
                if(child != null && child is IEventDispatcher) {
                    doUnCustomizingByComponent(
                        component,
                        prop.name,
                        child as IEventDispatcher,
                        listener,
                        listenerClassRef.functions.filter(
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