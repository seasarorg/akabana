package org.seasar.akabana.yui.framework
{
	import flash.display.DisplayObject;
	
	import mx.core.Container;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.managers.SystemManager;
	
	use namespace mx_internal;

	public class YuiFrameworkSystemManager extends SystemManager
	{
        private static const processer:ComponentParseProcesser = new ComponentParseProcesser();
        
		public static function externalContainer( container:Container ):void{
			container.addEventListener( FlexEvent.ADD, addHandler, true, int.MAX_VALUE, false);
		}
		
		public static function addHandler( event:FlexEvent ):void{
            trace( event + ":" + event.target );
            processer.parse( event.target );
        }
        
		mx_internal override function childAdded(child:DisplayObject):void
		{
			child.addEventListener( FlexEvent.ADD, addHandler, true, int.MAX_VALUE, false);
			super.childAdded(child);
		}
	}
}