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

[ResourceBundle("collections")]
[ResourceBundle("containers")]
[ResourceBundle("controls")]
[ResourceBundle("core")]
[ResourceBundle("effects")]
[ResourceBundle("skins")]
[ResourceBundle("styles")]
/**
 *  @private
 */
[ExcludeClass]
public class _EmbedXmlReaderSample_mx_managers_SystemManager
    extends mx.managers.SystemManager
    implements IFlexModuleFactory
{
    // Cause the CrossDomainRSLItem class to be linked into this application.
    import mx.core.CrossDomainRSLItem; CrossDomainRSLItem;

    public function _EmbedXmlReaderSample_mx_managers_SystemManager()
    {
        FlexVersion.compatibilityVersionString = "3.0.0";
        super();
    }

    override     public function create(... params):Object
    {
        if (params.length > 0 && !(params[0] is String))
            return super.create.apply(this, params);

        var mainClassName:String = params.length == 0 ? "EmbedXmlReaderSample" : String(params[0]);
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
            cdRsls: [{"rsls":["framework_3.4.0.9271.swz","framework_3.4.0.9271.swf"],
"policyFiles":["",""]
,"digests":["ff56dca4c4d6043f3d639eff51bf9a2934b7456beabf2fdb5f221cbbbbc90af7","ff56dca4c4d6043f3d639eff51bf9a2934b7456beabf2fdb5f221cbbbbc90af7"],
"types":["SHA-256","SHA-256"],
"isSigned":[true,false]
}]
,
            compiledLocales: [ "ja_JP" ],
            compiledResourceBundleNames: [ "collections", "containers", "controls", "core", "effects", "skins", "styles" ],
            currentDomain: ApplicationDomain.currentDomain,
            initialize: "initApp()",
            layout: "absolute",
            mainClassName: "EmbedXmlReaderSample",
            mixins: [ "_EmbedXmlReaderSample_FlexInit", "_richTextEditorTextAreaStyleStyle", "_DividedBoxStyle", "_ControlBarStyle", "_alertButtonStyleStyle", "_textAreaVScrollBarStyleStyle", "_headerDateTextStyle", "_globalStyle", "_ListBaseStyle", "_todayStyleStyle", "_windowStylesStyle", "_ApplicationStyle", "_ToolTipStyle", "_CursorManagerStyle", "_opaquePanelStyle", "_TextInputStyle", "_errorTipStyle", "_dateFieldPopupStyle", "_customizersStyle", "_TreeStyle", "_dataGridStylesStyle", "_popUpMenuStyle", "_headerDragProxyStyleStyle", "_activeTabStyleStyle", "_PanelStyle", "_DragManagerStyle", "_ContainerStyle", "_windowStatusStyle", "_ScrollBarStyle", "_TextAreaStyle", "_swatchPanelTextFieldStyle", "_textAreaHScrollBarStyleStyle", "_plainStyle", "_activeButtonStyleStyle", "_comboDropdownStyle", "_ButtonStyle", "_HDividedBoxStyle", "_weekDayStyleStyle", "_linkButtonStyleStyle", "_EmbedXmlReaderSampleWatcherSetupUtil" ],
            rsls: [{url: "yui-core.swf", size: -1}, {url: "yui-logging.swf", size: -1}, {url: "yui-service.swf", size: -1}, {url: "yui-framework.swf", size: -1}, {url: "yui_framework_bridge_flex3.swf", size: -1}]

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
