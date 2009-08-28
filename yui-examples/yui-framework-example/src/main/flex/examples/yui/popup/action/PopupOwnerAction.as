package examples.yui.popup.action
{
	import examples.yui.popup.helper.PopupOwnerHelper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PopupOwnerAction
	{
		public var helper:PopupOwnerHelper;
		
		public function showClickHandler(event:MouseEvent):void
		{
			helper.popup();
		}
		
		public function popupCloseHandler(event:Event):void{
			trace(event);
		}

	}
}