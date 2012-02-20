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
    CONFIG::UNCAUGHT_ERROR_GLOBAL{
        import flash.events.UncaughtErrorEvent;
    }

    import __AS3__.vec.Vector;    
    
    import flash.events.Event;
    import flash.errors.IllegalOperationError;
    import flash.system.Capabilities;
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import flash.utils.Dictionary;
    import flash.display.LoaderInfo;
    
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    import mx.managers.ISystemManager;
    import mx.managers.SystemManager;
    import mx.managers.CursorManager;
    import mx.managers.PopUpManager;
    import mx.managers.DragManager;
    import mx.styles.IStyleManager2;
    import mx.styles.CSSStyleDeclaration;
    
    import org.seasar.akabana.yui.core.Environment;
    import org.seasar.akabana.yui.core.ns.yui_internal;
    
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.event.YuiFrameworkEvent;
    import org.seasar.akabana.yui.framework.bridge.FrameworkBridge;
    import org.seasar.akabana.yui.framework.customizer.IComponentCustomizer;
    import org.seasar.akabana.yui.framework.customizer.IViewCustomizer;
    import org.seasar.akabana.yui.framework.customizer.IElementCustomizer;
    import org.seasar.akabana.yui.framework.error.YuiFrameworkError;
    import org.seasar.akabana.yui.framework.util.UIComponentUtil;
    import org.seasar.akabana.yui.framework.util.StyleManagerUtil;
    import org.seasar.akabana.yui.framework.event.RuntimeErrorEvent;
    import org.seasar.akabana.yui.framework.logging.debug;
    import org.seasar.akabana.yui.framework.logging.dump;
    import org.seasar.akabana.yui.framework.logging.Logging;
    import org.seasar.akabana.yui.core.ns.yui_internal;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    import mx.managers.FocusManager;
    import mx.styles.StyleManager;
    
    use namespace yui_internal;
    
    [ExcludeClass]
    public final class YuiFrameworkController extends YuiFrameworkControllerBase {
        
        private static function isView(component:DisplayObject):Boolean{
            if( component == null ){
                return false;
            }
            const frameworkBridge:FrameworkBridge = YuiFrameworkGlobals.public::frameworkBridge as FrameworkBridge;
            if( frameworkBridge.isContainer(component)){
                const namingConvention:NamingConvention = YuiFrameworkGlobals.public::namingConvention as NamingConvention;
                return namingConvention.isViewClassName( getCanonicalName(component) );
            } else {
                return false;
            }
        }
        
        private static function isComponent( target:DisplayObject ):Boolean{
            if( target == null ){
                return false;
            }
            const frameworkBridge:FrameworkBridge = YuiFrameworkGlobals.public::frameworkBridge as FrameworkBridge;
            return frameworkBridge.isComponent(target);            
        }
        
        private static function getDocumentOf(target:DisplayObject):UIComponent{
            if( target == null || !isComponent(target) ){
                return null;
            }
            const frameworkBridge:FrameworkBridge = YuiFrameworkGlobals.public::frameworkBridge as FrameworkBridge;
            return frameworkBridge.getDocumentOf(target) as UIComponent; 
        }
        
        {
            CursorManager;
            PopUpManager;
            DragManager;
        }
        
        private static var _this:IYuiFrameworkController;
        
        public static function getInstance():IYuiFrameworkController{
            return _this;
        }
        
        protected function set currentSystemManger(value:ISystemManager):void{  
            CONFIG::DEBUG{
                if( _currentRoot != value ){
                    _debug("CurrentRoot",value);
                }
            }
            _currentRoot = value as DisplayObject;
        }
        
        public function YuiFrameworkController(){
            super();
            if( _this == null ){
                _this = this;
            } else {
                throw new YuiFrameworkError("container is already created.");
            }            
        }
        
        public override function customizeView( container:DisplayObjectContainer ):void{
            var viewCustomizer_:IViewCustomizer;
            var view:UIComponent = container as UIComponent;
            if( view == null && !isView(view) ){   
                return;
            }
            CONFIG::DEBUG{
                _debug("ViewCustomizing", view, view.owner);
            }
            if( !view.initialized ){   
                CONFIG::DEBUG{
                    _debug("ViewCustomizeInitializeError",view);
                }
                return;
            }
            currentSystemManger = view.systemManager;
            //
            processViewRegister(view); 
            for each( var customizer_:IElementCustomizer in _customizers ){
                viewCustomizer_ = customizer_ as IViewCustomizer;
                if( viewCustomizer_ != null ){
                    viewCustomizer_.customizeView( view );
                }
            }
            if( view.hasEventListener(YuiFrameworkEvent.VIEW_INITIALIZED)){
                view.dispatchEvent( new YuiFrameworkEvent(YuiFrameworkEvent.VIEW_INITIALIZED));
            }
            CONFIG::DEBUG{
                _debug("ViewCustomized",view,view.owner);
            }
        }
        
        public override function uncustomizeView( container:DisplayObjectContainer ):void{
            var viewCustomizer_:IViewCustomizer;
            var view:UIComponent = container as UIComponent;
            if( !isView(view) ){   
                return;
            }
            if( !view.initialized ){     
                CONFIG::DEBUG {
                    _debug("ViewUncustomizeInitializeError",view);       
                }
                return;
            }
            CONFIG::DEBUG{
                _debug("ViewUncustomizing",view,view.owner);
            }
            currentSystemManger = view.systemManager;
            var numCustomizers:int = customizers.length;
            for( var i:int = numCustomizers-1; i >= 0; i-- ){
                viewCustomizer_ = customizers[i] as IViewCustomizer;
                if( viewCustomizer_ != null ){
                    viewCustomizer_.uncustomizeView( view );
                }
            }
            processViewUnregister(view);
            CONFIG::DEBUG{
                _debug("ViewUncustomized",view,view.owner);
            }
        }
        
        public override function customizeComponent( container:DisplayObjectContainer, child:DisplayObject ):void{
            if( container == null || !isView(container) ){
                return;
            }
            if( child == null || !isComponent(child) ){
                return;
            }
            //
            var componentCustomizer_:IComponentCustomizer;
            var view:UIComponent = container as UIComponent;
            var component:UIComponent = child as UIComponent;
            if( !view.initialized || !component.initialized){     
                CONFIG::DEBUG{
                    _debug("ComponentCustomizeViewInitializeError",view,view.owner);       
                }
                return;
            }
            CONFIG::DEBUG{
                _debug("ComponentCustomizing",child,container);
            }
            currentSystemManger = view.systemManager;
            for each( var customizer_:IElementCustomizer in _customizers ){
                componentCustomizer_ = customizer_ as IComponentCustomizer;
                if( componentCustomizer_ != null ){
                    componentCustomizer_.customizeComponent( view, component );
                }
            }
            CONFIG::DEBUG{
                _debug("ComponentCustomized",child,container);
            }
        }
        
        public override function uncustomizeComponent( container:DisplayObjectContainer, child:DisplayObject ):void{
            if( container == null || !isView(container) ){
                return;
            }
            if( child == null || !isComponent(child) ){
                return;
            }
            //
            var componentCustomizer_:IComponentCustomizer;
            var view:UIComponent = container as UIComponent;
            var component:UIComponent = child as UIComponent;
            if( !view.initialized ){     
                CONFIG::DEBUG{       
                    _debug("ComponentUncustomizeViewInitializeError",view);
                }
                return;
            }
            CONFIG::DEBUG{
                _debug("ComponentUncustomizing",child, container);
            }
            currentSystemManger = view.systemManager;
            var numCustomizers:int = customizers.length;
            for( var i:int = numCustomizers-1; i >= 0; i-- ){
                componentCustomizer_ = customizers[i] as IComponentCustomizer;
                if( componentCustomizer_ != null ){
                    componentCustomizer_.uncustomizeComponent( view, component );
                }
            }
            CONFIG::DEBUG{
                _debug("ComponentUncustomized",child, container);
            }
        }        
        
        private function application_initCompleteHandler( event:Event ):void{
            Logging.initialize();
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }
        }
        
        private function application_preloaderDoneHandler( event:Event ):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }
            if( event.currentTarget is ISystemManager ){
                var root:ISystemManager = event.currentTarget as ISystemManager;
                CONFIG::DEBUG{
                    _info("SystemManagerMonitoringStart",root);
                }
                registerRootDisplayObject(root as DisplayObject);
                
                //detecting component addition for register
                root.addEventListener(
                    Event.ADDED_TO_STAGE,
                    systemManager_addedToStageHandler,
                    true,
                    int.MAX_VALUE
                );
            } else {
                throw new IllegalOperationError("Illegal SystemManager"+event.currentTarget);
            }
            YuiFrameworkGlobals.initNamingConvention();
            CONFIG::DEBUG{
                _debug("ApplicationConventions",YuiFrameworkGlobals.public::namingConvention.conventions.toString());
            }            
        }
        
        private function application_applicationCompleteHandler( event:FlexEvent ):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }
            const frameworkBridge:FrameworkBridge = YuiFrameworkGlobals.public::frameworkBridge as FrameworkBridge;
            const root:DisplayObject = frameworkBridge.systemManager;
            systemManagerMonitoringStop(root);
            applicationInitialize();           
        }
        
        private function systemManager_addedToStageHandler( event:Event ):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }
            var component:UIComponent = event.target as UIComponent;
            if( component == null || !component.initialized ){
                return;
            }
            const frameworkBridge:FrameworkBridge = YuiFrameworkGlobals.public::frameworkBridge as FrameworkBridge;
            if( frameworkBridge.application == null && frameworkBridge.isApplication(component) ){
                processApplicationRegisteration(component as DisplayObjectContainer);
            } else {
                processViewRegister(component); 
            }
        }
        
        private function systemManager_creationCompleteHandler(event:FlexEvent):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }            
            doRegisterComponent(event.target as DisplayObject);
        }
        
        private function applicationInitialize():void{
            
            if( _customizers == null ){
                _customizers = getDefaultCustomizers();
            }
            CONFIG::DEBUG{
                _debug("ViewAssembleStart");
            }
            
            var allView:Dictionary = ViewComponentRepository.allView;
            for ( var viewName:String in allView ){
                CONFIG::DEBUG{
                    _debug("ViewAssembleing",viewName);
                }
                customizeView(ViewComponentRepository.getComponent(viewName));
                CONFIG::DEBUG{
                    _debug("ViewAssembled",viewName);
                }
            }
            
            CONFIG::DEBUG{
                _debug("ViewAssembleEnd");
            }
            callLater( processApplicationStart );
        }
        
        protected override function getDefaultCustomizerClasses():Array{
            const styleManager:IStyleManager2 = StyleManagerUtil.getStyleManager();
            const customizersDef:CSSStyleDeclaration = styleManager.getStyleDeclaration(".customizers");
            const defaultFactory:Function = customizersDef.defaultFactory;
            
            const result:Array = [];
            const keys:Array = [];
            
            var customizers:Object = {};
            var customizer:Class;
            var numKeys:int;
            
            if (defaultFactory != null){
                defaultFactory.prototype = {};
                customizers = new defaultFactory();
            }
            
            for( var key:String in customizers ){
                keys.push(key);
            }
            keys.sort();
            numKeys = keys.length;
            for( var i:int = 0; i < numKeys; i++ ){
                customizer = customizers[keys[i]] as Class;
                result.push(customizer);
            }
            CONFIG::DEBUG{
                _debug("CustomizerLoaded",result);
            }
            return result;
        }
        
        protected override function doRegisterComponent( target:DisplayObject ):void{
            const settings:YuiFrameworkSettings = YuiFrameworkGlobals.public::settings;
            
            var component:UIComponent = target as UIComponent;
            if( component == null || !component.initialized ){
                return;
            }
            if( isView(component) ){
                customizeView(component);
            } else {
                if( settings.isAutoMonitoring ){
                    customizeComponent(getDocumentOf(component),component);
                }
            }
        }
        
        protected override function doUnregisterComponent(target:DisplayObject):void{
            const settings:YuiFrameworkSettings = YuiFrameworkGlobals.public::settings;
            
            var component:UIComponent = target as UIComponent;
            if( component == null || !component.initialized ){
                return;
            }
            if( isView(component)){
                uncustomizeView( component as DisplayObjectContainer);
            } else {
                if( settings.isAutoMonitoring ){
                    uncustomizeComponent(getDocumentOf(component),component);
                }
            }
        }
        
        private function processApplicationRegisteration(component:DisplayObjectContainer):void{
            CONFIG::DEBUG{
                _debug("ApplicationRegistered",component.toString());
            }
            const frameworkBridge:FrameworkBridge = YuiFrameworkGlobals.public::frameworkBridge as FrameworkBridge;
            frameworkBridge.application = component;
            Environment.yui_internal::setRoot( component );
            Environment.yui_internal::setParameters( frameworkBridge.parameters );
            
            const root:DisplayObject = frameworkBridge.systemManager;
            CONFIG::UNCAUGHT_ERROR_GLOBAL{
                root.loaderInfo.uncaughtErrorEvents
                    .addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, loaderInfoUncaughtErrorHandler,false,int.MAX_VALUE);
            }
            if( root is SystemManager ){
                var sm:SystemManager = root as SystemManager;
                var preloadedRSLs:Dictionary = sm.preloadedRSLs;
                var loaderInfo:LoaderInfo;
                
                for( var item:Object in preloadedRSLs ){
                    loaderInfo = item as LoaderInfo;
                    CONFIG::DEBUG{
                        debug(this,"preloadedRSLs:"+loaderInfo.url);
                    }
                    CONFIG::UNCAUGHT_ERROR_GLOBAL{
                        loaderInfo.loader.uncaughtErrorEvents
                            .addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, loaderInfoUncaughtErrorHandler,false,int.MAX_VALUE);
                    }
                }
            }
        }
        
        private function processApplicationStart():void{
            const frameworkBridge:FrameworkBridge = YuiFrameworkGlobals.public::frameworkBridge as FrameworkBridge;
            const settings:YuiFrameworkSettings = YuiFrameworkGlobals.public::settings;
            
            const root:DisplayObject = frameworkBridge.systemManager;
            const app:UIComponent = frameworkBridge.application as UIComponent;
            const rootView:DisplayObjectContainer = frameworkBridge.rootView as DisplayObjectContainer;
            CONFIG::DEBUG{
                _info("ApplicationStart");
            }

            app.setVisible(true,true);
            if( rootView != null ){
                if( rootView.hasEventListener(YuiFrameworkEvent.APPLICATION_START)){
                    rootView.dispatchEvent( new YuiFrameworkEvent(YuiFrameworkEvent.APPLICATION_START));
                }
                rootView.visible = true;
            }

            var allView:Dictionary = ViewComponentRepository.allView;
            var fevent:YuiFrameworkEvent;
            for each (var view:UIComponent in allView) 
            {
                if( view === rootView ){
                    continue;
                }
                if( view.hasEventListener(YuiFrameworkEvent.APPLICATION_START)){
                    fevent = new YuiFrameworkEvent(YuiFrameworkEvent.APPLICATION_START);
                    view.dispatchEvent( fevent );
                }
            }
            _isApplicationStarted = true;
            
            if( settings.isAutoMonitoring ){
                componentMonitoringStart(root);
            }
        }

        private function processViewRegister( container:DisplayObjectContainer ):void{
            if( isView(container)){
                const namingConvention:NamingConvention = YuiFrameworkGlobals.public::namingConvention;
                const componentId:String = namingConvention.getComponentName(container);
                if( !ViewComponentRepository.hasComponent( componentId )){
                    ViewComponentRepository.addComponent( container );
                    CONFIG::DEBUG{
                        _debug("ViewRegistered",container.toString());
                    }
                }
            }
        }
        
        private function processViewUnregister( container:DisplayObjectContainer ):void{
            if( isView(container)){
                const namingConvention:NamingConvention = YuiFrameworkGlobals.public::namingConvention;
                const componentId:String = namingConvention.getComponentName(container);
                if( ViewComponentRepository.hasComponent( componentId )){
                    ViewComponentRepository.removeComponent( container );
                    CONFIG::DEBUG{
                        _debug("ViewUnRegistered",container.toString());
                    }
                }
            }
        }
        
        yui_internal function systemManagerMonitoringStart( root:DisplayObject ):void{
            CONFIG::DEBUG{
                Logging.initialize();
            }
            root.addEventListener(
                FlexEvent.INIT_COMPLETE,
                application_initCompleteHandler,
                true,
                int.MAX_VALUE
            );
            
            root.addEventListener(
                FlexEvent.PRELOADER_DONE,
                application_preloaderDoneHandler,
                true,
                int.MAX_VALUE
            );
            
            root.addEventListener(
                FlexEvent.APPLICATION_COMPLETE,
                application_applicationCompleteHandler,
                false,
                int.MAX_VALUE
            );
        }
        
        yui_internal function systemManagerMonitoringStop( root:DisplayObject ):void{
            
            root.removeEventListener(
                FlexEvent.APPLICATION_COMPLETE,
                application_applicationCompleteHandler,
                false
            );
            
            root.removeEventListener(
                FlexEvent.INIT_COMPLETE,
                application_initCompleteHandler,
                true
            );
            
            root.removeEventListener(
                FlexEvent.PRELOADER_DONE,
                application_preloaderDoneHandler,
                true
            );
            root.removeEventListener(
                Event.ADDED_TO_STAGE,
                systemManager_addedToStageHandler,
                true
            );
        }
        
        yui_internal override function componentMonitoringStart(root:DisplayObject):void{
            super.componentMonitoringStart(root);
            root.addEventListener(
                FlexEvent.CREATION_COMPLETE,
                systemManager_creationCompleteHandler,
                true,
                int.MAX_VALUE
            );
        }
        
        yui_internal override function componentMonitoringStop(root:DisplayObject):void{
            super.componentMonitoringStop(root);
            root.addEventListener(
                FlexEvent.CREATION_COMPLETE,
                systemManager_creationCompleteHandler,
                true,
                int.MAX_VALUE
            );
        }
    }
}