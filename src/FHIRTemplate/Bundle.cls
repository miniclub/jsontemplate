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
    "#(..Composition(FHIRTemplate.Bundle.entry))#",
    "#(..Patient(FHIRTemplate.Bundle.entry))#",
    "#(..Practitioner(FHIRTemplate.Bundle.entry))#"
  ],
  "signature": {
    "type":"a"
  }
  }
}

Parameter ResourceType = "Bundle";

Parameter Profile = "jpfhir.jp/fhir/eDischargeSummary/StructureDefinition/JP_Bundle_eDischargeSummary";

Property TimeStamp As FHIRTemplate.TimeStamp;

Property Composition As Composition [ Required ];

Property Patient As Patient [ Required ];

Property Practitioner As list Of Practitioner;

}
