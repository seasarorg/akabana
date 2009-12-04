
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
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='CloseButtonUp', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='1493', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_CloseButtonUp_1119297958:Class;
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='CloseButtonOver', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='1492', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_CloseButtonOver_46808413:Class;
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='CloseButtonDown', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='1491', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_CloseButtonDown_418592307:Class;
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='CloseButtonDisabled', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='1490', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_CloseButtonDisabled_1282091771:Class;

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
                this.closeButtonDisabledSkin = _embed_css_Assets_swf_CloseButtonDisabled_1282091771;
                this.paddingTop = 4;
                this.dropShadowEnabled = true;
                this.backgroundColor = 0xffffff;
                this.closeButtonOverSkin = _embed_css_Assets_swf_CloseButtonOver_46808413;
                this.closeButtonUpSkin = _embed_css_Assets_swf_CloseButtonUp_1119297958;
                this.closeButtonDownSkin = _embed_css_Assets_swf_CloseButtonDown_418592307;
                this.cornerRadius = 8;
                this.paddingLeft = 4;
                this.paddingBottom = 4;
                this.paddingRight = 4;
            };
        }
    }
}

}
