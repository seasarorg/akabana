package examples.yui.popup.behavior
{
	import examples.yui.popup.helper.PopupOwnerHelper;
	import examples.yui.popup.view.PopupView;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class PopupOwnerPopupBehavior
	{
		public var helper:PopupOwnerHelper;

		public function showClickHandler(event:MouseEvent):void
		{
			helper.popup();
		}

		public function popupCloseHandler(event:Event):void{
			helper.hide(event.target as PopupView);
		}
	}
}