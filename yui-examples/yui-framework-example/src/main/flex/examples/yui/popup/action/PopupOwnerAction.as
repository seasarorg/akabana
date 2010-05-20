package examples.yui.popup.action
{
	import examples.yui.popup.helper.PopupOwnerHelper;
	import examples.yui.popup.view.PopupView;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class PopupOwnerAction
	{
		public var helper:PopupOwnerHelper;

		public function onShowHandler(event:Event):void{
		    trace(event);
		}

		public function showClickHandler(event:MouseEvent):void
		{
			helper.popup();
		}

		public function popupCloseHandler(event:Event):void{
			helper.hide(event.target as PopupView);
		}

		public function fadeInEffectEndHandler(event:Event):void{
		    trace(event);
		}

	}
}