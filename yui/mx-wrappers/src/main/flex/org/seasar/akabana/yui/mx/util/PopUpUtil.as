package org.seasar.akabana.yui.mx.util
{
    import flash.display.DisplayObject;
    import flash.events.EventPhase;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    
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
    	public static const POPUP_INFO:String = "__popUp_info";
    	
        public static const POPUP_OWNER:String = "popUpOwner";
        
        public static const RELATED_OWNER:String = "relatedOwner";
        
        public static const CALLBACK:String = "callback";
        
        public static function createPopUp(name:String,
        									parent:DisplayObject,
                                            className:Class,
                                            modal:Boolean = false,
                                            childList:String = null,
                                            creationCompleteCallBack:Function=null,
                                            relatedOwner:UIComponent=null
                                            ):IFlexDisplayObject{

            var window:IUIComponent = new className();
			window.name = name;
            window.addEventListener(
                FlexEvent.INITIALIZE,
                function(event:FlexEvent):void{
                	if( event.eventPhase == EventPhase.AT_TARGET ){
	                	IEventDispatcher(event.target).removeEventListener(FlexEvent.INITIALIZE,arguments.callee);
	                    var descriptor:UIComponentDescriptor = UIComponent(event.target).mx_internal::_documentDescriptor;
	                    
	                    var popUpinfo_:Dictionary = new Dictionary(true);
	                    popUpinfo_[POPUP_OWNER] = parent; 
	                    popUpinfo_[RELATED_OWNER] = relatedOwner; 
	                    popUpinfo_[CALLBACK] = creationCompleteCallBack; 
	                    
	                    descriptor.properties[POPUP_INFO] = popUpinfo_;
                 	}
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
                );
                
            if( window is IEventDispatcher && 
                creationCompleteCallBack != null
            ){
                window.addEventListener(
                    FlexEvent.CREATION_COMPLETE,
                    onPopupCreationCompleteHandler,
                    false,
                    int.MAX_VALUE,
                    true
                );
            }
            
            return window;
        }

        public static function removePopUp(popUp:IFlexDisplayObject):void{
            if( popUp is UIComponent){
        		var properties_:Object = UIComponentUtil.getDocumentProperties(UIComponent(popUp));
                if( properties_ != null ){
                    properties_[POPUP_INFO][POPUP_OWNER] = null;
                    delete properties_[POPUP_INFO][POPUP_OWNER];
                    
                    properties_[POPUP_INFO][RELATED_OWNER] = null;
                    delete properties_[POPUP_INFO][RELATED_OWNER];
                    
                    properties_[POPUP_INFO] = null;
                    delete properties_[POPUP_INFO];
                }
            }
            PopUpManager.removePopUp(popUp);
        }
        
        public static function lookupPopupOwner( popUp:Container ):Container{
            var result:Container = null;
        	var properties_:Object = UIComponentUtil.getDocumentProperties(UIComponent(popUp));
            if( properties_.hasOwnProperty(POPUP_INFO)){
            	result = properties_[POPUP_INFO][POPUP_OWNER];
            }

            return result;
        }

        public static function lookupRelatedOwner( popUp:Container ):Container{
        	var result:Container = null;
        	var properties_:Object = UIComponentUtil.getDocumentProperties(UIComponent(popUp));
            if( properties_.hasOwnProperty(POPUP_INFO)){
            	result = properties_[POPUP_INFO][RELATED_OWNER];
            }
            
            return result;
        }
        
        private static function onPopupCreationCompleteHandler(event:FlexEvent):void{
        	if( event.eventPhase == EventPhase.AT_TARGET ){
        		IEventDispatcher(event.target).removeEventListener(FlexEvent.CREATION_COMPLETE,arguments.callee);
            	lookupCallBack(event.target as Container).apply(null,[event]);
         	}
        }   

        private static function lookupCallBack( popUp:Container ):Function{
        	var result:Function = null;
        	var properties_:Object = UIComponentUtil.getDocumentProperties(UIComponent(popUp));
            if( properties_.hasOwnProperty(POPUP_INFO)){
            	result = properties_[POPUP_INFO][CALLBACK];
            }
            delete properties_[POPUP_INFO][CALLBACK];
            
            return result;
        }
    }
}