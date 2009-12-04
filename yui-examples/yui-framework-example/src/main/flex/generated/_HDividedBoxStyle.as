
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;

[ExcludeClass]

public class _HDividedBoxStyle
{
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='mx.skins.BoxDividerSkin', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='787', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_mx_skins_BoxDividerSkin_21810309:Class;
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='mx.skins.cursor.HBoxDivider', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='789', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_mx_skins_cursor_HBoxDivider_152586014:Class;
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='mx.skins.cursor.VBoxDivider', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='791', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_mx_skins_cursor_VBoxDivider_610947752:Class;

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("HDividedBox");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("HDividedBox", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.dividerThickness = 3;
                this.dividerColor = 0x6f7777;
                this.dividerAffordance = 6;
                this.verticalDividerCursor = _embed_css_Assets_swf_mx_skins_cursor_VBoxDivider_610947752;
                this.dividerSkin = _embed_css_Assets_swf_mx_skins_BoxDividerSkin_21810309;
                this.horizontalDividerCursor = _embed_css_Assets_swf_mx_skins_cursor_HBoxDivider_152586014;
                this.dividerAlpha = 0.75;
                this.verticalGap = 10;
                this.horizontalGap = 10;
            };
        }
    }
}

}
