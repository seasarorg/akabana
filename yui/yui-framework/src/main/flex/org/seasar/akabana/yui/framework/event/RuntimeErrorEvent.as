package org.seasar.akabana.yui.framework.event
{
	import flash.events.ErrorEvent;
	
	public class RuntimeErrorEvent extends ErrorEvent
	{
		public static const RUNTIME_ERROR:String = "runtimeError";
		
		public var stackTrace:String;
		
		public function RuntimeErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = ""){
			super(type,bubbles,cancelable,text);
		}
		
		public override function toString():String{
			return stackTrace;
		}
	}
}