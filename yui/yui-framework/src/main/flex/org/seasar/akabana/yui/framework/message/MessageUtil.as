package org.seasar.akabana.yui.framework.message
{
    import mx.resources.ResourceManager;
    import mx.utils.StringUtil;
    
    public class MessageUtil
    {
        public static function getMessage(bundleName:String, resourceName:String,...parameters):String{
            return StringUtil.substitute(
                ResourceManager.getInstance().getString(bundleName,resourceName),
                parameters
            );
        }

    }
}