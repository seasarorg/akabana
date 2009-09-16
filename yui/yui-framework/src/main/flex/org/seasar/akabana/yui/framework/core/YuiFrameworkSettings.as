package org.seasar.akabana.yui.framework.core
{
    import mx.core.IMXMLObject;
    
    import org.seasar.akabana.yui.framework.mixin.YuiFrameworkMixin;

    public class YuiFrameworkSettings implements IMXMLObject
    {
        {
            YuiFrameworkMixin;
        }
        
        public function YuiFrameworkSettings()
        {
        }

        public function initialized(document:Object, id:String):void
        {
        }
        
    }
}