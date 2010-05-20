package 
{

import mx.resources.ResourceBundle;

[ExcludeClass]

public class ja_JP$application_properties extends ResourceBundle
{

    public function ja_JP$application_properties()
    {
		 super("ja_JP", "application");
    }

    override protected function getContent():Object
    {
        var content:Object =
        {
            "alert": "アラート"
        };
        return content;
    }
}



}
