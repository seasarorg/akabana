package org.seasar.akabana.yui.framework.message
{
    import mx.resources.ResourceManager;
    
    import org.seasar.akabana.yui.util.StringUtil;
    
    public class Messages {
        
        private static const RESOURCE_BUNDLE_MAP:Object = {};
        
        public static function getMessage( bundleName:String, resourceName:String,...parameters ):String{
            return substitute(
                        ResourceManager.getInstance().getString(bundleName,resourceName),
                        parameters
                    )
        }
        
        protected static function substitute(str:String, ... args):String{
            return StringUtil.substitute.apply( null, [str].concat( args ));
        }
    }
}