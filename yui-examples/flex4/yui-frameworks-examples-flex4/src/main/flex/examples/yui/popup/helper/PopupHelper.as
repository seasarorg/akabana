package examples.yui.popup.helper
{
	import examples.yui.popup.view.PopupView;
	
	import flash.events.Event;
	
	import org.seasar.akabana.yui.framework.rule.IStateless;
	
	public class PopupHelper implements IStateless
	{
		public var view:PopupView;
		
		public function commit():void{
			view.dispatchEvent(new Event("commit"));
		}

	}
}