
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;

[ExcludeClass]

public class _TitleWindowStyle
{
    [Embed(_pathsep='true', _resolvedSource='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', source='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$Assets.swf', _file='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$defaults.css', _line='1492', symbol='CloseButtonOver')]
    private static var _embed_css_Assets_swf_CloseButtonOver_1014568437:Class;
    [Embed(_pathsep='true', _resolvedSource='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', source='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$Assets.swf', _file='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$defaults.css', _line='1493', symbol='CloseButtonUp')]
    private static var _embed_css_Assets_swf_CloseButtonUp_2087977358:Class;
    [Embed(_pathsep='true', _resolvedSource='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', source='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$Assets.swf', _file='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$defaults.css', _line='1491', symbol='CloseButtonDown')]
    private static var _embed_css_Assets_swf_CloseButtonDown_909122587:Class;
    [Embed(_pathsep='true', _resolvedSource='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', source='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$Assets.swf', _file='D:/products/adobe/flex/flex_sdk_3.5.0.12683_air25/frameworks/libs/framework.swc$defaults.css', _line='1490', symbol='CloseButtonDisabled')]
    private static var _embed_css_Assets_swf_CloseButtonDisabled_1400160979:Class;

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("TitleWindow");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("TitleWindow", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.paddingTop = 4;
                this.paddingLeft = 4;
                this.cornerRadius = 8;
                this.paddingRight = 4;
                this.dropShadowEnabled = true;
                this.closeButtonDownSkin = _embed_css_Assets_swf_CloseButtonDown_909122587;
                this.closeButtonOverSkin = _embed_css_Assets_swf_CloseButtonOver_1014568437;
                this.closeButtonUpSkin = _embed_css_Assets_swf_CloseButtonUp_2087977358;
                this.closeButtonDisabledSkin = _embed_css_Assets_swf_CloseButtonDisabled_1400160979;
                this.paddingBottom = 4;
                this.backgroundColor = 0xffffff;
            };
        }
    }
}

}
