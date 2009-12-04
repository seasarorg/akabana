package org.seasar.akabana.yui.framework.bridge
{
	import mx.core.UIComponent;
	import mx.managers.ISystemManager;

	public interface IFrameworkBridgePlugin {
		function get application():UIComponent;
		
		function set application(value:UIComponent):void;
		
		function get parameters():Object;
		
		function get systemManager():ISystemManager;
		
		function isApplication(application:Object):Boolean;
		
		function isContainer(component:Object):Boolean;
	}
}