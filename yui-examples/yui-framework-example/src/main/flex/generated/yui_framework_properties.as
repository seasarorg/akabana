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
            "ViewComponentUnRegistered": "{0} is unregistered...",
            "ViewComponentRegistered": "{0} is registered as View Component.",
            "ServiceRegistered": "{0} is registered as Service.",
            "ViewComponentAssembleing": "{0} is assembling...",
            "Customized": "{1} of {0} is customized.",
            "ViewComponentAssembleEnd": "application assemble end.",
            "ViewComponentAssembled": "{0} is assembled.",
            "ApplicationStart": "application start...",
            "CustomizeError": "{0} doesn't customize, because ...\n {1}",
            "Uncustomizing": "{1} of {0} is uncustomizing...",
            "ApplicationRegistered": "{0} is registered as Application.",
            "Uncustomized": "{1} of {0} is uncustomized.",
            "EventRemoveEvent": "{1}.removeEventListener({2},{3}) on {0}.",
            "Customizing": "{1} of {0} is customizing...",
            "UncustomizeError": "{0} doesn't uncustomize, because ...\n {1}",
            "ApplicationInit": "application initialize...",
            "EventAddEvent": "{1}.addEventListener({2},{3}) on {0}.",
            "ApplicationConventions": "Application Conventions is {0}.",
            "ViewComponentAssembleStart": "application assemble start."
        };
        return content;
    }
}



}
