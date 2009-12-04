
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
import org.seasar.akabana.yui.framework.customizer.ActionCustomizer;
import org.seasar.akabana.yui.framework.customizer.EventHandlerCustomizer;

[ExcludeClass]

public class _customizersStyle
{

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".customizers");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".customizers", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.c1 = org.seasar.akabana.yui.framework.customizer.ActionCustomizer;
                this.c2 = org.seasar.akabana.yui.framework.customizer.EventHandlerCustomizer;
                this.classNames = ["c1", "c2"];
            };
        }
    }
}

}
