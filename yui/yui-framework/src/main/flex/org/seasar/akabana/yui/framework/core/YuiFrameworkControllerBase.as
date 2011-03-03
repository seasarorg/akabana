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
    import org.seasar.akabana.yui.core.ns.yui_internal;
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.bridge.FrameworkBridge;
    import org.seasar.akabana.yui.framework.customizer.IComponentCustomizer;
    import org.seasar.akabana.yui.framework.customizer.IViewCustomizer;
    import org.seasar.akabana.yui.framework.customizer.IElementCustomizer;
    import org.seasar.akabana.yui.framework.event.RuntimeErrorEvent;
    import org.seasar.akabana.yui.framework.error.YuiFrameworkError;
    import org.seasar.akabana.yui.framework.event.YuiFrameworkEvent;
	import org.seasar.akabana.yui.framework.logging.debug;
	import org.seasar.akabana.yui.framework.logging.info;
    import org.seasar.akabana.yui.framework.logging.dump;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    
    use namespace yui_internal;
    
    [ExcludeClass]
    public class YuiFrameworkControllerBase extends YuiFrameworkControllerCore
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
        
        protected var _currentRoot:DisplayObject;
        
        public override function get currentRoot():DisplayObject{
            return _currentRoot;
        }
        
        public function YuiFrameworkControllerBase(){
            super();
            
            trace("yui-frameworks-"+VERSION);
            trace("Copyright 2004-2011 the Seasar Foundation and the Others.");
            
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
                debug(this,"add external root"+root);
            }
            InstanceCache.addRoot(root);
            if( root in _rootDisplayObjectMap ){
                applicationMonitoringStop(root);
            }
            _rootDisplayObjectMap[ root ] = true;
            applicationMonitoringStart(root);
            super.addRootDisplayObject(root);
        }
        
        public override function removeRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                debug(this,"remove external root"+root);
            }
            super.removeRootDisplayObject(root);            
            if( root in _rootDisplayObjectMap ){
                applicationMonitoringStop(root);
            }
            _rootDisplayObjectMap[ root ] = true;
            delete _rootDisplayObjectMap[ root ];
            
            if( _currentRoot === root ){
                _currentRoot = null;
            }
            InstanceCache.removeRoot(root);
        }
        
        private function systemManager_addedToStageHandler( event:Event ):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }
            if( event.target is DisplayObject ){
                doRegisterComponent(event.target as DisplayObject);
            }
        }
        
        private function systemManager_addedToStageHandler2( event:Event ):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event,"");
            }
            if( event.target is DisplayObject ){
                doAssembleComponent(event.target as DisplayObject);
            }
        }
        
        private function systemManager_removeFromStageHandler(event:Event):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }        
            if( event.target is DisplayObject ){
                doUnregisterComponent(event.target as DisplayObject);
            }
        }
        
        CONFIG::UNCAUGHT_ERROR_GLOBAL{
            yui_internal function loaderInfoUncaughtErrorHandler(event:UncaughtErrorEvent):void
            {
                const frameworkBridge:FrameworkBridge = YuiFrameworkGlobals.public::frameworkBridge as FrameworkBridge;
                const runtimeErrorEvent:RuntimeErrorEvent = RuntimeErrorEvent.createEvent(event.error);
                if (!frameworkBridge.application.dispatchEvent(runtimeErrorEvent)){
                    event.preventDefault();
                }
            }
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
            
            if( root.hasEventListener(YuiFrameworkEvent.APPLICATION_MONITOR_START)){
                root.dispatchEvent(new YuiFrameworkEvent(YuiFrameworkEvent.APPLICATION_MONITOR_START));
            }
        }
        
        yui_internal function applicationMonitoringStop(root:DisplayObject):void{
            root.removeEventListener(
                Event.ADDED_TO_STAGE,
                systemManager_addedToStageHandler,
                true
            );
            
            yui_internal::applicationInitialize();
        }
        
        
        yui_internal function systemManagerMonitoringStart( root:DisplayObject ):void{
            CONFIG::DEBUG{
                info(this,"SystemManager Monitoring Start..."+root);
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
            if( root.hasEventListener(YuiFrameworkEvent.APPLICATION_MONITOR_STOP)){
                root.dispatchEvent(new YuiFrameworkEvent(YuiFrameworkEvent.APPLICATION_MONITOR_STOP));
            }
        }
        
        yui_internal function applicationInitialize():void{
            
        }

        protected function doRegisterComponent( component:DisplayObject ):void{
            const frameworkBridge:FrameworkBridge = YuiFrameworkGlobals.public::frameworkBridge as FrameworkBridge;
            if( frameworkBridge.isApplication(component) ){
                processApplicationRegister(component as DisplayObjectContainer);
            } else {
                processViewRegister(component as DisplayObjectContainer);
                if( _isApplicationStarted ){
                    doAssembleComponent(component);
                }
            }
        }
        
        protected function doUnregisterComponent(component:DisplayObject):void{
            if( isView(component)){
                processViewDisassemble( component as DisplayObjectContainer);
                processViewUnregister( component as DisplayObjectContainer);
            }
        }
        
        protected function doAssembleComponent( component:DisplayObject ):void{
            if( isView(component)){
                processViewAssemble( component as DisplayObjectContainer);
            }
        }
        
        protected function processApplicationRegister(component:DisplayObjectContainer):void{
            CONFIG::DEBUG{
                debug(this,getMessage("ApplicationRegistered",component.toString()));
            }
            const frameworkBridge:FrameworkBridge = YuiFrameworkGlobals.public::frameworkBridge as FrameworkBridge;
            frameworkBridge.application = component;
            Environment.yui_internal::root = component;
            Environment.yui_internal::parameters = frameworkBridge.parameters;
        }
        
        protected function processApplicationStart():void{
            const frameworkBridge:FrameworkBridge = YuiFrameworkGlobals.public::frameworkBridge as FrameworkBridge;
            const rootView:DisplayObjectContainer = frameworkBridge.rootView as DisplayObjectContainer;
            CONFIG::DEBUG{
                info(this,getMessage("ApplicationStart"));
            }
            if( rootView != null ){
                if( rootView.hasEventListener(YuiFrameworkEvent.APPLICATION_START)){
                    rootView.dispatchEvent( new YuiFrameworkEvent(YuiFrameworkEvent.APPLICATION_START));
                }
                rootView.visible = true;
            }
        }
        
        protected function processViewRegister( container:DisplayObjectContainer ):void{
            if( isView(container)){
                ViewComponentRepository.addComponent( container );
                CONFIG::DEBUG{
                    debug(this,getMessage("ViewComponentRegistered",container.toString()));
                }
            }
        }
        
        protected function processViewUnregister( container:DisplayObjectContainer ):void{
            if( isView(container)){
                if( ViewComponentRepository.hasComponent( container.name )){
                    ViewComponentRepository.removeComponent( container );
                    CONFIG::DEBUG{
                        debug(this,getMessage("ViewComponentUnRegistered",container.toString()));
                    }
                }
            }
        }
        
        protected function processViewAssemble( view:DisplayObjectContainer ):void{
            customizeView(view);
        }
        
        protected function processViewChildAssemble( container:DisplayObjectContainer,child:DisplayObject):void{
            customizeComponent(container,child);
        }
        
        protected function processViewDisassemble( container:DisplayObjectContainer ):void{
            uncustomizeView(container);
        }
        
        protected function processViewChildDisassemble( container:DisplayObjectContainer,child:DisplayObject):void{
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