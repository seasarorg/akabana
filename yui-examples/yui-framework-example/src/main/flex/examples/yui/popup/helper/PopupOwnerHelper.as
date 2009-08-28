package examples.yui.popup.helper
{
	import examples.yui.popup.view.PopupOwnerView;
	import examples.yui.popup.view.PopupView;
	
	import org.seasar.akabana.yui.framework.util.ViewPopUpUtil;
	
	public class PopupOwnerHelper
	{
		public var view:PopupOwnerView;
		
		public function popup():void{
			ViewPopUpUtil
			 .createPopUp(
			     "popup",
			     PopupView,
			     true,
			     view);
			     
			
		}

	}
}