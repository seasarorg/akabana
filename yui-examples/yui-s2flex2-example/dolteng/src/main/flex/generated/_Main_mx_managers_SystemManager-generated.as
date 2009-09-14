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

[ResourceBundle("SharedResources")]
[ResourceBundle("collections")]
[ResourceBundle("containers")]
[ResourceBundle("controls")]
[ResourceBundle("conventions")]
[ResourceBundle("core")]
[ResourceBundle("effects")]
[ResourceBundle("log4yui")]
[ResourceBundle("skins")]
[ResourceBundle("styles")]
[ResourceBundle("validators")]
[ResourceBundle("yui_framework")]
/**
 *  @private
 */
[ExcludeClass]
public class _Main_mx_managers_SystemManager
    extends mx.managers.SystemManager
    implements IFlexModuleFactory
{
    // Cause the CrossDomainRSLItem class to be linked into this application.
    import mx.core.CrossDomainRSLItem; CrossDomainRSLItem;

    public function _Main_mx_managers_SystemManager()
    {
        FlexVersion.compatibilityVersionString = "3.0.0";
        super();
    }

    override     public function create(... params):Object
    {
        if (params.length > 0 && !(params[0] is String))
            return super.create.apply(this, params);

        var mainClassName:String = params.length == 0 ? "Main" : String(params[0]);
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
            backgroundColor: "#FFFFFF",
            backgroundGradientAlphas: "[1.0, 1.0]",
            backgroundGradientColors: "[#FFFFFF, #FFFFFF]",
            cdRsls: [{"rsls":["yui-frameworks-1.0.0-beta-2-rc2.swf"],
"policyFiles":[""]
,"digests":["713709742297e224b1b0fc1c109b1d3124b65fb5273e6251a0f08c20421f3191"],
"types":["SHA-256"],
"isSigned":[false]
}]
,
            compiledLocales: [ "ja_JP" ],
            compiledResourceBundleNames: [ "SharedResources", "collections", "containers", "controls", "conventions", "core", "effects", "log4yui", "skins", "styles", "validators", "yui_framework" ],
            currentDomain: ApplicationDomain.currentDomain,
            layout: "absolute",
            mainClassName: "Main",
            minHeight: "430",
            minWidth: "600",
            mixins: [ "_Main_FlexInit", "_alertButtonStyleStyle", "_ControlBarStyle", "_ScrollBarStyle", "_activeTabStyleStyle", "_textAreaHScrollBarStyleStyle", "_ToolTipStyle", "_DragManagerStyle", "_DateFieldStyle", "_comboDropdownStyle", "_ListBaseStyle", "_DateChooserStyle", "_textAreaVScrollBarStyleStyle", "_ContainerStyle", "_linkButtonStyleStyle", "_globalStyle", "_windowStatusStyle", "_PanelStyle", "_windowStylesStyle", "_activeButtonStyleStyle", "_errorTipStyle", "_richTextEditorTextAreaStyleStyle", "_CursorManagerStyle", "_todayStyleStyle", "_TextInputStyle", "_dateFieldPopupStyle", "_plainStyle", "_dataGridStylesStyle", "_ApplicationStyle", "_headerDateTextStyle", "_ButtonStyle", "_DataGridStyle", "_CalendarLayoutStyle", "_popUpMenuStyle", "_swatchPanelTextFieldStyle", "_opaquePanelStyle", "_weekDayStyleStyle", "_headerDragProxyStyleStyle", "_DataGridItemRendererStyle", "org.seasar.akabana.yui.framework.mixin.YuiFrameworkMixin", "_examples_yui_employee_view_EmpViewWatcherSetupUtil" ],
            rsls: [{url: "framework.swf", size: -1}, {url: "dolteng_libs.swf", size: -1}]

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
        Security.allowDomain(domains);

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
