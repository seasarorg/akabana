package examples.yui.popup.action
{
	import examples.yui.popup.helper.PopupHelper;
	
	import flash.events.MouseEvent;
	
	public class PopupAction
	{
		public var helper:PopupHelper;
		
        public function sayClickHandler(event:MouseEvent):void
        {
            trace(event);
            helper.hide();
        }

	}
}