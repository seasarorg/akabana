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
    import flash.system.Capabilities;
    
    import mx.core.Application;
    import mx.core.Container;
    import mx.core.UIComponent;
    import mx.core.UIComponentDescriptor;
    import mx.events.FlexEvent;
    import mx.managers.ISystemManager;
    import mx.resources.ResourceManager;
    
    import org.seasar.akabana.yui.core.Environment;
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.yui_internal;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import org.seasar.akabana.yui.framework.core.event.FrameworkEvent;
    import org.seasar.akabana.yui.framework.customizer.IComponentCustomizer;
    import org.seasar.akabana.yui.framework.error.YuiFrameworkContainerError;

    public final class YuiFrameworkContainer extends YuiFrameworkContainerBase
    {

        protected static var _container:IYuiFrameworkContainer;

        public static function get yuicontainer():IYuiFrameworkContainer{
            return _container;
        }

        public function get customizers():Array{
            return _customizers;
        }

        public function get application():Application{
            return _application;
        }

        public function get namingConvention():NamingConvention{
            return _namingConvention;
        }

        yui_internal function set namingConvention( value:NamingConvention ):void{
            _namingConvention = value;
        }

        public function YuiFrameworkContainer(){
            super();
            if( _container == null ){
                _container = this;
                _systemManagers = [];
            } else {
                throw new YuiFrameworkContainerError("container is already created.");
            }
        }
        
        public override function addExternalSystemManager(systemManager:ISystemManager ):void{
CONFIG::DEBUG{
            _logger.info("add external systemManager"+systemManager);
}            
            systemManager
                .addEventListener(
                    FlexEvent.CREATION_COMPLETE,
                    creationCompleteHandler,
                    true,
                    int.MAX_VALUE
                    );

            systemManager
                .addEventListener(
                    FlexEvent.REMOVE,
                    removeCompleteHandler,
                    true,
                    int.MAX_VALUE
                );
                
            addSystemManager(systemManager);
        }
        
        public override function customizeComponent( container:Container, owner:Container=null):void{
            for each( var customizer_:IComponentCustomizer in customizers ){
                customizer_.customize( container, owner);
            }
        }

        public override function uncustomizeComponent( container:Container, owner:Container=null):void{
            var numCustomizers:int = customizers.length;
            for( var i:int = numCustomizers-1; i >= 0; i-- ){
                var customizer_:IComponentCustomizer = customizers[i] as IComponentCustomizer;
                customizer_.uncustomize( container, owner);
            }
        }
        
        private function applicationCompleteHandler( event:FlexEvent ):void{
            var systemManager_:ISystemManager = event.currentTarget as ISystemManager;

            systemManager_
            	.removeEventListener(
                    FlexEvent.APPLICATION_COMPLETE,
                    applicationCompleteHandler,
                    false
                ); 
           
            systemManager_
                .addEventListener(
                    Event.REMOVED_FROM_STAGE,
                    removedHandler,
                    true,
                    int.MAX_VALUE
                );

            initialize();
        }
        
        private function addedToStageHandler( event:Event ):void{
CONFIG::DEBUG_EVENT{
            _logger.info("addedToStageHandler"+event+","+event.target);
}            
            if( event.target is UIComponent ){
                doRegisterComponent(event.target as UIComponent);
            }
        }

        private function addedHandler( event:Event ):void{
CONFIG::DEBUG_EVENT{
            _logger.info("addedToStageHandler"+event+","+event.target);
} 
            if( event.target is UIComponent ){
                doRegisterComponent(event.target as UIComponent);
            }
        }

        private function removedHandler( event:Event ):void{
CONFIG::DEBUG_EVENT{
            _logger.info("removedHandler"+event+","+event.target);
} 
            if( event.target is UIComponent ){
                doUnregisterComponent(event.target as UIComponent);
            }
        }

        private function creationCompleteHandler(event:Event):void{
            doAssembleComponent(event.target as UIComponent);
        }

        private function removeCompleteHandler(event:Event):void{
            doUnregisterComponent(event.target as UIComponent);
        }

        yui_internal function monitoringSystemManager( systemManager:ISystemManager ):void{
CONFIG::DEBUG{
            _logger.info("monitoring..."+systemManager);
}  
            systemManager
                .addEventListener(
                    Event.ADDED_TO_STAGE,
                    addedToStageHandler,
                    true,
                    int.MAX_VALUE
                );
            systemManager
                .addEventListener(
                    FlexEvent.APPLICATION_COMPLETE,
                    applicationCompleteHandler,
                    false,
                    int.MAX_VALUE
                );    
                
            addSystemManager(systemManager);
        }

        protected function initialize():void{
            trace("yui-frameworks-"+VERSION);
            trace("Copyright 2004-2009 the Seasar Foundation and the Others.");

CONFIG::DEBUG{
            trace("using FlashPlayer " + Capabilities.version);
            _logger.debug(getMessage("ApplicationConventions",namingConvention.conventions.toString()));
}
            if( customizers == null ){
                _customizers = getDefaultCustomizers();
            }
CONFIG::DEBUG{
            _logger.debug(getMessage("ViewComponentAssembleStart"));
}

            var viewMap:Object = ViewComponentRepository.componentMap;
            for ( var key:String in viewMap ){
CONFIG::DEBUG{
                _logger.debug(getMessage("ViewComponentAssembleing",key));
}
                var view:Container = ViewComponentRepository.getComponent(key) as Container;
                if( view.initialized ){
                    processAssembleView(key,view);
                }
CONFIG::DEBUG{
                _logger.debug(getMessage("ViewComponentAssembled",key));
}
            }

CONFIG::DEBUG{
            _logger.debug(getMessage("ViewComponentAssembleEnd"));
}
            _isApplicationStarted = true;
            callLater( callApplicationStart );
        }
        
        protected function callApplicationStart():void{
            var rootView:UIComponent = application.getChildByName(ROOT_VIEW) as UIComponent;
            if( rootView == null ){
                if( application.numChildren > 0 ){
                    rootView = application.getChildAt(0) as UIComponent ;
                    rootView.setVisible(false,true);
                }
            } else {
                rootView.setVisible(false,true);
            }

CONFIG::DEBUG{
            _logger.info(getMessage("ApplicationStart"));
}

            application.visible = true;
            if( rootView != null ){
                rootView.dispatchEvent( new FrameworkEvent(FrameworkEvent.APPLICATION_START));
                rootView.visible = true;
            }
        }
        
        protected function isViewComponent( component:Object ):Boolean{
            if( component == null){
                return false;
            }
            if( !(component is Container )){
                return false;
            }
            return namingConvention.isViewClassName( ClassRef.getQualifiedClassName(component) );
        }

        protected function doRegisterComponent( component:UIComponent ):void{
            if( component != null && component is Container){
                processRegisterComponent(component as Container);
                if( _isApplicationStarted && component.initialized ){
                    doAssembleComponent(component);
                }
            }
        }

        protected function doAssembleComponent( component:UIComponent ):void{
            if( isViewComponent(component)){
                if( component != null && component is Container){
                    processAssembleComponent(component as Container);
                }
            }
        }

        protected function doUnregisterComponent(component:Object):void{

            if( isViewComponent(component)){
                do{
                    if( component is Container ){
                        processDisassembleView( component as Container );
                        processUnregisterView( component as Container );

                        break;
                    }

                } while( false );
            }
        }

        protected function processRegisterComponent(component:Container):void{
            do{
                if( component is Application ){     
                    _application = component as Application;
CONFIG::DEBUG{
                    _logger.debug(getMessage("ApplicationRegistered",component.toString()));
}
                    _application.setVisible(false,true);          
                    Environment.yui_internal::root = _application;
                    Environment.yui_internal::parameters = _application.parameters;
                    initNamingConvention();
                    applicationMonitoringStart();
                    break;
                }

                processRegisterView( component );

            } while( false );
        }

        protected function processRegisterView( container:Container ):void{
            if( isViewComponent(container)){
                var componentName:String = container.id;
                if( container.id == null ){
                    if(container.name == "hiddenItem"){
                        return;
                    }
                }

                ViewComponentRepository.addComponent( container );
CONFIG::DEBUG{
                _logger.debug(getMessage("ViewComponentRegistered",container.toString()));
}
            }
        }

        protected function processUnregisterView( container:Container ):void{
            if( isViewComponent(container)){
                if( ViewComponentRepository.hasComponent( container.name )){
                    ViewComponentRepository.removeComponent( container );
CONFIG::DEBUG{
                    _logger.debug(getMessage("ViewComponentUnRegistered",container.toString()));
}
                }
            }
        }

        protected function processAssembleComponent(container:Container):void{
            if( container.initialized ){
                processAssembleView( container.name, container);
            }
        }

        protected function processAssembleView( viewName:String, container:Container ):void{
CONFIG::DEBUG{
            _logger.debug(container + " as " + viewName);
}
            if( container.descriptor == null ){
                container.descriptor = new UIComponentDescriptor({});
            }
            customizeComponent(container);
            container.dispatchEvent( new FrameworkEvent(FrameworkEvent.ASSEMBLE_COMPELETE));
        }

        protected function processDisassembleView( container:Container ):void{
            if( container != null ){
                uncustomizeComponent(container);
            }
        }

        protected function applicationMonitoringStart():void{
            var systemManager_:ISystemManager = _application.systemManager as ISystemManager;
            if( _application != null ){
                systemManager_
                    .removeEventListener(
                        FlexEvent.CREATION_COMPLETE,
                        creationCompleteHandler,
                        true
                        );

                systemManager_
                    .removeEventListener(
                        FlexEvent.REMOVE,
                        removeCompleteHandler,
                        true
                        );
            }

            systemManager_
                .addEventListener(
                    FlexEvent.CREATION_COMPLETE,
                    creationCompleteHandler,
                    true,
                    int.MAX_VALUE
                    );

            systemManager_
                .addEventListener(
                    FlexEvent.REMOVE,
                    removeCompleteHandler,
                    true,
                    int.MAX_VALUE
                );
        }

        protected function initNamingConvention():void{
            if( _namingConvention == null ){
                _namingConvention = new NamingConvention();
                _namingConvention.conventions = ResourceManager.getInstance().getStringArray("conventions","package");
            }
        }

        protected function getDefaultCustomizers():Array{
            var classes:Array = getDefaultCustomizerClasses();
            var result:Array = [];
            for each( var customizerClass:Class in classes ){
                result.push(new customizerClass(_namingConvention));
            }
            return result;
        }
    }
}