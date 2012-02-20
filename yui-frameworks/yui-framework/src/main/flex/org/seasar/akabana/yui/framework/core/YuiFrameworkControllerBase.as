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
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    
    use namespace yui_internal;
    
    [ExcludeClass]
    /**
     * 
     * @author arikawa.eiichi
     * 
     */
    public class YuiFrameworkControllerBase extends YuiFrameworkControllerCore {

        /**
         * 
         * @return 
         * 
         */
        public function get customizers():Vector.<IElementCustomizer>{
            return _customizers;
        }
        
        /**
         * 
         */
        protected var _currentRoot:DisplayObject;
        
        /**
         * 
         * @return 
         * 
         */
        public override function get currentRoot():DisplayObject{
            return _currentRoot;
        }
        
        /**
         * 
         * 
         */
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
        
        /**
         * 
         * @param root
         * 
         */
        public override function addRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                _debug("ExternalRootAdd",root);
            }
            InstanceCache.addRoot(root);
            if( root in _rootDisplayObjectMap ){
                applicationMonitoringStop(root);
            }
            _rootDisplayObjectMap[ root ] = true;
            applicationMonitoringStart(root);
            super.addRootDisplayObject(root);
        }
        
        /**
         * 
         * @param root
         * 
         */
        public override function removeRootDisplayObject(root:DisplayObject):void{
            CONFIG::DEBUG{
                _debug("ExternalRootRemove",root);
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
        
        /**
         * @private
         */
        private function systemManager_addedToStageHandler( event:Event ):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }
            if( event.target is DisplayObject ){
                doRegisterComponent(event.target as DisplayObject);
            }
        }
        
        /**
         * @private
         */
        private function systemManager_removeFromStageHandler(event:Event):void{
            CONFIG::DEBUG_EVENT{
                dump(this,event);
            }        
            if( event.target is DisplayObject ){
                doUnregisterComponent(event.target as DisplayObject);
            }
        }

        /**
         * 
         * @param component
         * 
         */
        protected function doRegisterComponent( component:DisplayObject ):void{
        }
        
        /**
         * 
         * @param component
         * 
         */
        protected function doUnregisterComponent(component:DisplayObject):void{
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
        
        /**
         * 
         * @param root
         * 
         */
        yui_internal function applicationMonitoringStart(root:DisplayObject):void{
            const settings:YuiFrameworkSettings = YuiFrameworkGlobals.public::settings;
            //
            if( settings.isAutoMonitoring ){
                componentMonitoringStart(root);
            }
            
            //
            if( root.hasEventListener(YuiFrameworkEvent.APPLICATION_MONITOR_START)){
                root.dispatchEvent(new YuiFrameworkEvent(YuiFrameworkEvent.APPLICATION_MONITOR_START));
            }
        }
        
        /**
         * 
         * @param root
         * 
         */
        yui_internal function applicationMonitoringStop(root:DisplayObject):void{
            const settings:YuiFrameworkSettings = YuiFrameworkGlobals.public::settings;
            //stop detecting component addition for register
            if( settings.isAutoMonitoring ){
                componentMonitoringStop(root);
            }
            
            if( root.hasEventListener(YuiFrameworkEvent.APPLICATION_MONITOR_STOP)){
                root.dispatchEvent(new YuiFrameworkEvent(YuiFrameworkEvent.APPLICATION_MONITOR_STOP));
            }
        }
        
        /**
         * 
         * @param root
         * 
         */
        yui_internal function componentMonitoringStart(root:DisplayObject):void{
            
            //detecting component addition for assemble
            if( root.hasEventListener(Event.ADDED_TO_STAGE)){
                root.removeEventListener(
                    Event.ADDED_TO_STAGE,
                    systemManager_addedToStageHandler,
                    true
                );
            }
            root.addEventListener(
                Event.ADDED_TO_STAGE,
                systemManager_addedToStageHandler,
                true,
                int.MAX_VALUE
            );
            
            //detecting component deletion for assemble
            if( root.hasEventListener(Event.REMOVED_FROM_STAGE)){
                root.removeEventListener(
                    Event.REMOVED_FROM_STAGE,
                    systemManager_removeFromStageHandler,
                    true
                );
            }
            root.addEventListener(
                Event.REMOVED_FROM_STAGE,
                systemManager_removeFromStageHandler,
                true,
                int.MAX_VALUE
            );
        }
        
        /**
         * 
         * @param root
         * 
         */
        yui_internal function componentMonitoringStop(root:DisplayObject):void{
            root.removeEventListener(
                Event.ADDED_TO_STAGE,
                systemManager_addedToStageHandler,
                true
            );
            root.removeEventListener(
                Event.REMOVED_FROM_STAGE,
                systemManager_removeFromStageHandler,
                true
            );
        }
    }
}