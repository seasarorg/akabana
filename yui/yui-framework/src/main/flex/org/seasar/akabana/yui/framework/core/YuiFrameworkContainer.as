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
	import org.seasar.akabana.yui.framework.customizer.IViewCustomizer;
	import org.seasar.akabana.yui.framework.customizer.IElementCustomizer;
    import org.seasar.akabana.yui.framework.error.YuiFrameworkContainerError;
	import org.seasar.akabana.yui.framework.util.UIComponentUtil;

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
        public function get customizers():Vector.<IElementCustomizer>{
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
                    Event.REMOVED_FROM_STAGE,
                    systemManager_removeFromStageHandler,
                    true,
                    int.MAX_VALUE
                );

            addSystemManager(systemManager);
        }

        public override function customizeView( container:UIComponent ):void{
CONFIG::DEBUG{
            _logger.debug("customizeView:"+container+",owner:"+container.owner);
}
			var viewcustomizer_:IViewCustomizer; 
            for each( var customizer_:IElementCustomizer in _customizers ){
				viewcustomizer_ = customizer_ as IViewCustomizer;
				if( viewcustomizer_ != null ){
					viewcustomizer_.customizeView( container );
				}
            }
        }

        public override function uncustomizeView( container:UIComponent ):void{
CONFIG::DEBUG{
            _logger.debug("uncustomizeView:"+container+",owner:"+container.owner);
}
            var numCustomizers:int = customizers.length;
			var viewcustomizer_:IViewCustomizer;
            for( var i:int = numCustomizers-1; i >= 0; i-- ){
                viewcustomizer_ = customizers[i] as IViewCustomizer;
				if( viewcustomizer_ != null ){
					viewcustomizer_.uncustomizeView( container );
				}
            }
        }
		
		public override function customizeComponent( container:UIComponent, child:UIComponent ):void{
CONFIG::DEBUG{
	_logger.debug("customizeComponent:"+child+",owner:"+container);
}
			var componentcustomizer_:IComponentCustomizer;
			for each( var customizer_:IElementCustomizer in _customizers ){
				componentcustomizer_ = customizer_ as IComponentCustomizer;
				if( componentcustomizer_ != null ){
					componentcustomizer_.customizeComponent( container, child );
				}
			}
		}
		
		public override function uncustomizeComponent( container:UIComponent, child:UIComponent ):void{
CONFIG::DEBUG{
	_logger.debug("uncustomizeComponent:"+child+",owner:"+container);
}
			var numCustomizers:int = customizers.length;
			var componentcustomizer_:IComponentCustomizer;
			for( var i:int = numCustomizers-1; i >= 0; i-- ){
				componentcustomizer_ = customizers[i] as IComponentCustomizer;
				if( componentcustomizer_ != null ){
					componentcustomizer_.uncustomizeComponent( container, child );
				}
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
                    systemManager_addedToStageHandler,
                    true
                );

            initialize();
        }

        private function systemManager_addedToStageHandler( event:Event ):void{
CONFIG::DEBUG_EVENT{
            _logger.info("[EVENT] systemManager_addedToStageHandler"+event+","+event.target);
}
            if( event.target is UIComponent ){
                doRegisterComponent(event.target as UIComponent);
            }
        }

        private function systemManager_addedToStageHandler2( event:Event ):void{
CONFIG::DEBUG_EVENT{
            _logger.info("[EVENT] systemManager_addedToStageHandler2"+event+","+event.target);
}
            if( event.target is UIComponent ){
				var component:UIComponent = event.target as UIComponent;
				if( component != null && component.initialized ){
                	doAssembleComponent(component);
				}
            }
        }

        private function creationCompleteHandler(event:Event):void{
CONFIG::DEBUG_EVENT{
			_logger.info("[EVENT] creationCompleteHandler"+event+","+event.target);
}			
			if( event.target is UIComponent ){
            	doAssembleComponent(event.target as UIComponent);
			}
        }

        private function systemManager_removeFromStageHandler(event:Event):void{
CONFIG::DEBUG_EVENT{
			_logger.info("[EVENT] systemManager_removeHandler"+event+","+event.target);
}		
			if( event.target is UIComponent ){
            	doUnregisterComponent(event.target as UIComponent);
			}
        }

        yui_internal function monitoringSystemManager( systemManager:ISystemManager ):void{
CONFIG::DEBUG{
            _logger.info("monitoring..."+systemManager);
}
            systemManager
                .addEventListener(
                    Event.ADDED_TO_STAGE,
                    systemManager_addedToStageHandler,
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
			var view:UIComponent;
            for ( var key:String in viewMap ){
CONFIG::DEBUG{
                _logger.debug(getMessage("ViewComponentAssembleing",key));
}
                view = ViewComponentRepository.getComponent(key);
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

        protected function isView( component:Object ):Boolean{
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

                if( isView(component)){
                    processRegisterView(component as UIComponent);
                    if( _isApplicationStarted && component.initialized ){
                        doAssembleComponent(component);
                    }
                    break;
                }
            }while(false);
        }

        protected function doAssembleComponent( component:UIComponent ):void{
            if( isView(component)){
                processAssembleComponent(component as UIComponent);
            } else {
				var document:UIComponent = component.document as UIComponent;
				if( document != null && document.initialized && isView(document)){
					processAssembleViewChild(document,component);
				}
			}
        }

        protected function doUnregisterComponent(component:UIComponent):void{
            if( isView(component)){
                processDisassembleView( component as UIComponent );
                processUnregisterView( component as UIComponent );
            } else {
				var owner:UIComponent = component.owner as UIComponent;
				if( owner != null && owner.initialized && isView(owner)){
					processDisassembleViewChild(owner,component);
				}
			}
        }

        protected function processRegisterView( container:UIComponent ):void{
            if( isView(container)){
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
            if( isView(container)){
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

        protected function processAssembleView( viewName:String, view:UIComponent ):void{
CONFIG::DEBUG{
            _logger.debug(viewName + "[" + view + "] is assembling... ");
}
            customizeView(view);
			view.dispatchEvent( new FrameworkEvent(FrameworkEvent.ASSEMBLE_COMPELETE));

CONFIG::DEBUG{
			_logger.debug(viewName + "[" + view + "] is assembled.");
}
		}
		
		protected function processAssembleViewChild(view:UIComponent,child:UIComponent):void{
			if( view.initialized && child.initialized ){
				customizeComponent(view,child);
			}
		}

        protected function processDisassembleView( container:UIComponent ):void{
            if( container != null ){
                uncustomizeView(container);
            }
        }
		
		protected function processDisassembleViewChild(view:UIComponent,child:UIComponent):void{
			if( view.initialized ){
				uncustomizeComponent(view,child);
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
                        Event.REMOVED_FROM_STAGE,
                        systemManager_removeFromStageHandler,
                        true
                        );
					
				systemManager_
					.removeEventListener(
						Event.ADDED_TO_STAGE,
						systemManager_addedToStageHandler2,
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
					Event.REMOVED_FROM_STAGE,
					systemManager_removeFromStageHandler,
					true,
					int.MAX_VALUE
				);
				
			systemManager_
				.addEventListener(
					Event.ADDED_TO_STAGE,
					systemManager_addedToStageHandler2,
					true
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
        protected function getDefaultCustomizers():Vector.<IElementCustomizer>{
            var classes:Array = getDefaultCustomizerClasses();
            var result:Vector.<IElementCustomizer> = new Vector.<IElementCustomizer>();
            for each( var customizerClass:Class in classes ){
                result.push(new customizerClass());
            }
            return result;
        }
}

    }
}