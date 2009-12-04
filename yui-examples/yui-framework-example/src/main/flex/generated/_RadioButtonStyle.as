
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
import mx.skins.halo.RadioButtonIcon;

[ExcludeClass]

public class _RadioButtonStyle
{

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("RadioButton");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("RadioButton", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.downSkin = null;
                this.iconColor = 0x2b333c;
                this.cornerRadius = 7;
                this.selectedDownIcon = null;
                this.selectedUpSkin = null;
                this.overIcon = null;
                this.skin = null;
                this.upSkin = null;
                this.selectedDownSkin = null;
                this.selectedOverIcon = null;
                this.selectedDisabledIcon = null;
                this.textAlign = "left";
                this.horizontalGap = 5;
                this.downIcon = null;
                this.icon = mx.skins.halo.RadioButtonIcon;
                this.overSkin = null;
                this.disabledIcon = null;
                this.selectedDisabledSkin = null;
                this.upIcon = null;
                this.paddingLeft = 0;
                this.paddingRight = 0;
                this.fontWeight = "normal";
                this.selectedUpIcon = null;
                this.disabledSkin = null;
                this.selectedOverSkin = null;
            };
        }
    }
}

}
