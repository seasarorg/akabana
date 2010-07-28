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
	
	import mx.core.UIComponent;
	
	import org.seasar.akabana.yui.core.reflection.ClassRef;
	import org.seasar.akabana.yui.core.reflection.FunctionRef;
	import org.seasar.akabana.yui.core.reflection.PropertyRef;

    internal class AbstractEventListenerCustomizer extends AbstractComponentEventCustomizer
    {
		protected function doEventCustomize(name:String,component:UIComponent,listener:Object):void {
			const listenerClassRef:ClassRef = getClassRef(listener);
			CONFIG::FP9 {
				var props:Array = listenerClassRef.properties;
			}
			CONFIG::FP10 {
				var props:Vector.<PropertyRef> = listenerClassRef.properties;
			}
			
			for each(var prop:PropertyRef in props) {
				const child:Object = prop.getValue(listener);
				
				if(child != null && child is IEventDispatcher) {
					CONFIG::FP9 {
						doCustomizingByComponent(
							component,
							prop.name,
							child as IEventDispatcher,
							listener,
							listenerClassRef.functions.filter(
								function(item:*,index:int,array:Array):Boolean {
									return ((item as FunctionRef).name.indexOf(prop.name) == 0);
								}
							),
							int.MAX_VALUE>>2
						);
					}
					CONFIG::FP10 {
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
		}
		
		protected function doEventUncustomize(component:UIComponent,listener:Object):void {
			const listenerClassRef:ClassRef = getClassRef(listener);
			CONFIG::FP9 {
				var props:Array = listenerClassRef.properties;
			}
			CONFIG::FP10 {
				var props:Vector.<PropertyRef> = listenerClassRef.properties;
			}
			
			for each(var prop:PropertyRef in props) {
				const child:Object = prop.getValue(listener);
				
				if(child != null && child is IEventDispatcher) {
					CONFIG::FP9 {
						doUnCustomizingByComponent(
							component,
							prop.name,
							child as IEventDispatcher,
							listener,
							listenerClassRef.functions.filter(
								function(item:*,index:int,array:Array):Boolean {
									return ((item as FunctionRef).name.indexOf(prop.name) == 0);
								}
							)
						);
					}
					CONFIG::FP10 {
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
}