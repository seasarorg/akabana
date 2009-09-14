
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;

[ExcludeClass]

public class _DateFieldStyle
{
    [Embed(_resolvedSource='/Applications/Adobe Flex Builder 3 Plug-in/sdks/3.4.0/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', source='/Applications/Adobe Flex Builder 3 Plug-in/sdks/3.4.0/frameworks/libs/framework.swc$Assets.swf', _file='/Applications/Adobe Flex Builder 3 Plug-in/sdks/3.4.0/frameworks/libs/framework.swc$defaults.css', _line='605', symbol='openDateOver')]
    private static var _embed_css_Assets_swf_openDateOver_1787387628:Class;

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("DateField");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("DateField", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.upSkin = _embed_css_Assets_swf_openDateOver_1787387628;
                this.overSkin = _embed_css_Assets_swf_openDateOver_1787387628;
                this.downSkin = _embed_css_Assets_swf_openDateOver_1787387628;
                this.dateChooserStyleName = "dateFieldPopup";
                this.disabledSkin = _embed_css_Assets_swf_openDateOver_1787387628;
            };
        }
    }
}

}
