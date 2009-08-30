package org.seasar.akabana.yui.framework.util
{
    import flash.display.DisplayObject;
    
    import mx.core.Application;
    import mx.core.Container;
    import mx.core.IFlexDisplayObject;
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import org.seasar.akabana.yui.framework.core.YuiFrameworkContainer;
    
    public class ViewPopUpUtil
    {
        public static function createPopUp( viewName:String,
                                            className:Class,
                                            modal:Boolean = false,
                                            center:Boolean = false,
                                            relatedOwner:UIComponent=null
                                           ):IFlexDisplayObject{

            var window:IFlexDisplayObject = 
                PopUpUtil.createPopUp(
                    viewName,
                    Application.application as DisplayObject,
                    className,
                    modal,
                    center,
                    null,
                    creationCompleteCallBack,
                    relatedOwner
                    );       
            return window;
        }
        
        public static function removePopUp(popUp:IFlexDisplayObject):void{
        	YuiFrameworkContainer.yuicontainer.uncustomizeComponent(popUp as Container,PopUpUtil.lookupRelatedOwner(popUp as Container));
        	PopUpUtil.removePopUp(popUp);
        }
        
        private static function creationCompleteCallBack(event:FlexEvent):void{
            var popup:Container = event.target as Container;
            YuiFrameworkContainer.yuicontainer.customizeComponent(popup as Container,PopUpUtil.lookupRelatedOwner(popup));
        }
    }
}