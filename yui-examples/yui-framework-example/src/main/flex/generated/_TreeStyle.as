
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;

[ExcludeClass]

public class _TreeStyle
{
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='TreeFolderOpen', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='1554', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_TreeFolderOpen_1595250059:Class;
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='TreeFolderClosed', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='1553', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_TreeFolderClosed_247700071:Class;
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='TreeNodeIcon', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='1550', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_TreeNodeIcon_65088898:Class;
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='TreeDisclosureOpen', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='1552', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_TreeDisclosureOpen_618897546:Class;
    [Embed(_resolvedSource='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', symbol='TreeDisclosureClosed', source='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='1551', _pathsep='true', _file='D:/products/adobe/flex/flex_sdk_3.4.0.9271/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_TreeDisclosureClosed_1570962728:Class;

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("Tree");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Tree", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.disclosureOpenIcon = _embed_css_Assets_swf_TreeDisclosureOpen_618897546;
                this.folderClosedIcon = _embed_css_Assets_swf_TreeFolderClosed_247700071;
                this.folderOpenIcon = _embed_css_Assets_swf_TreeFolderOpen_1595250059;
                this.disclosureClosedIcon = _embed_css_Assets_swf_TreeDisclosureClosed_1570962728;
                this.verticalAlign = "middle";
                this.defaultLeafIcon = _embed_css_Assets_swf_TreeNodeIcon_65088898;
                this.paddingLeft = 2;
                this.paddingRight = 0;
            };
        }
    }
}

}
