
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
import org.seasar.akabana.yui.framework.customizer.HelperCustomizer;
import org.seasar.akabana.yui.framework.customizer.ServiceCustomizer;
import org.seasar.akabana.yui.framework.customizer.EventHandlerCustomizer;
import org.seasar.akabana.yui.framework.customizer.ActionCustomizer;

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
                this.classNames = ["c1", "c2", "c3", "c4"];
                this.c2 = org.seasar.akabana.yui.framework.customizer.HelperCustomizer;
                this.c4 = org.seasar.akabana.yui.framework.customizer.EventHandlerCustomizer;
                this.c3 = org.seasar.akabana.yui.framework.customizer.ServiceCustomizer;
                this.c1 = org.seasar.akabana.yui.framework.customizer.ActionCustomizer;
            };
        }
    }
}

}
