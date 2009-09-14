package 
{

import mx.resources.ResourceBundle;

[ExcludeClass]

public class ja_JP$collections_properties extends ResourceBundle
{

    public function ja_JP$collections_properties()
    {
		 super("ja_JP", "collections");
    }

    override protected function getContent():Object
    {
        var content:Object =
        {
            "findCondition": "検索基準には、'{0}' にいたるすべてのソートフィールドが含まれている必要があります。",
            "noComparatorSortField": "名前が '{0}' の SortField のコンパレータを特定できません。",
            "outOfBounds": "指定したインデックス '{0}' が範囲外です",
            "nonUnique": "アイテム内の値が一意ではありません",
            "incorrectAddition": "ビューに既に存在するアイテムを追加しようとしています",
            "findRestriction": "検索条件には、最低 1 つのソートフィールド値が含まれている必要があります",
            "invalidType": "型が正しくありません。XML、または XML オブジェクトを 1 つ含む XMLList である必要があります。 \t",
            "unknownMode": "不明な検索モードです",
            "invalidIndex": "無効なインデックス : '{0}' ",
            "invalidRemove": "current が beforeFirst または afterLast である場合は削除できません",
            "unknownProperty": "不明な Property です '{0}'",
            "invalidInsert": "current が beforeFirst である場合は挿入できません",
            "itemNotFound": "ビューがソートされていない場合は見つけることができません",
            "bookmarkInvalid": "ブックマークが有効ではありません",
            "noComparator": "コンパレータを特定できません '{0}'",
            "invalidCursor": "カーソルが有効ではありません",
            "noItems": "検索するアイテムがありません",
            "bookmarkNotFound": "ブックマークがこのビューのものではありません"
        };
        return content;
    }
}



}
