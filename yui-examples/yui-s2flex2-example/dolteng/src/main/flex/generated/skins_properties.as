package 
{

import mx.resources.ResourceBundle;

[ExcludeClass]

public class ja_JP$skins_properties extends ResourceBundle
{

    public function ja_JP$skins_properties()
    {
		 super("ja_JP", "skins");
    }

    override protected function getContent():Object
    {
        var content:Object =
        {
            "notLoaded": "ロードできません '{0}'"
        };
        return content;
    }
}



}
