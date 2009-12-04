package org.seasar.akabana.yui.framework
{
    import org.seasar.akabana.yui.core.yui_internal;
    import org.seasar.akabana.yui.framework.bridge.FrameworkBridge;
    import org.seasar.akabana.yui.framework.convention.NamingConvention;
    
    public class YuiFrameworkGlobals
    {
        protected static var _frameworkBridge:FrameworkBridge;
        
        public static function get frameworkBridge():FrameworkBridge{
            return _frameworkBridge;
        }

        yui_internal static function set frameworkBridge(value:FrameworkBridge):void{
            _frameworkBridge = value;
        }
		
		protected static var _namingConvention:NamingConvention;
		
		public static function get namingConvention():NamingConvention{
			return _namingConvention;
		}
		
		yui_internal static function set namingConvention( value:NamingConvention ):void{
			_namingConvention = value;
		}
    }
}