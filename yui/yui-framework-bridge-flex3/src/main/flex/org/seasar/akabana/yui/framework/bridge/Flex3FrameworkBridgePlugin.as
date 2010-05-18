package org.seasar.akabana.yui.framework.bridge
{
    import mx.core.Application;
    import mx.core.Container;
    import mx.core.UIComponent;
    import mx.managers.ISystemManager;
    
    public class Flex3FrameworkBridgePlugin implements IFrameworkBridgePlugin
    {
        private static const ROOT_VIEW:String = "rootView";
        
        protected var _application:Application;
        
        public function get application():UIComponent{
            return _application;
        }
        
        public function get parameters():Object{
            return _application.parameters;
        }
        
        public function set application(value:UIComponent):void{
            _application = value as Application;
        }
        
        public function get systemManager():ISystemManager{
            return _application.systemManager;
        }
        
        public function get rootView():UIComponent{
            var result:UIComponent = null;
            if( _application.hasOwnProperty(ROOT_VIEW)){
             	result = _application[ ROOT_VIEW ] as UIComponent;
            }
            if( result == null ){
                if( application.numChildren > 0 ){
                    result = application.getChildAt(0) as UIComponent;
                }
            }
            return result;      	
        }
        
        public function isApplication(component:Object):Boolean{
            return component is Application;
        }
        
        public function isContainer(component:Object):Boolean{
            return component is Container;
        }
    }
}