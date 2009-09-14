package 
{

import mx.resources.ResourceBundle;

[ExcludeClass]

public class ja_JP$SharedResources_properties extends ResourceBundle
{

    public function ja_JP$SharedResources_properties()
    {
		 super("ja_JP", "SharedResources");
    }

    override protected function getContent():Object
    {
        var content:Object =
        {
            "dateFormat": "YYYY/MM/DD",
            "dayNames": "日,月,火,水,木,金,土",
            "thousandsSeparatorFrom": ",",
            "monthNames": "1,2,3,4,5,6,7,8,9,10,11,12",
            "decimalSeparatorFrom": ".",
            "currencySymbol": "¥",
            "decimalSeparatorTo": ".",
            "thousandsSeparatorTo": ",",
            "monthSymbol": "月",
            "alignSymbol": "left"
        };
        return content;
    }
}



}
