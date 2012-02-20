package examples.yui.popup.action
{
	import examples.yui.popup.behavior.PopupButtonBehavior;
	import examples.yui.popup.helper.PopupHelper;
	
	import flash.events.Event;
	
	import org.seasar.akabana.yui.framework.ns.behavior;
	import org.seasar.akabana.yui.framework.rule.IStateless;

	public class PopupAction implements IStateless
	{
		behavior var buttonBehavior:PopupButtonBehavior;

		public function PopupAction():void{
		}

		public function onShowHandler(event:Event):void{
		    trace(event);
		}

	}
}