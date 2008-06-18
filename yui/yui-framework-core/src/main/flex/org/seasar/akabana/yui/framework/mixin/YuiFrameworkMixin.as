package org.seasar.akabana.yui.framework.mixin
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.IFlexModuleFactory;
	import mx.events.FlexEvent;
	import mx.managers.ISystemManager;
	
	import org.seasar.akabana.yui.framework.core.YuiFrameworkContainer;
	import org.seasar.akabana.yui.framework.convention.NamingConvention;
	
	[Mixin]
	/**
	 * YuiFramework設定用MIXIN
	 *  
	 */
	public class YuiFrameworkMixin
	{
		private static const _this:YuiFrameworkMixin = new YuiFrameworkMixin();
		
		private static const _container:YuiFrameworkContainer = new YuiFrameworkContainer();
		
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
                    true,
                    int.MAX_VALUE
                );    
            }
        }
        
        public function set conventions( value:Array ):void{
            trace("conventions:",value);
            var namingConvention_:NamingConvention = new NamingConvention();
            namingConvention_.conventions = value;
            _container.namingConvention = namingConvention_;
        }
        
        private function addedToStageHandler( event:Event ):void{
            _container.registerComponent(event.target as DisplayObject);
        }
        
        private function applicationCompleteHandler( event:FlexEvent ):void{
            trace("aplication complete",event.target,event.currentTarget);
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
                    true
                );
            }
            
            _container.init();
        }
	}
}