package org.seasar.akabana.yui.framework.util
{
    import flash.display.DisplayObject;
    
    import mx.core.Container;
    import mx.core.IFlexDisplayObject;
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    
    import org.seasar.akabana.yui.core.yui_internal;
    import org.seasar.akabana.yui.framework.core.YuiFrameworkContainer;
    import org.seasar.akabana.yui.framework.customizer.EventHandlerCustomizer;
    import org.seasar.akabana.yui.mx.util.PopUpUtil;
    
    use namespace yui_internal;
    
    public class ViewPopUpUtil
    {
    	private static var customizer:EventHandlerCustomizer = new EventHandlerCustomizer();
    	
        public static function createPopUp(name:String,
                                           parent:DisplayObject,
                                           className:Class,
                                           modal:Boolean = false,
                                           childList:String = null,
                                           relatedOwner:UIComponent=null
                                           ):IFlexDisplayObject{

            var window:IFlexDisplayObject = PopUpUtil.createPopUp(name,parent,className,modal,childList,creationCompleteCallBack,relatedOwner);            
            return window;
        }
        
        public static function removePopUp(popUp:IFlexDisplayObject):void{
            customizer.namingConvention = YuiFrameworkContainer.yuicontainer.namingConvention;
        	customizer.uncustomizeComponent(popUp as UIComponent,PopUpUtil.lookupRelatedOwner(popUp as Container));
        	PopUpUtil.removePopUp(popUp);
        }        
        
        private static function creationCompleteCallBack(event:FlexEvent):void{
            customizer.namingConvention = YuiFrameworkContainer.yuicontainer.namingConvention;
            var popup:Container = event.target as Container;
            customizer.customizeComponent(popup,PopUpUtil.lookupRelatedOwner(popup));
        }
    }
}