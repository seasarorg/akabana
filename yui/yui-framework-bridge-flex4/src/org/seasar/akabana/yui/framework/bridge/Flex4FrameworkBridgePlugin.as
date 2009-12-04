package org.seasar.akabana.yui.framework.bridge
{
    import flash.utils.describeType;
    
    import mx.core.UIComponent;
    import mx.managers.ISystemManager;
    
    import spark.components.Application;
    import spark.components.Group;
    import spark.components.SkinnableContainer;
    
    public class Flex4FrameworkBridgePlugin implements IFrameworkBridgePlugin
    {
        protected var _application:Application;
        
        public function get application():UIComponent{
            return _application;
        }
		
		public function set application(value:UIComponent):void{
			_application = value as Application;
		}
        
        public function get parameters():Object{
            return _application.parameters;
        }
        
        public function get systemManager():ISystemManager{
            return _application.systemManager;
        }
        
        public function isApplication(component:Object):Boolean{
            return component is Application;
        }
        
        public function isContainer(component:Object):Boolean{
            return component is SkinnableContainer || component is Group;
        }
    }
}