package examples.yui.popup.helper
{
	import examples.yui.popup.view.PopupView;

	import flash.events.Event;

	import mx.events.FlexEvent;

	public class PopupHelper
	{
		public var view:PopupView;

        public function commit():void{
            view.dispatchEvent(new Event(FlexEvent.VALUE_COMMIT));
        }
	}
}