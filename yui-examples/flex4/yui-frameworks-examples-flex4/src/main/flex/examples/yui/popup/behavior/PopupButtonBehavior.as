package examples.yui.popup.behavior
{
	import examples.yui.popup.helper.PopupHelper;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.seasar.akabana.yui.framework.core.ILifeCyclable;
	import org.seasar.akabana.yui.framework.rule.IStateless;

	public class PopupButtonBehavior implements ILifeCyclable,IStateless
	{
		public var helper:PopupHelper;

		public var timer:Timer;

		public var token:IEventDispatcher;

		public function PopupButtonBehavior():void{
		    timer = new Timer(100,0);
		    token = new EventDispatcher();
		}
		public function start():void{
		}

		public function stop():void{
		    if( timer.running ){
		        timer.stop();
		    }
		}

		public function onShowHandler(event:Event):void{
		    trace(">>",event);
		}

		public function tokenCompleteHandler():void{
			trace(1111);
		}

        public function timerTimerHandler(event:TimerEvent):void{
            trace(event);
            timer.stop();
            token.dispatchEvent(new Event(Event.COMPLETE));
        }

        public function sayClickHandler(event:MouseEvent):void
        {
            trace(event);
		    timer.start();
			helper.commit();
        }

	}
}