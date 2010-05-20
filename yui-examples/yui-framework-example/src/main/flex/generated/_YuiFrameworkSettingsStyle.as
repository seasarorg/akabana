
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
import org.seasar.akabana.yui.framework.bridge.Flex3FrameworkBridgePlugin;
import org.seasar.akabana.yui.framework.convention.Flex3NamingConvention;

[ExcludeClass]

public class _YuiFrameworkSettingsStyle
{

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("YuiFrameworkSettings");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("YuiFrameworkSettings", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.frameworkBridgePlugin = org.seasar.akabana.yui.framework.bridge.Flex3FrameworkBridgePlugin;
                this.namingConventionClass = org.seasar.akabana.yui.framework.convention.Flex3NamingConvention;
            };
        }
    }
}

}
