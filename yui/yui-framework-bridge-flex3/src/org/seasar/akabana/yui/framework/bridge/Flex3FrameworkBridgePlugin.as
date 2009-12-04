package org.seasar.akabana.yui.framework.bridge
{
    import flash.net.registerClassAlias;
    
    import mx.core.Application;
    import mx.core.Container;
    import mx.core.UIComponent;
    import mx.managers.ISystemManager;
    
    public class Flex3FrameworkBridgePlugin implements IFrameworkBridgePlugin
    {
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
        
        public function isApplication(component:Object):Boolean{
            return component is Application;
        }
        
        public function isContainer(component:Object):Boolean{
            return component is Container;
        }
    }
}