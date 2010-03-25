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
    import mx.core.IMXMLObject;
    import mx.core.UIComponent;
    import mx.core.mx_internal;
    import mx.effects.IEffect;

    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.logging.Logger;

    use namespace mx_internal;

    public class EventHandlerCustomizer extends AbstractEventCustomizer{

        private static const _logger:Logger = Logger.getLogger(EventHandlerCustomizer);

        public override function customize( view:UIComponent, owner:UIComponent=null):void {
            const viewName:String = UIComponentUtil.getName(view);
            const viewClassName:String = YuiFrameworkGlobals.namingConvention.getClassName(view);
            if( owner == null ){
                const action_:Object = view.descriptor.properties[ YuiFrameworkGlobals.namingConvention.getActionPackageName() ];
                if( action_ != null){
                     doCustomize(viewName,view,action_);
                }
            } else {
                const ownerName:String = UIComponentUtil.getName(owner);
                const ownerAction_:Object = owner.descriptor.properties[ YuiFrameworkGlobals.namingConvention.getActionPackageName() ];
                if( ownerAction_ != null){
                    const actionClassRef:ClassRef = ClassRef.getReflector(ownerAction_);
                    doCustomizingByComponent(
                        owner,
                        viewName,
                        view,
                        ownerAction_,
                        actionClassRef.functions.filter(
                            function(item:*, index:int, array:Array):Boolean{
                                return ( FunctionRef(item).name.indexOf(viewName) == 0 );
                            }
                        )
                    );
                }
            }
        }

        public override function uncustomize( view:UIComponent, owner:UIComponent=null):void{
            const viewName:String = UIComponentUtil.getName(view);
            const viewClassName:String = ClassRef.getReflector(view).name;
            if( owner == null ){

                var action:Object = null;
    			if ( view.descriptor != null && view.descriptor.properties != null ){
                    action = view.descriptor.properties[ YuiFrameworkGlobals.namingConvention.getActionPackageName() ];
                }
                if( action == null ){
                } else {
                     doUncustomize(viewName,view,action);
                }
            } else {
                const ownerName:String = UIComponentUtil.getName(owner);
                var ownerAction_:Object = null;
    			if ( owner.descriptor != null && owner.descriptor.properties != null ){
                    ownerAction_ = owner.descriptor.properties[ YuiFrameworkGlobals.namingConvention.getActionPackageName() ];
                }
                if( ownerAction_ == null ){
                } else {
                    const actionClassRef:ClassRef = ClassRef.getReflector(ownerAction_);
                    doUnCustomizingByComponent(
                        owner,
                        viewName,
                        view,
                        ownerAction_,
                        actionClassRef.functions.filter(
                            function(item:*, index:int, array:Array):Boolean{
                                return ( FunctionRef(item).name.indexOf(viewName) == 0 );
                            }
                        )
                    );
                }
            }
        }

        private function doCustomize( viewName:String, view:UIComponent, action:Object ):void{
            const actionClassRef:ClassRef = ClassRef.getReflector(action);
            var component:UIComponent;

CONFIG::DEBUG{
            _logger.debug(getMessage("ViewEventCustomizing",viewName,actionClassRef.name));
}

            //for children
            var numChildren:int = view.numChildren;
            for( var index:int = 0; index < numChildren; index++ ){

                component = view.getChildAt(index) as UIComponent;
                if( component == null ){
                	continue;
                }

                if( YuiFrameworkGlobals.frameworkBridge.isContainer(component) ){
	                if(component.isDocument ){

			            const properties:Object = component.documentDescriptor["properties"];
			            if (properties != null && properties.childDescriptors != null){

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

                if( component.id != null ){
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

            //for children
            var props:Array = ClassRef.getReflector(YuiFrameworkGlobals.namingConvention.getClassName(view)).properties;
            for each( var prop:PropertyRef in props ){
                const child:Object = view[ prop.name ];
                if( child != null &&
                    child is IEventDispatcher &&
                    ( child is IMXMLObject || child is IEffect )
                ){
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
                        return ( FunctionRef(item).name.indexOf(YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix()) == 0 );
                    }
                )
            );
        }

        private function doCustomizeByContainer( view:UIComponent, container:UIComponent, action:Object):void {
            var actionClassRef:ClassRef = ClassRef.getReflector(action);
            var component:UIComponent;

            var numChildren:int = container.numChildren;
            for( var index:int =0; index < numChildren; index++ ){
                do {
                    component = container.getChildAt(index) as UIComponent;
                    if( component == null ){
                        continue;
                    }

                    if( YuiFrameworkGlobals.frameworkBridge.isContainer(component)){
	                    if(component.isDocument ){

	                        var properties:Object = component.documentDescriptor["properties"];
	                        if (properties != null && properties.childDescriptors != null){

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

                    if( component.id != null ){
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

        private function doCustomizeByComponent( view:UIComponent, componentName:String, action:Object, functionRefs:Array):void {

            var componentName:String;
            var component:IEventDispatcher;
            if( componentName != null ){
                if( view.hasOwnProperty(componentName)){
                    component = view[componentName] as IEventDispatcher;
                } else {
                    component = view.getChildByName(componentName) as IEventDispatcher;
                }
            } else {
                componentName = YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix();
                component = view;
            }
            doCustomizingByComponent(view,componentName,component,action,functionRefs);
        }

        private function doCustomizingByComponent( view:UIComponent, componentName:String, component:IEventDispatcher, action:Object, functionRefs:Array):void {

            var eventName:String;
            var enhancedEventName:String;
            var enhancedFunction:Function;

            checkDescriptor(view);
            for each( var functionRef:FunctionRef in functionRefs ){

                eventName = getEventName(functionRef,componentName);
                enhancedEventName = getEnhancedEventName(componentName,eventName);

                enhancedFunction = getEnhancedEventHandler( view, enhancedEventName);
                if( enhancedFunction != null ){
                    component.removeEventListener(eventName, enhancedFunction);
                }
                if( functionRef.parameters.length > 0 ){
                    enhancedFunction = createEnhancedEventHandler( view,functionRef.getFunction(action));
                } else {
                    enhancedFunction = createEnhancedEventNoneHandler( view,functionRef.getFunction(action));
                }

                addEventListener( component, eventName, enhancedFunction);
                storeEnhancedEventHandler(view, enhancedEventName,enhancedFunction);
CONFIG::DEBUG{
                _logger.debug(getMessage("ViewEventCustomizingAddEvent",view.className,componentName == YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix() ? view.name : componentName, eventName,functionRef.name));
}
            }
        }

        private function doUncustomize( viewName:String, view:UIComponent, action:Object ):void{
CONFIG::DEBUG{
            _logger.debug(getMessage("ViewEventUncustomizing",viewName,view));
}
            const actionClassRef:ClassRef = ClassRef.getReflector(action);
            var component:UIComponent;
            var numChildren:int = view.numChildren;
            for( var index:int = 0; index < numChildren; index++ ){

                component = view.getChildAt(index) as UIComponent;
                if( component == null ){
                    continue;
                }

                if( YuiFrameworkGlobals.frameworkBridge.isContainer(component) ){
                    if(component.isDocument ){

                        const properties:Object = component.documentDescriptor["properties"];
                        if (properties != null && properties.childDescriptors != null){

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

                if( component.id != null){
                    doUncustomizeByComponent(
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

            //for children
            const props:Array = ClassRef.getReflector(YuiFrameworkGlobals.namingConvention.getClassName(view)).properties;
            for each( var prop:PropertyRef in props ){
                const child:Object = view[ prop.name ];
                if( child != null &&
                    child is IEventDispatcher &&
                    ( child is IMXMLObject || child is IEffect )
                ){
                    doUncustomizeByComponent(
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
            doUncustomizeByComponent(
                view,
                null,
                action,
                actionClassRef.functions.filter(
                    function(item:*, index:int, array:Array):Boolean{
                        return ( FunctionRef(item).name.indexOf(YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix()) == 0 );
                    }
                )
            );
        }

        private function doUncustomizeByContainer( view:UIComponent, container:UIComponent, action:Object):void {
            const actionClassRef:ClassRef = ClassRef.getReflector(action);
            var componentName:String;
            var component:UIComponent;

            var numChildren:int = container.numChildren;
            for( var index:int =0; index < numChildren; index++ ){
                do {
                    component = container.getChildAt(index) as UIComponent;
	                if( component == null ){
	                    continue;
	                }

	                if( YuiFrameworkGlobals.frameworkBridge.isContainer(component) ){
	                    if(component.isDocument ){

	                        const properties:Object = component.documentDescriptor["properties"];
	                        if (properties != null && properties.childDescriptors != null){

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

                    if( component.id != null ){
                        doUncustomizeByComponent(
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

        private function doUncustomizeByComponent( view:UIComponent, componentName:String, action:Object, functionRefs:Array):void {

            var componentName:String;
            var component:IEventDispatcher;
            if( componentName != null ){
                if( view.hasOwnProperty(componentName)){
                    component = view[componentName] as IEventDispatcher;
                } else {
                    component = view.getChildByName(componentName) as IEventDispatcher;
                }
            } else {
                componentName = YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix();
                component = view;
            }
            doUnCustomizingByComponent(view,componentName,component,action,functionRefs);
        }

        private function doUnCustomizingByComponent( view:UIComponent, componentName:String, component:IEventDispatcher, action:Object, functionRefs:Array):void {

            var eventName:String;
            var enhancedEventName:String;
            var enhancedFunction:Function;
            for each( var functionRef:FunctionRef in functionRefs ){
                eventName = getEventName(functionRef,componentName);
                enhancedEventName = getEnhancedEventName(componentName,eventName);
                enhancedFunction = getEnhancedEventHandler( view, enhancedEventName);
                if( enhancedFunction != null ){
                    component.removeEventListener(eventName, enhancedFunction);
                    removeEnhancedEventHandler(view, enhancedEventName );
CONFIG::DEBUG{
                    _logger.debug(getMessage("ViewEventCustomizingRemoveEvent",view.className,componentName == YuiFrameworkGlobals.namingConvention.getOwnHandlerPrefix() ? view.name : componentName, eventName,functionRef.name));
}
                }
            }
        }
    }
}