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
package org.seasar.akabana.yui.framework.core
{
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    
    import mx.core.Application;
    import mx.core.Container;
    import mx.core.UIComponent;
    import mx.core.UIComponentDescriptor;
    import mx.events.ChildExistenceChangedEvent;
    import mx.events.FlexEvent;
    import mx.managers.CursorManager;
    import mx.managers.DragManager;
    import mx.managers.PopUpManager;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import org.seasar.akabana.yui.framework.customizer.ActionCustomizer;
    import org.seasar.akabana.yui.framework.customizer.EventHandlerCustomizer;
    import org.seasar.akabana.yui.framework.customizer.IComponentCustomizer;
    import org.seasar.akabana.yui.framework.error.RuntimeError;
    import org.seasar.akabana.yui.framework.event.FrameworkEvent;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.logging.Logger;
    
    public class YuiFrameworkContainer
    {
    	private static const ROOT_VIEW:String = "rootView";
    	
        private static const logger:Logger = Logger.getLogger(YuiFrameworkContainer);
                
        public var namingConvention:NamingConvention;
        
        public var customizers:Array;
        
        protected var _callTimer:Timer = new Timer(100,1);
        
        protected var _application:Application;
        
        public function get application():Application{
            return _application;
        }
        
        public function set application( value:Application ):void{
            _application = value;
            applicationMonitoringStart();
            initNamingConvention();
        }
        
        public function YuiFrameworkContainer(){
    	    CursorManager;
	        PopUpManager;
	        DragManager;
        }
        
        public function initialize():void{
            logger.debugMessage("yui_framework","ApplicationInit");
            logger.debugMessage("yui_framework","ApplicationConventions",namingConvention.conventions.toString());
            
            if( customizers == null ){
                customizers = getDefaultCustomizers();
            }
            logger.debugMessage("yui_framework","ViewComponentAssembleStart"); 
            
            var viewMap:Object = ViewComponentRepository.componentMap;
            for ( var key:String in viewMap ){
                logger.debugMessage("yui_framework","ViewComponentAssembleing",key); 
                var view:Container = ViewComponentRepository.getComponent(key) as Container;
                if( view.initialized ){
                    processAssembleView(key,view);
                }
                logger.debugMessage("yui_framework","ViewComponentAssembled",key); 
            }
            
            application.visible = true;
            
            logger.debugMessage("yui_framework","ViewComponentAssembleEnd"); 
         
            _callTimer.addEventListener(TimerEvent.TIMER,callApplicationStart,false,0,true);
            _callTimer.start();
        }
        
        public function registerComponent( component:UIComponent ):void{
            doRegisterComponent(component);
        }
        
        private function callApplicationStart( event:TimerEvent ):void{
            logger.debugMessage("yui_framework","ApplicationStart");
            var rootView:UIComponent = application.getChildByName(ROOT_VIEW) as UIComponent;
            if( rootView != null ){
                rootView.dispatchEvent( new FrameworkEvent(FrameworkEvent.APPLICATION_START));
            }
            
            var componentMap:Dictionary = ViewComponentRepository.componentMap;
            for each( var view:Container in componentMap ){
                if( rootView != view ){
            	   view.dispatchEvent( new FrameworkEvent(FrameworkEvent.APPLICATION_START));
                }
            }
        }
        
        private function childAddHandler( event:ChildExistenceChangedEvent ):void{
            doRegisterComponent(event.relatedObject as UIComponent);
        }

        private function childRemoveHandler( event:ChildExistenceChangedEvent ):void{
            doUnregisterComponent(event.target as UIComponent);
        }
        
        private function creationCompleteHandler(event:Event):void{
            doAssembleComponent(event.target as UIComponent);
        }

        private function removeCompleteHandler(event:Event):void{
            doUnregisterComponent(event.target as UIComponent);
        }
        
        protected function doRegisterComponent( component:UIComponent ):void{
            if( component != null && component is Container){
                processRegisterComponent(component as Container);               
            }
        }     

        protected function doAssembleComponent( component:UIComponent ):void{
            if( component != null && component is Container){
                processAssembleComponent(component as Container);
            }
        }     

        protected function processRegisterComponent(container:Container):void{
            do{                 
                if( container is Application ){
                    application = container as Application;
                    application.visible = false;
                    logger.debugMessage("yui_framework","ApplicationRegistered",container.toString());
                    break;
                }
                
                processRegisterView( container );
               
            } while( false );
        }
        
        protected function doUnregisterComponent(component:Object):void{
            if( component != null ){
                do{
                    if( component is Container ){
                        processDisassembleView( component as Container );
                        processUnregisterView( component as Container );
                        
                        break;   
                    }
                
                } while( false );
            }
        }
        
        protected function processRegisterView( container:Container ):void{            
            const className:String = ClassRef.getQualifiedClassName(container);

            if(
                namingConvention.isTargetClassName( className ) &&
                namingConvention.isViewName( className )
            ){
                var componentName:String = container.id;
                if( componentName == null ){
                    
                    componentName = container.name;
                    if(componentName == "hiddenItem"){
                        return;
                    }                
                    ViewComponentRepository.addComponent( componentName, container );              
                    logger.debugMessage("yui_framework","ViewComponentRegistered",container.toString(),componentName);                  
                } else {
                    if( ViewComponentRepository.hasComponent( componentName )){
                        var view:UIComponent = ViewComponentRepository.getComponent( componentName );                         
                        if( view.initialized ){
                            throw new RuntimeError(componentName+"is already registered.");
                        }
                    } else {
                        ViewComponentRepository.addComponent( componentName, container );              
                        logger.debugMessage("yui_framework","ViewComponentRegistered",container.toString(),componentName);                    
                    }
                }
            }
        }

        protected function processUnregisterView( container:Container ):void{
            const className:String = ClassRef.getQualifiedClassName(container);

            if(
                namingConvention.isTargetClassName( className ) &&
                namingConvention.isViewName( className )
            ){
                var componentName:String = container.id;
                if( componentName == null ){
                    componentName = container.name;
                }
                
                if( ViewComponentRepository.hasComponent( componentName )){
                    ViewComponentRepository.removeComponent( componentName, container );  
                    logger.debugMessage("yui_framework","ViewComponentUnRegistered",container.toString(),componentName);
                }
            }
        }

        protected function processAssembleComponent(container:Container):void{
            if( container.initialized ){
                var viewName:String = ViewComponentRepository.getComponentName(container);
                if( viewName != null ){
                    processAssembleView( viewName, container);    
                }
            }
        }
        
        protected function processAssembleView( viewName:String, container:Container ):void{
            if( container.descriptor == null ){
                container.descriptor = new UIComponentDescriptor({});
            }
            for each( var customizer_:IComponentCustomizer in customizers ){
                if( customizer_.namingConvention == null ){
                    customizer_.namingConvention = namingConvention;
                }
                customizer_.customize( viewName, container );                    
            }
            container.dispatchEvent( new FrameworkEvent(FrameworkEvent.ASSEMBLE_COMPELETE));
        }

        protected function processDisassembleView( container:Container ):void{
            if( container != null ){
                var viewName:String = UIComponentUtil.getName(container);
                for each( var customizer_:IComponentCustomizer in customizers ){
                    customizer_.namingConvention = namingConvention;
                    customizer_.uncustomize( viewName, container);
                }
            }
        }
        
        protected function applicationMonitoringStart():void{
            if( application != null ){
                application.systemManager.removeEventListener(
                    FlexEvent.CREATION_COMPLETE,
                    creationCompleteHandler,
                    true
                ); 

                application.systemManager.removeEventListener(
                    FlexEvent.REMOVE,
                    removeCompleteHandler,
                    true
                );
            }

            application.systemManager.addEventListener(
                FlexEvent.CREATION_COMPLETE,
                creationCompleteHandler,
                true,
                int.MAX_VALUE
            );    

            application.systemManager.addEventListener(
                FlexEvent.REMOVE,
                removeCompleteHandler,
                true,
                int.MAX_VALUE
            );
        }    
        
        protected function initNamingConvention():void{
        	if( namingConvention == null ){
            	namingConvention = new NamingConvention();
            	namingConvention.conventions = ResourceManager.getInstance().getStringArray("conventions","package");
         	}
        } 
        
        protected function getDefaultCustomizers():Array{
            return [
                new ActionCustomizer(),
                new EventHandlerCustomizer()
            ];
        }     
    }
}