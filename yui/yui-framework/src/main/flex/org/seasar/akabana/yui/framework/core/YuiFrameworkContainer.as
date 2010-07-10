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
package org.seasar.akabana.yui.framework.core
{
CONFIG::FP10{
    import __AS3__.vec.Vector;
}

    import flash.events.Event;
    import flash.system.Capabilities;

    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    import mx.managers.ISystemManager;

    import org.seasar.akabana.yui.core.Environment;
    import org.seasar.akabana.yui.core.yui_internal;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.core.event.FrameworkEvent;
    import org.seasar.akabana.yui.framework.customizer.IComponentCustomizer;
    import org.seasar.akabana.yui.framework.error.YuiFrameworkContainerError;

    [ExcludeClass]
    public final class YuiFrameworkContainer extends YuiFrameworkContainerBase
    {

        protected static var _container:IYuiFrameworkContainer;

        public static function get yuicontainer():IYuiFrameworkContainer{
            return _container;
        }

CONFIG::FP9{
        public function get customizers():Array{
            return _customizers;
        }
}
CONFIG::FP10{
        public function get customizers():Vector.<IComponentCustomizer>{
            return _customizers;
        }
}

        public function get application():UIComponent{
            return YuiFrameworkGlobals.frameworkBridge.application;
        }

        public function YuiFrameworkContainer(){
            super();
            if( _container == null ){
                _container = this;
CONFIG::FP9{
                _systemManagers = [];
}
CONFIG::FP10{
                _systemManagers = new Vector.<ISystemManager>;
}
            } else {
                throw new YuiFrameworkContainerError("container is already created.");
            }
        }

        public override function addExternalSystemManager(systemManager:ISystemManager ):void{
CONFIG::DEBUG{
            _logger.debug("add external systemManager"+systemManager);
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

        public override function customizeComponent( container:UIComponent, owner:UIComponent=null):void{
CONFIG::DEBUG{
            _logger.debug("customizeComponent:"+container+",owner:"+owner);
}
            for each( var customizer_:IComponentCustomizer in _customizers ){
                customizer_.customize( container, owner);
            }
        }

        public override function uncustomizeComponent( container:UIComponent, owner:UIComponent=null):void{
CONFIG::DEBUG{
            _logger.debug("uncustomizeComponent:"+container+",owner:"+owner);
}
            var numCustomizers:int = customizers.length;
            for( var i:int = numCustomizers-1; i >= 0; i-- ){
                var customizer_:IComponentCustomizer = customizers[i] as IComponentCustomizer;
                customizer_.uncustomize( container, owner);
            }
        }

        private function applicationInitCompleteHandler( event:Event ):void{
CONFIG::DEBUG_EVENT{
			_logger.info("[EVENT] applicationInitCompleteHandler"+event+","+event.target);
}
CONFIG::DEBUG{
            _logger.debug("applicationInitCompleteHandler:"+event+","+event.target);
}
        }

        private function applicationPreloaderDoneHandler( event:Event ):void{
CONFIG::DEBUG_EVENT{
			_logger.info("[EVENT] applicationPreloaderDoneHandler"+event+","+event.target);
}
CONFIG::DEBUG{
            _logger.debug("applicationPreloaderDoneHandler:"+event+","+event.target);
}
            YuiFrameworkGlobals.yui_internal::initNamingConvention();
        }

        private function applicationCompleteHandler( event:FlexEvent ):void{
CONFIG::DEBUG_EVENT{
			_logger.info("[EVENT] applicationCompleteHandler"+event+","+event.target);
}
CONFIG::DEBUG{
            _logger.debug("applicationCompleteHandler:"+event+","+event.target);
}
            var systemManager_:ISystemManager = event.currentTarget as ISystemManager;

            systemManager_
            	.removeEventListener(
                    FlexEvent.APPLICATION_COMPLETE,
                    applicationCompleteHandler,
                    false
                );

            systemManager_
                .removeEventListener(
                    FlexEvent.INIT_COMPLETE,
                    applicationInitCompleteHandler,
                    true
                );

            systemManager_
                .removeEventListener(
                    FlexEvent.PRELOADER_DONE,
                    applicationPreloaderDoneHandler,
                    true
                );

            systemManager_
                .removeEventListener(
                    Event.ADDED_TO_STAGE,
                    addedToStageHandler,
                    true
                );

            initialize();
        }

        private function addedToStageHandler( event:Event ):void{
CONFIG::DEBUG_EVENT{
            _logger.info("[EVENT] addedToStageHandler"+event+","+event.target);
}
            if( event.target is UIComponent ){
                doRegisterComponent(event.target as UIComponent);
            }
        }

        private function removedHandler( event:Event ):void{
CONFIG::DEBUG_EVENT{
            _logger.info("[EVENT] removedHandler"+event+","+event.target);
}
            if( event.target is UIComponent ){
                doUnregisterComponent(event.target as UIComponent);
            }
        }

        private function creationCompleteHandler(event:Event):void{
CONFIG::DEBUG_EVENT{
			_logger.info("[EVENT] creationCompleteHandler"+event+","+event.target);
}			
            doAssembleComponent(event.target as UIComponent);
        }

        private function removeCompleteHandler(event:Event):void{
CONFIG::DEBUG_EVENT{
			_logger.info("[EVENT] removeCompleteHandler"+event+","+event.target);
}		
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
                    FlexEvent.INIT_COMPLETE,
                    applicationInitCompleteHandler,
                    true,
                    int.MAX_VALUE
                );

            systemManager
                .addEventListener(
                    FlexEvent.PRELOADER_DONE,
                    applicationPreloaderDoneHandler,
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
            trace("Copyright 2004-2010 the Seasar Foundation and the Others.");

CONFIG::DEBUG{
            if( Capabilities.isDebugger ){
                trace("using Flash Debug Player " + Capabilities.version);
            } else {
                trace("using Flash Player " + Capabilities.version);
            }
            _logger.debug(getMessage("ApplicationConventions",YuiFrameworkGlobals.namingConvention.conventions.toString()));
}
            if( _customizers == null ){
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
                var view:UIComponent = ViewComponentRepository.getComponent(key);
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
        	var rootView:UIComponent = YuiFrameworkGlobals.frameworkBridge.rootView;
        	if( rootView != null ){
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
            if( component == null || !(component is UIComponent)){
                return false;
            }
			if( YuiFrameworkGlobals.frameworkBridge.isContainer(component)){
				return YuiFrameworkGlobals.namingConvention.isViewClassName( getCanonicalName(component) );
			} else {
				return false;
			}
        }

        protected function doRegisterComponent( component:UIComponent ):void{
            do{
                if( YuiFrameworkGlobals.frameworkBridge.isApplication(component) ){
CONFIG::DEBUG{
                        _logger.debug(getMessage("ApplicationRegistered",component.toString()));
}
                        YuiFrameworkGlobals.frameworkBridge.yui_internal::application = component;
    					Environment.yui_internal::root = component;
    					Environment.yui_internal::parameters = YuiFrameworkGlobals.frameworkBridge.parameters;
                        component.setVisible(false,true);
                        applicationMonitoringStart();
                        break;
                }

                if( isViewComponent(component)){
                    processRegisterView(component as UIComponent);
                    if( _isApplicationStarted && component.initialized ){
                        doAssembleComponent(component);
                    }
                    break;
                }
            }while(false);
        }

        protected function doAssembleComponent( component:UIComponent ):void{
            if( isViewComponent(component)){
                processAssembleComponent(component as UIComponent);
            }
        }

        protected function doUnregisterComponent(component:Object):void{
            if( isViewComponent(component)){
                processDisassembleView( component as UIComponent );
                processUnregisterView( component as UIComponent );
            }
        }

        protected function processRegisterView( container:UIComponent ):void{
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

        protected function processUnregisterView( container:UIComponent ):void{
            if( isViewComponent(container)){
                if( ViewComponentRepository.hasComponent( container.name )){
                    ViewComponentRepository.removeComponent( container );
CONFIG::DEBUG{
                    _logger.debug(getMessage("ViewComponentUnRegistered",container.toString()));
}
                }
            }
        }

        protected function processAssembleComponent(container:UIComponent):void{
            if( container.initialized ){
                processAssembleView( container.name, container);
            }
        }

        protected function processAssembleView( viewName:String, container:UIComponent ):void{
CONFIG::DEBUG{
            _logger.debug(container + " as " + viewName);
}
            customizeComponent(container);
            container.dispatchEvent( new FrameworkEvent(FrameworkEvent.ASSEMBLE_COMPELETE));
        }

        protected function processDisassembleView( container:UIComponent ):void{
            if( container != null ){
                uncustomizeComponent(container);
            }
        }

        protected function applicationMonitoringStart():void{
            var systemManager_:ISystemManager = YuiFrameworkGlobals.frameworkBridge.systemManager;
            var application_:UIComponent = YuiFrameworkGlobals.frameworkBridge.application;
            if( application_ != null ){
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

            systemManager_.dispatchEvent(new FrameworkEvent(FrameworkEvent.APPLICATION_MONITOR_START));
        }

CONFIG::FP9{
        protected function getDefaultCustomizers():Array{
            var classes:Array = getDefaultCustomizerClasses();
            var result:Array = [];
            for each( var customizerClass:Class in classes ){
                result.push(new customizerClass());
            }
            return result;
        }
}
CONFIG::FP10{
        protected function getDefaultCustomizers():Vector.<IComponentCustomizer>{
            var classes:Array = getDefaultCustomizerClasses();
            var result:Vector.<IComponentCustomizer> = new Vector.<IComponentCustomizer>();
            for each( var customizerClass:Class in classes ){
                result.push(new customizerClass());
            }
            return result;
        }
}

    }
}