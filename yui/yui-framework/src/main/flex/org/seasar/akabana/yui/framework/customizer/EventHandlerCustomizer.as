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
    CONFIG::FP10 {
        import __AS3__.vec.Vector;
    }
    import flash.events.IEventDispatcher;

    import mx.core.IMXMLObject;
    import mx.core.UIComponent;
    import mx.core.UIComponentDescriptor;
    import mx.core.mx_internal;
    import mx.effects.IEffect;

    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.logging.Logger;
    use namespace mx_internal;

    [ExcludeClass]
    public class EventHandlerCustomizer extends AbstractEventCustomizer {
        private static const _logger:Logger = Logger.getLogger(EventHandlerCustomizer);

        public override function customize(view:UIComponent,owner:UIComponent = null):void {
            if(owner == null) {
                const viewName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
                const viewClassName:String = getCanonicalName(view);
                const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);
                CONFIG::DEBUG {
                    _logger.debug(getMessage("Customizing",viewClassName,actionClassName));
                }

                const properties:Object = UIComponentUtil.getProperties(view);
                const action_:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];

                if(action_ != null) {
                    doCustomize(viewName,view,action_);
                }

                CONFIG::DEBUG {
                    _logger.debug(getMessage("Customized",viewClassName,actionClassName));
                }
            } else {
                const componentName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
                const ownerName:String = YuiFrameworkGlobals.namingConvention.getComponentName(owner);
                const ownerProperties:Object = UIComponentUtil.getProperties(owner);
                const ownerAction_:Object = ownerProperties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];

                if(ownerAction_ != null) {
                    const actionClassRef:ClassRef = getClassRef(ownerAction_);

                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Customizing",ownerName,actionClassRef.name));
                    }
                    CONFIG::FP9 {
                        doCustomizingByComponent(
                                        owner,
                                        componentName,
                                        view,
                                        ownerAction_,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Array):Boolean {
                                            return ((item as FunctionRef).name.indexOf(componentName) == 0);
                                        }
                                        )
                                        );
                    }
                    CONFIG::FP10 {
                        doCustomizingByComponent(
                                        owner,
                                        componentName,
                                        view,
                                        ownerAction_,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                            return ((item as FunctionRef).name.indexOf(componentName) == 0);
                                        }
                                        )
                                        );
                    }
                    CONFIG::DEBUG {
                        _logger.debug(getMessage("Customized",ownerName,actionClassRef.name));
                    }
                }
            }
        }

        public override function uncustomize(view:UIComponent,owner:UIComponent = null):void {
            const properties:Object = UIComponentUtil.getProperties(view);
            const viewName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
            const viewClassName:String = getCanonicalName(view);
            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);
            CONFIG::DEBUG {
                _logger.debug(getMessage("Uncustomizing",viewClassName,actionClassName));
            }

            if(owner == null) {
                var action:Object = properties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];

                if(action == null) {
                } else {
                    doUncustomize(viewName,view,action);
                }
            } else {
                const ownerName:String = YuiFrameworkGlobals.namingConvention.getComponentName(owner);
                const ownerProperties:Object = UIComponentUtil.getProperties(owner);
                const ownerAction_:Object = ownerProperties[YuiFrameworkGlobals.namingConvention.getActionPackageName()];

                if(ownerAction_ == null) {
                } else {
                    const actionClassRef:ClassRef = getClassRef(ownerAction_);
                    CONFIG::FP9 {
                        doUnCustomizingByComponent(
                                        owner,
                                        viewName,
                                        view,
                                        ownerAction_,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Array):Boolean {
                                            return ((item as FunctionRef).name.indexOf(viewName) == 0);
                                        }
                                        )
                                        );
                    }
                    CONFIG::FP10 {
                        doUnCustomizingByComponent(
                                        owner,
                                        viewName,
                                        view,
                                        ownerAction_,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                            return ((item as FunctionRef).name.indexOf(viewName) == 0);
                                        }
                                        )
                                        );
                    }
                }
            }
            CONFIG::DEBUG {
                _logger.debug(getMessage("Uncustomizing",viewClassName,actionClassName));
            }
        }

        private function doCustomize(viewName:String,view:UIComponent,action:Object):void {
            const actionClassRef:ClassRef = getClassRef(action);
            var component:UIComponent;
            var componentName:String;
            //for children
            var numChildren:int = view.numChildren;

            for(var index:int = 0;index < numChildren;index++) {
                component = view.getChildAt(index) as UIComponent;
                componentName = YuiFrameworkGlobals.namingConvention.getComponentName(component);

                if(component == null) {
                    continue;
                }

                if(YuiFrameworkGlobals.frameworkBridge.isContainer(component)) {
                    if(component.isDocument) {
                        const properties:Object = component.documentDescriptor["properties"];

                        if(properties != null && properties.childDescriptors != null) {
                        } else {
                            doCustomizeByContainer(
                                            view,
                                            component,
                                            action
                                            );
                        }
                    } else {
                        doCustomizeByContainer(
                                        view,
                                        component,
                                        action
                                        );
                    }
                }

                if(componentName != null) {
                    CONFIG::FP9 {
                        doCustomizeByComponent(
                                        view,
                                        componentName,
                                        component,
                                        action,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Array):Boolean {
                                            return ((item as FunctionRef).name.indexOf(componentName) == 0);
                                        }
                                        )
                                        );
                    }
                    CONFIG::FP10 {
                        doCustomizeByComponent(
                                        view,
                                        componentName,
                                        component,
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
            //for children
            CONFIG::FP9 {
                var props:Array = getClassRef(getCanonicalName(view)).properties;
            }
            CONFIG::FP10 {
                var props:Vector.<PropertyRef> = getClassRef(getCanonicalName(view)).properties;
            }

            for each(var prop:PropertyRef in props) {
                const child:Object = view[prop.name];

                if(child != null &&
                                child is IEventDispatcher &&
                                (child is IMXMLObject || child is IEffect)) {
                    CONFIG::FP9 {
                        doCustomizeByComponent(
                                        view,
                                        prop.name,
                                        child as IEventDispatcher,
                                        action,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Array):Boolean {
                                            return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                                        }
                                        )
                                        );
                    }
                    CONFIG::FP10 {
                        doCustomizeByComponent(
                                        view,
                                        prop.name,
                                        child as IEventDispatcher,
                                        action,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                            return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                                        }
                                        )
                                        );
                    }
                }
            }
            //for self
            CONFIG::FP9 {
                doCustomizeByComponent(
                                view,
                                null,
                                null,
                                action,
                                actionClassRef.functions.filter(
                                function(item:*,index:int,array:Array):Boolean {
                                    return ((item as FunctionRef).name.indexOf(YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix()) == 0);
                                }
                                )
                                );
            }
            CONFIG::FP10 {
                doCustomizeByComponent(
                                view,
                                null,
                                null,
                                action,
                                actionClassRef.functions.filter(
                                function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                    return ((item as FunctionRef).name.indexOf(YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix()) == 0);
                                }
                                )
                                );
            }
        }

        private function doCustomizeByContainer(view:UIComponent,container:UIComponent,action:Object):void {
            var actionClassRef:ClassRef = getClassRef(action);
            var component:UIComponent;
            var componentName:String;

            var numChildren:int = container.numChildren;

            for(var index:int = 0;index < numChildren;index++) {
                do {
                    component = container.getChildAt(index) as UIComponent;
                    componentName = YuiFrameworkGlobals.namingConvention.getComponentName(component);

                    if(component == null) {
                        continue;
                    }

                    if(YuiFrameworkGlobals.frameworkBridge.isContainer(component)) {
                        if(component.isDocument) {
                            var documentDescriptor:UIComponentDescriptor = UIComponentUtil.getDocumentDescriptor( component );
                            var properties:Object = documentDescriptor.properties;

                            if(properties != null && properties.childDescriptors != null) {
                            } else {
                                doCustomizeByContainer(
                                                view,
                                                component,
                                                action
                                                );
                            }
                        } else {
                            doCustomizeByContainer(
                                            view,
                                            component,
                                            action
                                            );
                        }
                    }

                    if(componentName != null) {
                        CONFIG::FP9 {
                            doCustomizeByComponent(
                                            view,
                                            componentName,
                                            component,
                                            action,
                                            actionClassRef.functions.filter(
                                            function(item:*,index:int,array:Array):Boolean {
                                                return (item as FunctionRef).name.indexOf(componentName) == 0;
                                            }
                                            )
                                            );
                        }
                        CONFIG::FP10 {
                            doCustomizeByComponent(
                                            view,
                                            componentName,
                                            component,
                                            action,
                                            actionClassRef.functions.filter(
                                            function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                                return (item as FunctionRef).name.indexOf(componentName) == 0;
                                            }
                                            )
                                            );
                        }
                    }
                } while(false);
            }
        }
        CONFIG::FP9 {
            private function doCustomizeByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,action:Object,functionRefs:Array):void {
                var componentName:String;
                if(componentName != null) {
                    if( component == null ){
                        if(view.hasOwnProperty(componentName)) {
                            component = view[componentName] as IEventDispatcher;
                        } else {
                            component = view.getChildByName(componentName) as IEventDispatcher;
                        }
                    }
                } else {
                    componentName = YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix();
                    component = view;
                }
                doCustomizingByComponent(view,componentName,component,action,functionRefs);
            }
        }
        CONFIG::FP10 {
            private function doCustomizeByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,action:Object,functionRefs:Vector.<FunctionRef>):void {
                var componentName:String;
                if(componentName != null) {
                    if( component == null ){
                        if(view.hasOwnProperty(componentName)) {
                            component = view[componentName] as IEventDispatcher;
                        } else {
                            component = view.getChildByName(componentName) as IEventDispatcher;
                        }
                    }
                } else {
                    componentName = YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix();
                    component = view;
                }
                doCustomizingByComponent(view,componentName,component,action,functionRefs);
            }
        }

        private function doUncustomize(viewName:String,view:UIComponent,action:Object):void {
            CONFIG::DEBUG {
                _logger.debug(getMessage("Uncustomizing",viewName,view));
            }
            const actionClassRef:ClassRef = getClassRef(action);
            var component:UIComponent;
            var componentName:String;
            var numChildren:int = view.numChildren;

            for(var index:int = 0;index < numChildren;index++) {
                component = view.getChildAt(index) as UIComponent;
                componentName = YuiFrameworkGlobals.namingConvention.getComponentName(component);

                if(component == null) {
                    continue;
                }

                if(YuiFrameworkGlobals.frameworkBridge.isContainer(component)) {
                    if(component.isDocument) {
                        const properties:Object = UIComponentUtil.getProperties(component);

                        if(properties != null && properties.childDescriptors != null) {
                        } else {
                            doUncustomizeByContainer(
                                            view,
                                            component,
                                            action
                                            );
                        }
                    } else {
                        doUncustomizeByContainer(
                                        view,
                                        component,
                                        action
                                        );
                    }
                }

                if(componentName != null) {
                    CONFIG::FP9 {
                        doUncustomizeByComponent(
                                        view,
                                        componentName,
                                        component,
                                        action,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Array):Boolean {
                                            return ((item as FunctionRef).name.indexOf(componentName) == 0);
                                        }
                                        )
                                        );
                    }
                    CONFIG::FP10 {
                        doUncustomizeByComponent(
                                        view,
                                        componentName,
                                        component,
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
            //for children
            CONFIG::FP9 {
                const props:Array = getClassRef(getCanonicalName(view)).properties;
            }
            CONFIG::FP10 {
                const props:Vector.<PropertyRef> = getClassRef(getCanonicalName(view)).properties;
            }

            for each(var prop:PropertyRef in props) {
                const child:Object = view[prop.name];

                if(child != null &&
                                child is IEventDispatcher &&
                                (child is IMXMLObject || child is IEffect)) {
                    CONFIG::FP9 {
                        doUncustomizeByComponent(
                                        view,
                                        prop.name,
                                        child as IEventDispatcher,
                                        action,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Array):Boolean {
                                            return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                                        }
                                        )
                                        );
                    }
                    CONFIG::FP10 {
                        doUncustomizeByComponent(
                                        view,
                                        prop.name,
                                        child as IEventDispatcher,
                                        action,
                                        actionClassRef.functions.filter(
                                        function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                            return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                                        }
                                        )
                                        );
                    }
                }
            }
            //for self
            CONFIG::FP9 {
                doUncustomizeByComponent(
                                view,
                                null,
                                null,
                                action,
                                actionClassRef.functions.filter(
                                function(item:*,index:int,array:Array):Boolean {
                                    return ((item as FunctionRef).name.indexOf(YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix()) == 0);
                                }
                                )
                                );
            }
            CONFIG::FP10 {
                doUncustomizeByComponent(
                                view,
                                null,
                                null,
                                action,
                                actionClassRef.functions.filter(
                                function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                    return ((item as FunctionRef).name.indexOf(YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix()) == 0);
                                }
                                )
                                );
            }
        }

        private function doUncustomizeByContainer(view:UIComponent,container:UIComponent,action:Object):void {
            const actionClassRef:ClassRef = getClassRef(action);
            var component:UIComponent;
            var componentName:String;
            var numChildren:int = container.numChildren;

            for(var index:int = 0;index < numChildren;index++) {
                do {
                    component = container.getChildAt(index) as UIComponent;
                    componentName = YuiFrameworkGlobals.namingConvention.getComponentName(component);

                    if(component == null) {
                        continue;
                    }

                    if(YuiFrameworkGlobals.frameworkBridge.isContainer(component)) {
                        if(component.isDocument) {
                            const properties:Object = UIComponentUtil.getProperties(component);

                            if(properties != null && properties.childDescriptors != null) {
                            } else {
                                doUncustomizeByContainer(
                                                view,
                                                component,
                                                action
                                                );
                            }
                        } else {
                            doUncustomizeByContainer(
                                            view,
                                            component,
                                            action
                                            );
                        }
                    }

                    if(componentName != null) {
                        CONFIG::FP9 {
                            doUncustomizeByComponent(
                                            view,
                                            componentName,
                                            component,
                                            action,
                                            actionClassRef.functions.filter(
                                            function(item:*,index:int,array:Array):Boolean {
                                                return (item as FunctionRef).name.indexOf(componentName) == 0;
                                            }
                                            )
                                            );
                        }
                        CONFIG::FP10 {
                            doUncustomizeByComponent(
                                            view,
                                            componentName,
                                            component,
                                            action,
                                            actionClassRef.functions.filter(
                                            function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                                return (item as FunctionRef).name.indexOf(componentName) == 0;
                                            }
                                            )
                                            );
                        }
                    }
                } while(false);
            }
        }
        CONFIG::FP9 {
            private function doUncustomizeByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,action:Object,functionRefs:Array):void {
                var componentName:String;

                if(componentName != null) {
                    if( component == null ){
                        if(view.hasOwnProperty(componentName)) {
                            component = view[componentName] as IEventDispatcher;
                        } else {
                            component = view.getChildByName(componentName) as IEventDispatcher;
                        }
                    }
                } else {
                    componentName = YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix();
                    component = view;
                }
                doUnCustomizingByComponent(view,componentName,component,action,functionRefs);
            }
        }
        CONFIG::FP10 {
            private function doUncustomizeByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,action:Object,functionRefs:Vector.<FunctionRef>):void {
                var componentName:String;
                var component:IEventDispatcher;

                if(componentName != null) {
                    if( component == null ){
                        if(view.hasOwnProperty(componentName)) {
                            component = view[componentName] as IEventDispatcher;
                        } else {
                            component = view.getChildByName(componentName) as IEventDispatcher;
                        }
                    }
                } else {
                    componentName = YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix();
                    component = view;
                }
                doUnCustomizingByComponent(view,componentName,component,action,functionRefs);
            }
        }
    }
}