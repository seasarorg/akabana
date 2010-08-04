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
package org.seasar.akabana.yui.air.core
{
    import flash.events.Event;
    import flash.events.EventPhase;
    
    import mx.core.UIComponent;
    import mx.events.AIREvent;
    import mx.events.CloseEvent;
    import mx.managers.ISystemManager;
    
    import org.seasar.akabana.yui.framework.core.YuiFrameworkContainer;
    import org.seasar.akabana.yui.framework.error.YuiFrameworkContainerError;
    
    import spark.components.Window;
	
	[Style(name="rootViewClass", type="Class")]
    public class Window extends spark.components.Window{
		
		private var _rootView:UIComponent;
		
		public function get rootView():UIComponent{
			return _rootView;
		}
		
		public function Window(){
			super();
			addEventListener(AIREvent.WINDOW_COMPLETE,onWindowCompleteHandler);
		}
		
        public override function set systemManager(value:ISystemManager):void{
            if( super.systemManager != value ){
                super.systemManager = value;
                YuiFrameworkContainer.yuicontainer.addExternalSystemManager(value);
            }
        }
		
		private function onWindowCompleteHandler(event:AIREvent):void{
			_rootView.visible = true;
			addEventListener(Event.CLOSE,onCloseHandler);
			addEventListener(Event.CLOSING,onClosingHandler);
		}
		
		private function onCloseHandler(event:Event):void{
			var e:Event = new Event(event.type, false, false);
			_rootView.dispatchEvent(e);
			YuiFrameworkContainer.yuicontainer.removeExternalSystemManager(systemManager);
		}

		private function onClosingHandler(event:Event):void{
			var e:Event = new Event(event.type, false, true);
			_rootView.dispatchEvent(e);
			if( e.isDefaultPrevented() ){
				event.preventDefault();			
			}
		}
		
		protected override function createChildren():void{
			super.createChildren();
			
			createRootView();
		}
		
		protected function createRootView():void{
			var viewClass:Class = getStyle("rootViewClass") as Class;
			
			if( viewClass == null ){
				throw new YuiFrameworkContainerError("rootViewClass style is needed.");
			} else {
				_rootView = new viewClass();
				_rootView.name = "rootView";
				_rootView.setVisible(false,true);
				addElement(_rootView);
			}
		}
    }
}