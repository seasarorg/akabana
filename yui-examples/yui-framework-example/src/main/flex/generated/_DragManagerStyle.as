
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
import mx.skins.halo.DefaultDragImage;

[ExcludeClass]

public class _DragManagerStyle
{
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='mx.skins.cursor.DragCopy', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='651', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_mx_skins_cursor_DragCopy_1414651237:Class;
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='mx.skins.cursor.DragLink', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='653', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_mx_skins_cursor_DragLink_1414913268:Class;
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='mx.skins.cursor.DragReject', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='655', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_mx_skins_cursor_DragReject_1928363681:Class;
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='mx.skins.cursor.DragMove', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='654', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_mx_skins_cursor_DragMove_1414901961:Class;

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("DragManager");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("DragManager", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.copyCursor = _embed_css_Assets_swf_mx_skins_cursor_DragCopy_1414651237;
                this.moveCursor = _embed_css_Assets_swf_mx_skins_cursor_DragMove_1414901961;
                this.rejectCursor = _embed_css_Assets_swf_mx_skins_cursor_DragReject_1928363681;
                this.linkCursor = _embed_css_Assets_swf_mx_skins_cursor_DragLink_1414913268;
                this.defaultDragImageSkin = mx.skins.halo.DefaultDragImage;
            };
        }
    }
}

}
