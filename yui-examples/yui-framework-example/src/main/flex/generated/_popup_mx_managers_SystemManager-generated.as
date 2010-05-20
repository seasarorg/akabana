package
{

import flash.display.LoaderInfo;
import flash.text.Font;
import flash.text.TextFormat;
import flash.system.ApplicationDomain;
import flash.system.Security;
import flash.utils.getDefinitionByName;
import flash.utils.Dictionary;
import mx.core.IFlexModule;
import mx.core.IFlexModuleFactory;
import mx.core.FlexVersion;
import mx.managers.SystemManager;

[ResourceBundle("application")]
[ResourceBundle("containers")]
[ResourceBundle("conventions")]
[ResourceBundle("core")]
[ResourceBundle("effects")]
[ResourceBundle("errors")]
[ResourceBundle("log4yui")]
[ResourceBundle("messages")]
[ResourceBundle("skins")]
[ResourceBundle("styles")]
[ResourceBundle("yui_framework")]
/**
 *  @private
 */
[ExcludeClass]
public class _popup_mx_managers_SystemManager
    extends mx.managers.SystemManager
    implements IFlexModuleFactory
{
    public function _popup_mx_managers_SystemManager()
    {
        FlexVersion.compatibilityVersionString = "3.0.0";
        super();
    }

    override     public function create(... params):Object
    {
        if (params.length > 0 && !(params[0] is String))
            return super.create.apply(this, params);

        var mainClassName:String = params.length == 0 ? "popup" : String(params[0]);
        var mainClass:Class = Class(getDefinitionByName(mainClassName));
        if (!mainClass)
            return null;

        var instance:Object = new mainClass();
        if (instance is IFlexModule)
            (IFlexModule(instance)).moduleFactory = this;
        return instance;
    }

    override    public function info():Object
    {
        return {
            compiledLocales: [ "ja_JP" ],
            compiledResourceBundleNames: [ "application", "containers", "conventions", "core", "effects", "errors", "log4yui", "messages", "skins", "styles", "yui_framework" ],
            currentDomain: ApplicationDomain.currentDomain,
            layout: "absolute",
            mainClassName: "popup",
            mixins: [ "_popup_FlexInit", "_alertButtonStyleStyle", "_ControlBarStyle", "_ScrollBarStyle", "_activeTabStyleStyle", "_textAreaHScrollBarStyleStyle", "_ToolTipStyle", "_DragManagerStyle", "_comboDropdownStyle", "_textAreaVScrollBarStyleStyle", "_YuiFrameworkSettingsStyle", "_ContainerStyle", "_linkButtonStyleStyle", "_globalStyle", "_windowStatusStyle", "_windowStylesStyle", "_PanelStyle", "_activeButtonStyleStyle", "_errorTipStyle", "_richTextEditorTextAreaStyleStyle", "_CursorManagerStyle", "_todayStyleStyle", "_dateFieldPopupStyle", "_plainStyle", "_dataGridStylesStyle", "_customizersStyle", "_ApplicationStyle", "_TitleWindowStyle", "_headerDateTextStyle", "_ButtonStyle", "_popUpMenuStyle", "_swatchPanelTextFieldStyle", "_opaquePanelStyle", "_weekDayStyleStyle", "_headerDragProxyStyleStyle", "org.seasar.akabana.yui.framework.mixin.YuiFrameworkMixin", "_examples_yui_popup_view_PopupOwnerViewWatcherSetupUtil" ],
            rsls: [{url: "framework.swf", size: -1}, {url: "yui-core.swf", size: -1}, {url: "yui-logging.swf", size: -1}, {url: "yui-service.swf", size: -1}, {url: "yui-framework.swf", size: -1}, {url: "yui-framework-bridge-flex3.swf", size: -1}]

        }
    }


    /**
     *  @private
     */
    private var _preloadedRSLs:Dictionary; // key: LoaderInfo, value: RSL URL

    /**
     *  The RSLs loaded by this system manager before the application
     *  starts. RSLs loaded by the application are not included in this list.
     */
    override     public function get preloadedRSLs():Dictionary
    {
        if (_preloadedRSLs == null)
           _preloadedRSLs = new Dictionary(true);
        return _preloadedRSLs;
    }

    /**
     *  Calls Security.allowDomain() for the SWF associated with this IFlexModuleFactory
     *  plus all the SWFs assocatiated with RSLs preLoaded by this IFlexModuleFactory.
     *
     */
    override     public function allowDomain(... domains):void
    {
        Security.allowDomain(domains);

        for (var loaderInfo:Object in _preloadedRSLs)
        {
            if (loaderInfo.content && ("allowDomainInRSL" in loaderInfo.content))
            {
                loaderInfo.content["allowDomainInRSL"](domains);
            }
        }
    }

    /**
     *  Calls Security.allowInsecureDomain() for the SWF associated with this IFlexModuleFactory
     *  plus all the SWFs assocatiated with RSLs preLoaded by this IFlexModuleFactory.
     *
     */
    override     public function allowInsecureDomain(... domains):void
    {
        Security.allowInsecureDomain(domains);

        for (var loaderInfo:Object in _preloadedRSLs)
        {
            if (loaderInfo.content && ("allowInsecureDomainInRSL" in loaderInfo.content))
            {
                loaderInfo.content["allowInsecureDomainInRSL"](domains);
            }
        }
    }


}

}
