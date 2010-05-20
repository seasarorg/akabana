package examples.yui.popup.action
{
	import examples.yui.popup.helper.PopupHelper;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class PopupAction
	{
		public var helper:PopupHelper;

		public function onShowHandler(event:Event):void{
		    trace(event);
		}

        public function sayClickHandler(event:MouseEvent):void
        {
            trace(event);
        }

	}
}