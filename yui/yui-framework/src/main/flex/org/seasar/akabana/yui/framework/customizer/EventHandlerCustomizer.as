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
    import mx.core.Container;
    import mx.core.IMXMLObject;
    import mx.core.UIComponent;
    import mx.core.mx_internal;
    import mx.effects.IEffect;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.core.reflection.PropertyRef;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import org.seasar.akabana.yui.framework.message.MessageManager;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.logging.Logger;

    use namespace mx_internal;
    
    public class EventHandlerCustomizer extends AbstractEventCustomizer{
        
        private static const _logger:Logger = Logger.getLogger(EventHandlerCustomizer);
        
        public function EventHandlerCustomizer(_namingConvention:NamingConvention){
            super(_namingConvention);
        }
        
        public override function customize( view:Container, owner:Container=null):void {
            var viewName:String = UIComponentUtil.getName(view);
            var viewClassName:String = ClassRef.getReflector(view).name;
            if( owner == null ){
                var action_:Object = view.descriptor.properties[ _namingConvention.getActionPackageName() ];
                if( action_ != null){
                     doCustomize(viewName,view,action_);
                }
            } else {
                var ownerName:String = UIComponentUtil.getName(owner);
                var ownerAction_:Object = owner.descriptor.properties[ _namingConvention.getActionPackageName() ];
                if( ownerAction_ != null){
                    var actionClassRef:ClassRef = ClassRef.getReflector(ownerAction_);
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

        public override function uncustomize( view:Container, owner:Container=null):void{
            var viewName:String = UIComponentUtil.getName(view);
            var viewClassName:String = ClassRef.getReflector(view).name;
            if( owner == null ){
                var action_:Object = view.descriptor.properties[ _namingConvention.getActionPackageName() ];
                if( action_ != null){
                     doUncustomize(viewName,view,action_);
                }
            } else {
                var ownerName:String = UIComponentUtil.getName(owner);
                var ownerAction_:Object = owner.descriptor.properties[ _namingConvention.getActionPackageName() ];
                if( ownerAction_ != null){
                    var actionClassRef:ClassRef = ClassRef.getReflector(ownerAction_);
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
        
        private function doCustomize( viewName:String, view:Container, action:Object ):void{
            var actionClassRef:ClassRef = ClassRef.getReflector(action);
            var component:UIComponent;

CONFIG::DEBUG{
            _logger.debug(getMessage("ViewEventCustomizing",viewName,actionClassRef.name));
}

            //for children
            for( var index:int = 0; index < view.numChildren; index++ ){

                component = view.getChildAt(index) as UIComponent;
                if( component == null ){
                	continue;
                }

                if( component is Container ){
	                if(component.isDocument ){
		            
			            var properties:Object = Container(component).documentDescriptor["properties"];
			            if (properties != null && properties.childDescriptors != null){
			            	
			            } else {
	                        doCustomizeByContainer(
	                            view,
	                            component as Container,
	                            action
	                        );
			            }
	                	
	                } else {
                        doCustomizeByContainer(
                            view,
                            component as Container,
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
                var child:Object = view[ prop.name ];
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
                        return ( FunctionRef(item).name.indexOf(_namingConvention.getOwnHandlerPrefix()) == 0 ) &&
                               ( FunctionRef(item).name.indexOf(_namingConvention.getHandlerSuffix()) > 3 ) ;
                    }
                )
            );  
        }    
        
        private function doCustomizeByContainer( view:Container, container:Container, action:Object):void {
            var actionClassRef:ClassRef = ClassRef.getReflector(action);
            var component:UIComponent;
            if( container.childDescriptors == null ){
                return;
            }

            for( var index:int =0; index < container.numChildren; index++ ){
                do {
                    component = container.getChildAt(index) as UIComponent;
                    if( component == null ){
                        continue;
                    }
                                          
                    if( component is Container ){
	                    if(component.isDocument ){
	                    
	                        var properties:Object = Container(component).documentDescriptor["properties"];
	                        if (properties != null && properties.childDescriptors != null){
	                        	
	                        } else {
	                            doCustomizeByContainer(
	                                view,
	                                component as Container,
	                                action
	                            );
	                        }
                            
                        } else {
	                        doCustomizeByContainer(
	                            view,
	                            component as Container,
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

            if( container is Panel ){
                var controlBar:ControlBar = Panel(container).mx_internal::getControlBar() as ControlBar;
                if( controlBar != null){
                    doCustomizeByContainer(
                        view,
                        controlBar,
                        action
                    );
                }
            }
        }

        
        private function doCustomizeByComponent( view:Container, componentName:String, action:Object, functionRefs:Array):void {

            var componentName:String;
            var component:IEventDispatcher;
            if( componentName != null ){
                if( view.hasOwnProperty(componentName)){
                    component = view[componentName] as IEventDispatcher;
                } else {
                    component = view.getChildByName(componentName) as IEventDispatcher;
                }
            } else {
                componentName = _namingConvention.getOwnHandlerPrefix();
                component = view;
            }
            doCustomizingByComponent(view,componentName,component,action,functionRefs);
        }
        
        private function doCustomizingByComponent( view:Container, componentName:String, component:IEventDispatcher, action:Object, functionRefs:Array):void {
            
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
                    enhancedFunction = createEnhancedEventHandler( view,action[functionRef.name]);
                } else {
                    enhancedFunction = createEnhancedEventNoneHandler( view,action[functionRef.name]);
                }
                
                addEventListener( component, eventName, enhancedFunction);          
                storeEnhancedEventHandler(view, enhancedEventName,enhancedFunction);                
CONFIG::DEBUG{
                _logger.debug(getMessage("ViewEventCustomizingAddEvent",view.className,componentName == _namingConvention.getOwnHandlerPrefix() ? view.name : componentName, eventName,functionRef.name));
}
            }
        }

        private function doUncustomize( viewName:String, view:Container, action:Object ):void{
            var actionClassRef:ClassRef = ClassRef.getReflector(action);
            var component:UIComponent;

CONFIG::DEBUG{
            _logger.debug(getMessage("ViewEventUncustomizing",viewName,actionClassRef.name));
}
            
            //for children
            for( var index:int = 0; index < view.numChildren; index++ ){

                component = view.getChildAt(index) as UIComponent;
                if( component == null ){
                    continue;
                }

                if( component is Container ){
                    if(component.isDocument ){
                    
                        var properties:Object = Container(component).documentDescriptor["properties"];
                        if (properties != null && properties.childDescriptors != null){
                            
                        } else { 
	                        doUncustomizeByContainer(
	                            view,
	                            component as Container,
	                            action
	                        );
                        }   
                    } else {
	                    doUncustomizeByContainer(
	                        view,
	                        component as Container,
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

            if( view is Panel ){
                var controlBar:ControlBar = Panel(view).mx_internal::getControlBar() as ControlBar;
                if( controlBar != null){
                    doUncustomizeByContainer(
                        view,
                        controlBar,
                        action
                    );
                }
            }
            
            //for children
            var props:Array = ClassRef.getReflector(ClassRef.getQualifiedClassName(view)).properties;
            for each( var prop:PropertyRef in props ){
                var child:Object = view[ prop.name ];
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
                        return ( FunctionRef(item).name.indexOf(_namingConvention.getOwnHandlerPrefix()) == 0 ) &&
                               ( FunctionRef(item).name.indexOf(_namingConvention.getHandlerSuffix()) > 3 ) ;
                    }
                )
            );  
        }
        
        private function doUncustomizeByContainer( view:Container, container:Container, action:Object):void {
            var actionClassRef:ClassRef = ClassRef.getReflector(action);
            var componentName:String;
            var component:UIComponent;
            if( container.childDescriptors == null ){
                return;
            }
            for( var index:int =0; index < container.numChildren; index++ ){
                do {
                    component = container.getChildAt(index) as UIComponent;
	                if( component == null ){
	                    continue;
	                }
	                
	                if( component is Container ){
	                    if(component.isDocument ){
	                    
	                        var properties:Object = Container(component).documentDescriptor["properties"];
	                        if (properties != null && properties.childDescriptors != null){
	                            
	                        } else { 
	                            doUncustomizeByContainer(
	                                view,
	                                component as Container,
	                                action
	                            );
	                        }   
	                    } else {
	                        doUncustomizeByContainer(
	                            view,
	                            component as Container,
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

            if( container is Panel ){
                var controlBar:ControlBar = Panel(container).mx_internal::getControlBar() as ControlBar;
                if( controlBar != null){
                    doUncustomizeByContainer(
                        view,
                        controlBar,
                        action
                    );
                }
            }
        }

        private function doUncustomizeByComponent( view:Container, componentName:String, action:Object, functionRefs:Array):void {

            var componentName:String;
            var component:IEventDispatcher;
            if( componentName != null ){
                if( view.hasOwnProperty(componentName)){
                    component = view[componentName] as IEventDispatcher;
                } else {
                    component = view.getChildByName(componentName) as IEventDispatcher;
                }
            } else {
                componentName = _namingConvention.getOwnHandlerPrefix();
                component = view;
            }
            doUnCustomizingByComponent(view,componentName,component,action,functionRefs);
        }
        
        private function doUnCustomizingByComponent( view:Container, componentName:String, component:IEventDispatcher, action:Object, functionRefs:Array):void {
            
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
                    _logger.debug(getMessage("ViewEventCustomizingRemoveEvent",view.className,componentName == _namingConvention.getOwnHandlerPrefix() ? view.name : componentName, eventName,functionRef.name));
}
                }
            }
        }        
    }
}