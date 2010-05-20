package 
{

import mx.resources.ResourceBundle;

[ExcludeClass]

public class ja_JP$validators_properties extends ResourceBundle
{

    public function ja_JP$validators_properties()
    {
		 super("ja_JP", "validators");
    }

    override protected function getContent():Object
    {
        var content:Object =
        {
            "PAttributeMissing": "source 属性を指定する場合は、property 属性を指定する必要があります。",
            "wrongLengthErrorDV": "形式に基づき日付を入力してください。",
            "maxLength": "NaN",
            "invalidDomainErrorZCV": "domain パラメータが無効です。'US Only'、'Canada Only' または 'US or Canada' のいずれかである必要があります。",
            "creditCardValidatorAllowedFormatChars": " -",
            "wrongFormatError": "社会保障番号は 9 桁または NNN-NN-NNNN の形式である必要があります。",
            "invalidNumberError": "クレジットカード番号が無効です。",
            "CNSAttribute": "cardNumberSource 属性 ('{0}') は、String 型にはできません。",
            "invalidCharErrorCCV": "クレジットカード番号の文字が無効です(数値のみを入力してください)。",
            "thousandsSeparator": ",",
            "wrongLengthErrorPNV": "電話番号は最低 10 桁である必要があります。",
            "invalidPeriodsInDomainError": "電子メールアドレスのドメインに連続するピリオドが含まれています。",
            "precisionError": "入力した小数部の桁数が多すぎます。",
            "wrongUSFormatError": "ZIP+4 コードは '12345-6789' の形式である必要があります。",
            "separationError": "桁区切り記号は 3 桁ごとに挿入する必要があります。",
            "DSAttribute": "daySource 属性 ('{0}') は、String 型にはできません。",
            "zipCodeValidatorDomain": "US Only",
            "exceedsMaxErrorCV": "入力した金額が大きすぎます。",
            "allowNegative": "true",
            "decimalPointCountError": "小数点は 1 回だけ使用できます。",
            "requiredFieldError": "このフィールドは必須です。",
            "missingPeriodInDomainError": "電子メールアドレスのドメインにピリオドがありません。",
            "invalidCharError": "入力値に無効な文字が含まれています。",
            "SAttribute": "source 属性 ('{0}') は、String 型にはできません。",
            "wrongCAFormatError": "カナダの郵便番号は 'A1B 2C3' の形式である必要があります。",
            "wrongLengthErrorCCV": "クレジットカード番号の桁数が正しくありません。",
            "tooShortError": "このストリングは最小値よりも短いストリングです。このストリングは最低 {0} 文字である必要があります。",
            "decimalSeparator": ".",
            "zeroStartError": "無効な社会保障番号です。番号の先頭を 000 にすることはできません。",
            "invalidFormatChars": "allowedFormatChars パラメータが無効です。数字は使用できません。",
            "validateAsString": "true",
            "invalidCharErrorZCV": "ZIP コードに無効な文字が含まれています。",
            "exceedsMaxErrorNV": "入力した数値が大きすぎます。",
            "missingCardNumber": "検証した値には cardNumber プロパティが含まれていません。",
            "CTSAttribute": "cardTypeSource 属性 ('{0}') は、String 型にはできません。",
            "numberValidatorPrecision": "-1",
            "YSAttribute": "yearSource 属性 ('{0}') は、String 型にはできません。",
            "negativeError": "負の値にすることはできません。",
            "fieldNotFound": "'{0}' フィールドが見つかりません",
            "noNumError": "クレジットカード番号が指定されていません。",
            "SAttributeMissing": "property 属性を指定する場合は、source 属性を指定する必要があります。",
            "noTypeError": "クレジットカードの種類が指定されていないか、有効ではありません。",
            "tooManyAtSignsError": "電子メールアドレスに含まれているアットマーク (@) が多すぎます。",
            "wrongLengthErrorZCV": "ZIP コードは 5 桁または 5+4 桁である必要があります。",
            "socialSecurityValidatorAllowedFormatChars": " -",
            "wrongYearError": "0 ～ 9999 の範囲で年を入力してください。",
            "minLength": "NaN",
            "missingCardType": "検証した値には cardType プロパティが含まれていません。",
            "noExpressionError": "式がありません。",
            "maxValue": "NaN",
            "invalidDomainErrorEV": "電子メールアドレスのドメインの形式が正しくありません。",
            "numberValidatorDomain": "real",
            "minValue": "NaN",
            "missingUsernameError": "電子メールアドレスにユーザー名がありません。",
            "invalidCharErrorEV": "電子メールアドレスに無効な文字が含まれています。",
            "MSAttribute": "monthSource 属性 ('{0}') は、String 型にはできません。",
            "phoneNumberValidatorAllowedFormatChars": "-()+ .",
            "noMatchError": "フィールドが無効です。",
            "wrongMonthError": "1 ～ 12 の範囲で月を入力してください。",
            "invalidIPDomainError": "電子メールアドレスの IP ドメインの形式が正しくありません。",
            "dateValidatorAllowedFormatChars": "/- \\.",
            "integerError": "数値は整数である必要があります。",
            "currencyValidatorPrecision": "2",
            "invalidFormatCharsZCV": "allowedFormatChars パラメータが無効です。英数字 (a-z A-Z 0-9) は使用できません。",
            "formatError": "設定エラー :ストリングのフォーマットが正しくありません",
            "wrongDayError": "月の有効な日付を入力してください。",
            "lowerThanMinError": "入力した値が小さすぎます。",
            "zipCodeValidatorAllowedFormatChars": " -",
            "invalidCharErrorPNV": "電話番号に無効な文字が含まれています。",
            "invalidCharErrorDV": "日付に無効な文字が含まれています。",
            "missingAtSignError": "電子メールアドレスにアットマーク (@) がありません。",
            "invalidFormatCharsError": "フォーマット用パラメータのいずれかが無効です。",
            "wrongTypeError": "指定されたカードの種類が正しくありません。",
            "tooLongError": "このストリングは最大値よりも長いストリングです。このストリングは {0} 文字未満である必要があります。",
            "currencySymbolError": "通貨記号が無効な位置にあります。",
            "invalidCharErrorSSV": "社会保障番号に無効な文字を入力しました。"
        };
        return content;
    }
}



}
