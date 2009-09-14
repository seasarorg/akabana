package 
{

import mx.resources.ResourceBundle;

[ExcludeClass]

public class ja_JP$containers_properties extends ResourceBundle
{

    public function ja_JP$containers_properties()
    {
		 super("ja_JP", "containers");
    }

    override protected function getContent():Object
    {
        var content:Object =
        {
            "noColumnsFound": "ConstraintColumns が見つかりませんでした。",
            "noRowsFound": "ConstraintRows が見つかりませんでした。",
            "rowNotFound": "ConstraintRow '{0}' が見つかりませんでした。",
            "columnNotFound": "ConstraintColumn '{0}' が見つかりませんでした。"
        };
        return content;
    }
}



}
