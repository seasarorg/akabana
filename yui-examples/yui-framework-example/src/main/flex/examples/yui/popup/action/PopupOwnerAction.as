package examples.yui.popup.action
{
	import examples.yui.popup.behavior.PopupOwnerPopupBehavior;
	import examples.yui.popup.helper.PopupOwnerHelper;

	import flash.events.Event;

	public class PopupOwnerAction
	{
		public var helper:PopupOwnerHelper;

		public var popupBehavior:PopupOwnerPopupBehavior;

		public function onShowHandler(event:Event):void{
		    trace(event);
		}

		public function fadeInEffectEndHandler(event:Event):void{
		    trace(event);
		}

	}
}