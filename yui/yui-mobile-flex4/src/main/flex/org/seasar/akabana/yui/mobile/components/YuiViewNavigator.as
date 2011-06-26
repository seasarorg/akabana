package org.seasar.akabana.yui.mobile.components
{
    import flash.display.DisplayObjectContainer;
    
    import mx.core.IVisualElement;
    import mx.events.FlexEvent;
    
    import org.seasar.akabana.yui.framework.core.YuiFrameworkController;
    
    import spark.components.View;
    import spark.components.ViewNavigator;
    
    public class YuiViewNavigator extends ViewNavigator
    {
        public var monitring:Boolean = false;
        public function YuiViewNavigator()
        {
            super();
        }
        
        public override function addElement(element:IVisualElement):IVisualElement{
            var view:View = super.addElement(element) as View;
            if( monitring ){
                if( view.initialized ){
                    YuiFrameworkController.getInstance().customizeView(view as DisplayObjectContainer);
                } else {
                    view.addEventListener(FlexEvent.CREATION_COMPLETE,view_initializeHandler);
                }
            }
            return view;
        }
        
        protected function view_initializeHandler(event:FlexEvent):void
        {
            var view:View = event.target as View;
            view.removeEventListener(FlexEvent.INITIALIZE,view_initializeHandler);
            YuiFrameworkController.getInstance().customizeView(view as DisplayObjectContainer);
        }
        
        public override function removeElement(element:IVisualElement):IVisualElement{
            var view:IVisualElement = super.removeElement(element);
            if( monitring ){
                YuiFrameworkController.getInstance().uncustomizeView(view as DisplayObjectContainer);
            }
            return view;
        }
    }
}