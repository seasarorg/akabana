package org.seasar.akabana.yui.framework.bridge
{
    import flash.errors.IllegalOperationError;
    
    import mx.core.UIComponent;
    import mx.managers.ISystemManager;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.StyleManager;
    
    import org.seasar.akabana.yui.core.yui_internal;
    
    public class FrameworkBridge
    {
        public static function initialize():FrameworkBridge{
            var result:FrameworkBridge = new FrameworkBridge();
            var frameworkBridgeCss:CSSStyleDeclaration = StyleManager.getStyleDeclaration("org.seasar.akabana.yui.framework.core.YuiFrameworkSettings");
			if( frameworkBridgeCss == null ){
				frameworkBridgeCss = StyleManager.getStyleDeclaration("YuiFrameworkSettings");
			    if( frameworkBridgeCss == null ){
			        throw new IllegalOperationError("No Framework BridgePlugin");
			    }
			}
			var pluginClass:Class = frameworkBridgeCss.getStyle("frameworkBridgePlugin");            
            result.frameworkBridgePlugin = new pluginClass();     
            return result;
        }
        
        protected var frameworkBridgePlugin:IFrameworkBridgePlugin;        
        
        public function get application():UIComponent{
            return frameworkBridgePlugin.application;
        }
        
        public function get parameters():Object{
            return frameworkBridgePlugin.parameters;
        }
        
        yui_internal function set application(value:UIComponent):void{
            frameworkBridgePlugin.application = value;
        }
        
        public function get systemManager():ISystemManager{
            return frameworkBridgePlugin.systemManager;
        }
        
        public function isApplication(application:Object):Boolean{
            return frameworkBridgePlugin.isApplication(application);
        }
        
        public function isContainer(component:Object):Boolean{
            return frameworkBridgePlugin.isContainer(component);
        }      
        
    }
}