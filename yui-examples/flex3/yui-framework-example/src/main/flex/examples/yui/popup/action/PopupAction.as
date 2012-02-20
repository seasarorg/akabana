package examples.yui.popup.action
{
	import examples.yui.popup.behavior.PopupButtonBehavior;
	import examples.yui.popup.helper.PopupHelper;

	import org.seasar.akabana.yui.framework.ns.behavior;

	import flash.events.Event;

	public class PopupAction
	{
		behavior var buttonBehavior:PopupButtonBehavior;

		public function PopupAction():void{
		}

		public function onShowHandler(event:Event):void{
		    trace(event);
		}

	}
}