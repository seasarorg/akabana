package 
{

import mx.resources.ResourceBundle;

[ExcludeClass]

public class ja_JP$controls_properties extends ResourceBundle
{

    public function ja_JP$controls_properties()
    {
		 super("ja_JP", "controls");
    }

    override protected function getContent():Object
    {
        var content:Object =
        {
            "undefinedParameter": "cuePoint パラメータが未定義です",
            "nullURL": "null url が VideoPlayer.load に送信されました",
            "incorrectType": "type は 0、1、または 2 である必要があります",
            "okLabel": "OK",
            "noLabel": "いいえ",
            "wrongNumParams": "num パラメータは数値である必要があります",
            "wrongDisabled": "disabled は数値である必要があります",
            "wrongTime": "time は数値である必要があります",
            "dayNamesShortest": "日, 月, 火, 水, 木, 金, 土",
            "wrongType": "type は数値である必要があります",
            "firstDayOfWeek": "0",
            "rootNotSMIL": "URL: '{0}' ルートノードが smil ではありません : '{1}'。",
            "errorMessages": "サーバーに接続できないか、またはサーバー上で FLV が見つかりません。,一致するキューポイントが見つかりませんでした。,キューポイントが不正です。,シークが無効です。,contentPath が無効です。,XML が無効です。,ビットレートが一致しません。; デフォルト以外の FLV を指定してください。,デフォルトの VideoPlayer は削除できません。",
            "unexpectedEnd": "予期しない cuePoint パラメータ文字列の終わりです",
            "rootNotFound": "URL: '{0}' ルートノードが見つかりませんでした。ファイルが flv である場合は、拡張子を .flv にしてください。",
            "errWrongContainer": "エラー :'{0}' の dataProvider には、flash.display.DisplayObject 型のオブジェクトを含めることができません。",
            "invalidCall": "http 接続について reconnect を呼び出すことができません",
            "cancelLabel": "キャンセル",
            "errWrongType": "エラー : '{0}' の dataProvider は、String、ViewStack、Array、または IList である必要があります。",
            "badArgs": "_play の引数が正しくありません",
            "missingRoot": "URL: '{0}' ルートノードが見つかりませんでした。URL が FLV に対するものである場合は、拡張子を .flv にし、パラメータを指定しないでください。",
            "notLoadable": "ロードできません '{0}'.",
            "wrongName": "name を未定義または null にすることはできません",
            "wrongTimeName": "time は数値である必要があり、name は未定義または null にすることはできません",
            "yesLabel": "はい",
            "undefinedArray": "cuePoint.array が未定義です",
            "missingProxy": "URL: '{0}' fpad xml にはプロキシタグが必要です。",
            "unknownInput": "不明な inputType '{0}'",
            "missingAttributeSrc": "URL: '{0}' 属性 src が '{1}' タグに必要です。",
            "yearSymbol": "年",
            "wrongIndex": "cuePoint.index は -1 ～ cuePoint.array.length の範囲の数値である必要があります",
            "notImplemented": "'{0}' 実装されていません",
            "label": "ロード中 %3%%",
            "wrongFormat": "予期しない cuePoint パラメータの形式です",
            "tagNotFound": "URL: '{0}' ref タグのビデオが少なくとも 1 つ必要です。",
            "unsupportedMode": "IMEMode '{0}' はサポートされていません。",
            "cannotDisable": "ActionScript キューポイントを無効にできません",
            "missingAttributes": "URL: '{0}' タグ '{1}' は id、width、および height 属性を必要とします。width と height は 0 以上の数値である必要があります。",
            "notfpad": "URL: '{0}' ルートノードが fpad ではありません。"
        };
        return content;
    }
}



}
