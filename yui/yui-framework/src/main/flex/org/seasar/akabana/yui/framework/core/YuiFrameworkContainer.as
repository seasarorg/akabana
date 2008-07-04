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
    
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import org.seasar.akabana.yui.framework.customizer.ActionCustomizer;
    import org.seasar.akabana.yui.framework.customizer.IComponentCustomizer;
    import org.seasar.akabana.yui.framework.customizer.ViewEventCustomizer;
    import org.seasar.akabana.yui.framework.event.FrameworkEvent;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.logging.Logger;
    
    public class YuiFrameworkContainer
    {
        private static const logger:Logger = Logger.getLogger(YuiFrameworkContainer);
                
        public var namingConvention:NamingConvention;
        
        public var customizers:Array;
        
        protected var cursorManager:CursorManager;
        
        protected var popUpManager:PopUpManager;
        
        protected var dragManager:DragManager;
        
        protected var _application:Application;
        
        protected var _callTimer:Timer = new Timer(100,1);
        
        public function get application():Application{
            return _application;
        }
        
        public function set application( value:Application ):void{
            if( _application != null ){
                _application.systemManager.removeEventListener(
                    FlexEvent.CREATION_COMPLETE,
                    creationCompleteHandler,
                    true
                ); 

                _application.systemManager.removeEventListener(
                    FlexEvent.REMOVE,
                    removeCompleteHandler,
                    true
                );
                
                _application.removeEventListener(
                    ChildExistenceChangedEvent.CHILD_ADD,
                    childAddHandler,
                    true
                );
                
//                _application.removeEventListener(
//                    ChildExistenceChangedEvent.CHILD_REMOVE,
//                    childRemoveHandler,
//                    true
//                ); 
            }
            
            _application = value;

            _application.systemManager.addEventListener(
                FlexEvent.CREATION_COMPLETE,
                creationCompleteHandler,
                true,
                int.MAX_VALUE
            );    

            _application.systemManager.addEventListener(
                FlexEvent.REMOVE,
                removeCompleteHandler,
                true,
                int.MAX_VALUE
            );
            
            _application.addEventListener(
                ChildExistenceChangedEvent.CHILD_ADD,
                childAddHandler,
                true
            );
             
//            _application.addEventListener(
//                ChildExistenceChangedEvent.CHILD_REMOVE,
//                childRemoveHandler,
//                true
//            ); 
        }
        
        public function YuiFrameworkContainer(){
            
        }
        
        public function init():void{
            logger.debugMessage("yui_framework","ApplicationInit");
            
            if( customizers == null ){
                customizers = getDefaultCustomizers();
            }
            
            logger.debugMessage("yui_framework","ViewComponentAssembleStart"); 
            
            var componentMap:Object = ViewComponentRepository.componentMap;
            for ( var key:String in componentMap ){
                logger.debugMessage("yui_framework","ViewComponentAssembleing",key); 
                processAssembleView(key,ViewComponentRepository.getComponent(key) as Container);
                logger.debugMessage("yui_framework","ViewComponentAssembled",key); 
            }
            
            application.visible = true;
            application.dispatchEvent(new FrameworkEvent(FrameworkEvent.ASSEMBLED));
            
            logger.debugMessage("yui_framework","ViewComponentAssembleEnd"); 
         
            _callTimer.addEventListener(TimerEvent.TIMER,callApplicationStart,false,0,true);
            _callTimer.start();
        }
        
        public function registerComponent( component:UIComponent ):void{
            doRegisterComponent(component);
        }
        
        private function callApplicationStart( event:TimerEvent ):void{
            logger.debugMessage("yui_framework","ApplicationStart");
            var rootView:UIComponent = application.getChildByName("rootView") as UIComponent;
            if( rootView != null ){
                rootView.dispatchEvent( new FrameworkEvent(FrameworkEvent.APPLICATION_START));
            }
        }
        
        private function getViewName( container:Container ):String{
            var viewName:String = null;
            if( container.isDocument ){
                viewName = ClassRef.getQualifiedClassName(container);
            } else {
                var parentDocument_:UIComponent = container.parentDocument as UIComponent;
                var parentDocumentClassName:String = ClassRef.getQualifiedClassName(parentDocument_);
                var dotLastIndex:int = parentDocumentClassName.lastIndexOf(".");
                var packageName:String = parentDocumentClassName.substring(0,dotLastIndex);
                viewName = packageName + "." + UIComponentUtil.getName(container);
            }
            return viewName;
        }
        
        private function childAddHandler( event:ChildExistenceChangedEvent ):void{
            doRegisterComponent(event.relatedObject as UIComponent);
        }

        private function childRemoveHandler( event:ChildExistenceChangedEvent ):void{
            doUnregisterComponent(event.target as UIComponent);
        }
        
        private function creationCompleteHandler(event:Event):void{
            doRegisterComponent(event.target as UIComponent);
        }

        private function removeCompleteHandler(event:Event):void{
            doUnregisterComponent(event.target as UIComponent);
        }
        
        protected function doRegisterComponent( component:UIComponent ):void{
            if( component != null ){
                processRegisterComponent(component);
                processAssembleComponent(component);                
            }
        }     

        protected function processRegisterComponent(component:Object):void{
            do{                 
                if( component is Application ){
                    application = component as Application;
                    application.visible = false;
                    logger.debugMessage("yui_framework","ApplicationRegistered",component.toString());
                    break;
                }

                if( component is Container ){
                    processRegisterView( component as Container );
                    logger.debugMessage("yui_framework","ViewComponentRegistered",component.toString());    
                    break;   
                }
            
            } while( false );
        }
        
        protected function doUnregisterComponent(component:Object):void{
            if( component != null ){
                do{
                    if( component is Container ){
                        processUnregisterView( component as Container );
                        logger.debugMessage("yui_framework","ViewComponentUnRegistered",component.toString()); 
                        break;   
                    }
                
                } while( false );
            }
        }
        
        protected function processRegisterView( container:Container ):void{            
            const className:String = ClassRef.getQualifiedClassName(container);
            
            if( !namingConvention.isTargetClassName( className )){
                if(namingConvention.isViewName( className )){
                    if( !ViewComponentRepository.hasComponent( className )){
                        ViewComponentRepository.addComponent( className, container );              
                    }
                }
            } else {
                var viewName:String = getViewName(container);
                if(
                    viewName != null && 
                    namingConvention.isViewName( viewName )
                ){
                    if( !ViewComponentRepository.hasComponent( viewName )){
                        ViewComponentRepository.addComponent( viewName, container );  
                    }
                }
            }
        }

        protected function processUnregisterView( container:Container ):void{
            const className:String = ClassRef.getQualifiedClassName(container);
            
            if( !namingConvention.isTargetClassName( className )){
                if(namingConvention.isViewName( className )){
                    if( container.initialized ){
                        processDisassembleView( className, container);
                    }
                    if( ViewComponentRepository.hasComponent( className )){
                        ViewComponentRepository.removeComponent( className, container );              
                    }
                }               
            } else {
                var viewName:String = getViewName(container);
                if(
                    viewName != null && 
                    namingConvention.isViewName( viewName )
                ){
                    if( container.initialized ){
                        processDisassembleView(viewName, container);
                    }
                    if( ViewComponentRepository.hasComponent( viewName )){
                        ViewComponentRepository.removeComponent( viewName, container );  
                    }
                }
            }
        }

        public function processAssembleComponent(component:Object):void{
            if( component is Container ){
                var componentName:String = ViewComponentRepository.getComponentName(component as Container);
                if( componentName != null ){
                    processAssembleView( componentName, component as Container);    
                }
            }  
        }
        
        protected function processAssembleView( name:String, view:Container ):void{
            if( view != null && view.initialized){
                if( view.descriptor == null ){
                    view.descriptor = new UIComponentDescriptor({});
                }
                for each( var customizer_:IComponentCustomizer in customizers ){
                    if( customizer_.namingConvention == null ){
                        customizer_.namingConvention = namingConvention;
                    }
                    customizer_.customize( name, view );                    
                }
            }
        }

        protected function processDisassembleView( name:String, view:Container ):void{
            if( view != null ){
                for each( var customizer_:IComponentCustomizer in customizers ){
                    customizer_.namingConvention = namingConvention;
                    customizer_.uncustomize( name );                    
                }
            }
        }        
        
        protected function getDefaultCustomizers():Array{
            return [
                new ActionCustomizer(),
                new ViewEventCustomizer()
            ];
        }     
    }
}