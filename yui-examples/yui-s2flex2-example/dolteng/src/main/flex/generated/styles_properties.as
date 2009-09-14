package 
{

import mx.resources.ResourceBundle;

[ExcludeClass]

public class ja_JP$styles_properties extends ResourceBundle
{

    public function ja_JP$styles_properties()
    {
		 super("ja_JP", "styles");
    }

    override protected function getContent():Object
    {
        var content:Object =
        {
            "unableToLoad": "スタイル ({0}) をロードできません : {1}。"
        };
        return content;
    }
}



}
