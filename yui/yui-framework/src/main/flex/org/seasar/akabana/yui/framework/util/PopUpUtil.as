package org.seasar.akabana.yui.framework.util
{
    import flash.display.DisplayObject;
    import flash.events.Event;
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
    
    import org.seasar.akabana.yui.framework.YuiFrameworkGlobals;
    import org.seasar.akabana.yui.framework.core.YuiFrameworkContainer;
    
    public class PopUpUtil
    {
    	public static const POPUP_INFO:String = "__popUp_info";
    	
        public static const POPUP_OWNER:String = "popUpOwner";
        
        public static const RELATED_OWNER:String = "relatedOwner";
        
        public static const CALLBACK:String = "callback";
        
        public static function createPopUpView( viewName:String,
                                                popupClass:Class,
                                                modal:Boolean = false,
                                                center:Boolean = false,
                                                relatedOwner:UIComponent=null,
                                                data:Object=null
                                               ):IFlexDisplayObject{

            var window:Container = 
                PopUpUtil.createPopUp(
                    viewName,
                    YuiFrameworkGlobals.frameworkBridge.application as UIComponent,
                    popupClass,
                    modal,
                    center,
                    null,
                    relatedOwner,
                    data
                    ) as Container;       
            return window;
        }
        
        public static function removePopUpView(popUp:IFlexDisplayObject):void{
            if( popUp is Container ){
                var popUpContainer:Container = popUp as Container;
            	YuiFrameworkContainer
            	    .yuicontainer.uncustomizeComponent(
            	        popUpContainer,
            	        PopUpUtil.lookupRelatedOwner(popUpContainer)
            	        );
            	PopUpUtil.removePopUp(popUp);
            }
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

        private static function createPopUp(name:String,
        									parent:DisplayObject,
                                            className:Class,
                                            modal:Boolean = false,
                                            center:Boolean = false,
                                            childList:String = null,
                                            relatedOwner:UIComponent=null,
                                            data:Object=null
                                            ):IFlexDisplayObject{

            var window:IUIComponent = new className();
			window.name = name;
            window.addEventListener(
                FlexEvent.INITIALIZE,
                function(event:FlexEvent):void{
                	if( event.eventPhase == EventPhase.AT_TARGET ){
	                	IEventDispatcher(event.target).removeEventListener(FlexEvent.INITIALIZE,arguments.callee);
	                    var descriptor:UIComponentDescriptor = (event.target as UIComponent).mx_internal::_documentDescriptor;
	                    
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
                
            if( center ){
                window.addEventListener(
                    FlexEvent.CREATION_COMPLETE,
                    onPopupCreationForMoveCenterCompleteHandler,
                    false,
                    int.MAX_VALUE,
                    true
                );
            }   
            if( window is Container ){
                ( window as Container)
                    .addEventListener(
                            FlexEvent.CREATION_COMPLETE,
                            onPopupCreationCompleteHandler,
                            false,
                            0,
                            true
                        );
                ( window as Container).data = data; 
            }
                                    
            return window;
        }

        private static function removePopUp(popUp:IFlexDisplayObject):void{
            if( popUp is UIComponent){
        		var properties_:Object = UIComponentUtil.getDocumentProperties(UIComponent(popUp));
                if( properties_ != null ){
                	if( properties_.hasOwnProperty(POPUP_INFO)){
	                    properties_[POPUP_INFO][POPUP_OWNER] = null;
	                    delete properties_[POPUP_INFO][POPUP_OWNER];
	                    
	                    properties_[POPUP_INFO][RELATED_OWNER] = null;
	                    delete properties_[POPUP_INFO][RELATED_OWNER];
	                    
	                    properties_[POPUP_INFO] = null;
	                    delete properties_[POPUP_INFO];
                    }
                }
            }
            PopUpManager.removePopUp(popUp);
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
        
        private static function onPopupCreationForMoveCenterCompleteHandler(event:Event):void{
        	var window:UIComponent = event.target as UIComponent;
        	
            window.removeEventListener(
                FlexEvent.CREATION_COMPLETE,
                onPopupCreationForMoveCenterCompleteHandler,
                false
            );
            PopUpManager.centerPopUp(window);
        }
        
        private static function creationCompleteCallBack(event:FlexEvent):void{
            var popup:Container = event.target as Container;
            YuiFrameworkContainer.yuicontainer.customizeComponent(popup as Container,PopUpUtil.lookupRelatedOwner(popup));
        }
    }
}