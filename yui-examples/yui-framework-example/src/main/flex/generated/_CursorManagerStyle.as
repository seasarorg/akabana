
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
import mx.skins.halo.BusyCursor;

[ExcludeClass]

public class _CursorManagerStyle
{
    [Embed(_pathsep='true', _resolvedSource='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', source='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$Assets.swf', _file='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$defaults.css', _line='509', symbol='mx.skins.cursor.BusyCursor')]
    private static var _embed_css_Assets_swf_mx_skins_cursor_BusyCursor_2026704187:Class;

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("CursorManager");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("CursorManager", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.busyCursor = mx.skins.halo.BusyCursor;
                this.busyCursorBackground = _embed_css_Assets_swf_mx_skins_cursor_BusyCursor_2026704187;
            };
        }
    }
}

}
