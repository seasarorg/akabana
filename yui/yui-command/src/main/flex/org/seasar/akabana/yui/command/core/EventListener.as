package org.seasar.akabana.yui.command.core
{
	import flash.utils.Dictionary;

	public class EventListener
	{
		protected var _handler:Dictionary;
		
		public function EventListener(){
			_handler = new Dictionary(true);
		}

		public function get handler():Function{
			var result:*;
			for( result in _handler ){
			}
			return result as Function;
		}		
		
		public function set handler( value:Function ):void{
			if( value != null ){
				_handler[ value ] = true;
			} else {
				_handler = new Dictionary();
			}
		}

	}
}