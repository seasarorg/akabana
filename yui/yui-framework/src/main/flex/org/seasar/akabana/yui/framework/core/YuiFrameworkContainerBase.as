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
    
    CONFIG::UNCAUGHT_ERROR_GLOBAL{
        import flash.events.UncaughtErrorEvent;
    }
    
    import flash.events.Event;
    import flash.system.Capabilities;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    
    import org.seasar.akabana.yui.core.Environment;
    import org.seasar.akabana.yui.core.yui_internal;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.core.event.FrameworkEvent;
    import org.seasar.akabana.yui.framework.customizer.IComponentCustomizer;
    import org.seasar.akabana.yui.framework.customizer.IViewCustomizer;
    import org.seasar.akabana.yui.framework.customizer.IElementCustomizer;
    import org.seasar.akabana.yui.framework.error.YuiFrameworkContainerError;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.framework.core.event.RuntimeErrorEvent;
    
    use namespace yui_internal;
    
    [ExcludeClass]
    public class YuiFrameworkContainerBase extends YuiFrameworkContainerCore
    {
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
        
        public function YuiFrameworkContainerBase(){
            super();
            
            trace("yui-frameworks-"+VERSION);
            trace("Copyright 2004-2010 the Seasar Foundation and the Others.");
            
            CONFIG::DEBUG{
                if( Capabilities.isDebugger ){
                    trace("using Flash Debug Player " + Capabilities.version);
                } else {
                    trace("using Flash Player " + Capabilities.version);
                }
            }
        }
        
        public override function addRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                _logger.debug("add external root"+root);
            }
            if( root in _rootDisplayObjectMap ){
                applicationMonitoringStop(root);
            }
            applicationMonitoringStart(root);
            
            addRootDisplayObject(root);
        }
        
        public override function removeRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                _logger.debug("remove external root"+root);
            }
            if( root in _rootDisplayObjectMap ){
                applicationMonitoringStop(root);
            }
            
            removeRootDisplayObject(root);
        }
        
        private function systemManager_addedToStageHandler( event:Event ):void{
            CONFIG::DEBUG_EVENT{
                _logger.info("[EVENT] systemManager_addedToStageHandler"+event+","+event.target);
            }
            if( event.target is DisplayObject ){
                doRegisterComponent(event.target as DisplayObject);
            }
        }
        
        private function systemManager_addedToStageHandler2( event:Event ):void{
            CONFIG::DEBUG_EVENT{
                _logger.info("[EVENT] systemManager_addedToStageHandler2"+event+","+event.target);
            }
            if( event.target is DisplayObject ){
                doAssembleComponent(event.target as DisplayObject);
            }
        }
        
        private function systemManager_removeFromStageHandler(event:Event):void{
            CONFIG::DEBUG_EVENT{
                _logger.info("[EVENT] systemManager_removeHandler"+event+","+event.target);
            }        
            if( event.target is DisplayObject ){
                doUnregisterComponent(event.target as DisplayObject);
            }
        }
        
        CONFIG::UNCAUGHT_ERROR_GLOBAL{
            private function loaderInfoUncaughtErrorHandler(event:UncaughtErrorEvent):void
            {
                var runtimeErrorEvent:RuntimeErrorEvent = RuntimeErrorEvent.createEvent(event.error);
                YuiFrameworkGlobals.public::frameworkBridge.application.dispatchEvent(runtimeErrorEvent);
            }
        }
        
        yui_internal function applicationMonitoringStop(root:DisplayObject):void{
            root.removeEventListener(
                Event.ADDED_TO_STAGE,
                systemManager_addedToStageHandler,
                true
            );
            
            yui_internal::initialize();
        }
        
        
        yui_internal function systemManagerMonitoringStart( root:DisplayObject ):void{
            CONFIG::DEBUG{
                _logger.info("monitoring..."+root);
            }
            root.addEventListener(
                Event.ADDED_TO_STAGE,
                systemManager_addedToStageHandler,
                true,
                int.MAX_VALUE
            );
            registerRootDisplayObject(root);
        }
        
        yui_internal function systemManagerMonitoringStop(root:DisplayObject):void{
            root.removeEventListener(
                Event.REMOVED_FROM_STAGE,
                systemManager_removeFromStageHandler,
                true
            );
            
            root.removeEventListener(
                Event.ADDED_TO_STAGE,
                systemManager_addedToStageHandler2,
                true
            );
            root.dispatchEvent(new FrameworkEvent(FrameworkEvent.APPLICATION_MONITOR_STOP));
        }
        
        yui_internal function applicationMonitoringStart(root:DisplayObject):void{
            
            root.addEventListener(
                Event.REMOVED_FROM_STAGE,
                systemManager_removeFromStageHandler,
                true,
                int.MAX_VALUE
            );
            
            root.addEventListener(
                Event.ADDED_TO_STAGE,
                systemManager_addedToStageHandler2,
                true,
                int.MAX_VALUE
            );
            
            root.dispatchEvent(new FrameworkEvent(FrameworkEvent.APPLICATION_MONITOR_START));
        }
        
        yui_internal function initialize():void{
            
        }

        protected function doRegisterComponent( component:DisplayObject ):void{
            if( YuiFrameworkGlobals.public::frameworkBridge.isApplication(component) ){
                processRegisterApplication(component as DisplayObjectContainer);
            } else {
                processRegisterView(component as DisplayObjectContainer);
                if( _isApplicationStarted ){
                    doAssembleComponent(component);
                }
            }
        }
        
        protected function doUnregisterComponent(component:DisplayObject):void{
            if( isView(component)){
                processDisassembleView( component as DisplayObjectContainer);
                processUnregisterView( component as DisplayObjectContainer);
            }
        }
        
        protected function doAssembleComponent( component:DisplayObject ):void{
            if( isView(component)){
                processAssembleView( component as DisplayObjectContainer);
            }
        }
        
        protected function processRegisterApplication(component:DisplayObjectContainer):void{
            CONFIG::DEBUG{
                _logger.debug(getMessage("ApplicationRegistered",component.toString()));
            }
            YuiFrameworkGlobals.public::frameworkBridge.application = component;
            Environment.yui_internal::root = component;
            Environment.yui_internal::parameters = YuiFrameworkGlobals.public::frameworkBridge.parameters;
            
            const root:DisplayObject = YuiFrameworkGlobals.public::frameworkBridge.systemManager;
            systemManagerMonitoringStop(root);
            applicationMonitoringStart(root);
            CONFIG::UNCAUGHT_ERROR_GLOBAL{
                component.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, loaderInfoUncaughtErrorHandler);
            }
        }
        
        protected function processApplicationStart():void{
            var rootView:DisplayObjectContainer = YuiFrameworkGlobals.public::frameworkBridge.rootView;
            if( rootView != null ){
                rootView.visible = true;
            }
            CONFIG::DEBUG{
                _logger.info(getMessage("ApplicationStart"));
            }
            if( rootView != null ){
                rootView.dispatchEvent( new FrameworkEvent(FrameworkEvent.APPLICATION_START));
                rootView.visible = true;
            }
        }
        
        protected function processRegisterView( container:DisplayObjectContainer ):void{
            if( isView(container)){
                ViewComponentRepository.addComponent( container );
                CONFIG::DEBUG{
                    _logger.debug(getMessage("ViewComponentRegistered",container.toString()));
                }
            }
        }
        
        protected function processUnregisterView( container:DisplayObjectContainer ):void{
            if( isView(container)){
                if( ViewComponentRepository.hasComponent( container.name )){
                    ViewComponentRepository.removeComponent( container );
                    CONFIG::DEBUG{
                        _logger.debug(getMessage("ViewComponentUnRegistered",container.toString()));
                    }
                }
            }
        }
        
        protected function processAssembleView( view:DisplayObjectContainer ):void{
            customizeView(view);
            view.dispatchEvent( new FrameworkEvent(FrameworkEvent.ASSEMBLE_COMPELETE));
        }
        
        protected function processAssembleViewChild( container:DisplayObjectContainer,child:DisplayObject):void{
            customizeComponent(container,child);
        }
        
        protected function processDisassembleView( container:DisplayObjectContainer ):void{
            uncustomizeView(container);
        }
        
        protected function processDisassembleViewChild( container:DisplayObjectContainer,child:DisplayObject):void{
            uncustomizeComponent(container,child);
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