/// 患者リソース
Class FHIRTemplate.Bundle Extends FHIRTemplate.Resource
{

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
  "resourceType": "#(..#ResourceType)#",
  "meta": {
    "profile": "#(..#Profile)#"
  },
  "type": "document",
  "timestamp": "#(..TimeStamp)#",
  "entry": [
    "#(..Composition)#",
    "#(..Patient)#"
  ],
  "signature": {
    "type":"a"
  }
  }
}

Parameter ResourceType = "Bundle";

Parameter Profile = "jpfhir.jp/fhir/eDischargeSummary/StructureDefinition/JP_Bundle_eDischargeSummary";

Property TimeStamp As %TimeStamp;

Property Composition As Composition;

Property Patient As Patient;

}
