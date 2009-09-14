package 
{

import mx.resources.ResourceBundle;

[ExcludeClass]

public class ja_JP$log4yui_properties extends ResourceBundle
{

    public function ja_JP$log4yui_properties()
    {
		 super("ja_JP", "log4yui");
    }

    override protected function getContent():Object
    {
        var content:Object =
        {
            "log4yui.appender.C.layout": "org.seasar.akabana.yui.logging.layout.PatternLayout",
            "log4yui.appender.A1.layout": "org.seasar.akabana.yui.logging.layout.PatternLayout",
            "log4yui.category.org.seasar": "DEBUG, C",
            "log4yui.category.com.wni.ecf": "DEBUG, C",
            "log4yui.appender.C": "org.seasar.akabana.yui.logging.appender.SimpleAppender",
            "log4yui.appender.A1": "org.seasar.akabana.yui.logging.appender.SimpleAppender",
            "log4yui.appender.C.layout.pattern": "%d(%t)[%c] %l - %m",
            "log4yui.rootLogger": "INFO, A1",
            "log4yui.appender.A1.layout.pattern": "%d [%c] %l - %m"
        };
        return content;
    }
}



}
