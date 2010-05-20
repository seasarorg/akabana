package 
{

import mx.resources.ResourceBundle;

[ExcludeClass]

public class ja_JP$effects_properties extends ResourceBundle
{

    public function ja_JP$effects_properties()
    {
		 super("ja_JP", "effects");
    }

    override protected function getContent():Object
    {
        var content:Object =
        {
            "incorrectTrigger": "Zoom エフェクトは moveEffect トリガでトリガすることはできません。",
            "incorrectSource": "Source プロパティは Class または String である必要があります。"
        };
        return content;
    }
}



}
