package org.seasar.akabana.yui.mx.util
{
    import flash.display.DisplayObject;
    import flash.events.IEventDispatcher;
    
    import mx.core.Container;
    import mx.core.IFlexDisplayObject;
    import mx.core.IUIComponent;
    import mx.core.UIComponent;
    import mx.core.UIComponentDescriptor;
    import mx.core.mx_internal;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    public class PopUpUtil
    {
        public static const POPUP_OWNER:String = "popupOwner";
        
        public static function createPopUp(parent:DisplayObject,
                                            className:Class,
                                            modal:Boolean = false,
                                            childList:String = null,
                                            creationCompleteCallBack:Function=null
                                            ):IFlexDisplayObject{

            var window:IUIComponent = new className();

            window.addEventListener(
                FlexEvent.INITIALIZE,
                function(event:FlexEvent):void{
                    var descriptor:UIComponentDescriptor = 
                        UIComponent(event.target).mx_internal::_documentDescriptor;
                    descriptor.properties[POPUP_OWNER] = parent; 
                },
                false,
                int.MAX_VALUE,
                true
            );
                
            PopUpManager.addPopUp(
                window,
                parent, 
                modal,
                childList
                ) as UIComponent;
                
            if( window is IEventDispatcher && 
                creationCompleteCallBack != null
            ){

                window.addEventListener(
                    FlexEvent.CREATION_COMPLETE,
                    function(event:FlexEvent):void{
                        creationCompleteCallBack.call();
                    },
                    false,
                    int.MAX_VALUE,
                    true
                );
            }
            
            return window;
        }

        public static function removePopUp(popUp:IFlexDisplayObject):void{
            if( popUp is UIComponent){
                var documentDescriptor:UIComponentDescriptor = UIComponent(popUp).mx_internal::_documentDescriptor;
                if( documentDescriptor != null ){
                    if( documentDescriptor.properties != null ){
                        documentDescriptor.properties[POPUP_OWNER] = null;
                        delete documentDescriptor.properties[POPUP_OWNER];
                    }
                }
            }
            PopUpManager.removePopUp(popUp);
        }
        
        public static function lookupPopupOwner( popup:Container ):Container{
            var descriptor:UIComponentDescriptor = popup.mx_internal::_documentDescriptor;
            var popupOwner:Container = descriptor.properties[POPUP_OWNER];
            
            return popupOwner;
        }
    }
}