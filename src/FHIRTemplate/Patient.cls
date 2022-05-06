/// 患者リソース
Class FHIRTemplate.Patient Extends Resource
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
  "address": [
    {
      "postalCode": "#(..PostalCode)#",
      "text": "#(..Address)#"
    }
  ],
  "birthDate": "#(..DOB)#",
  "gender": "#(..Gender)#",
  "identifier": [
    {
      "value": "#(..PatientId)#"
    }
  ],
  "name": [
    {
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/iso21090-EN-representation",
          "valueCode": "IDE"
        }
      ],
      "use": "official",
      "text": "  #(..LastName)# #(..FirstName)#",
      "family": "#(..LastName)#",
      "given": [
        "#(..FirstName)#"
      ]
    },
    {
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/iso21090-EN-representation",
          "valueCode": "SYL"
        }
      ],
      "use": "official",
      "text": "#(..LastNameKana)# #(..FirstNameKana)# ",
      "family": "#(..LastNameKana)#",
      "given": [
        "#(..FirstNameKana)#"
      ]
    }
  ],
  "telecom": [
    {
      "value": "#(..Phone)#"
    }
  ]
}
}

Parameter ResourceType = "Patient";

Property LastName As %String;

Property FirstName As %String;

Property LastNameKana As %String;

Property FirstNameKana As %String;

Property Phone As %String;

Property DOB As %Date(FORMAT = 3);

Property Gender As %String(DISPLAYLIST = ",male,female", VALUELIST = ",1,2");

Property PostalCode As %String;

Property PatientId As %String;

Property Address As %String;

}
