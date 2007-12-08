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
			container.addEventListener( FlexEvent.REMOVE, removeHandler, true, int.MAX_VALUE, false);
		}
		
		public static function addHandler( event:FlexEvent ):void{
            trace( event + ":" + event.target );
            processer.add( event.target );
        }
		
		public static function removeHandler( event:FlexEvent ):void{
            trace( event + ":" + event.target );
            processer.remove( event.target );
        }
                
		mx_internal override function childAdded(child:DisplayObject):void
		{
			child.addEventListener( FlexEvent.ADD, addHandler, true, int.MAX_VALUE, false);
			child.addEventListener( FlexEvent.REMOVE, removeHandler, true, int.MAX_VALUE, false);
			super.childAdded(child);
		}
	}
}