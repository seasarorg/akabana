package 
{

import mx.resources.ResourceBundle;

[ExcludeClass]

public class ja_JP$messages_properties extends ResourceBundle
{

    public function ja_JP$messages_properties()
    {
		 super("ja_JP", "messages");
    }

    override protected function getContent():Object
    {
        var content:Object =
        {
            "E1001": "showHelloWorldクリックされました。"
        };
        return content;
    }
}



}
