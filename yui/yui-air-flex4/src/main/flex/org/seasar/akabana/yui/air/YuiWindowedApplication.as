package org.seasar.akabana.yui.air
{
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.events.AIREvent;
	
	import org.seasar.akabana.yui.framework.core.YuiFrameworkSettings;
	import org.seasar.akabana.yui.framework.core.YuiFrameworkContainer;
	import org.seasar.akabana.yui.framework.error.YuiFrameworkContainerError;
	
	import spark.components.WindowedApplication;
	
	[Style(name="rootViewClass", type="Class")]
	public class YuiWindowedApplication extends WindowedApplication
	{
		private var _setting:YuiFrameworkSettings;
		
		public function get setting():YuiFrameworkSettings{
			return _setting;
		}
		
		private var _rootView:UIComponent;
		
		public function get rootView():UIComponent{
			return _rootView;
		}
		
		public function YuiWindowedApplication()
		{
			super();
			_setting = new YuiFrameworkSettings();
			addEventListener(AIREvent.WINDOW_COMPLETE,onWindowCompleteHandler);
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