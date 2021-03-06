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
    import mx.core.IMXMLObject;
    import mx.core.UIComponent;
    import mx.core.IUIComponent;
    import mx.core.UIComponentDescriptor;
    import mx.core.mx_internal;
    import mx.effects.IEffect;
    import jp.akb7.yui.core.reflection.ClassRef;
    import jp.akb7.yui.core.reflection.FunctionRef;
    import jp.akb7.yui.core.reflection.PropertyRef;
    import jp.akb7.yui.YuiFrameworkGlobals;
    import jp.akb7.yui.util.UIComponentUtil;
    import jp.akb7.yui.logging.debug;
    import jp.akb7.yui.convention.NamingConvention;
    
    use namespace mx_internal;

    [ExcludeClass]
    public class EventHandlerCustomizer extends AbstractComponentEventListenerCustomizer implements IComponentCustomizer {
        
        public function customizeComponent( owner:UIComponent, component:UIComponent ):void{
            const componentName:String = YuiFrameworkGlobals.namingConvention.getComponentName(component);
            const ownerName:String = YuiFrameworkGlobals.namingConvention.getComponentName(owner);
            const ownerClassName:String = getCanonicalName(component);
            const ownerProperties:Object = UIComponentUtil.getProperties(owner);
            const ownerAction_:Object = ownerProperties[NamingConvention.ACTION];
            
            if(ownerAction_ != null) {
                const actionClassRef:ClassRef = getClassRef(ownerAction_);
                CONFIG::DEBUG {
                    _debug("Customizing",ownerName+"#"+componentName,actionClassRef.name);
                }
                doCustomizingByComponent(
                    owner,
                    componentName,
                    component,
                    ownerAction_,
                    actionClassRef.functions.filter(
                        function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                            return ((item as FunctionRef).name.indexOf(componentName) == 0);
                        }
                    ),
                    int.MAX_VALUE>>1
                );
                CONFIG::DEBUG {
                    _debug("Customized",ownerName+"#"+componentName,actionClassRef.name);
                }
            }
            //
            const ownerBehaviors_:Array = ownerProperties[NamingConvention.BEHAVIOR];
            
            if(ownerBehaviors_ != null) {
                var behaviorClassRef:ClassRef;
                for each(var ownerBehavior_:Object in ownerBehaviors_) {
                    behaviorClassRef = getClassRef(ownerBehavior_);
                    CONFIG::DEBUG {
                        _debug("Customizing",ownerClassName+"#"+componentName,behaviorClassRef.name);
                    }
                    doCustomizingByComponent(
                        owner,
                        componentName,
                        component,
                        ownerBehavior_,
                        behaviorClassRef.functions.filter(
                            function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                return ((item as FunctionRef).name.indexOf(componentName) == 0);
                            }
                        ),
                        0
                    );
                    CONFIG::DEBUG {
                        _debug("Customized",ownerClassName+"#"+componentName,behaviorClassRef.name);
                    }
                }
            }
        }

        public override function customizeView(view:UIComponent):void {
            const viewName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
            const viewClassName:String = getCanonicalName(view);
            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);
            const viewProperties:Object = UIComponentUtil.getProperties(view);
            //
            const action_:Object = viewProperties[NamingConvention.ACTION];

            if(action_ != null) {
                CONFIG::DEBUG {
                    _debug("Customizing",viewClassName,actionClassName);
                }
                doCustomize(view,action_,int.MAX_VALUE>>1);
                
                super.doEventCustomize(viewName,view,action_);
                CONFIG::DEBUG {
                    _debug("Customized",viewClassName,actionClassName);
                }
            }
            //
            const behaviors_:Array = viewProperties[NamingConvention.BEHAVIOR];

            if(behaviors_ != null) {
                var behaviorClassName:String;
                for each(var behavior_:Object in behaviors_) {
                    behaviorClassName = getCanonicalName(behavior_);
                    CONFIG::DEBUG {
                        _debug("Customizing",viewClassName,behaviorClassName);
                    }
                    doCustomize(view,behavior_,int.MAX_VALUE>>1);
                    
                    super.doEventCustomize(viewName,view,behavior_);
                    CONFIG::DEBUG {
                        _debug("Customized",viewClassName,behaviorClassName);
                    }
                }
            }
        }

        public function isTargetComponent( component:UIComponent ):Boolean{
            return component.initialized && component.parent != null;
        }
        
        public function uncustomizeComponent( owner:UIComponent, component:UIComponent):void{
            const componentName:String = YuiFrameworkGlobals.namingConvention.getComponentName(component);
            const ownerClassName:String = getCanonicalName(owner);
            const ownerProperties:Object = UIComponentUtil.getProperties(owner);
            const ownerAction_:Object = ownerProperties[NamingConvention.ACTION];
            
            if(ownerAction_ != null) {
                const actionClassRef:ClassRef = getClassRef(ownerAction_);
                CONFIG::DEBUG {
                    _debug("Uncustomizing",ownerClassName+"#"+componentName,actionClassRef.name);
                }
                doUnCustomizingByComponent(
                    owner,
                    componentName,
                    component,
                    ownerAction_,
                    actionClassRef.functions.filter(
                        function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                            return ((item as FunctionRef).name.indexOf(componentName) == 0);
                        }
                    )
                );
                CONFIG::DEBUG {
                    _debug("Uncustomized",ownerClassName+"#"+componentName,actionClassRef.name);
                }
            }
            //
            const ownerBehaviors_:Array = ownerProperties[NamingConvention.BEHAVIOR];
            
            if(ownerBehaviors_ != null) {
                var behaviorClassRef:ClassRef;
                for each(var ownerBehavior_:Object in ownerBehaviors_) {
                    behaviorClassRef = getClassRef(ownerBehavior_);
                    CONFIG::DEBUG {
                        _debug("Uncustomizing",ownerClassName+"#"+componentName,behaviorClassRef.name);
                    }
                    doUnCustomizingByComponent(
                        owner,
                        componentName,
                        component,
                        ownerBehavior_,
                        behaviorClassRef.functions.filter(
                            function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                return ((item as FunctionRef).name.indexOf(componentName) == 0);
                            }
                        )
                    );
                    CONFIG::DEBUG {
                        _debug("Uncustomized",ownerClassName+"#"+componentName,behaviorClassRef.name);
                    }
                }
            }
        }
        
        public override function uncustomizeView(view:UIComponent):void {
            const viewProperties:Object = UIComponentUtil.getProperties(view);
            const viewName:String = YuiFrameworkGlobals.namingConvention.getComponentName(view);
            const viewClassName:String = getCanonicalName(view);
            const actionClassName:String = YuiFrameworkGlobals.namingConvention.getActionClassName(viewClassName);

            const action_:Object = viewProperties[NamingConvention.ACTION];

            if(action_ != null) {
                CONFIG::DEBUG {
                    _debug("Uncustomizing",viewClassName,actionClassName);
                }
                doUncustomize(view,action_);
                
                super.doEventUncustomize(view,action_);
                CONFIG::DEBUG {
                    _debug("Uncustomized",viewClassName,actionClassName);
                }
            }
            //
            const behaviors_:Array = viewProperties[NamingConvention.BEHAVIOR];

            if(behaviors_ != null) {
                var behaviorClassName:String;
                for each(var behavior_:Object in behaviors_) {
                    behaviorClassName = getCanonicalName(behavior_);
                    CONFIG::DEBUG {
                        _debug("Uncustomizing",viewClassName,behaviorClassName);
                    }
                    doUncustomize(view,behavior_);
                    
                    super.doEventUncustomize(view,behavior_);
                    CONFIG::DEBUG {
                        _debug("Uncustomized",viewClassName,behaviorClassName);
                    }
                }
            }
        }

        protected function doCustomize(container:UIComponent,action:Object,priority:int = int.MAX_VALUE):void {    
            const actionClassRef:ClassRef = getClassRef(action);
            //for children
            const props:Vector.<PropertyRef> = getClassRef(container).properties;
            
            var child:Object;
            for each(var prop:PropertyRef in props) {
                child = container[prop.name];

                if(child != null &&
                                child is IEventDispatcher &&
                                (child is IUIComponent || child is IMXMLObject || child is IEffect)) {
                    doCustomizeByComponent(
                                    container,
                                    prop.name,
                                    child as IEventDispatcher,
                                    action,
                                    actionClassRef.functions.filter(
                                    function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                        return ((item as FunctionRef).name.indexOf(prop.name) == 0);
                                    }
                                    ),
                                    priority
                                    );
                }
            }
            //for self
            doCustomizeByComponent(
                            container,
                            null,
                            null,
                            action,
                            actionClassRef.functions.filter(
                            function(item:*,index:int,array:Vector.<FunctionRef>):Boolean {
                                return ((item as FunctionRef).name.indexOf(YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix()) == 0);
                            }
                            ),
                            priority
                            );
        }

        protected function doCustomizeByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,action:Object,functionRefs:Vector.<FunctionRef>,priority:int):void {
            var componentName:String;

            if(componentName != null) {
                if(component == null) {
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
            doCustomizingByComponent(view,componentName,component,action,functionRefs,priority);
        }

        protected function doUncustomize(container:UIComponent,action:Object):void {
            const actionClassRef:ClassRef = getClassRef(action);
            //for children
            const props:Vector.<PropertyRef> = getClassRef(container).properties;

            var child:Object;
            for each(var prop:PropertyRef in props) {
                child = container[prop.name];

                if(child != null &&
                        child is IEventDispatcher &&
                        (child is IUIComponent || child is IMXMLObject || child is IEffect)) {
                   doUncustomizeByComponent(
                                    container,
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
            //for self
            doUncustomizeByComponent(
                            container,
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

        protected function doUncustomizeByComponent(view:UIComponent,componentName:String,component:IEventDispatcher,action:Object,functionRefs:Vector.<FunctionRef>):void {
            var componentName:String;
            var component:IEventDispatcher;

            if(componentName != null) {
                if(component == null) {
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