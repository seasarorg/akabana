package examples.yui.popup.action
{
	import examples.yui.popup.behavior.PopupButtonBehavior;
	import examples.yui.popup.helper.PopupHelper;

	import flash.events.Event;

	public class PopupAction
	{
		public var buttonBehavior:PopupButtonBehavior;

		public function PopupAction():void{
		}

		public function onShowHandler(event:Event):void{
		    trace(event);
		}

	}
}