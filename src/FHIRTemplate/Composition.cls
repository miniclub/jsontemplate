/// 患者リソース
Class FHIRTemplate.Composition Extends FHIRTemplate.Resource
{

/// JSON出力する際のテンプレート
/// JSONの値の文字列に#(..プロパティ名)#または#(..#パラメータ名)#を指定することで
/// プロパティの値をJSON形式で出力できます。
/// プロパティの型がJSONTemplate.Baseを継承したクラスの場合、
/// そのクラスのテンプレートからJSON出力します。
XData Template [ MimeType = application/json ]
{
{
  "resourceType": "#(..#ResourceType)#",
  "meta": {
    "profile": [
      "#(..#Profile)#"
    ]
  }
}
}

Parameter ResourceType = "Composition";

Parameter Profile = "http://jpfhir.jp/fhir/eDischargeSummary/StructureDefinition/JP_Composition_eDischargeSummary";

}
