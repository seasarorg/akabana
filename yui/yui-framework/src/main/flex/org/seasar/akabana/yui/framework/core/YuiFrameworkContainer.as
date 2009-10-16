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
    import org.seasar.akabana.yui.framework.util.SystemManagerUtil;
    import org.seasar.akabana.yui.logging.Logger;

    public class YuiFrameworkContainer extends YuiFrameworkContainerBase
    {

        private static const _logger:Logger = Logger.getLogger(YuiFrameworkContainer);
        
        protected static var _container:YuiFrameworkContainer;

        public static function get yuicontainer():YuiFrameworkContainer{
            return _container;
        }

        protected var _customizers:Array;

        public function get customizers():Array{
            return _customizers;
        }

        protected var _isApplicationStarted:Boolean = true;

        protected var _systemManager:ISystemManager;

        public function get systemManager():ISystemManager{
            return _systemManager;
        }

        public function set systemManager( value:ISystemManager ):void{
            _systemManager = value;
        }

        protected var _application:Application;

        public function get application():Application{
            return _application;
        }

        public function set application( value:Application ):void{
            _application = value;
            Environment.yui_internal::root = _application;
            Environment.yui_internal::parameters = _application.parameters;
            applicationMonitoringStart();

            initNamingConvention();
        }

        private var _namingConvention:NamingConvention;

        public function get namingConvention():NamingConvention{
            return _namingConvention;
        }

        public function set namingConvention( value:NamingConvention ):void{
            _namingConvention = value;
        }

        public function YuiFrameworkContainer(){
            super();
            if( _container == null ){
                _container = this;
            } else {
                throw new YuiFrameworkContainerError("container is already created.");
            }
        }

        public function initialize():void{
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

        public function registerComponent( component:UIComponent ):void{
            doRegisterComponent(component);
        }

        public function unregisterComponent( component:UIComponent ):void{
            doUnregisterComponent(component);
        }

        public function customizeComponent( container:Container, owner:Container=null):void{
            for each( var customizer_:IComponentCustomizer in customizers ){
                customizer_.customize( container, owner);
            }
        }

        public function uncustomizeComponent( container:Container, owner:Container=null):void{
            var numCustomizers:int = customizers.length;
            for( var i:int = numCustomizers-1; i >= 0; i-- ){
                var customizer_:IComponentCustomizer = customizers[i] as IComponentCustomizer;
                customizer_.uncustomize( container, owner);
            }
        }

        private function callApplicationStart():void{
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

        private function creationCompleteHandler(event:Event):void{
            doAssembleComponent(event.target as UIComponent);
        }

        private function removeCompleteHandler(event:Event):void{
            doUnregisterComponent(event.target as UIComponent);
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

        protected function processRegisterComponent(component:Container):void{
            do{
                if( component is Application ){
                    application = component as Application;
                    application.setVisible(false,true);
CONFIG::DEBUG{
                    _logger.debug(getMessage("ApplicationRegistered",component.toString()));
}
                    break;
                }

                processRegisterView( component );

            } while( false );
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
            var systemManager_:ISystemManager = SystemManagerUtil.getRootSystemManager( _systemManager );
            if( application != null ){
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
            if( namingConvention == null ){
                namingConvention = new NamingConvention();
                namingConvention.conventions = ResourceManager.getInstance().getStringArray("conventions","package");
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