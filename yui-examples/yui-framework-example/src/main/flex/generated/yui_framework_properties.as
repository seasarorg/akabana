package 
{

import mx.resources.ResourceBundle;

[ExcludeClass]

public class ja_JP$yui_framework_properties extends ResourceBundle
{

    public function ja_JP$yui_framework_properties()
    {
		 super("ja_JP", "yui_framework");
    }

    override protected function getContent():Object
    {
        var content:Object =
        {
            "ValidatorUncustomizing": "{0} is uncustomizing by {1}.",
            "ViewComponentUnRegistered": "{0} is unregistered...",
            "LogicUncustomized": "logic property({0}#{1}({2})) is uncustomized.",
            "ViewComponentRegistered": "{0} is registered as View Component.",
            "ServiceRegistered": "{0} is registered as Service.",
            "ServiceCustomized": "service property({0}#{1}({2})) is customized.",
            "ValidatorUncustomized": "validator property({0}#{1}({2})) is uncustomized.",
            "ViewEventCustomizingRemoveEvent": "{1}.removeEventListener({2},{3}) on {0}.",
            "ViewComponentAssembleing": "{0} is assembling...",
            "HelperUncustomized": "{0}#{1}({2}) is uncustomized.",
            "ViewComponentAssembleEnd": "application assemble end.",
            "HelperCustomized": "{0}#{1}({2}) is customized.",
            "ViewComponentAssembled": "{0} is assembled.",
            "ApplicationStart": "application start...",
            "CustomizeError": "{0} doesn't customize, because ...\n {1}",
            "ActionUnCustomizing": "{0} is uncustomizing by {1}.",
            "ServiceUncustomized": "service property({0}#{1}({2})) is uncustomized.",
            "ViewEventCustomizing": "{0} is customizing by {1}.",
            "ViewEventCustomizingAddEvent": "{1}.addEventListener({2},{3}) on {0}.",
            "ApplicationRegistered": "{0} is registered as Application.",
            "ViewEventUncustomizing": "{0} is uncustomizing by {1}.",
            "ActionCustomizing": "{0} is customizing by {1}.",
            "ValidatorCustomizing": "{0} is customizing by {1}.",
            "UncustomizeError": "{0} doesn't uncustomize, because ...\n {1}",
            "ApplicationInit": "application initialize...",
            "LogicCustomized": "logic property({0}#{1}({2})) is customized.",
            "ValidatorCustomized": "validator property({0}#{1}({2})) is customized.",
            "ApplicationConventions": "Application Conventions is {0}.",
            "ViewComponentAssembleStart": "application assemble start."
        };
        return content;
    }
}



}