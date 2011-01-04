/*
* Copyright 2004-2010 the Seasar Foundation and the Others.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
* either express or implied. See the License for the specific language
* governing permissions and limitations under the License.
*/
package org.seasar.akabana.yui.core.reflection
{
    import flash.display.DisplayObject;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    
    [ExcludeClass]
    public final class FunctionInvoker{
		
        private var _func:Function;
		
		private var _args:Array;
        
        private var _timer:Timer;
		
		private var _frameCount:int;
		
		private var _invokeFrame:int;
        
        public function FunctionInvoker(func:Function, args:Array=null){
            super();
			_func = func;
			_args = args;
        }
		
		public function invokeLater(base:DisplayObject,invokeFrame:int=1):void{
			if( base == null ){
				clear();
			} else {
				_frameCount = 0;
				_invokeFrame = invokeFrame;
				base.addEventListener(Event.ENTER_FRAME,baseEnterFrameHandler);
			}
			
		}
		
		private function baseEnterFrameHandler(event:Event):void{
			_frameCount++;
			if( _frameCount > 0 && _frameCount >= _invokeFrame ){
				var base:DisplayObject = event.target as DisplayObject;
				base.removeEventListener(Event.ENTER_FRAME,baseEnterFrameHandler);
				doInvoke();
			}
		}
		
		public function invokeDelay(delay:Number=10):void{
			_timer = new Timer(10);
			_timer.addEventListener(TimerEvent.TIMER, timerEventHandler);
			_timer.start();
		}
        
        private function timerEventHandler(event:TimerEvent):void{
            _timer.stop();
            _timer.removeEventListener(TimerEvent.TIMER, timerEventHandler);
            _timer = null;
			
			doInvoke();
		}
		
		private function doInvoke():void{
			const func:Function = _func;
			try{
				var args:Array = _args;
				if( args != null && args.length > 0 ){
					func.apply(null, args);
				} else {
					func.apply(null);
				}
			} catch( e:Error ){
				throw e;
			} finally {
				clear();
			}
        }
		
		private function clear():void{
			_frameCount = 0;
			_invokeFrame = 0;
			_func = null;
			_args = null;
		}
    }
}