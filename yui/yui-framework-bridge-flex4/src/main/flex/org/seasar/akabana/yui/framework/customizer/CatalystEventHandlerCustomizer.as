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
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.framework.customizer.EventHandlerCustomizer;
    import org.seasar.akabana.yui.framework.customizer.IComponentCustomizer;
    import org.seasar.akabana.yui.framework.util.CatalystGroupUtil;

    use namespace mx_internal;

    [ExcludeClass]
    public class CatalystEventHandlerCustomizer extends EventHandlerCustomizer implements IComponentCustomizer {
        
        protected override function doCustomize(container:UIComponent,action:Object,priority:int = int.MAX_VALUE):void {
            super.doCustomize(container,action,priority); 
            
            const actionClassRef:ClassRef = getClassRef(action);            
            var elements:Vector.<IVisualElement> = CatalystGroupUtil.getAllElements(container);      
            var component:UIComponent;     
            var componentName:String;
            for each(var element:IVisualElement in elements) {
                if( element is UIComponent ){
                    component = element as UIComponent;
                    componentName = YuiFrameworkGlobals.namingConvention.getComponentName(component);
                    doCustomizeByComponent(
                        container,
                        componentName,
                        component as IEventDispatcher,
                        action,
                        actionClassRef.functions.filter(
                            function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                return ((item as FunctionRef).name.indexOf(componentName) == 0);
                            }
                        ),
                        priority
                    );
                }
            }
        }

        protected override function doUncustomize(container:UIComponent,action:Object):void {
            super.doCustomize(container,action);
            
            const actionClassRef:ClassRef = getClassRef(action);            
            var elements:Vector.<IVisualElement> = CatalystGroupUtil.getAllElements(container);      
            var component:UIComponent;     
            var componentName:String;
            for each(var element:IVisualElement in elements) {
                if( element is UIComponent ){
                    component = element as UIComponent;
                    componentName = YuiFrameworkGlobals.namingConvention.getComponentName(component);
                    doUncustomizeByComponent(
                        container,
                        componentName,
                        component as IEventDispatcher,
                        action,
                        actionClassRef.functions.filter(
                            function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                return ((item as FunctionRef).name.indexOf(componentName) == 0);
                            }
                        )
                    );
                }
            }
        }
    }
}