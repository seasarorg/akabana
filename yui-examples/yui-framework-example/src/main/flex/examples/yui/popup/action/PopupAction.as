package examples.yui.popup.action
{
	import examples.yui.popup.helper.PopupHelper;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class PopupAction
	{
		public var helper:PopupHelper;

		public var timer:Timer;

		public function PopupAction():void{
		    timer = new Timer(100,0);
		}

		public function onShowHandler(event:Event):void{
		    trace(event);
		}

        public function timerTimerHandler(event:TimerEvent):void{
            trace(event);
            timer.stop();
        }

        public function sayClickHandler(event:MouseEvent):void
        {
            trace(event);
		    timer.start();
        }

	}
}