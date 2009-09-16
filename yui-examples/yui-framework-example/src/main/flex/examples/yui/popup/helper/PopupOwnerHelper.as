package examples.yui.popup.helper
{
	import examples.yui.popup.view.PopupOwnerView;
	import examples.yui.popup.view.PopupView;
	
	import org.seasar.akabana.yui.framework.util.PopUpUtil;
	
	public class PopupOwnerHelper
	{
		public var view:PopupOwnerView;
		
		public function popup():void{
			PopUpUtil
			 .createPopUpView(
			     "popup",
			     PopupView,
			     true,
			     true,
			     view,
			     null
			     );
		}
        
        public function hide(popup:PopupView):void
        {
            PopUpUtil.removePopUp(popup);
        }

	}
}