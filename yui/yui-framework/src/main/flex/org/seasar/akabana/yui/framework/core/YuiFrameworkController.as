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
    import flash.errors.IllegalOperationError;
    import flash.system.Capabilities;
    import flash.display.DisplayObjectContainer;
    import flash.display.DisplayObject;
    import flash.utils.Dictionary;
    
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
    
    use namespace yui_internal;
    
    [ExcludeClass]
    public final class YuiFrameworkController extends YuiFrameworkControllerBase
    {   
        {
            CursorManager;
            PopUpManager;
            DragManager;
        }
        
        private static var _container:IYuiFrameworkContainer;
        
        public static function get yuicontainer():IYuiFrameworkContainer{
            return _container;
        }
        
        public function YuiFrameworkController(){
            super();
            if( _container == null ){
                _container = this;
            } else {
                throw new YuiFrameworkError("container is already created.");
            }            
        }
        
        public function addExternalSystemManager(sm:ISystemManager ):void{
            addRootDisplayObject(sm as DisplayObject);
        }
        
        public function removeExternalSystemManager(sm:ISystemManager ):void{
            removeRootDisplayObject(sm as DisplayObject);
        }
        
        public override function customizeView( container:DisplayObjectContainer ):void{
            var view:UIComponent = container as UIComponent;
            if( !view.initialized ){   
                CONFIG::DEBUG {         
                    debug(this,"customizeView:"+view+" is not initialize.");
                }
                return;
            }
            CONFIG::DEBUG{
                debug(this,"customizeView:"+view+",owner:"+view.owner);
            }
            var viewcustomizer_:IViewCustomizer; 
            for each( var customizer_:IElementCustomizer in _customizers ){
                viewcustomizer_ = customizer_ as IViewCustomizer;
                if( viewcustomizer_ != null ){
                    viewcustomizer_.customizeView( view );
                }
            }
            if( view.hasEventListener(YuiFrameworkEvent.VIEW_INITIALIZED)){
                view.dispatchEvent( new YuiFrameworkEvent(YuiFrameworkEvent.VIEW_INITIALIZED));
            }
        }
        
        public override function uncustomizeView( container:DisplayObjectContainer ):void{
            var view:UIComponent = container as UIComponent;
            if( !view.initialized ){     
                CONFIG::DEBUG {
                    debug(this,"customizeView:"+view+" is not initialize.");       
                }
                return;
            }
            CONFIG::DEBUG{
                debug(this,"uncustomizeView:"+view+",owner:"+view.owner);
            }
            var numCustomizers:int = customizers.length;
            var viewcustomizer_:IViewCustomizer;
            for( var i:int = numCustomizers-1; i >= 0; i-- ){
                viewcustomizer_ = customizers[i] as IViewCustomizer;
                if( viewcustomizer_ != null ){
                    viewcustomizer_.uncustomizeView( view );
                }
            }
        }
        
        public override function customizeComponent( container:DisplayObjectContainer, child:DisplayObject ):void{
            var view:UIComponent = container as UIComponent;
            var component:UIComponent = child as UIComponent;
            if( !view.initialized || !component.initialized){     
                CONFIG::DEBUG{
                    debug(this,"customizeComponent:"+view+" is not initialize.");       
                }
                return;
            }
            CONFIG::DEBUG{
                debug(this,"customizeComponent:start, "+child+",owner:"+container);
            }
            var componentcustomizer_:IComponentCustomizer;
            for each( var customizer_:IElementCustomizer in _customizers ){
                componentcustomizer_ = customizer_ as IComponentCustomizer;
                if( componentcustomizer_ != null ){
                    componentcustomizer_.customizeComponent( view, component );
                }
            }
            CONFIG::DEBUG{
                debug(this,"customizeComponent:end, "+child+",owner:"+container);
            }
        }
        
        public override function uncustomizeComponent( container:DisplayObjectContainer, child:DisplayObject ):void{
            var view:UIComponent = container as UIComponent;
            var component:UIComponent = child as UIComponent;
            if( !view.initialized ){     
                CONFIG::DEBUG{       
                    debug(this,"uncustomizeComponent:"+view+" is not initialize.");
                }
                return;
            }
            CONFIG::DEBUG{
                debug(this,"uncustomizeComponent:start, "+child+",owner:"+container);
            }
            var numCustomizers:int = customizers.length;
            var componentcustomizer_:IComponentCustomizer;
            for( var i:int = numCustomizers-1; i >= 0; i-- ){
                componentcustomizer_ = customizers[i] as IComponentCustomizer;
                if( componentcustomizer_ != null ){
                    componentcustomizer_.uncustomizeComponent( view, component );
                }
            }
            CONFIG::DEBUG{
                debug(this,"uncustomizeComponent:end, "+child+",owner:"+container);
            }
        }        
        
        private function applicationInitCompleteHandler( event:Event ):void{
            Logging.initialize();
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }
        }
        
        private function applicationPreloaderDoneHandler( event:Event ):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }
            if( event.currentTarget is ISystemManager ){
                var sm:ISystemManager = event.currentTarget as ISystemManager;
                super.yui_internal::systemManagerMonitoringStart(sm as DisplayObject);
            } else {
                throw new IllegalOperationError("Illegal SystemManager"+event.currentTarget);
            }
            YuiFrameworkGlobals.initNamingConvention();
            CONFIG::DEBUG{
                debug(this,getMessage("ApplicationConventions",YuiFrameworkGlobals.public::namingConvention.conventions.toString()));
            }            
        }
        
        private function applicationCompleteHandler( event:FlexEvent ):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }
            applicationMonitoringStop(event.currentTarget as DisplayObject);            
        }
        
        private function creationCompleteHandler(event:FlexEvent):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }            
            doAssembleComponent(event.target as DisplayObject);
        }
        
        protected override function doRegisterComponent( target:DisplayObject ):void{
            var component:UIComponent = target as UIComponent;
            super.doRegisterComponent(component);
        }
        
        protected override function doUnregisterComponent(target:DisplayObject):void{
            var component:UIComponent = target as UIComponent;
            if( isView(component)){
                super.doUnregisterComponent(component);
            } else if(isComponent(component)){
                var document:UIComponent = component.document as UIComponent;
                if( document != null && document.initialized && isView(document)){
                    processViewChildDisassemble(document,component);
                }
            }
        }
        
        protected override function doAssembleComponent( target:DisplayObject ):void{
            var component:UIComponent = target as UIComponent;
            if( component == null || !component.initialized ){
                return;
            }
            if( isView(component)){
                processViewAssemble(component);
            } else if(isComponent(component)){
                var document:UIComponent = component.document as UIComponent;
                if( document != null && document.initialized && isView(document)){
                    processViewChildAssemble(document,component);
                }
            }
        }
        
        protected override function processApplicationStart():void{
            const app:UIComponent = YuiFrameworkGlobals.public::frameworkBridge.application as UIComponent;
            const rootView:DisplayObjectContainer = YuiFrameworkGlobals.public::frameworkBridge.rootView as DisplayObjectContainer;
            app.setVisible(true,true);
            super.processApplicationStart();
            
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
        }
        
        protected override function getDefaultCustomizerClasses():Array{
            const styleManager:IStyleManager2 = StyleManagerUtil.getStyleManager();
            const customizersDef:CSSStyleDeclaration = styleManager.getStyleDeclaration(".customizers");
            const defaultFactory:Function = customizersDef.defaultFactory;
            
            const result:Array = [];
            const keys:Array = [];
            
            var customizers:Object = {};
            if (defaultFactory != null)
            {
                defaultFactory.prototype = {};
                customizers = new defaultFactory();
            }
            
            var customizer:Class;
            for( var key:String in customizers ){
                keys.push(key);
            }
            keys.sort();
            for( var i:int = 0; i < keys.length; i++ ){                
                customizer = customizers[keys[i]] as Class;
                result.push(customizer);
            }
            CONFIG::DEBUG{
                debug(this,"default customizers is "+result);
            }
            return result;
        }

        yui_internal override function applicationInitialize():void{
            if( _customizers == null ){
                _customizers = getDefaultCustomizers();
            }
            CONFIG::DEBUG{
                debug(this,getMessage("ViewComponentAssembleStart"));
            }
            
            var allView:Dictionary = ViewComponentRepository.allView;
            var view:UIComponent;
            for ( var viewName:String in allView ){
                CONFIG::DEBUG{
                    debug(this,getMessage("ViewComponentAssembleing",viewName));
                }
                view = ViewComponentRepository.getComponent(viewName) as UIComponent;
                if( view != null && view.initialized ){
                    processViewAssemble(view);
                }
                CONFIG::DEBUG{
                    debug(this,getMessage("ViewComponentAssembled",viewName));
                }
            }
            
            CONFIG::DEBUG{
                debug(this,getMessage("ViewComponentAssembleEnd"));
            }
            _isApplicationStarted = true;
            callLater( processApplicationStart );
        }
        
        yui_internal override function isView(component:DisplayObject):Boolean{
            if( component == null || !(component is UIComponent)){
                return false;
            }
            if( YuiFrameworkGlobals.public::frameworkBridge.isContainer(component)){
                return YuiFrameworkGlobals.public::namingConvention.isViewClassName( getCanonicalName(component) );
            } else {
                return false;
            }
        }
        
        yui_internal override function isComponent( target:DisplayObject ):Boolean{
            var component:UIComponent = target as UIComponent;
            if( component == null || component.id == null || !(component is UIComponent)){
                return false;
            }
            return YuiFrameworkGlobals.public::frameworkBridge.isComponent(component);            
        }
        
        yui_internal override function applicationMonitoringStart(root:DisplayObject):void{
            root.addEventListener(
                FlexEvent.CREATION_COMPLETE,
                creationCompleteHandler,
                true,
                int.MAX_VALUE
            );
            super.yui_internal::applicationMonitoringStart(root);
        }
        
        yui_internal override function applicationMonitoringStop(root:DisplayObject):void{
            root.removeEventListener(
                FlexEvent.APPLICATION_COMPLETE,
                applicationCompleteHandler,
                false
            );
            
            root.removeEventListener(
                FlexEvent.INIT_COMPLETE,
                applicationInitCompleteHandler,
                true
            );
            
            root.removeEventListener(
                FlexEvent.PRELOADER_DONE,
                applicationPreloaderDoneHandler,
                true
            );
            super.applicationMonitoringStop(root);
        }
        
        yui_internal override function systemManagerMonitoringStart( root:DisplayObject ):void{
            root.addEventListener(
                FlexEvent.INIT_COMPLETE,
                applicationInitCompleteHandler,
                true,
                int.MAX_VALUE
            );
            
            root.addEventListener(
                FlexEvent.PRELOADER_DONE,
                applicationPreloaderDoneHandler,
                true,
                int.MAX_VALUE
            );
            
            root.addEventListener(
                FlexEvent.APPLICATION_COMPLETE,
                applicationCompleteHandler,
                false,
                int.MAX_VALUE
            );
        }
        
        yui_internal override function systemManagerMonitoringStop(root:DisplayObject):void{
            const application_:DisplayObjectContainer = YuiFrameworkGlobals.public::frameworkBridge.application;
            if( application_ != null ){
                root.removeEventListener(
                    FlexEvent.CREATION_COMPLETE,
                    creationCompleteHandler,
                    true
                );
            }
            super.yui_internal::systemManagerMonitoringStop(root);
        }
    }
}