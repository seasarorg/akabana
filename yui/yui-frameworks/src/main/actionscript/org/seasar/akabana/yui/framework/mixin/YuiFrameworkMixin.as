package org.seasar.akabana.yui.framework.mixin
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.managers.SystemManager;
	
	[Mixin]
	public class YuiFrameworkMixin
	{
		private static const instance:YuiFrameworkMixin = new YuiFrameworkMixin();
		
		public static function init( systemManager:SystemManager ):void{
		}
	}
}