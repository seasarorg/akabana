package org.seasar.akabana.yui.mx.util
{
    import flash.display.DisplayObject;
    import flash.events.IEventDispatcher;
    import flash.utils.getTimer;
    
    import mx.core.IFlexDisplayObject;
    import mx.core.UIComponent;
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

            var popup_:UIComponent = PopUpManager.createPopUp(
                                        parent, 
                                        className, 
                                        modal,
                                        childList
                                        ) as UIComponent;

            if( popup_ is IEventDispatcher && 
                creationCompleteCallBack != null
            ){
                popup_.addEventListener(
                    FlexEvent.CREATION_COMPLETE,
                    function(event:FlexEvent):void{
                        var popup:UIComponent = event.target as UIComponent;
                        if( popup.descriptor != null ){                      
                            trace("P1",getTimer(),UIComponent(popup).descriptor);
                            popup.descriptor.properties[POPUP_OWNER] = parent;           
                        } else {
                            trace("P2",getTimer(),UIComponent(popup).descriptor);
                        }
                        creationCompleteCallBack.call();
                    },
                    false,
                    0,
                    true
                );
            }
            
            return popup_;
        }

//        function addPopUp(window:IFlexDisplayObject,
//                parent:DisplayObject,
//                modal:Boolean = false,
//                childList:String = null):void;
//
//        function centerPopUp(popUp:IFlexDisplayObject):void;
//
        public static function removePopUp(popUp:IFlexDisplayObject):void{
            if( popUp is UIComponent){              
                if( UIComponent(popUp).descriptor != null ){
                    UIComponent(popUp).descriptor.properties[POPUP_OWNER] = null;
                    delete UIComponent(popUp).descriptor.properties[POPUP_OWNER];
                } else {
                    trace("D",getTimer(),UIComponent(popUp).descriptor);
                }
            }
            PopUpManager.removePopUp(popUp);
        }
//
//        function bringToFront(popUp:IFlexDisplayObject):void;

    }
}