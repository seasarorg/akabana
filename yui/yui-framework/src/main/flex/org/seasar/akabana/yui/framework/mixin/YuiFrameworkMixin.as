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
package org.seasar.akabana.yui.framework.mixin
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.IFlexModuleFactory;
	import mx.events.FlexEvent;
	import mx.managers.ISystemManager;
	
	import org.seasar.akabana.yui.framework.convention.NamingConvention;
	import org.seasar.akabana.yui.framework.core.YuiFrameworkContainer;
	import org.seasar.akabana.yui.logging.LogManager;
	
	[Mixin]
	[ResourceBundle("yui_framework")]
    /**
	 * YuiFramework設定用MIXIN
	 *  
	 */
	public class YuiFrameworkMixin
	{
        YuiCoreClasses;
        LogManager.init();
        YuiFrameworkClasses;
        
	    private static const _logManagerInitialized:Boolean = initLogManager();
	    
		private static const _this:YuiFrameworkMixin = new YuiFrameworkMixin();
		
		private static const _container:YuiFrameworkContainer = new YuiFrameworkContainer();
		
		public static function initLogManager():Boolean{
		    LogManager.init();
		    return true;
		}
		
        public static function init( flexModuleFactory:IFlexModuleFactory ):void{
            if( flexModuleFactory is ISystemManager ){
                var systemManager:ISystemManager = flexModuleFactory as ISystemManager;
                systemManager.addEventListener(
                    Event.ADDED_TO_STAGE,
                    _this.addedToStageHandler,
                    true,
                    int.MAX_VALUE
                ); 
                systemManager.addEventListener(
                    FlexEvent.APPLICATION_COMPLETE,
                    _this.applicationCompleteHandler,
                    false,
                    int.MAX_VALUE
                );    
            }
        }
        
        public function set conventions( value:Array ):void{
            var namingConvention_:NamingConvention = new NamingConvention();
            namingConvention_.conventions = value;
            _container.namingConvention = namingConvention_;
        }
        
        protected var initialized:Boolean;
        
        private function addedToStageHandler( event:Event ):void{
            _container.registerComponent(event.target as DisplayObject);
        }
        
        private function applicationCompleteHandler( event:FlexEvent ):void{
            if( event.currentTarget is ISystemManager ){
                var systemManager:ISystemManager = event.currentTarget as ISystemManager;
                systemManager.removeEventListener(
                    Event.ADDED_TO_STAGE,
                    addedToStageHandler,
                    true
                );
                systemManager.removeEventListener(
                    FlexEvent.APPLICATION_COMPLETE,
                    applicationCompleteHandler,
                    false
                );
                if( !initialized ){
                    initialized = true;
                    _container.init();
                }
            }
        }
	}
}