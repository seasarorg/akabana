package 
{

import mx.resources.ResourceBundle;

[ExcludeClass]

public class ja_JP$core_properties extends ResourceBundle
{

    public function ja_JP$core_properties()
    {
		 super("ja_JP", "core");
    }

    override protected function getContent():Object
    {
        var content:Object =
        {
            "multipleChildSets_ClassAndInstance": "このコンポーネント (コンポーネント定義とコンポーネントインスタンス) に対して、可視の子のセットが複数指定されています。",
            "truncationIndicator": "...",
            "notExecuting": "Repeater は実行されていません。",
            "versionAlreadyRead": "互換性のあるバージョンが既に読み込まれています。",
            "multipleChildSets_ClassAndSubclass": "このコンポーネント (基本の core.properties) に対して、可視の子のセットが複数指定されています。",
            "viewSource": "ソースの表示",
            "badFile": "ファイルが存在しません。",
            "stateUndefined": "未定義のステート '{0}'",
            "versionAlreadySet": "互換性のあるバージョンが既に設定されています。"
        };
        return content;
    }
}



}
