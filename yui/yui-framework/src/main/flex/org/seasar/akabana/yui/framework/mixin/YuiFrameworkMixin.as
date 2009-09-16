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
	
	import flash.events.Event;
	import flash.net.registerClassAlias;
	
	import mx.core.IFlexModuleFactory;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.ISystemManager;
	
	import org.seasar.akabana.yui.framework.convention.NamingConvention;
	import org.seasar.akabana.yui.framework.core.YuiFrameworkContainer;
	import org.seasar.akabana.yui.framework.util.SystemManagerUtil;
	import org.seasar.akabana.yui.logging.LogManager;
	import org.seasar.akabana.yui.logging.config.ConfigurationProvider;
	import org.seasar.akabana.yui.logging.config.factory.LogConfigurationFactory;
	
	[Mixin]
	[ResourceBundle("yui_framework")]
	[ResourceBundle("conventions")]
	/**
	 * YuiFramework初期設定用Mixinクラス
	 * 
	 * @author $Author$
	 * @version $Revision$
	 */
	public class YuiFrameworkMixin
	{
		{
			LogConfigurationFactory;
			registerClassAlias(ConfigurationProvider.FACTORY_CLASS_NAME,LogConfigurationFactory);
		}
		
		private static var _this:YuiFrameworkMixin;
		
		private static var _container:YuiFrameworkContainer;
		
        public static function init( flexModuleFactory:IFlexModuleFactory ):void{
        	
            LogManager.init();

            _this = new YuiFrameworkMixin();
            _container = new YuiFrameworkContainer();

            if( flexModuleFactory is ISystemManager ){
            	_container.systemManager = flexModuleFactory as ISystemManager;
                var systemManager_:ISystemManager = SystemManagerUtil.getRootSystemManager(_container.systemManager);
                
                systemManager_
	                .addEventListener(
	                    Event.ADDED_TO_STAGE,
	                    _this.addedToStageHandler,
	                    true,
	                    int.MAX_VALUE
	                );
                systemManager_
	                .addEventListener(
	                    FlexEvent.APPLICATION_COMPLETE,
	                    _this.applicationCompleteHandler,
	                    false,
	                    int.MAX_VALUE
	                );        
                
                if( systemManager_ != flexModuleFactory ){
	                (flexModuleFactory as ISystemManager)
	                	.addEventListener(
		                    FlexEvent.APPLICATION_COMPLETE,
		                    _this.applicationCompleteHandler,
		                    false,
		                    int.MAX_VALUE
		                ); 
                }
            }            
        }
        
        public function set conventions( value:Array ):void{
            var namingConvention_:NamingConvention = new NamingConvention();
            namingConvention_.conventions = value;
            _container.namingConvention = namingConvention_;
        }
        
        protected var initialized:Boolean;
        
        private function addedToStageHandler( event:Event ):void{
            if( event.target is UIComponent ){
                _container.registerComponent(event.target as UIComponent);
            }
        }

        private function addedHandler( event:Event ):void{
            if( event.target is UIComponent ){
                _container.registerComponent(event.target as UIComponent);
            }
        }

        private function removedHandler( event:Event ):void{
            if( event.target is UIComponent ){
                _container.unregisterComponent(event.target as UIComponent);
            }
        }         
        
        private function applicationCompleteHandler( event:FlexEvent ):void{
            if( event.currentTarget is ISystemManager ){
                var systemManager_:ISystemManager = SystemManagerUtil.getRootSystemManager(_container.systemManager);
                systemManager_
	                .removeEventListener(
	                    FlexEvent.APPLICATION_COMPLETE,
	                    applicationCompleteHandler,
	                    false
	                );

                if( systemManager_ != event.currentTarget ){
	                (event.currentTarget as ISystemManager)
	                	.removeEventListener(
		                    FlexEvent.APPLICATION_COMPLETE,
		                    applicationCompleteHandler,
		                    false
		                ); 
                }                
                systemManager_
	                .removeEventListener(
	                    Event.ADDED_TO_STAGE,
	                    _this.addedToStageHandler,
	                    true
	                );
                systemManager_
	                .addEventListener(
	                    Event.ADDED,
	                    _this.addedHandler,
	                    true,
	                    int.MAX_VALUE
	                );
                systemManager_
	                .addEventListener(
	                    Event.REMOVED_FROM_STAGE,
	                    _this.removedHandler,
	                    true,
	                    int.MAX_VALUE
	                );                  
                if( !initialized ){
                    initialized = true;
                    _container.initialize();
                }
            }
        }
	}
}