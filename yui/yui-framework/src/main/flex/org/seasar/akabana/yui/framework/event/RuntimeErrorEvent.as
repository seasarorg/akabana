package org.seasar.akabana.yui.framework.event
{
	import flash.events.ErrorEvent;
	
	import org.seasar.akabana.yui.core.reflection.ClassRef;
	
	public class RuntimeErrorEvent extends ErrorEvent
	{
		public static const RUNTIME_ERROR:String = "runtimeError";
		
		public static function createEvent( e:Error ):RuntimeErrorEvent{
			var runtimeErrorEvent:RuntimeErrorEvent = new RuntimeErrorEvent(RUNTIME_ERROR);
            runtimeErrorEvent.text = e.message;
            runtimeErrorEvent.errorType = ClassRef.getQualifiedClassName(e);
            runtimeErrorEvent.stackTrace = e.getStackTrace();
			return runtimeErrorEvent;
		}
		
		public var stackTrace:String;
		
		public var errorType:String;
		
		public function RuntimeErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = ""){
			super(type,bubbles,cancelable,text);
		}
		
		public override function toString():String{
			return stackTrace;
		}
	}
}