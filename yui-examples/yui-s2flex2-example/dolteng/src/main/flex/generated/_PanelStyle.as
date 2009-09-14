
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
import mx.skins.halo.TitleBackground;
import mx.skins.halo.PanelSkin;

[ExcludeClass]

public class _PanelStyle
{

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("Panel");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Panel", style, false);
            var effects:Array = style.mx_internal::effects;
            if (!effects)
            {
                effects = style.mx_internal::effects = new Array();
            }
            effects.push("resizeEndEffect");
            effects.push("resizeStartEffect");
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.dropShadowEnabled = false;
                this.borderStyle = "default";
                this.resizeEndEffect = "Dissolve";
                this.paddingTop = 0;
                this.footerColors = [0xffffff, 0xffffff];
                this.titleStyleName = "windowStyles";
                this.highlightAlphas = [0, 0];
                this.cornerRadius = 0;
                this.borderThicknessLeft = 10;
                this.headerHeight = 30;
                this.borderThickness = 0;
                this.borderColor = 0xffffff;
                this.paddingLeft = 0;
                this.roundedBottomCorners = false;
                this.resizeStartEffect = "Dissolve";
                this.borderSkin = mx.skins.halo.PanelSkin;
                this.backgroundAlpha = 1;
                this.paddingBottom = 0;
                this.borderAlpha = 1;
                this.statusStyleName = "windowStatus";
                this.borderThicknessRight = 0;
                this.paddingRight = 0;
                this.headerColors = [0xffffff, 0xffffff];
                this.titleBackgroundSkin = mx.skins.halo.TitleBackground;
                this.borderThicknessTop = 2;
                this.backgroundColor = 0xffffff;
            };
        }
    }
}

}
